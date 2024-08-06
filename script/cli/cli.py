import os
import typing as t

import click

from cli.documentation import generate_documentation
from cli.jsonld import convert_jsonld
from cli.nquads import convert_nquads


@click.group()
def root():
    """A command line interface used to manage the OKP4 ontology."""
    pass


@click.group()
def documentation():
    """Group of commands used to manage the documentation for the OKP4 ontology."""
    pass


@click.group()
def jsonld():
    """Group of commands used to manage the OKP4 ontology."""
    pass


root.add_command(documentation)
root.add_command(jsonld)


@documentation.command()
@click.argument(
    "input_path",
    type=click.Path(dir_okay=True, file_okay=False, exists=True, readable=True),
)
@click.argument(
    "output_path",
    type=click.Path(dir_okay=True, file_okay=False, exists=True, readable=True),
)
@click.option(
    "-e",
    "--example-path",
    "example_path",
    type=click.Path(exists=True, readable=True),
    help="The path to the example file used to generate the documentation.",
)
def generate(input_path: os.PathLike[str], output_path: os.PathLike[str],
             example_path: t.Optional[os.PathLike[str]]) -> None:
    """Generate the markdown documentation from the ontology turtle files found in the input directory."""
    try:
        generate_documentation(input_path, output_path, example_path)
    except Exception as e:
        raise click.UsageError(f"{e}") from e


@jsonld.command()
@click.argument(
    "input_file",
    type=click.File('r'),
)
@click.option(
    "-o",
    "--output",
    "output_file",
    type=click.File('w'),
    default=click.get_text_stream('stdout'),
    help="The path and name for the generated JSON-LD file.",
)
@click.option(
    "-f",
    "--format",
    "format",
    type=click.Choice(["turtle", "n3", "nt", "xml", "nquads", "trix"]),
    default=None,
    help="The format of the input file.",
)
@click.option(
    "--indent",
    "indent",
    type=int,
    default=None,
    help="The number of spaces to use for indentation.",
)
@click.option(
    "--flatten",
    "flatten",
    is_flag=True,
    help="Produces a flattened JSON-LD representation.",
)
def convert(input_file: t.TextIO, output_file: t.TextIO, flatten: bool, indent: t.Optional[int],
            format: t.Optional[str]) -> None:
    """Converts a schema to JSON-LD.

    If the output file is not specified, the JSON-LD will be printed to the console.
    You can specify the format of the input file, if it cannot be inferred from the file extension.
    """
    try:
        convert_jsonld(input_file, output_file, flatten, indent, format)
    except Exception as e:
        raise click.UsageError(f"{e}") from e


@jsonld.command()
@click.argument(
    "input_file",
    type=click.Path(exists=True)
)
@click.option(
    "-o",
    "--output",
    "output_file",
    type=click.File('w'),
    default=click.get_text_stream('stdout'),
    help="The path and name for the generated NQUADS file.",
)
@click.option(
    "-a",
    "--algorithm",
    "algorithm",
    type=click.Choice(["URDNA2015", "URGNA2012"]),
    default="URGNA2012",
    help="The algorithm used to normalize the graph.",
)
@click.option(
    "-c",
    "--context-folder",
    "context_folder",
    type=click.Path(exists=True, readable=True),
    default=None,
    help="The folder containing the JSON-LD files used as local contexts.",
)
def nquads(input_file: os.PathLike[str], output_file: t.TextIO, context_folder: t.Optional[os.PathLike[str]],
           algorithm: str) -> None:
    """Converts a JSON-LD schema to normalized NQUADS.

    If the output file is not specified, the NQUADS will be printed to the console.
    You can specify the folder containing the JSON-LD files used as local contexts, in which case the matching contexts
    will be resolved using the files in the folder. If not specified, the contexts will be resolved using the web.
    """
    try:
        convert_nquads(input_file, output_file, context_folder, algorithm)
    except Exception as e:
        raise click.UsageError(f"{e}") from e


if __name__ == '__main__':
    root()
