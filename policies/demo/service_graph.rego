package service_graph

import data.istio_attrs

connectivity = {
    "ingress": ["productpage"],
    "productpage": ["details"],
    "reviews": ["ratings"],
}

default allow = true

allow {
    allowed_targets = connectivity[istio_attrs.source_service]
    istio_attrs.dest_service = allowed_targets[_]
}

allow {
    not istio_attrs.source_service
    istio_attrs.dest_service = "ingress"
}
