package org_chart

import data.istio_attrs

org_chart = {
    "alice": {"teams": ["management"]},
    "bob": {"teams": ["reviewing", "shelving"]},
    "ken": {"teams": ["shelving"]},
}

default allow = false

allow {
    not deny
}

deny {
    not is_manager
    is_sensitive_api
}

is_manager {
    user = istio_attrs.cookies["user"]
    employee_info = org_chart[user]
    employee_info.teams[_] = "management"
}

is_sensitive_api {
    istio_attrs.dest_service = "reviews"
}

is_sensitive_api {
    istio_attrs.dest_service = "ratings"
}
