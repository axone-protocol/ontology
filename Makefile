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
build:  build-ontology build-examples ## Build all the files (ontology and examples)

.PHONY: cache build-ontology
build-ontology: $(BIN_OKP4_TTL) $(BIN_OKP4_RDFXML) ## Build the ontology

.PHONY: cache build-examples
build-examples: $(BIN_EXAMPLE_TTL) $(BIN_EXAMPLE_JSONLD) ## Build the examples

$(OBJ_ONTS): $(DST_ONT)/%.nt: $(SRC_ONT)/%.ttl
    @echo "${COLOR_CYAN}🔄 converting${COLOR_RESET} to ${COLOR_GREEN}$@${COLOR_RESET}"
    @mkdir -p $(@D)
    ${call RDF_SERIALIZE,turtle,ntriples,$<,$@}

$(OBJ_EXMS): $(DST_EXM)/%.nt: $(SRC_EXM)/%.ttl
    @echo "${COLOR_CYAN}🔄 converting${COLOR_RESET} to ${COLOR_GREEN}$@${COLOR_RESET}"
    @mkdir -p $(@D)
    ${call RDF_SERIALIZE,turtle,ntriples,$<,$@}

$(BIN_OKP4_NT): $(OBJ_ONTS)
    @echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
    @cat $^ > $@

$(BIN_OKP4_TTL): $(BIN_OKP4_NT)
    @echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
    @touch $@
    ${call RDF_SERIALIZE,ntriples,turtle,$<,$@}

$(BIN_OKP4_RDFXML): $(BIN_OKP4_NT)
    @echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
    @touch $@
    ${call RDF_SERIALIZE,ntriples,rdfxml,$<,$@}

$(BIN_EXAMPLE_NT): $(OBJ_EXMS)
    @echo "${COLOR_CYAN}📦 making${COLOR_RESET} examples ${COLOR_GREEN}$@${COLOR_RESET}"
    @cat $^ > $@

$(BIN_EXAMPLE_TTL): $(BIN_EXAMPLE_NT)
    @echo "${COLOR_CYAN}📦 making${COLOR_RESET} examples ${COLOR_GREEN}$@${COLOR_RESET}"
    ${call RDF_SERIALIZE,ntriples,turtle,$<,$@}

$(BIN_EXAMPLE_JSONLD): $(BIN_EXAMPLE_NT)
    @echo "${COLOR_CYAN}📦 making${COLOR_RESET} examples ${COLOR_GREEN}$@${COLOR_RESET}"
    ${call RDF_SERIALIZE,ntriples,jsonld,$<,$@}

## Format:
.PHONY: format
format: format-ttl ## Format with all available formatters

.PHONY: format-ttl
format-ttl: cache $(FLG_TTLS_FMT) ## Format all Turtle files

$(FLG_TTLS_FMT): $(DST_LINT)/%.formatted.flag: $(ROOT)/%.ttl
    @echo "${COLOR_CYAN}📐 formating: ${COLOR_GREEN}$<${COLOR_RESET}"
    @mkdir -p $(@D)
    ${call RDF_WRITE,turtle,$<,"$<.formatted"}
    @mv -f "$<.formatted" $<
    @touch $@

## Lint:
.PHONY: lint
lint: lint-ttl ## Lint with all available linters

.PHONY: lint-ttl
lint-ttl: cache $(FLG_TTLS_LNT) ## Lint all Turtle files

$(FLG_TTLS_LNT): $(DST_LINT)/%.linted.flag: $(ROOT)/%.ttl
    @echo "${COLOR_CYAN}🔬 linting: ${COLOR_GREEN}$<${COLOR_RESET}"
    @mkdir -p $(@D)
    @docker run --rm \
      -v `pwd`:/usr/src/ontology:ro \
      -w /usr/src/ontology \
      ${DOCKER_IMAGE_RUBY_RDF} validate --validate $<
    @touch $@

## Test:
.PHONY: test
test: test-ontology ## Run all available tests

.PHONY: test-ontology
test-ontology: build $(FLG_TSTS) ## Test final (generated) ontology

$(FLG_TSTS): $(DST_TEST)/%.tested.flag: $(SRC_TST)/%.ttl $(SRC_ONT)/%.ttl
    @echo "${COLOR_CYAN}🧪 testing: ${COLOR_GREEN}$<${COLOR_RESET}"
    @mkdir -p $(@D)
    $(call RDF_SHACL,$<,$@) \
      && echo "  ↳ ✅ ${COLOR_GREEN}passed ${COLOR_CYAN}$<${COLOR_RESET}" \
      || { \
           echo "  ↳ ❌ ${COLOR_RED}failed ${COLOR_CYAN}$<${COLOR_RESET}"; \
           exit 1; \
         }

## Documentation:
.PHONY: doc
doc: build-ontology ## Generate documentation site
    @echo "${COLOR_CYAN}📖 generating documentation for ${COLOR_GREEN}${BIN_OKP4_TTL}${COLOR_RESET}"
    @docker run \
        --rm \
        -v `pwd`:/usr/src/ontology \
        ${DOCKER_IMAGE_WIDOCO} \
            -ontFile /usr/src/ontology/${BIN_OKP4_RDFXML} \
            -outFolder /usr/src/ontology/${DST_DOC} \
            -lang en \
            -rewriteAll \
            -getOntologyMetadata \
            -includeImportedOntologies \
            -webVowl \
            -displayDirectImportsOnly \
            -uniteSections
    @sudo chown -R  "$$(id -u):$$(id -g)" ${DST_DOC}
    @cp -R public/* ${DST_DOC}

.PHONY: doc-serve
doc-serve: doc ## Start a web server for serving generated documentation
    @echo "${COLOR_CYAN}🌐 serving documentation - available at ${COLOR_GREEN}http://localhost:8080/index-en.html${COLOR_RESET}"
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
