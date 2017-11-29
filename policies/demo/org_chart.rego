package org_chart

import data.service_graph

org_chart = {
    "alice": {"teams": ["management"]},
    "bob": {"teams": ["reviewing", "shelving"]},
    "ken": {"teams": ["shelving"]},
}

default allow = false

allow {
    not is_sensitive_api
}

allow {
    user = request_cookies["user"]
    employee_info = org_chart[user]
    employee_info.teams[_] = "management"
}

is_sensitive_api {
    service_graph.destination_service = "reviews"
}

is_sensitive_api {
    service_graph.destination_service = "ratings"
}

request_cookies = cs {
    s = split(input.action.headers.cookie, ";")
    cs = {key: value | [key, value] = split(s[_], "=")}
}

#allow {
#    user = request_cookies["user"]
#    org_chart[user].teams[_] = "reviewing"
#    is_sensitive_api
#    after_4pm
#}
#
#after_4pm {
#    four_pm = time.parse_rfc3339_ns("2017-11-29T00:00:00Z")
#    midnight = time.parse_rfc3339_ns("2017-11-29T08:00:00Z")
#    time.now_ns(current_time)
#    current_time >= four_pm
#    current_time < midnight
#}
