# OKP4 Ontology

> The ontology used [@okp4](okp4.network) to describe knowledge data, services and processes in the OKP4 platform.

[![lint](https://img.shields.io/github/workflow/status/okp4/ontology/Lint?label=lint&style=for-the-badge)](https://github.com/okp4/ontology/actions/workflows/lint.yml) [![build](https://img.shields.io/github/workflow/status/okp4/ontology/Build?label=build&style=for-the-badge)](https://github.com/okp4/ontology/actions/workflows/build.yml) [![publish](https://img.shields.io/github/workflow/status/okp4/ontology/Publish?label=publish&style=for-the-badge)](https://github.com/okp4/ontology/actions/workflows/publish.yml) [![release](https://img.shields.io/github/v/release/okp4/ontology?style=for-the-badge)](https://github.com/okp4/ontology/releases)
[![conventional commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=for-the-badge)](https://conventionalcommits.org)
![W3C](https://img.shields.io/badge/W3C-1572B6?style=for-the-badge&logo=w3c&logoColor=white) [![cc-by-sa-4.0][cc-by-sa-image]][cc-by-sa]

## The [OKP4](https://okp4.network) ontology

### A formal model for the OKP4 blockchain

This ontology describes and defines the different forms of vocabularies used in the [OKP4](https://okp4.network) protocol in a standard and well designed format. The aim is to model a semantic network of all the _entities_  (Data Spaces, data, services, processing workflows) by semantically characterizing what they are and the relationships they maintain between them. Thus, the ontology provides a complete living understanding and knowledge of the datasets within a Data Space, their transformation (by the services), as well as the governance rules that apply (data sharing, consents, policy rules).

### Ontology at the heart of the blockchain

Ontology is at the heart of the [OKP4](https://github.com/okp4/okp4d) protocol as much of the information is encoded and stored as an ontology _on-chain_ in the blockchain transactions. This means that (almost) all the semantics of the transactions submitted to the blockchain are expressed through this ontology - for instance the creation of a dataspace, the execution of a service, the description of a dataset, etc.

### Why an ontology?

[Ontology](https://www.w3.org/standards/semanticweb/ontology) is the most general and fundamental concept of the [Semantic Web](https://en.wikipedia.org/wiki/Semantic_Web). Ontologies are linked to various data elements representing conceptualized information about these data items. This allows for unambiguous identification, understanding, navigation and usage of this information.

The knowledge representation language chosen for OKP4 is [RDF Schema](http://www.w3.org/TR/rdf-schema/) and [Web Ontology Language](http://www.w3.org/TR/owl2-overview/) on top of the framework [Resource Description Framework](http://www.w3.org/TR/rdf-concepts/).

## Documentation

Last released version of OKP4 ontology documentation is available here: <https://ontology.okp4.network>.

## Some assumptions

- There's no one correct way to model a domain and a trade-off must be found between the meaning given to ontology, its expressiveness, its extensibility and its usage.
- The OKP4 ontology is not frozen. It is built step by step in an iterative process (see next section), and some decisions made here may be changed later.
- It should be understood that OWL modeling is different from UML modeling (or more simply of the Oriented Object interpretation that one would be tempted to make). As such, the following readings are relevant:
  - [A detailed comparison of UML and OWL](https://madoc.bib.uni-mannheim.de/1898/1/TR2008_004.pdf)
  - [A common misconception regarding owl properties](https://henrietteharmse.com/2018/06/22/a-common-misconception-regarding-owl-properties/)
- OWL being a logical description language, some deductions can be made by an OWL reasoner. However, as far as possible, it will be best to make explicit what could be deduced by an OWL reasoner.

## Ontology construction process

The construction of this ontology follows a number of steps which are described below:

1. __Ontology capture__:
   Identification and definition of key concepts and relationships in the domain of interest and the terms that refer to such concepts, in natural language.
2. __Ontology design__:
   Formalizing of the elements identified in the previous step in the form of a knowledge representation, using the building blocks of ontologies: classes, attributes, relationships, subsumption.
3. __Ontology encoding__:
   Encoding the ontology according to the [OWL](https://www.w3.org/TR/owl-ref/) grammar.
4. __Ontology integration__:
   Association of key concepts and terms in the ontology with concepts and terms of other ontologies.

## Contributing

Contributions are welcome. Please check the following guidelines:

- [Contributing](https://github.com/okp4/.github/blob/main/CONTRIBUTING.md)
- [Code of conduct](https://github.com/okp4/.github/blob/main/CODE_OF_CONDUCT.md)

[cc-by-sa]: https://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://i.creativecommons.org/l/by-sa/4.0/88x31.png

## License

The ontology and related assets (markdown documentation, images, etc.) are licensed under a [CC-BY license](LICENSE).

All other code in this repository is licensed under the [BSD-3-Clause license](LICENSE-CODE).
