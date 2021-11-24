# Freely based on: https://gist.github.com/thomaspoignant/5b72d579bd5f311904d973652180c705
ONTOLOGY_PATH = "src/okp4.ttl"

DOCKER_IMAGE_RUBY_RDF=ghcr.io/okp4/ruby-rdf:3.1.15
DOCKER_IMAGE_WIDOCO=ghcr.io/okp4/widoco:1.4.15
DOCKER_IMAGE_HTTPD=httpd:2.4.51

# Some colors
COLOR_GREEN  = $(shell tput -Txterm setaf 2)
COLOR_YELLOW = $(shell tput -Txterm setaf 3)
COLOR_WHITE  = $(shell tput -Txterm setaf 7)
COLOR_CYAN   = $(shell tput -Txterm setaf 6)
COLOR_RESET  = $(shell tput -Txterm sgr0)

.PHONY: all lint lint-ontology documentation

all: help

## Lint:
lint: lint-ontology ## Lint all available linters

lint-ontology: ## Lint ontology
	@echo "${COLOR_CYAN}Linting: ${COLOR_GREEN}${ONTOLOGY_PATH}${COLOR_RESET}"
	@docker run -ti --rm \
  		-v `pwd`:/usr/src/ontology:ro \
  		-w /usr/src/ontology \
  		${DOCKER_IMAGE_RUBY_RDF} validate --validate ${ONTOLOGY_PATH}

## Documentation:
documentation: ## Generate documentation site
	@echo "${COLOR_CYAN}Generate documentation for ${COLOR_GREEN}${ONTOLOGY_PATH}${COLOR_RESET}"
	@docker run \
	    -ti --rm \
  		-v `pwd`:/usr/src/ontology \
		${DOCKER_IMAGE_WIDOCO} \
			-ontFile /usr/src/ontology/${ONTOLOGY_PATH} \
			-outFolder /usr/src/ontology/target/generated/ontology \
			-lang en \
			-rewriteAll \
			-getOntologyMetadata \
			-includeImportedOntologies \
			-webVowl \
			-displayDirectImportsOnly \
			-uniteSections

start-site: documentation ## Start a web server for serving generated documentation
	@echo "${COLOR_CYAN}Site will be available here: ${COLOR_GREEN}http://localhost:8080/index-en.html${COLOR_RESET}"
	@docker run -ti --rm \
	  -p 8080:80 \
	  -v `pwd`/target/generated/ontology:/usr/local/apache2/htdocs/:ro \
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
	@echo 'This Makefile depends on ${COLOR_CYAN}docker${COLOR_RESET}. To install jt, please follow the instructions:'
	@echo '- for ${COLOR_YELLOW}macOS${COLOR_RESET}: https://docs.docker.com/docker-for-mac/install/'
	@echo '- for ${COLOR_YELLOW}Windows${COLOR_RESET}: https://docs.docker.com/docker-for-windows/install/'
	@echo '- for ${COLOR_YELLOW}Linux${COLOR_RESET}: https://docs.docker.com/engine/install/'