import json
import typing as t

import click
from rdflib import Graph, RDF, RDFS, XSD, Namespace, term
from rdflib.term import Node

SCHEMA = Namespace("http://schema.org/")


def convert_jsonld(input_file: t.TextIO, output_file: t.TextIO, flatten: bool, indent: t.Optional[int] = None,
                   format: t.Optional[str] = None):
    """Converts a schema to JSON-LD."""
    context = empty_context()

    click.echo(f"🔬 loading graph from {input_file.name}")
    g = Graph()
    g.parse(input_file, format=format)
    click.echo(f"📊 graph has {len(g)} triples")

    for s in g.subjects(RDF.type, RDFS.Class):
        path = [get_name(s)]
        click.echo(f"✔ discovered class\t{'/'.join(path)}")
        add_to_context(context, '@id', str(s), path)

    for s in g.subjects(RDF.type, RDF.Property):
        root = [get_name(s)]

        range = next(g.objects(s, SCHEMA.rangeIncludes), None)
        is_a_type = (isinstance(range, term.Identifier)) and ((range == XSD.anyURI) or not range.startswith(str(XSD)))

        domains: list[Node | None] = list(g.objects(s, SCHEMA.domainIncludes))
        if not domains or flatten:
            domains = [None]

        for domain in domains:
            path = [get_name(domain), '@context'] + root if domain else root

            click.echo(f"✔ discovered property\t{'/'.join(path)}")
            add_to_context(context, '@id', str(s), path)
            if is_a_type:
                add_to_context(context, '@type', '@id', path)

    click.echo(f"💾 writing to: {click.format_filename(output_file.name)}")
    json.dump({'@context': context}, output_file, indent=indent)


def get_name(uri: term.Node) -> str:
    return str(uri).split("/")[-1]


def empty_context() -> dict:
    return {
        "@protected": True,
        "id": "@id",
        "type": "@type",
    }


def add_to_context(context: dict, key: t.Optional[str], value: t.Optional[t.Any], paths=None) -> None:
    if paths is None:
        paths = []
    if not paths:
        if key is not None:
            context[key] = value
    else:
        path = paths[0]
        if path not in context:
            context[path] = empty_context() if path == '@context' else {}
        add_to_context(context[path], key, value, paths[1:])
