import os
import re
from pathlib import Path
from typing import Callable, Dict, Optional, TextIO, Union

import click
from pyld import jsonld
from rdflib import Namespace

SCHEMA = Namespace("http://schema.org/")
AXONE = Namespace("https://w3id.org/axone/ontology/")


def convert_nquads(input_file: Union[str, os.PathLike], output_file: TextIO,
                   context_folder: Optional[Union[str, os.PathLike]] = None, algorithm: str = "URGNA2012") -> None:
    """Converts a JSON-LD schema to N-Quads format."""
    context_mapping = create_context_mapping(context_folder)

    click.echo(f"🔬 Loading graph from {input_file}")
    normalized = jsonld.normalize(
        f"file://{input_file}",
        {
            'algorithm': algorithm,
            'format': 'application/nquads',
            'documentLoader': create_custom_document_loader(context_mapping)
        }
    )

    click.echo(f"💾 writing to: {click.format_filename(output_file.name)}")
    output_file.write(normalized)


def create_context_mapping(context_folder: Optional[Union[str, os.PathLike]]) -> Dict[str, str]:
    """Creates a JSON-LD context mapping from files in the specified folder."""
    context = {}

    if context_folder:
        context_folder = str(context_folder)
        click.echo(f"🔍 Scanning directory: {context_folder}")
        for root, _, files in os.walk(context_folder):
            for file in files:
                if file.endswith('.jsonld'):
                    file_path = os.path.join(root, file)
                    document = jsonld.load_document(f"file://{Path(file_path).resolve()}",
                                                    options={'documentLoader': create_custom_document_loader()})
                    uri = extract_context_uri(document)
                    if uri:
                        click.echo(f"📌 Mapping: {uri} → {file}")
                        context[uri] = file_path

    return context


def create_custom_document_loader(context_mapping: Optional[Dict[str, str]] = None) -> Callable[[str, Dict[str, str]], Dict[str, Union[str, None]]]:
    """Creates a custom document loader for JSON-LD which supports local file Axone URIs."""
    if context_mapping is None:
        context_mapping = {}

    def loader(url: str, options: Dict[str, str] = {}) -> Dict[str, Union[str, None]]:
        if url.startswith("file://"):
            path = url[7:]
            with open(path, 'r') as f:
                return {
                    'document': f.read(),
                    'contentType': 'application/ld+json',
                    'documentUrl': '',
                    'contextUrl': None
                }
        elif url in context_mapping:
            local_path = context_mapping[url]
            return loader(f"file://{local_path}")
        else:
            return jsonld.requests_document_loader()(url, options=options)

    return loader


def extract_context_uri(document: Dict) -> Optional[str]:
    """Extracts the URI from the JSON-LD document's @context."""
    context = document.get('document', {}).get('@context')

    if context:
        if isinstance(context, str):
            return context
        elif isinstance(context, list):
            return context[0] if context else None
        elif isinstance(context, dict):
            first_id = next((v.get('@id') for v in context.values() if isinstance(v, dict) and '@id' in v), None)
            if first_id:
                match = re.match(r'(.*/).*', first_id)
                return match.group(1) if match else None

    return None
