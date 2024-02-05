import os
import typing as t
from pathlib import Path

import click
from jinja2 import FileSystemLoader, Environment
from rdflib import URIRef, RDF, SKOS, DCTERMS, RDFS, Graph, Namespace
from rdflib.namespace import NamespaceManager
from rdflib.term import Node

PathLikeStr = os.PathLike[str]

FILE_FORMAT = "turtle"
EXAMPLE_SUFFIX = ".jsonld"
TEMPLATE_DIR = 'templates'
TEMPLATE_FILE = 'schema.md.jinja2'
SCHEMA = Namespace('http://schema.org/')

NAMESPACES = {
    'RDF': RDF,
    'RDFS': RDFS,
    'SKOS': SKOS,
    'DCTERMS': DCTERMS,
    'SCHEMA': SCHEMA
}


def parse_vc_graph(filename: Path) -> Graph:
    """Parse the graph from a given filename."""
    click.echo("  🔬 Loading graph")
    ns_mgr = NamespaceManager(Graph(), bind_namespaces="none")
    ns_mgr.bind("rdf", RDF)
    ns_mgr.bind("rdfs", RDFS)
    ns_mgr.bind("skos", SKOS)
    ns_mgr.bind("dcterms", DCTERMS)
    ns_mgr.bind("schema", SCHEMA)
    graph = Graph(namespace_manager=ns_mgr)
    graph.parse(str(filename), format=FILE_FORMAT)

    credential_uri = credential_class(graph)
    if credential_uri:
        ns, _ = split_uri(credential_uri)
        graph.bind(filename.stem, f"{ns}/")

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

        graph = parse_vc_graph(filename)

        schema: dict[str, t.Any] = {
            'filename': filename,
            'name': filename.stem,
            'graph': graph,
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
        'curiefy': curiefy,
        'split_uri': split_uri,
        'normalize_text': normalize_text,
        'linkify': linkify,
        'domains': domains,
        'ranges': ranges,
        'append': append,
    })

    for idx, schema in enumerate(schemas):
        click.echo(f"📝 Generating markdown for {schema['name']}")
        template = env.get_template(TEMPLATE_FILE)
        output_filename = Path(output_path) / f"{schema['name']}.md"
        template.stream(schema=schema, pos=idx + 1, **NAMESPACES).dump(str(output_filename))


def normalize_text(text: str) -> str:
    lines = text.lstrip('\n').rstrip(' ').rstrip('\n').split('\n')
    leading_spaces = len(lines[0]) - len(lines[0].lstrip(' '))

    processed_lines = [line[leading_spaces:] for line in lines]
    normalized_text = '\n'.join(processed_lines)

    return normalized_text


def linkify(text: str, link: t.Optional[str] = None) -> str:
    return f"[{text}]({link or text})"


def credential_class(graph: Graph) -> t.Optional[URIRef]:
    for s in graph.subjects(RDF.type, RDFS.Class):
        if str(s).endswith("Credential") and isinstance(s, URIRef):
            return s
    return None


def value(subject: Node | None, graph: Graph, predicate: Node | None) -> Node | None:
    return graph.value(subject, predicate)


def split_uri(uri: URIRef, sep: str = '/') -> t.Tuple[str, str]:
    parts = str(uri).rsplit(sep, 1)
    return (parts[0], parts[1]) if len(parts) == 2 else (parts[0], '')


def curiefy(uri: str, graph: Graph) -> str:
    return graph.namespace_manager.curie(uri)


def domains(predicate: Node, graph: Graph) -> list[Node]:
    return sorted(graph.objects(predicate, SCHEMA.domainIncludes), key=str)


def ranges(predicate: Node, graph: Graph) -> list[Node]:
    return sorted(graph.objects(predicate, SCHEMA.rangeIncludes), key=str)


def append(s: str, *args: t.Any) -> str:
    return s + ''.join(args)
