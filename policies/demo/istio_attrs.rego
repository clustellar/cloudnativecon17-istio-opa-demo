package istio_attrs

dest_service = x {
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

cookies = cs {
    s = split(input.action.headers.cookie, ";")
    cs = {key: value | [key, value] = split(s[_], "=")}
}
