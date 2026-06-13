# Axone Ontology

> RDF vocabularies, thesauri, and Verifiable Credential payload schemas used by the Axone protocol.

[![release](https://img.shields.io/github/v/release/axone-protocol/ontology?style=for-the-badge&logo=github)](https://github.com/axone-protocol/ontology/releases)
[![lint](https://img.shields.io/github/actions/workflow/status/axone-protocol/ontology/lint.yml?label=lint&style=for-the-badge&logo=github)](https://github.com/axone-protocol/ontology/actions/workflows/lint.yml)
[![build](https://img.shields.io/github/actions/workflow/status/axone-protocol/ontology/build.yml?label=build&style=for-the-badge&logo=github)](https://github.com/axone-protocol/ontology/actions/workflows/build.yml)
[![test](https://img.shields.io/github/actions/workflow/status/axone-protocol/ontology/test.yml?label=test&style=for-the-badge&logo=github)](https://github.com/axone-protocol/ontology/actions/workflows/test.yml)
[![publish](https://img.shields.io/github/actions/workflow/status/axone-protocol/ontology/publish.yml?label=publish&style=for-the-badge&logo=github)](https://github.com/axone-protocol/ontology/actions/workflows/publish.yml)
[![conventional commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=for-the-badge&logo=conventionalcommits)](https://conventionalcommits.org)
[![contributor covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg?style=for-the-badge)](https://github.com/axone-protocol/.github/blob/main/CODE_OF_CONDUCT.md)
![W3C](https://img.shields.io/badge/W3C-1572B6?style=for-the-badge&logo=w3c&logoColor=white) [![cc-by-sa-4.0][cc-by-sa-image]][cc-by-sa]

## The [Axone](https://axone.xyz) ontology

This repository defines RDF vocabularies, thesauri, and Verifiable Credential payload schemas used by the [Axone protocol](https://axone.xyz).

It provides the semantic artefacts required to name, describe, and constrain credential payloads in Axone.

### Vocabulary and thesauri

[Verifiable Credentials](https://www.w3.org/TR/vc-data-model/) use JSON-LD contexts to map credential terms to machine-readable identifiers. Axone defines these terms with RDF-compatible vocabularies and controlled thesauri so that credential payloads can be interpreted consistently across implementations.

Axone uses [RDF Schema](http://www.w3.org/TR/rdf-schema/) to define reusable semantic terms and [SKOS](https://www.w3.org/TR/skos-reference/) for controlled vocabularies. Both are built on top of the [Resource Description Framework](http://www.w3.org/TR/rdf-concepts/). This keeps the model lightweight while remaining compatible with RDF and JSON-LD tooling.

### Verifiable Credential payload schemas

This repository defines semantic payload schemas for VCs.

These schemas describe the content carried by credentials. They are designed to remain generic and extensible. A schema should be introduced only when it captures a stable payload structure that cannot be expressed cleanly through an existing one.

Axone distinguishes between informational credentials and governance-relevant credentials.

Informational credentials carry descriptive material. They help humans, wallets, explorers, indexers, and agents discover or understand an identifiable subject. They are not intended to provide material that can directly support a governance decision.

Governance-relevant credentials carry structured information that may be evaluated by a governance process. They may express facts, rights, attestations, authorisations, or other statements with normative or evidentiary value.

Core VC schemas live under the `schema/core` sub-domain.

Some credentials are descriptive. They help identify, discover, and display a subject.

Other credentials are governance-relevant. They carry structured statements that may be evaluated by protocol components.

### Credential authorship

Axone credentials are not expected to carry embedded off-chain proofs when submitted to the protocol.

Authorship is established by the account that submits the credential. The transaction signer controls the abstract account that emits the credential. The credential payload therefore carries semantics; the protocol submission carries authorship.

When an Axone account is represented as a DID, examples use the `did:pkh` method grounded in the on-chain abstract account address, for example `did:pkh:cosmos:<chain_id>:cosmos1...`.

### Use in Axone

In the [Axone protocol](https://axone.xyz), the ontology provides the vocabulary used to describe credential payloads and controlled terms.

Credentials may either provide informational metadata or carry governance-relevant material. Informational payloads can be discovered, indexed, and displayed. Governance-relevant payloads can be referenced or evaluated by protocol components according to their own rules.

Domain-specific facts such as licences, compliance status, authority, capability, resource properties, or identity attributes can often be represented through assertion predicates. Dedicated schemas should be introduced only when the structure has a stable and concrete use case that is not cleanly captured by the generic assertion model.

## Design

### Construction process

The construction of the semantic model follows a number of steps which are described below:

- __Ontology scope definition (1) & knowledge acquisition (2)__: Identification and definition of key concepts and relationships in the domain of interest and the terms that refer to such concepts, in natural language.
- __Ontology specification (3) & conceptualization (4)__: Formalizing of the elements identified in the previous step in the form of a knowledge representation, using the building blocks of ontologies: classes, attributes, relationships, subsumption.
- __Implementation (5)__: Encoding the semantic model using RDF-compatible formats and JSON-LD contexts.
- __Evaluation (6)__: Association of key concepts and terms with concepts and terms from other vocabularies when relevant.

### Organization

The repository is structured in a modular way, with each part representing a specific semantic domain while keeping credential payload schemas generic and extensible.

At the root, the semantic model is divided into two main parts:

- __Thesaurus Part__: This part contains all controlled vocabularies integral to the ontology. The thesaurus adheres to the [SKOS standard](https://www.w3.org/TR/skos-reference/), which is instrumental in ensuring compatibility with other thesauri and simplifying the ontology's integration into various systems.

- __Schema Part__: This part contains the active [Verifiable Credentials](https://www.w3.org/TR/vc-data-model/) payload schemas used within the [Axone protocol](https://axone.xyz). These schemas are deployed as [JSON-LD contexts](https://www.w3.org/TR/json-ld11/) under the `schema/core` sub-domain. They describe reusable payload semantics, not protocol operations.

Credential schemas should remain generic when possible. Descriptive credentials carry information about identifiable subjects. Governance-relevant credentials carry structured statements with normative or evidentiary value.

The foundational philosophy underpinning the semantic model is grounded in the *Open World* principle. Knowledge is not static or finite. The model is therefore not confined to a closed set of schemas and thesauri. It is designed to accommodate new terms and payload structures when they are justified by concrete use cases.

### Axone semantic URIs

#### W3ID.org persistent URI

For robust [RDF](https://www.w3.org/RDF/) resource management, Axone uses the [w3id.org](https://w3id.org) service for persistent URIs. This strategy maintains both URI and content stability, which is required for web-based semantic technologies.

__Persistent URI Benefits:__

- __Durability:__ [w3id.org](https://w3id.org) URIs are designed to be persistent, meaning they are intended to be available for a long duration. This permanence is crucial for maintaining reliable references over time.
- __Redirect Capability:__ The [w3id.org](https://w3id.org) service enables redirection, allowing Axone semantic URIs to direct clients to the appropriate resource location as the repository evolves. This feature is particularly useful for versioning.

#### Semantic versioning

Axone semantic resources adopt the [Semantic Versioning](https://semver.org/) format of `MAJOR.MINOR.PATCH`. This approach includes incorporating the `MAJOR` version number into the URI. As a result, the URI structure is:

```text
https://w3id.org/axone/ontology/<MAJOR>/<path>
```

Note: by including only the `MAJOR` version number in the URI, significant updates that could impact compatibility are referenced through a different namespace. `MINOR` and `PATCH` updates that do not introduce breaking changes have no impact on the URI, maintaining the stability of the URI for external references.

## Development

### Building the ontology

The ontology is built using [GNU make](https://www.gnu.org/software/make/manual/make.html) and [Docker](https://www.docker.com/).
To build the ontology, run the following command:

```bash
make build
```

This will build the `axone` ontology under the `target` directory. The files generated have different [RDF](https://www.w3.org/RDF/) formats:

- [Turtle](https://www.w3.org/TR/turtle/)
- [N-Triples](http://www.w3.org/TR/n-triples/)
- [RDF/XML](https://www.w3.org/TR/rdf-syntax-grammar/)
- [Tarball](https://en.wikipedia.org/wiki/Tar_(computing)) containing all the schemas and vocabularies in different formats.

```text
./target
   ├── axone-ontology-<version>.nt
   ├── axone-ontology-<version>.rdf.xml
   ├── axone-ontology-<version>.ttl
   └── axone-ontology-<version>-bundle.tar.gz
```

### Deploying the ontology in local triple store

The ontology can be deployed in a local triple store using [Docker](https://www.docker.com/). The triple store used is [Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/).

To start the triple store, run the following command. This will start the triple store and wait to be ready.

```bash
make fuseki-up
```

Then, you can load the `axone` ontology in the triple store using the following command:

```bash
make fuseki-load
```

You can now play with the ontology using the Fuseki UI - <http://localhost:3030/>.

Conversaly, to stop the triple store, run the following command:

```bash
make fuseki-down
```

⚠️ Note that the triple store is *not persistent*, so all the data will be *lost* when the triple store is stopped.

### Testing the ontology

The ontology is tested using [Shapes Constraint Language (SHACL)](https://www.w3.org/TR/shacl/). To run the tests, run the following command:

```bash
make test
```

### Generating the documentation

The documentation is generated using the following command:

```bash
make docs
```

This will generate the documentation under the `docs` directory. Don't forget to commit the generated files.

### Other commands

You can get the list of all available commands by running the following command:

```bash
make help
```

Which will output the following:

```text
Usage:
  make <target>

Targets:
  Clean:
    clean                 Clean all generated files
    clean-cache           Clean the cache
    clean-build           Clean the .make (build) directory
    clean-ontologies      Clean the built ontologies
  Build:
    build                 Build all the files
    build-ontology        Build the ontology in all available formats (N-Triples, RDF/XML, JSON-LD)
    build-ontology-ttl    Build the ontology in Turtle format
    build-ontology-nt     Build the ontology in N-Triples format
    build-ontology-rdfxml Build the ontology in RDF/XML format
    build-ontology-jsonld Build the ontology in JSON-LD format
    build-examples        Build the examples in different formats (N-Quads, JSON-LD)
    build-ontology-bundle Build a tarball containing the segments and the ontology in all available formats (N-Triples, RDF/XML, JSON-LD) plus the examples
  Format:
    format                Format with all available formatters
    format-ttl            Format all Turtle files
  Lint:
    lint                  Lint with all available linters
    lint-ttl              Lint all Turtle files
    lint-jsonld           Lint all JSON-LD files
  Documentation:
    docs                  Generate all available documentation
    docs-schemas          Generate schemas markdown documentation
  Test:
    test                  Run all available tests
    test-ontology         Test the ontology
  Fuseki:
    fuseki-up             Start a Fuseki server and wait for it to be ready
    fuseki-down           Stop the Fuseki container
    fuseki-load           Load the ontology in Fuseki server
    fuseki-log            Show Fuseki server logs
  Misc:
    cache                 Download all required files to cache
    check                 Check if all required commands are available in the system
    version               Show the current version
  Help:
    vars                  Show relevant variables used in this Makefile
    help                  Show this help.

This Makefile depends on docker. To install it, please follow the instructions:
- for macOS: https://docs.docker.com/docker-for-mac/install/
- for Windows: https://docs.docker.com/docker-for-windows/install/
- for Linux: https://docs.docker.com/engine/install/
```

## Contributing

Contributions are welcome. Please check the following guidelines:

- [Contributing](https://github.com/axone-protocol/.github/blob/main/CONTRIBUTING.md)
- [Code of conduct](https://github.com/axone-protocol/.github/blob/main/CODE_OF_CONDUCT.md)

[cc-by-sa]: https://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://i.creativecommons.org/l/by-sa/4.0/88x31.png

## License

The ontology and related assets (markdown documentation, images, etc.) are licensed under a [CC-BY license](LICENSE).

All other code in this repository is licensed under the [BSD-3-Clause license](LICENSE-CODE).
