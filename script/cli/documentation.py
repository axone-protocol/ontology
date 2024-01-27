import glob
import os
import typing as t

import click
from jinja2 import Environment, FileSystemLoader
from rdflib import URIRef, Dataset, RDF, SKOS, DCTERMS, RDFS, Graph
from rdflib.term import Node


def generate_documentation(input_path: os.PathLike[str], output_file: t.TextIO) -> None:
    """Generate the markdown documentation from the ontology schemas."""
    dataset = Dataset()

    click.echo(f"🔍 Looking into: {input_path}")

    for filename in glob.glob(f"{input_path}/*/*.ttl"):
        click.echo(f"✔ {filename}")
        name = os.path.basename(filename).replace(".ttl", "")
        click.echo("  🔬 loading graph")
        g = dataset.graph(URIRef("urn:x-schema:" + name))
        g.parse(filename, format="ttl")
        click.echo(f"  📊 graph has {len(g)} triples")

    env = Environment(loader=FileSystemLoader(os.path.join(os.path.dirname(__file__), 'templates')))
    env.filters.update({
        'credential_class': credential_class,
        'value': value,
        'graphs': graphs,
        'sort_graphs': sort_graphs,
        'graph_name': graph_name,
        'uri_split': uri_split,
        'normalize_text': normalize_text,
        'linkify': linkify
    })
    namespaces = {
        'RDF': RDF,
        'RDFS': RDFS,
        'SKOS': SKOS,
        'DCTERMS': DCTERMS
    }

    click.echo("📝 generating markdown...")
    template = env.get_template('schemas.md.jinja2')
    rendered = template.render(dataset=dataset, **namespaces)

    click.echo(f"💾 writing to: {click.format_filename(output_file.name)}")
    output_file.write(rendered)


def normalize_text(text: str) -> str:
    lines = text.lstrip('\n').rstrip(' ').rstrip('\n').split('\n')
    leading_spaces = len(lines[0]) - len(lines[0].lstrip(' '))

    processed_lines = [line[leading_spaces:] for line in lines]
    normalized_text = '\n'.join(processed_lines)

    return normalized_text


def linkify(link: str) -> str:
    return f"[{link}]({link})"


def graphs(dataset: Dataset) -> t.Generator[Graph, None, None]:
    return dataset.graphs()


def sort_graphs(graphs: list[Graph]) -> list[Graph]:
    return sorted(
        graphs,
        key=lambda g: graph_name(g) or "")


def graph_name(graph: Graph) -> t.Optional[str]:
    cc = credential_class(graph)
    return str(value(cc, graph, RDFS.label)) if cc else None


def credential_class(graph: Graph) -> t.Optional[Node]:
    for s in graph.subjects(RDF.type, RDFS.Class):
        if str(s).endswith("Credential"):
            return s
    return None


def value(subject: Node | None, graph: Graph, predicate: Node | None) -> Node | None:
    return graph.value(subject, predicate)


def uri_split(uri: URIRef, sep: str = '/') -> t.Tuple[str, str]:
    parts = str(uri).rsplit(sep, 1)
    return (parts[0], parts[1]) if len(parts) == 2 else (parts[0], '')
