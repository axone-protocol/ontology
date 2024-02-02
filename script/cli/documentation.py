import os
import typing as t
from pathlib import Path

import click
from jinja2 import FileSystemLoader, Environment
from rdflib import URIRef, RDF, SKOS, DCTERMS, RDFS, Graph
from rdflib.term import Node

PathLikeStr = os.PathLike[str]

FILE_FORMAT = "turtle"
EXAMPLE_SUFFIX = ".jsonld"
TEMPLATE_DIR = 'templates'
TEMPLATE_FILE = 'schema.md.jinja2'

NAMESPACES = {
    'RDF': RDF,
    'RDFS': RDFS,
    'SKOS': SKOS,
    'DCTERMS': DCTERMS
}


def parse_graph(filename: PathLikeStr) -> Graph:
    """Parse the graph from a given filename."""
    click.echo("  🔬 Loading graph")
    graph = Graph()
    graph.parse(str(filename), format=FILE_FORMAT)
    click.echo(f"  📊 Graph has {len(graph)} triples")
    return graph


def find_examples(filename: PathLikeStr, example_path: PathLikeStr) -> list[dict[str, t.Any]]:
    """Find and return examples related to the given schema filename."""
    click.echo("  📚 Looking for examples related to this graph")
    pattern = str(Path(filename).with_suffix(EXAMPLE_SUFFIX)).replace("credential-", "*-")
    examples = [
        {
            'filename': example_filename.name,
            'content': example_filename.read_text()
        } for example_filename in Path(example_path).glob(pattern)
    ]
    examples.sort(key=lambda x: x['filename'])
    click.echo(f"  {'✅' if examples else '✔️'} found {len(examples)} example(s)")
    return examples


def generate_documentation(input_path: PathLikeStr, output_path: PathLikeStr,
                           example_path: t.Optional[PathLikeStr]) -> None:
    """Generate the markdown documentation from the ontology turtle files found in the input directory."""
    schemas = []

    click.echo(f"🔍 Looking into: {input_path}")

    for filename in Path(input_path).rglob("**/*.ttl"):
        rel_path = filename.relative_to(input_path)
        click.echo(f"✔ {rel_path}")

        schema: dict[str, t.Any] = {
            'filename': filename,
            'name': filename.stem,
            'graph': parse_graph(filename)
        }

        if example_path:
            schema['examples'] = find_examples(rel_path, example_path)

        schemas.append(schema)

    schemas.sort(key=lambda x: x['name'])
    loader = FileSystemLoader(Path(__file__).parent / TEMPLATE_DIR)
    env = Environment(loader=loader)
    env.filters.update({
        'credential_class': credential_class,
        'value': value,
        'uri_split': uri_split,
        'normalize_text': normalize_text,
        'linkify': linkify
    })

    for idx, schema in enumerate(schemas):
        click.echo(f"📝 Generating markdown for {schema['name']}")
        template = env.get_template(TEMPLATE_FILE)
        output_filename = Path(output_path) / f"{schema['name']}.md"
        template.stream(schema=schema, pos=idx+1, **NAMESPACES).dump(str(output_filename))


def normalize_text(text: str) -> str:
    lines = text.lstrip('\n').rstrip(' ').rstrip('\n').split('\n')
    leading_spaces = len(lines[0]) - len(lines[0].lstrip(' '))

    processed_lines = [line[leading_spaces:] for line in lines]
    normalized_text = '\n'.join(processed_lines)

    return normalized_text


def linkify(link: str) -> str:
    return f"[{link}]({link})"


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
