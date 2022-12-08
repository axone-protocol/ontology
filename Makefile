# Freely based on: https://gist.github.com/thomaspoignant/5b72d579bd5f311904d973652180c705

# Docker images
DOCKER_IMAGE_RUBY_RDF=ghcr.io/okp4/ruby-rdf:3.1.15
DOCKER_IMAGE_WIDOCO=ghcr.io/okp4/widoco:1.4.15
DOCKER_IMAGE_HTTPD=httpd:2.4.51

# Some colors
COLOR_GREEN  = $(shell tput -Txterm setaf 2)
COLOR_YELLOW = $(shell tput -Txterm setaf 3)
COLOR_WHITE  = $(shell tput -Txterm setaf 7)
COLOR_CYAN   = $(shell tput -Txterm setaf 6)
COLOR_RESET  = $(shell tput -Txterm sgr0)

# Build constants
TARGET       := ./target
OBJ          := $(TARGET)/nt
DOC          := $(TARGET)/doc
SRC          := ./src
SRCS         := $(wildcard $(SRC)/*.ttl)
OBJS         := $(patsubst $(SRC)/%.ttl,$(OBJ)/%.nt,$(SRCS))
ARTIFACT_TTL := $(TARGET)/okp4.ttl
ARTIFACT_NT  := $(TARGET)/okp4.nt

.PHONY: all clean build lint lint-ontology lint-parts documentation start-site help

all: help

## Clean:
clean: ## Clean all generated files
	@echo "${COLOR_CYAN}Cleaning: ${COLOR_GREEN}${DOC}${COLOR_RESET}"
	@sudo rm -rf target

## Build:
build: $(ARTIFACT_TTL) ## Build the ontology

$(ARTIFACT_TTL): $(ARTIFACT_NT)
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} the ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@docker run --rm \
  		-v `pwd`:/usr/src/ontology:rw \
  		-w /usr/src/ontology \
  		${DOCKER_IMAGE_RUBY_RDF} serialize -o $@ --output-format turtle $<

$(ARTIFACT_NT): $(OBJS) | $(BIN)
	@echo "${COLOR_CYAN}🔨 assembling${COLOR_RESET} ontology into ${COLOR_GREEN}$@${COLOR_RESET}"
	@cat $^ > $@

$(OBJ)/%.nt: $(SRC)/%.ttl | $(OBJ)
	@echo "${COLOR_CYAN}🔁 converting${COLOR_RESET} ontology ${COLOR_GREEN}$<${COLOR_RESET} into ${COLOR_GREEN}$@${COLOR_RESET}"
	@docker run --rm \
  		-v `pwd`:/usr/src/ontology:rw \
  		-w /usr/src/ontology \
  		${DOCKER_IMAGE_RUBY_RDF} serialize -o $@ $<

$(BIN) $(OBJ):
	@mkdir -p $@

## Lint:
lint: lint-parts lint-ontology ## Lint all available linters

lint-ontology: build ## Lint final (generated) ontology
	@echo "${COLOR_CYAN}Linting: ${COLOR_GREEN}${ARTIFACT_TTL}${COLOR_RESET}"
	@docker run --rm \
  		-v `pwd`:/usr/src/ontology:ro \
  		-w /usr/src/ontology \
  		${DOCKER_IMAGE_RUBY_RDF} validate --validate ${ARTIFACT_TTL}

lint-parts: $(SRC)/*.ttl ## Lint all the parts of the ontology
	@for file in $^ ; do \
		echo "${COLOR_CYAN}Linting: ${COLOR_GREEN}$${file}${COLOR_RESET}"; \
		docker run --rm \
  		  -v `pwd`:/usr/src/ontology:ro \
  		  -w /usr/src/ontology \
  		  ${DOCKER_IMAGE_RUBY_RDF} validate --validate $${file}; \
	done

## Documentation:
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

start-site: documentation ## Start a web server for serving generated documentation
	@echo "${COLOR_CYAN}Site will be available here: ${COLOR_GREEN}http://localhost:8080/index-en.html${COLOR_RESET}"
	@docker run --rm \
	  -p 8080:80 \
	  -v `pwd`/${DOC}/ontology/:/usr/local/apache2/htdocs/:ro \
	  ${DOCKER_IMAGE_HTTPD}

## Help:
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
