# ---
FROM ghcr.io/okp4/widoco:1.4.17 AS BUILD_IMAGE

WORKDIR /var/build/ontology

COPY . .

RUN  java -jar /usr/local/widoco/widoco.jar \
        -ontFile src/okp4.ttl               \
        -outFolder documentation            \ 
        -htaccess                           \
        -lang en                            \
        -getOntologyMetadata                \
        -includeImportedOntologies          \
        -displayDirectImportsOnly           \
        -webVowl                            \
        -uniteSections                      \
  && cp -R public/* documentation           \
  && sed -i "s/http:\/\//https:\/\//" documentation/webvowl/css/*.css  \
  && rm documentation/readme.md

# ---
FROM httpd:2.4.51-alpine3.14

WORKDIR /usr/local/apache2/htdocs/

RUN  rm -r ./* \
  && sed -i "s/Options Indexes FollowSymLinks/# Options Indexes FollowSymLinks/" ../conf/httpd.conf

COPY --from=BUILD_IMAGE /var/build/ontology/documentation .
