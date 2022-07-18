# OKP4 Ontology

> The ontology used [@okp4](okp4.com) to describe knowledge data, services and processes in the OKP4 platform.

[![lint](https://img.shields.io/github/workflow/status/okp4/ontology/Lint?label=lint&style=for-the-badge)](https://github.com/okp4/ontology/actions/workflows/lint.yml)
[![build](https://img.shields.io/github/workflow/status/okp4/ontology/Build?label=build&style=for-the-badge)](https://github.com/okp4/ontology/actions/workflows/build.yml)
[![publish](https://img.shields.io/github/workflow/status/okp4/ontology/Publish?label=publish&style=for-the-badge)](https://github.com/okp4/ontology/actions/workflows/publish.yml)
[![release](https://img.shields.io/github/v/release/okp4/ontology?style=for-the-badge)](https://github.com/okp4/ontology/releases)
[![conventional commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=for-the-badge)](https://conventionalcommits.org)
[![cc-by-sa-4.0][cc-by-sa-image]][cc-by-sa]

## The [OKP4](https://okp4.network) ontology

### A formal model for the OKP4 blockchain

This ontology describes and defines the different forms of vocabularies used in the [OKP4](https://okp4.network) protocol in a standard and well designed format. The aim is to model a semantic network of all the _entities_  (Data Spaces, data, services, processing workflows) by semantically characterizing what they are and the relationships they maintain between them. Thus, the ontology provides a complete living understanding and knowledge of the datasets within a Data Space, their transformation (by the services), as well as the governance rules that apply (data sharing, consents, policy rules).

### Ontology at the heart of the blockchain

Ontology is at the heart of the [OKP4](https://github.com/okp4/okp4d) protocol as much of the information is encoded and stored as an ontology _on-chain_ in the blockchain transactions. This means that (almost) all the semantics of the transactions submitted to the blockchain are expressed through this ontology - for instance the creation of a dataspace, the execution of a service, the description of a dataset, etc.

### Why an ontology?

[Ontology](https://www.w3.org/standards/semanticweb/ontology) is the most general and fundamental concept of the [Semantic Web](https://en.wikipedia.org/wiki/Semantic_Web). Ontologies are linked to various data elements representing conceptualized information about these data items. This allows for unambiguous identification, understanding, navigation and usage of this information.

The knowledge representation language chosen for OKP4 is [RDF Schema](http://www.w3.org/TR/rdf-schema/) and [Web Ontology Language](http://www.w3.org/TR/owl2-overview/) on top of the framework [Resource Description Framework](http://www.w3.org/TR/rdf-concepts/).

## Documentation

Last released version of OKP4 ontology documentation is available here: <https://ontology.okp4.network>

## Ontology construction process

The construction of this ontology follows a number of steps which are described below:

1. __Ontology capture__:
   Identification and definition of key concepts and relationships in the domain of interest and the terms that refer to such concepts, in natural language.
2. __Ontology design__:
   Formalizing of the elements identified in the previous step in the form of a knowledge representation, using the building blocks of ontologies: classes, attributes, relationships, subsumption.  
3. __Ontology encoding__:
   Encoding in [OWL](https://www.w3.org/TR/owl-ref/).
4. __Ontology integration__:
   Association of key concepts and terms in the ontology with concepts and terms of other ontologies.

## Contributing

Contributions are welcome. Please check the following guidelines:

- [Contributing](https://github.com/okp4/.github/blob/main/CONTRIBUTING.md)
- [Code of conduct](https://github.com/okp4/.github/blob/main/CODE_OF_CONDUCT.md)

[cc-by-sa]: https://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://i.creativecommons.org/l/by-sa/4.0/88x31.png
