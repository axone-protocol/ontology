import os
import typing as t

import click

from cli.documentation import generate_documentation
from cli.jsonld import convert_jsonld


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
        raise click.UsageError(f"{e}")


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
def convert(input_file: t.TextIO, output_file: t.TextIO, indent: t.Optional[int], format: t.Optional[str]) -> None:
    """Converts a schema to JSON-LD.

    If the output file is not specified, the JSON-LD will be printed to the console.
    You can specify the format of the input file, if it cannot be inferred from the file extension.
    """
    try:
        convert_jsonld(input_file, output_file, indent, format)
    except Exception as e:
        raise click.UsageError(f"{e}")


if __name__ == '__main__':
    root()
