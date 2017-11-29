package service_graph

service_graph = {
    "ingress": ["productpage"],
    "productpage": ["details", "reviews"],
    "reviews": ["ratings"],
}

default allow = false

allow {
    allowed_targets = service_graph[source_service]
    destination_service = allowed_targets[_]
}

allow {
    not source_service
    destination_service = "ingress"
}

destination_service = x {
    raw = input.action["destination-service"]
    raw != null
    s = split(raw, ".")
    x = s[0]
}

source_service = x {
    raw = input.action["source-service"]
    raw != null
    s = split(raw, ".")
    x = s[0]
}
