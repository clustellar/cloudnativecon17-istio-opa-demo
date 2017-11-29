package example

default allow = false

allow {
    service_graph_allows
    org_chart_allows
}

org_chart = {
    "alice": {"teams": ["management"]},
    "bob": {"teams": ["reviewing", "shelving"]},
    "ken": {"teams": ["shelving"]},
}

org_chart_allows {
    not is_sensitive_api
}

is_sensitive_api {
    destination_service = "reviews"
}

is_sensitive_api {
    destination_service = "ratings"
}

org_chart_allows {
    employee_info = org_chart[auth_user]
    employee_info.teams[_] = "management"
}

auth_user = request_cookies["user"]

request_cookies = cs {
    s = split(input.action.headers.cookie, ";")
    cs = {key: value | [key, value] = split(s[_], "=")}
}

org_chart_allows {
    org_chart[auth_user].teams[_] = "reviewing"
    is_sensitive_api
    after_4pm
}

after_4pm {
    four_pm = time.parse_rfc3339_ns("2017-11-29T00:00:00Z")
    midnight = time.parse_rfc3339_ns("2017-11-29T08:00:00Z")
    time.now_ns(current_time)
    current_time >= four_pm
    current_time < midnight
}

service_graph = {
    "ingress": ["productpage"],
    "productpage": ["reviews", "details"],
    "ratings": [],
    "reviews": ["ratings"],
    "details": [],
}

service_graph_allows {
    allowed = service_graph[source_service]
    destination_service = allowed[_]
}

service_graph_allows {
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
