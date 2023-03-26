# Freely based on: https://gist.github.com/thomaspoignant/5b72d579bd5f311904d973652180c705

# Docker images
DOCKER_IMAGE_HTTPD    := httpd:2.4.51
DOCKER_IMAGE_PYSHACL  := ashleysommer/pyshacl:0.20.0
DOCKER_IMAGE_RUBY_RDF := ghcr.io/okp4/ruby-rdf:3.1.15
DOCKER_IMAGE_WIDOCO   := ghcr.io/okp4/widoco:1.4.15
DOCKER_IMAGE_JRE      := eclipse-temurin:19.0.2_7-jre-focal

# Some colors
COLOR_CYAN   := $(shell tput -Txterm setaf 6)
COLOR_GREEN  := $(shell tput -Txterm setaf 2)
COLOR_RED    := $(shell tput -Txterm setaf 1)
COLOR_RESET  := $(shell tput -Txterm sgr0)
COLOR_WHITE  := $(shell tput -Txterm setaf 7)
COLOR_YELLOW := $(shell tput -Txterm setaf 3)

# Build constants
ROOT               := .

DST                := $(ROOT)/target
DST_CACHE          := $(DST)/.cache
DST_EXM            := $(DST)/example
DST_ONT            := $(DST)/ontology
DST_LINT           := $(DST)/lint
DST_TEST           := $(DST)/test
DST_DOC            := $(DST)/doc

SRC_ONT            := $(ROOT)/src
SRC_EXM            := $(ROOT)/example
SRC_TST            := $(ROOT)/test
SRC_EXMS           := $(shell find $(SRC_EXM) -name "*.ttl" | sort)
SRC_ONTS           := $(shell find $(SRC_ONT) -name "*.ttl" | sort)
SRC_TTLS           := $(shell find $(SRC_ONT) $(SRC_EXM) -name "*.ttl" | sort)
SRC_TSTS           := $(shell find $(SRC_TST) -name "*.ttl" | sort)

OBJ_EXMS           := $(patsubst $(SRC_EXM)/%.ttl,$(DST_EXM)/%.nt,$(SRC_EXMS))
OBJ_ONTS           := $(patsubst $(SRC_ONT)/%.ttl,$(DST_ONT)/%.nt,$(SRC_ONTS))
FLG_TSTS           := $(patsubst $(SRC_TST)/%.ttl,$(DST_TEST)/%.tested.flag,$(SRC_TSTS))
FLG_TTLS_FMT       := $(patsubst $(ROOT)/%.ttl,$(DST_LINT)/%.formatted.flag,$(SRC_TTLS))
FLG_TTLS_LNT       := $(patsubst $(ROOT)/%.ttl,$(DST_LINT)/%.linted.flag,$(SRC_TTLS))

BIN_OKP4_TTL       := $(DST)/okp4.ttl
BIN_OKP4_NT        := $(DST)/okp4.nt
BIN_OKP4_RDFXML    := $(DST)/okp4.rdf.xml
BIN_EXAMPLE_TTL    := $(DST)/examples.ttl
BIN_EXAMPLE_NT     := $(DST)/examples.nt
BIN_EXAMPLE_JSONLD := $(DST)/examples.jsonld

# Runners
RDF_WRITE = \
  docker run --rm \
      -v `pwd`:/usr/src/ontology:rw \
      -w /usr/src/ontology \
      ${DOCKER_IMAGE_JRE} \
        java -jar ${DST_CACHE}/owl-cli-1.2.2.jar \
        write \
        -o $1 \
        $2 \
        $3
RDF_SERIALIZE = \
  @docker run --rm \
    -v `pwd`:/usr/src/ontology:rw \
    -w /usr/src/ontology \
    ${DOCKER_IMAGE_RUBY_RDF} \
      serialize \
      -o $4 \
      --output-format $2 \
      --input-format $1 \
      $3
RDF_SHACL = \
  @docker run --rm \
    -v `pwd`:/usr/src/ontology \
    ${DOCKER_IMAGE_PYSHACL} poetry run pyshacl \
    --shacl /usr/src/ontology/$1 \
    --output /usr/src/ontology/$2 \
    --inference none \
    --format human \
    /usr/src/ontology/$(BIN_OKP4_NT)

.PHONY: help
all: help

## Clean:
.PHONY: clean
clean: ## Clean all generated files
    @echo "${COLOR_CYAN}🧹 cleaning: ${COLOR_GREEN}${DST}${COLOR_RESET}"
    @rm -rf ${DST}

## Build:
.PHONY: build
build: $(CACHE)/owl-x86_64-linux-1.2.2 $(ARTIFACT_TTL) ## Build the ontology

$(ARTIFACT_TTL): $(ARTIFACT_NT)
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} the ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@docker run --rm \
  		-v `pwd`:/usr/src/ontology:rw \
  		-w /usr/src/ontology \
  		${DOCKER_IMAGE_RUBY_RDF} serialize -o $@ --output-format turtle $<

$(ARTIFACT_NT): $(OBJ_FILES) | $(BIN)
	@echo "${COLOR_CYAN}🔨 assembling${COLOR_RESET} ontology into ${COLOR_GREEN}$@${COLOR_RESET}"
	@cat $^ > $@

$(OBJ)/%.nt: $(SRC)/%.ttl | $(OBJ)
	@echo "${COLOR_CYAN}🔁 converting${COLOR_RESET} ontology ${COLOR_GREEN}$<${COLOR_RESET} into ${COLOR_GREEN}$@${COLOR_RESET}"
	@docker run --rm \
	  -v `pwd`:/usr/src/ontology:rw \
	  -w /usr/src/ontology \
	  ${DOCKER_IMAGE_UBUNTU} bash -c " \
		${CACHE}/owl-x86_64-linux-1.2.2 write \
		-o ntriple $< $@ \
	  "

$(BIN) $(OBJ) $(RES):
	@mkdir -p -m 777 $@

## Format:
.PHONY: format
format: format-rdf ## Format with all available formatters

.PHONY: format-rdf
format-rdf: $(SRC)/*.ttl $(TST)/*.ttl | $(CACHE)/owl-x86_64-linux-1.2.2 ## Format all the rdfs files (turtle)
	@for file in $^ ; do \
		echo "${COLOR_CYAN}📐 Formating: ${COLOR_GREEN}$${file}${COLOR_RESET}"; \
		docker run --rm \
  		  -v `pwd`:/usr/src/ontology:rw \
  		  -w /usr/src/ontology \
  		  ${DOCKER_IMAGE_UBUNTU} bash -c " \
		  	${CACHE}/owl-x86_64-linux-1.2.2 write \
			$${file} $${file}.formatted \
		  " && \
		mv -f "$${file}.formatted" "$${file}"; \
	done

$(CACHE)/owl-x86_64-linux-1.2.2:
	@echo "⤵️ installing $(notdir $@)"
	@mkdir -p $(CACHE); \
	cd $(CACHE); \
	wget https://github.com/atextor/owl-cli/releases/download/v1.2.2/owl-x86_64-linux-1.2.2; \
	chmod +x owl-x86_64-linux-1.2.2

## Lint:
.PHONY: lint
lint: lint-rdf ## Lint with all available linters

.PHONY: lint-rdf

lint-rdf: $(SRC)/*.ttl $(TST)/*.ttl $(EXM_FILES) ## Lint all the rdf files (turtle)
	@set -e; \
	for file in $^ ; do \
		echo "${COLOR_CYAN}Linting: ${COLOR_GREEN}$${file}${COLOR_RESET}"; \
		docker run --rm \
		  -v `pwd`:/usr/src/ontology:ro \
		  -w /usr/src/ontology \
		  ${DOCKER_IMAGE_RUBY_RDF} validate --validate $${file}; \
	done

## Test:
.PHONY: test
test: test-ontology ## Run all available tests

.PHONY: test-ontology
test-ontology: $(RESULT_FILES) ## Test final (generated) ontology

$(RES)/%.result: $(TST)/%.ttl | $(RES) build
	@echo "${COLOR_CYAN}Testing: ${COLOR_GREEN}$<${COLOR_RESET}"
	@docker run --rm \
	  -v `pwd`:/usr/src/ontology \
	  ${DOCKER_IMAGE_PYSHACL} poetry run pyshacl \
		-s /usr/src/ontology/$< \
	    -o /usr/src/ontology/$@ \
		/usr/src/ontology/$(ARTIFACT_TTL) \
	  && echo "✅ Test passed" \
	  || { \
		echo "❌ Test failed"; \
		echo "📄 Test result:"; \
		cat $@; \
		exit 1; \
	  }\

## Documentation:
.PHONY: documentation
documentation: build ## Generate documentation site
	@echo "${COLOR_CYAN}Generate documentation for ${COLOR_GREEN}${ARTIFACT_TTL}${COLOR_RESET}"
	@docker run \
	    --rm \
  		-v `pwd`:/usr/src/ontology \
		${DOCKER_IMAGE_WIDOCO} \
			-ontFile /usr/src/ontology/${ARTIFACT_TTL} \
			-outFolder /usr/src/ontology/${DOC}/ontology \
			-lang en \
			-rewriteAll \
			-getOntologyMetadata \
			-includeImportedOntologies \
			-webVowl \
			-displayDirectImportsOnly \
			-uniteSections
	@sudo chown -R  "$$(id -u):$$(id -g)" ${DOC}/ontology
	@cp -R public/* ${DOC}/ontology/

.PHONY: start-site
start-site: documentation ## Start a web server for serving generated documentation
	@echo "${COLOR_CYAN}Site will be available here: ${COLOR_GREEN}http://localhost:8080/index-en.html${COLOR_RESET}"
	@docker run --rm \
	  -p 8080:80 \
	  -v `pwd`/${DOC}/ontology/:/usr/local/apache2/htdocs/:ro \
	  ${DOCKER_IMAGE_HTTPD}

## Help:
.PHONY: help
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${COLOR_YELLOW}make${COLOR_RESET} ${COLOR_GREEN}<target>${COLOR_RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${COLOR_YELLOW}%-20s${COLOR_GREEN}%s${COLOR_RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${COLOR_CYAN}%s${COLOR_RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
	@echo ''
	@echo 'This Makefile depends on ${COLOR_CYAN}docker${COLOR_RESET}. To install it, please follow the instructions:'
	@echo '- for ${COLOR_YELLOW}macOS${COLOR_RESET}: https://docs.docker.com/docker-for-mac/install/'
	@echo '- for ${COLOR_YELLOW}Windows${COLOR_RESET}: https://docs.docker.com/docker-for-windows/install/'
	@echo '- for ${COLOR_YELLOW}Linux${COLOR_RESET}: https://docs.docker.com/engine/install/'
