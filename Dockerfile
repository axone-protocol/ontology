# ---
FROM ghcr.io/okp4/widoco:1.4.15 AS BUILD_IMAGE

WORKDIR /var/build/ontology/documentation

COPY src ..

RUN  java -jar /usr/local/widoco/widoco.jar \
        -ontFile ../okp4.ttl                \
        -outFolder .                        \ 
        -htaccess                           \
  && rm readme.md

# ---
FROM httpd:2.4.51-alpine3.14

WORKDIR /usr/local/apache2/htdocs/

RUN  rm -r ./* \
  && sed -i "s/Options Indexes FollowSymLinks/# Options Indexes FollowSymLinks/" ../conf/httpd.conf

COPY --from=BUILD_IMAGE /var/build/ontology/documentation .
