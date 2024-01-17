import glob
import os

import click
from jinja2 import Environment, FileSystemLoader
from rdflib import URIRef, Dataset, RDF, SKOS, DCTERMS, RDFS

from cli.markdown import normalize_text, linkify
from cli.rdf import credential_class, value, graphs, sort_graphs, graph_name, uri_split


@click.command()
@click.option(
    "-i",
    "--input",
    "input_path",
    type=click.Path(dir_okay=True, file_okay=False, exists=True, readable=True),
    required=True,
    help="The path to the directory containing the ontology schemas.",
)
@click.option(
    "-o",
    "--output",
    "out_file",
    type=click.Path(dir_okay=False, file_okay=True, readable=True),
    required=True,
    help="The path and name for the generated markdown document.",
)
def command(input_path, out_file):
    """Generate a markdown document from the ontology schemas."""

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
    env.filters['credential_class'] = credential_class
    env.filters['value'] = value
    env.filters['graphs'] = graphs
    env.filters['sort_graphs'] = sort_graphs
    env.filters['graph_name'] = graph_name
    env.filters['uri_split'] = uri_split
    env.filters['normalize_text'] = normalize_text
    env.filters['linkify'] = linkify
    namespaces = {
        'RDF': RDF,
        'RDFS': RDFS,
        'SKOS': SKOS,
        'DCTERMS': DCTERMS
    }

    click.echo("📝 generating markdown...")
    template = env.get_template('schemas.md.jinja2')
    rendered = template.render(dataset=dataset, **namespaces)

    click.echo(f"💾 writing to: {click.format_filename(out_file)}")
    with open(out_file, "w") as fh:
        fh.write(rendered)


if __name__ == '__main__':
    command()
