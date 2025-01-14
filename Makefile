# Freely based on: https://gist.github.com/thomaspoignant/5b72d579bd5f311904d973652180c705

# Deployment
DEPLOYMENT_FUSEKI_CONTAINER=okp4-dataverse-fuseki
DEPLOYMENT_FUSEKI_STARTUP_TIMEOUT=30
DEPLOYMENT_FUSEKI_PORT=3030
DEPLOYMENT_FUSEKI_USER_NAME=admin
DEPLOYMENT_FUSEKI_USER_PWD=admin
DEPLOYMENT_FUSEKI_DATASET=dataverse

# Some colors
COLOR_CYAN   := $(shell tput -Txterm setaf 6)
COLOR_GREEN  := $(shell tput -Txterm setaf 2)
COLOR_RED    := $(shell tput -Txterm setaf 1)
COLOR_RESET  := $(shell tput -Txterm sgr0)
COLOR_WHITE  := $(shell tput -Txterm setaf 7)
COLOR_YELLOW := $(shell tput -Txterm setaf 3)

# Build constants
ROOT := .

# - Version constants
VERSION 	  := $(shell cat version)
VERSION_MAJOR := $(word 1,$(subst ., ,$(VERSION)))
VERSION_MINOR := $(word 2,$(subst ., ,$(VERSION)))
VERSION_PATCH := $(word 3,$(subst ., ,$(VERSION)))

# - Destination directories
DST              := $(ROOT)/target
DST_CACHE        := $(DST)/.cache
DST_DOCS		 := $(ROOT)/docs
DTS_DOCS_SCHEMAS := $(DST_DOCS)/schemas
DST_MAKE         := $(DST)/.make
DST_ONT          := $(DST)/ontology/v$(VERSION_MAJOR)
DST_SCHEMA       := $(DST_ONT)/schema
DST_THESAURUS    := $(DST_ONT)/thesaurus
DST_FORMAT       := $(DST_MAKE)/format
DST_LINT         := $(DST_MAKE)/lint
DST_TEST         := $(DST_MAKE)/test

# - Build
SRC_ONT             := $(ROOT)/src
SRC_SCRIPT          := $(ROOT)/script
SRC_SCHEMA 		    := $(SRC_ONT)/schema
SRC_THESAURUS	    := $(SRC_ONT)/thesaurus
SRC_ONTS            := $(shell find $(SRC_ONT) -name "*.ttl" | sort)
SRC_SCHEMAS		    := $(shell find $(SRC_SCHEMA) -name "*.ttl" | sort)
SRC_THESAURI	    := $(shell find $(SRC_THESAURUS) -name "*.ttl" | sort)
SRC_EXAMPLES        := $(shell find $(SRC_ONT) -name "*.jsonld" | sort)
OBJ_ONTS_TTL        := $(patsubst $(SRC_ONT)/%.ttl,$(DST_ONT)/%.ttl,$(SRC_ONTS))
OBJ_ONTS_NT         := $(patsubst $(SRC_ONT)/%.ttl,$(DST_ONT)/%.nt,$(SRC_ONTS))
OBJ_ONTS_RDFXML     := $(patsubst $(SRC_ONT)/%.ttl,$(DST_ONT)/%.rdf.xml,$(SRC_ONTS))
OBJ_SCHEMAS_JSONLD  := $(patsubst $(SRC_SCHEMA)/%.ttl,$(DST_ONT)/schema/%.jsonld,$(SRC_SCHEMAS))
OBJ_THESAURI_JSONLD := $(patsubst $(SRC_THESAURUS)/%.ttl,$(DST_ONT)/thesaurus/%.jsonld,$(SRC_THESAURI))
OBJ_EXAMPLES_JSONLD := $(patsubst $(SRC_ONT)/%.jsonld,$(DST_ONT)/%.jsonld,$(SRC_EXAMPLES))
OBJ_EXAMPLES_NQUAD  := $(patsubst $(SRC_ONT)/%.jsonld,$(DST_ONT)/%.nq,$(SRC_EXAMPLES))

AXONE_ARTIFACT_ID   := axone-ontology
BIN_AXONE_TTL       := $(DST)/$(AXONE_ARTIFACT_ID)-$(VERSION).ttl
BIN_AXONE_NT        := $(DST)/$(AXONE_ARTIFACT_ID)-$(VERSION).nt
BIN_AXONE_RDFXML    := $(DST)/$(AXONE_ARTIFACT_ID)-$(VERSION).rdf.xml
BIN_AXONE_BUNDLE    := $(DST)/$(AXONE_ARTIFACT_ID)-$(VERSION)-bundle.tar.gz
BIN_DOC_SCHEMAS	    := $(patsubst %.ttl,$(DTS_DOCS_SCHEMAS)/%.md,$(notdir $(SRC_SCHEMAS)))

# - Format
FLG_FMT_TTLS := $(patsubst $(SRC_ONT)/%.ttl,$(DST_FORMAT)/%.formatted,$(SRC_ONTS))

# - Lint
FLG_LINT_TTLS    := $(patsubst $(SRC_ONT)/%.ttl,$(DST_LINT)/%.linted,$(SRC_ONTS))
FLG_LINT_JSONLDS := $(patsubst $(SRC_ONT)/%.jsonld,$(DST_LINT)/%.linted,$(SRC_EXAMPLES))

# - Test
SRC_TST  := $(ROOT)/test
SRC_TSTS := $(shell find $(SRC_TST) -name "*.ttl" | sort)
FLG_TSTS := $(patsubst $(SRC_TST)/%.ttl,$(DST_TEST)/%.tested,$(SRC_TSTS))

# - Script
SRC_SCRIPT := $(ROOT)/script

# Docker images
DOCKER_IMAGE_FUSEKI       := secoresearch/fuseki:5.2.0
DOCKER_IMAGE_HTTPD        := httpd:2.4.62-alpine3.21
DOCKER_IMAGE_JRE          := eclipse-temurin:19.0.2_7-jre-focal
DOCKER_IMAGE_MARKDOWNLINT := thegeeklab/markdownlint-cli:0.42.0
DOCKER_IMAGE_POETRY       := fnndsc/python-poetry:1.7.1
DOCKER_IMAGE_PYSHACL      := ashleysommer/pyshacl:v0.25.0
DOCKER_IMAGE_RUBY_RDF     := okp4/ruby-rdf:3.3.1
DOCKER_IMAGE_CLI	      := okp4/cli

# Executables
VERSION_OWL_CLI := 1.2.4
EXEC_OWL_CLI    := owl-cli-$(VERSION_OWL_CLI).jar

# Other constants
PERMISSION_MODE := 767
JSONLD_INDENT   := 2

# sed -i support
SED_FLAG=
SHELL_NAME := $(shell uname -s)
ifeq ($(SHELL_NAME),Darwin)
    SED_FLAG := ""
endif

# Runners
RDF_WRITE = \
  docker run --rm \
      -v `pwd`:/usr/src/ontology:rw \
      -w /usr/src/ontology \
      ${DOCKER_IMAGE_JRE} \
        java -jar ${DST_CACHE}/$(EXEC_OWL_CLI) \
        write \
        -o $1 \
        $2 \
        $3
RDF_SERIALIZE = \
  docker run --rm \
    -v `pwd`:/usr/src/ontology:rw \
    -w /usr/src/ontology \
    ${DOCKER_IMAGE_RUBY_RDF} \
      serialize \
	  --validate \
      -o $4 \
      --output-format $2 \
      --input-format $1 \
      $3
RDF_SHACL = \
  docker run --rm \
    -v `pwd`:/usr/src/ontology \
    ${DOCKER_IMAGE_PYSHACL} poetry run pyshacl \
    --shacl /usr/src/ontology/$1 \
    --output /usr/src/ontology/$3 \
    --inference none \
    --format human \
    /usr/src/ontology/$2
NT_UNIQUIFY = \
  HASH=`md5sum $1 | awk '{print $$1}'`; \
  sed -E -i ${SED_FLAG} "s/_:(g[0-9]+)/_:$${HASH}_\1/g" $1
CLI = \
  docker run --rm \
	-v `pwd`:/usr/src/ontology \
	-w /usr/src/ontology \
	${DOCKER_IMAGE_CLI} sh -c "poetry run -C $(SRC_SCRIPT) cli $1 $2 $3 $4 $5 $6 $7 $8 $9"
MARKDOWN_LINT = \
  docker run --rm \
	-v `pwd`:/usr/src/ontology \
	-w /usr/src/ontology \
	${DOCKER_IMAGE_MARKDOWNLINT} $1 $2 $3 $4 $5 $6 $7 $8 $9

.PHONY: help
all: help

## Clean:
.PHONY: clean
clean: clean-cache clean-build clean-ontologies ## Clean all generated files
	@echo "${COLOR_CYAN}🧹 cleaning: ${COLOR_GREEN}${DST}${COLOR_RESET}"
	@rm -rf ${DST}

.PHONY: clean-cache
clean-cache: ## Clean the cache
	@echo "${COLOR_CYAN}🧹 cleaning: ${COLOR_GREEN}${DST_CACHE}${COLOR_RESET}"
	@rm -rf ${DST_CACHE}

.PHONY: clean-build
clean-build: ## Clean the .make (build) directory
	@echo "${COLOR_CYAN}🧹 cleaning: ${COLOR_GREEN}${DST_MAKE}${COLOR_RESET}"
	@rm -rf ${DST_MAKE}

.PHONY: clean-ontologies
clean-ontologies: ## Clean the built ontologies
	@echo "${COLOR_CYAN}🧹 cleaning: ${COLOR_GREEN}${DST_ONT}${COLOR_RESET}"
	@rm -rf ${DST_ONT}

## Build:
.PHONY: build
build: build-ontology-bundle ## Build all the files

.PHONY: build-ontology
build-ontology: check $(DST) build-ontology-ttl build-ontology-nt build-ontology-rdfxml build-ontology-jsonld ## Build the ontology in all available formats (N-Triples, RDF/XML, JSON-LD)

.PHONY: build-ontology-ttl
build-ontology-ttl: check $(DST) $(BIN_AXONE_TTL) ## Build the ontology in Turtle format

.PHONY: build-ontology-nt
build-ontology-nt: check $(DST) $(BIN_AXONE_NT) ## Build the ontology in N-Triples format

.PHONY: build-ontology-rdfxml
build-ontology-rdfxml: check $(DST) $(OBJ_ONTS_RDFXML) $(BIN_AXONE_RDFXML) ## Build the ontology in RDF/XML format

.PHONY: build-ontology-jsonld
build-ontology-jsonld: check cache $(DST) $(OBJ_SCHEMAS_JSONLD) $(OBJ_THESAURI_JSONLD)  ## Build the ontology in JSON-LD format

.PHONY: build-examples
build-examples: build-examples-jsonld build-ontology-jsonld build-examples-nquad $(DST) ## Build the examples in different formats (N-Quads, JSON-LD)

.PHONY: build-examples-jsonld
build-examples-jsonld: check $(OBJ_EXAMPLES_JSONLD)

.PHONY: build-examples-nquad
build-examples-nquad: check build-examples-jsonld build-ontology-jsonld $(OBJ_EXAMPLES_NQUAD)

$(OBJ_ONTS_TTL): $(DST_ONT)/%.ttl: $(SRC_ONT)/%.ttl
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@cp $< $@
	@sed -i ${SED_FLAG} "s/\$$major/$(VERSION_MAJOR)/g" $@

$(OBJ_ONTS_NT): $(DST_ONT)/%.nt: $(DST_ONT)/%.ttl
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@${call RDF_SERIALIZE,turtle,ntriples,$<,$@}
	@${call NT_UNIQUIFY,$@}

$(OBJ_ONTS_RDFXML): $(DST_ONT)/%.rdf.xml: $(DST_ONT)/%.ttl
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@${call RDF_SERIALIZE,turtle,rdfxml,$<,$@}

$(OBJ_SCHEMAS_JSONLD): $(DST_SCHEMA)/%.jsonld: $(DST_SCHEMA)/%.ttl
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} schema ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@${call CLI,jsonld,convert,$<,-o,$@,--flatten,--indent,$(JSONLD_INDENT)}

$(OBJ_THESAURI_JSONLD): $(DST_THESAURUS)/%.jsonld: $(DST_THESAURUS)/%.ttl
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} thesaurus ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@${call RDF_SERIALIZE,turtle,jsonld,$<,$@}

$(OBJ_EXAMPLES_JSONLD): $(DST_ONT)/%.jsonld: $(SRC_ONT)/%.jsonld
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} example ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@cp $< $@
	@sed -i ${SED_FLAG} "s/\$$major/$(VERSION_MAJOR)/g" $@

$(OBJ_EXAMPLES_NQUAD): $(DST_ONT)/%.nq: $(DST_ONT)/%.jsonld
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} example ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@${call CLI,jsonld,nquads,$<,-o,$@,--algorithm,URDNA2015,--context-folder,$(DST_SCHEMA)}

$(BIN_AXONE_NT): $(OBJ_ONTS_NT)
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@cat $^ > $@

$(BIN_AXONE_TTL): $(BIN_AXONE_NT)
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@touch $@
	@${call RDF_SERIALIZE,ntriples,turtle,$<,$@}

$(BIN_AXONE_RDFXML): $(BIN_AXONE_NT)
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@touch $@
	@${call RDF_SERIALIZE,ntriples,rdfxml,$<,$@}

$(BIN_AXONE_JSONLD): $(BIN_AXONE_NT)
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@touch $@
	@${call CLI,jsonld,convert,$<,-o,$@,--flatten,--indent,$(JSONLD_INDENT)}

$(BIN_DOC_SCHEMAS): $(OBJ_ONTS_TTL) $(OBJ_EXAMPLES_JSONLD) $(shell find $(SRC_SCRIPT) -name "*.*") Makefile
	@echo "${COLOR_CYAN}📝 generating ${COLOR_GREEN}schemas ${COLOR_RESET}documentation"
	@rm -rf $(DTS_DOCS_SCHEMAS)
	@mkdir -p -m $(PERMISSION_MODE) $(DTS_DOCS_SCHEMAS)
	@${call CLI,documentation,generate,$(DST_ONT)/schema,$(DTS_DOCS_SCHEMAS),--example-path,$(DST_ONT)/example}
	@echo "${COLOR_CYAN}🔍 linting ${COLOR_GREEN}schemas ${COLOR_RESET}documentation"
	${call MARKDOWN_LINT,-f,$(DTS_DOCS_SCHEMAS)}

.PHONY: build-ontology-bundle
build-ontology-bundle: $(DST) build-ontology build-examples $(BIN_AXONE_BUNDLE) ## Build a tarball containing the segments and the ontology in all available formats (N-Triples, RDF/XML, JSON-LD) plus the examples

$(BIN_AXONE_BUNDLE): $(shell test -d $(DST_ONT) && find $(DST_ONT) -type f -name "*.ttl") $(ROOT)/LICENSE
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET} tarball"
	@tar -cvzf $(BIN_AXONE_BUNDLE) \
	  -C $(abspath $(ROOT)) LICENSE \
	  -C $(abspath $(DST)) $(shell cd $(DST) ; echo $(AXONE_ARTIFACT_ID)-$(VERSION).*) \
	  -C $(abspath $(DST_ONT)) $(shell cd $(DST_ONT) ; echo *)
	@echo "${COLOR_CYAN}📊 tarball ${COLOR_GREEN}statistics${COLOR_RESET}"
	@echo "${COLOR_CYAN}   ↳ 🗃️ number of files${COLOR_RESET}: ${COLOR_GREEN}$$(tar -tzf $(BIN_AXONE_BUNDLE) | wc -l | bc)${COLOR_RESET}"
	@echo "${COLOR_CYAN}   ↳ 📏 size${COLOR_RESET}           : ${COLOR_GREEN}$$(du -sh $(BIN_AXONE_BUNDLE) | cut -f1)${COLOR_RESET}"

## Format:
.PHONY: format
format: check format-ttl ## Format with all available formatters

.PHONY: format-ttl
format-ttl: check cache $(FLG_FMT_TTLS) ## Format all Turtle files

$(FLG_FMT_TTLS): $(DST_FORMAT)/%.formatted: $(SRC_ONT)/%.ttl
	@echo "${COLOR_CYAN}📐 formating: ${COLOR_GREEN}$<${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@${call RDF_WRITE,turtle,$<,"$<.formatted"}
	@mv -f "$<.formatted" $<
	@touch $@

## Lint:
.PHONY: lint
lint: lint-ttl lint-jsonld ## Lint with all available linters

.PHONY: lint-ttl
lint-ttl: check cache $(FLG_LINT_TTLS) ## Lint all Turtle files

$(FLG_LINT_TTLS): $(DST_LINT)/%.linted: $(SRC_ONT)/%.ttl
	@echo "${COLOR_CYAN}🔬 linting: ${COLOR_GREEN}$<${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@docker run --rm \
      -v `pwd`:/usr/src/ontology:ro \
      -w /usr/src/ontology \
      ${DOCKER_IMAGE_RUBY_RDF} validate --validate $<
	@touch $@

.PHONY: lint-jsonld
lint-jsonld: check cache $(FLG_LINT_JSONLDS) ## Lint all JSON-LD files

$(FLG_LINT_JSONLDS): $(DST_LINT)/%.linted: $(SRC_ONT)/%.jsonld
	@echo "${COLOR_CYAN}🔬 linting: ${COLOR_GREEN}$<${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@cp $< $@.jsonld
	@sed -i ${SED_FLAG} "s/\$$major/next/g" $@.jsonld
	@docker run --rm \
	  -v `pwd`:/usr/src/ontology:ro \
	  -w /usr/src/ontology \
	  ${DOCKER_IMAGE_RUBY_RDF} validate --validate $@.jsonld
	@mv -f $@.jsonld $@

## Documentation:
.PHONY: docs
docs: build-examples docs-schemas ## Generate all available documentation

.PHONY: docs-schemas
docs-schemas: check cache $(BIN_DOC_SCHEMAS) ## Generate schemas markdown documentation

## Test:
.PHONY: test
test: test-ontology ## Run all available tests

.PHONY: test-ontology
test-ontology: check build-ontology-nt $(FLG_TSTS) ## Test the ontology

$(FLG_TSTS): $(DST_TEST)/%.tested: $(SRC_TST)/%.ttl $(wildcard $(DST_ONT)/*.ttl)
	@echo "${COLOR_CYAN}🧪 test: ${COLOR_GREEN}$<${COLOR_RESET}"
	mkdir -p -m $(PERMISSION_MODE) $(@D)
	@bash -c '\
		for target in $(BIN_AXONE_NT); do \
			$(call RDF_SHACL,$<,$$target,$@) \
			&& echo "  ↳ ✅ ${COLOR_CYAN}$$target ${COLOR_GREEN}passed ${COLOR_CYAN}$<${COLOR_RESET}" \
			|| { \
				echo "  ↳ ❌ ${COLOR_CYAN}$$target ${COLOR_RED}failed ${COLOR_CYAN}$<${COLOR_RESET}"; \
				exit 1; \
			}; \
		done \
	'

## Fuseki:
.PHONY: fuseki-up
fuseki-up: ## Start a Fuseki server and wait for it to be ready
	@if [ "$$(docker ps -q -f name=${DEPLOYMENT_FUSEKI_CONTAINER})" ]; then \
	  echo "${COLOR_CYAN}🟢 Fuseki already running on container ${COLOR_GREEN}${DEPLOYMENT_FUSEKI_CONTAINER}${COLOR_RESET} and exposing ${COLOR_GREEN}http://localhost:${DEPLOYMENT_FUSEKI_PORT}/${COLOR_RESET}"; \
	else \
	  echo "${COLOR_CYAN}🚀 starting ${COLOR_GREEN}Fuseki${COLOR_RESET} server" && \
	  docker run \
	    --rm \
	    -d \
	    --name ${DEPLOYMENT_FUSEKI_CONTAINER} \
	    -p ${DEPLOYMENT_FUSEKI_PORT}:${DEPLOYMENT_FUSEKI_PORT} \
	    -v `pwd`/shiro.ini:/fuseki/shiro.ini \
	    -e ADMIN_PASSWORD=${DEPLOYMENT_FUSEKI_USER_PWD} \
	    -e ENABLE_DATA_WRITE=true \
	    -e ENABLE_UPDATE=true \
	    -e ENABLE_UPLOAD=true \
	    ${DOCKER_IMAGE_FUSEKI} && \
	  sleep 1 && \
	  echo "${COLOR_CYAN}⏱️ waiting ${COLOR_RESET}for ${COLOR_GREEN}REST API${COLOR_RESET} to be ${COLOR_GREEN}ready${COLOR_RESET}...${COLOR_RESET}" && \
	  timeout ${DEPLOYMENT_FUSEKI_STARTUP_TIMEOUT} sh -c 'until $$(curl --output /dev/null --silent --head --fail http://localhost:${DEPLOYMENT_FUSEKI_PORT}/$$/ping); do \
	      printf '.'; \
	      sleep 1; \
	  done' && \
	  echo "" \
	  echo "${COLOR_CYAN}🟢 Fuseki running on container ${COLOR_GREEN}${DEPLOYMENT_FUSEKI_CONTAINER}${COLOR_RESET} and exposing ${COLOR_GREEN}http://localhost:${DEPLOYMENT_FUSEKI_PORT}/${COLOR_RESET} - have fun 🎉" || \
	  (echo "❌ ${COLOR_RED}failed${COLOR_RESET}" && exit 1); \
	fi

.PHONY: fuseki-down
fuseki-down: check ## Stop the Fuseki container
	@echo "${COLOR_CYAN}✋ stopping ${COLOR_GREEN}Fuseki${COLOR_RESET} server running on container ${COLOR_GREEN}${DEPLOYMENT_FUSEKI_CONTAINER}${COLOR_RESET}"
	@docker stop ${DEPLOYMENT_FUSEKI_CONTAINER}
	@echo "${COLOR_CYAN}⚪️ Fuseki server stopped${COLOR_RESET}"

.PHONY: fuseki-load
fuseki-load: $(BIN_AXONE_TTL) fuseki-up ## Load the ontology in Fuseki server
	@echo "${COLOR_CYAN}📂 creating ${COLOR_GREEN}${DEPLOYMENT_FUSEKI_DATASET}${COLOR_RESET}"
	curl -X POST --user "${DEPLOYMENT_FUSEKI_USER_NAME}:${DEPLOYMENT_FUSEKI_USER_PWD}" --fail --data "dbName=${DEPLOYMENT_FUSEKI_DATASET}&dbType=tdb2" "http://localhost:${DEPLOYMENT_FUSEKI_PORT}/$$/datasets"
	@echo "${COLOR_CYAN}📦 loading ${COLOR_GREEN}${BIN_AXONE_TTL}${COLOR_RESET}"
	@curl -X POST --user "${DEPLOYMENT_FUSEKI_USER_NAME}:${DEPLOYMENT_FUSEKI_USER_PWD}" -H "Content-Type: text/turtle" --data-binary "@${BIN_AXONE_TTL}" http://localhost:${DEPLOYMENT_FUSEKI_PORT}/${DEPLOYMENT_FUSEKI_DATASET}/data

.PHONY: fuseki-log
fuseki-log: check ## Show Fuseki server logs
	@echo "${COLOR_CYAN}📜 showing ${COLOR_GREEN}Fuseki logs${COLOR_RESET} from container ${COLOR_GREEN}${DEPLOYMENT_FUSEKI_CONTAINER}${COLOR_RESET}"
	@docker logs ${DEPLOYMENT_FUSEKI_CONTAINER} -f

## Misc:
.PHONY: cache
cache: $(DST_CACHE)/$(EXEC_OWL_CLI) $(DST_CACHE)/cli ## Download all required files to cache

$(DST_CACHE)/$(EXEC_OWL_CLI):
	@echo "${COLOR_CYAN}⤵️ downlading ${COLOR_GREEN}$(notdir $@)${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(DST_CACHE); \
    cd $(DST_CACHE); \
    wget https://github.com/atextor/owl-cli/releases/download/v$(VERSION_OWL_CLI)/$(EXEC_OWL_CLI)

$(DST_CACHE)/cli: $(shell find $(SRC_SCRIPT) -name "*.*" -not -path "$(SRC_SCRIPT)/.*")
	@echo "${COLOR_CYAN}🐳 making ${COLOR_GREEN}$(DOCKER_IMAGE_CLI)${COLOR_RESET} image"
	@docker image rm "$(DOCKER_IMAGE_CLI)" 2>/dev/null || true
	@DOCKER_CONTAINER_NAME="axone-cli-$$(date +%s)"; \
	docker run --name $$DOCKER_CONTAINER_NAME \
	  -v `pwd`:/usr/src/ontology \
	  -w /usr/src/ontology \
	  $(DOCKER_IMAGE_POETRY) sh -c "poetry install -C $(SRC_SCRIPT)" && \
	docker commit $$DOCKER_CONTAINER_NAME "$(DOCKER_IMAGE_CLI)" && \
	docker rm $$DOCKER_CONTAINER_NAME && \
	touch $@

.PHONY: check
check: $(FLG_CHECK_OK) ## Check if all required commands are available in the system

$(FLG_CHECK_OK):
	@echo "${COLOR_CYAN}☑️ checking ${COLOR_RESET} if required commands are available..."
	@for cmd in awk curl docker md5sum timeout wget; do \
		path=$$(which $$cmd); \
		if [ -z "$$path" ]; then \
			echo "${COLOR_CYAN}❌ ${COLOR_GREEN}$$cmd${COLOR_RESET} command is not available, please install it." && exit 1; \
		else \
			echo "${COLOR_CYAN}✅ ${COLOR_GREEN}$$cmd${COLOR_RESET} ($$path)"; \
		fi \
	done
	@mkdir -p -m $(PERMISSION_MODE) $(@D)
	@touch $(FLG_CHECK_OK)

$(DST):
	@echo "${COLOR_CYAN}📂 creating ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m $(PERMISSION_MODE) $(DST)

.PHONY: version
version: ## Show the current version
	@echo "${COLOR_CYAN}📦 version: ${COLOR_GREEN}${VERSION}${COLOR_RESET}"

## Help:
.PHONY: vars
vars: ## Show relevant variables used in this Makefile
	$(foreach var,$(sort $(filter DOCKER_IMAGE_% SRC_% DST_% OBJ_% FLG_% BIN_%,$(.VARIABLES))),$(info ${COLOR_GREEN}$(var)${COLOR_WHITE}=${COLOR_CYAN}$($(var))${COLOR_RESET}))

.PHONY: help
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${COLOR_YELLOW}make${COLOR_RESET} ${COLOR_GREEN}<target>${COLOR_RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${COLOR_YELLOW}%-22s${COLOR_GREEN}%s${COLOR_RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${COLOR_CYAN}%s${COLOR_RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
	@echo ''
	@echo 'This Makefile depends on ${COLOR_CYAN}docker${COLOR_RESET}. To install it, please follow the instructions:'
	@echo '- for ${COLOR_YELLOW}macOS${COLOR_RESET}: https://docs.docker.com/docker-for-mac/install/'
	@echo '- for ${COLOR_YELLOW}Windows${COLOR_RESET}: https://docs.docker.com/docker-for-windows/install/'
	@echo '- for ${COLOR_YELLOW}Linux${COLOR_RESET}: https://docs.docker.com/engine/install/'
