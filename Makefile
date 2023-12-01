# Freely based on: https://gist.github.com/thomaspoignant/5b72d579bd5f311904d973652180c705

# Docker images
DOCKER_IMAGE_FUSEKI   := docuteam/fuseki:4.2.0
DOCKER_IMAGE_HTTPD    := httpd:2.4.51
DOCKER_IMAGE_JRE      := eclipse-temurin:19.0.2_7-jre-focal
DOCKER_IMAGE_PYSHACL  := ashleysommer/pyshacl:v0.25.0
DOCKER_IMAGE_RUBY_RDF := okp4/ruby-rdf:3.3.1

# Executables
VERSION_OWL_CLI := 1.2.4
EXEC_OWL_CLI    := owl-cli-$(VERSION_OWL_CLI).jar

# Deployment
DEPLOYMENT_FUSEKI_CONTAINER=okp4-dataverse-fuseki
DEPLOYMENT_FUSEKI_STARTUP_TIMEOUT=30
DEPLOYMENT_FUSEKI_PORT=3030
DEPLOYMENT_FUSEKI_JVM_ARGS=-Xmx3g -Xms1048m
DEPLOYMENT_FUSEKI_DATASET=dataverse

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
DST_MAKE           := $(DST)/.make
DST_ONT            := $(DST)/ontology
DST_FORMAT         := $(DST_MAKE)/format
DST_LINT           := $(DST_MAKE)/lint
DST_TEST           := $(DST_MAKE)/test

# - Build
SRC_ONT            := $(ROOT)/src
SRC_ONTS           := $(shell find $(SRC_ONT) -name "*.ttl" | sort)
OBJ_ONTS_TTL       := $(patsubst $(SRC_ONT)/%.ttl,$(DST_ONT)/%.ttl,$(SRC_ONTS))
OBJ_ONTS_NT        := $(patsubst $(SRC_ONT)/%.ttl,$(DST_ONT)/%.nt,$(SRC_ONTS))
OBJ_ONTS_RDFXML    := $(patsubst $(SRC_ONT)/%.ttl,$(DST_ONT)/%.rdf.xml,$(SRC_ONTS))
OBJ_ONTS_JSONLD    := $(patsubst $(SRC_ONT)/%.ttl,$(DST_ONT)/%.jsonld,$(SRC_ONTS))

BIN_OKP4_TTL       := $(DST)/okp4.ttl
BIN_OKP4_NT        := $(DST)/okp4.nt
BIN_OKP4_RDFXML    := $(DST)/okp4.rdf.xml
BIN_OKP4_JSONLD    := $(DST)/okp4.jsonld

# - Format
FLG_FMT_TTLS       := $(patsubst $(SRC_ONT)/%.ttl,$(DST_FORMAT)/%.formatted,$(SRC_ONTS))

# - Lint
FLG_LINT_TTLS      := $(patsubst $(SRC_ONT)/%.ttl,$(DST_LINT)/%.linted,$(SRC_ONTS))

# - Test
SRC_TST            := $(ROOT)/test
SRC_TSTS           := $(shell find $(SRC_TST) -name "*.ttl" | sort)
FLG_TSTS           := $(patsubst $(SRC_TST)/%.ttl,$(DST_TEST)/%.tested,$(SRC_TSTS))

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

.PHONY: help
all: help

## Clean:
.PHONY: clean
clean: ## Clean all generated files
	@echo "${COLOR_CYAN}🧹 cleaning: ${COLOR_GREEN}${DST}${COLOR_RESET}"
	@rm -rf ${DST}

## Build:
.PHONY: build
build: build-ontology ## Build all the files

.PHONY: build-ontology
build-ontology: check build-ontology-ttl build-ontology-nt build-ontology-rdfxml build-ontology-jsonld ## Build the ontology in all available formats (N-Triples, RDF/XML, JSON-LD)

.PHONY: build-ontology-ttl
build-ontology-ttl: check $(BIN_OKP4_TTL) ## Build the ontology in Turtle format

.PHONY: build-ontology-nt
build-ontology-nt: check $(BIN_OKP4_NT) ## Build the ontology in N-Triples format

.PHONY: build-ontology-rdfxml
build-ontology-rdfxml: check $(OBJ_ONTS_RDFXML) $(BIN_OKP4_RDFXML) ## Build the ontology in RDF/XML format

.PHONY: build-ontology-jsonld
build-ontology-jsonld: check $(OBJ_ONTS_JSONLD) $(BIN_OKP4_JSONLD) ## Build the ontology in JSON-LD format

$(OBJ_ONTS_TTL): $(DST_ONT)/%.ttl: $(SRC_ONT)/%.ttl
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m 777 $(@D)
	@cp $< $@

$(OBJ_ONTS_NT): $(DST_ONT)/%.nt: $(DST_ONT)/%.ttl
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m 777 $(@D)
	@${call RDF_SERIALIZE,turtle,ntriples,$<,$@}
	@${call NT_UNIQUIFY,$@}

$(OBJ_ONTS_RDFXML): $(DST_ONT)/%.rdf.xml: $(DST_ONT)/%.ttl
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m 777 $(@D)
	@${call RDF_SERIALIZE,turtle,rdfxml,$<,$@}

$(OBJ_ONTS_JSONLD): $(DST_ONT)/%.jsonld: $(DST_ONT)/%.ttl
	@echo "${COLOR_CYAN}🔨 building${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@mkdir -p -m 777 $(@D)
	@${call RDF_SERIALIZE,turtle,jsonld,$<,$@}

$(BIN_OKP4_NT): $(OBJ_ONTS_NT)
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@cat $^ > $@

$(BIN_OKP4_TTL): $(BIN_OKP4_NT)
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@touch $@
	@${call RDF_SERIALIZE,ntriples,turtle,$<,$@}

$(BIN_OKP4_RDFXML): $(BIN_OKP4_NT)
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@touch $@
	@${call RDF_SERIALIZE,ntriples,rdfxml,$<,$@}

$(BIN_OKP4_JSONLD): $(BIN_OKP4_NT)
	@echo "${COLOR_CYAN}📦 making${COLOR_RESET} ontology ${COLOR_GREEN}$@${COLOR_RESET}"
	@touch $@
	@${call RDF_SERIALIZE,ntriples,jsonld,$<,$@}

## Format:
.PHONY: format
format: check format-ttl ## Format with all available formatters

.PHONY: format-ttl
format-ttl: check cache $(FLG_FMT_TTLS) ## Format all Turtle files

$(FLG_FMT_TTLS): $(DST_FORMAT)/%.formatted: $(SRC_ONT)/%.ttl
	@echo "${COLOR_CYAN}📐 formating: ${COLOR_GREEN}$<${COLOR_RESET}"
	@mkdir -p -m 777 $(@D)
	@${call RDF_WRITE,turtle,$<,"$<.formatted"}
	@mv -f "$<.formatted" $<
	@touch $@

## Lint:
.PHONY: lint
lint: lint-ttl ## Lint with all available linters

.PHONY: lint-ttl
lint-ttl: check cache $(FLG_LINT_TTLS) ## Lint all Turtle files

$(FLG_LINT_TTLS): $(DST_LINT)/%.linted: $(SRC_ONT)/%.ttl
	@echo "${COLOR_CYAN}🔬 linting: ${COLOR_GREEN}$<${COLOR_RESET}"
	@mkdir -p -m 777 $(@D)
	@docker run --rm \
      -v `pwd`:/usr/src/ontology:ro \
      -w /usr/src/ontology \
      ${DOCKER_IMAGE_RUBY_RDF} validate --validate $<
	@touch $@

## Test:
.PHONY: test
test: test-ontology ## Run all available tests

.PHONY: test-ontology
test-ontology: check build-ontology-nt $(FLG_TSTS) ## Test the ontology

$(FLG_TSTS): $(DST_TEST)/%.tested: $(SRC_TST)/%.ttl $(wildcard $(DST_ONT)/*.ttl)
	@echo "${COLOR_CYAN}🧪 test: ${COLOR_GREEN}$<${COLOR_RESET}"
	@mkdir -p -m 777 $(@D)
	@bash -c '\
		for target in $(BIN_OKP4_NT); do \
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
	    -e JAVA_OPTS="${DEPLOYMENT_FUSEKI_JVM_ARGS}" \
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
fuseki-load: $(BIN_OKP4_TTL) fuseki-up ## Load the ontology in Fuseki server
	@echo "${COLOR_CYAN}📂 creating ${COLOR_GREEN}${DEPLOYMENT_FUSEKI_DATASET}${COLOR_RESET}"
	curl -X POST --fail --data "dbName=${DEPLOYMENT_FUSEKI_DATASET}&dbType=tdb2" "http://localhost:${DEPLOYMENT_FUSEKI_PORT}/$$/datasets"
	@echo "${COLOR_CYAN}📦 loading ${COLOR_GREEN}${BIN_OKP4_TTL}${COLOR_RESET}"
	@curl -X POST -H "Content-Type: text/turtle" --data-binary "@${BIN_OKP4_TTL}" http://localhost:${DEPLOYMENT_FUSEKI_PORT}/${DEPLOYMENT_FUSEKI_DATASET}/data

.PHONY: fuseki-log
fuseki-log: check ## Show Fuseki server logs
	@echo "${COLOR_CYAN}📜 showing ${COLOR_GREEN}Fuseki logs${COLOR_RESET} from container ${COLOR_GREEN}${DEPLOYMENT_FUSEKI_CONTAINER}${COLOR_RESET}"
	@docker logs ${DEPLOYMENT_FUSEKI_CONTAINER} -f

## Misc:
.PHONY: cache
cache: $(DST_CACHE)/$(EXEC_OWL_CLI) ## Download all required files to cache

$(DST_CACHE)/$(EXEC_OWL_CLI):
	@echo "${COLOR_CYAN}⤵️ downlading ${COLOR_GREEN}$(notdir $@)${COLOR_RESET}"
	@mkdir -p -m 777 $(DST_CACHE); \
    cd $(DST_CACHE); \
    wget https://github.com/atextor/owl-cli/releases/download/v$(VERSION_OWL_CLI)/$(EXEC_OWL_CLI)

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
	@mkdir -p -m 777 $(@D)
	@touch $(FLG_CHECK_OK)

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
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${COLOR_YELLOW}%-20s${COLOR_GREEN}%s${COLOR_RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${COLOR_CYAN}%s${COLOR_RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
	@echo ''
	@echo 'This Makefile depends on ${COLOR_CYAN}docker${COLOR_RESET}. To install it, please follow the instructions:'
	@echo '- for ${COLOR_YELLOW}macOS${COLOR_RESET}: https://docs.docker.com/docker-for-mac/install/'
	@echo '- for ${COLOR_YELLOW}Windows${COLOR_RESET}: https://docs.docker.com/docker-for-windows/install/'
	@echo '- for ${COLOR_YELLOW}Linux${COLOR_RESET}: https://docs.docker.com/engine/install/'
