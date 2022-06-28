# OKP4 Ontology

> The ontology used [@okp4](okp4.com) to describe knowledge data, services and processes in the OKP4 platform.

[![lint](https://img.shields.io/github/workflow/status/okp4/ontology/Lint?label=lint&style=for-the-badge)](https://github.com/okp4/ontology/actions/workflows/lint.yml)
[![build](https://img.shields.io/github/workflow/status/okp4/ontology/Build?label=build&style=for-the-badge)](https://github.com/okp4/ontology/actions/workflows/build.yml)
[![publish](https://img.shields.io/github/workflow/status/okp4/ontology/Publish?label=publish&style=for-the-badge)](https://github.com/okp4/ontology/actions/workflows/publish.yml)
[![Version](https://img.shields.io/github/v/release/okp4/ontology?style=for-the-badge)](https://github.com/okp4/ontology/releases)
[![conventional commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=for-the-badge)](https://conventionalcommits.org)
[![cc-by-sa-4.0][cc-by-sa-image]][cc-by-sa]

## OKP4 Ontology design guide

This section provides a (reference) design guide to best practices regarding this ontology, its construction and its maintenance.

### Ontology construction process

The construction of the ontology include three steps:

1. __Ontology capture__: Identification and definition of key concepts and relationships in the domain of interest and the terms that refer to such concepts.
2. __Ontology coding__; Formalizing of such definitions and relationships in [OWL](https://www.w3.org/TR/owl-ref/).
3. __Ontology integration__: Association of key concepts and terms in the ontology with concepts and terms of other ontologies.

### Naming and Vocabulary

**Rule:** For *concepts*

- Name all concepts as *single nouns*
- Use [UpperCamelCase](https://wiki.c2.com/?UpperCamelCase) notation for naming the concepts
- e.g.: `MyFooConcept`

**Rule:** For *properties*

- Name all properties as *verb tenses*
- Use [LowerCamelCase](https://wiki.c2.com/?LowerCamelCase) notation for naming the propeties
- e.g.: `hasName`, `isLinkedTo`

[cc-by-sa]: https://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://i.creativecommons.org/l/by-sa/4.0/88x31.png
