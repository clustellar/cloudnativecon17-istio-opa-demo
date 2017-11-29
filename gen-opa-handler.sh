#!/usr/bin/env bash

cat <<EOF
apiVersion: "config.istio.io/v1alpha2"
kind: opa
metadata:
  name: opa-handler
  namespace: istio-system
spec:
  policy:
    - |+
$(cat example.rego | sed 's/^/      /')
  checkMethod: "data.example.allow"
EOF
