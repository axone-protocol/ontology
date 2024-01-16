from rdflib import RDF, RDFS


def graphs(dataset):
    return dataset.graphs()


def sort_graphs(graphs):
    return sorted(
        graphs,
        key=lambda g: graph_name(g) if graph_name(g) is not None else "")


def graph_name(graph):
    cc = credential_class(graph)
    return value(cc, graph, RDFS.label) if cc else None


def credential_class(graph):
    for s, _, _ in graph.triples((None, RDF.type, RDFS.Class)):
        if str(s).endswith("Credential"):
            return s
    return None


def value(subject, graph, predicate):
    return graph.value(subject, predicate)


def uri_split(uri, sep='/'):
    return uri.rsplit(sep, 1)
