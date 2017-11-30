package org_chart

import data.istio_attrs

#allow {
#    user = istio_attrs.cookies["user"]
#    org_chart[user].teams[_] = "reviewing"
#    after_4pm
#}
#
#after_4pm {
#    four_pm = time.parse_rfc3339_ns("2017-11-30T03:00:00Z")
#    midnight = time.parse_rfc3339_ns("2017-11-30T04:00:00Z")
#    time.now_ns(current_time)
#    current_time >= four_pm
#    current_time < midnight
#}
