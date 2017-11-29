#!/usr/bin/env bash

cat <<EOF
apiVersion: "config.istio.io/v1alpha2"
kind: opa
metadata:
  name: opa-handler
  namespace: istio-system
spec:
  checkMethod: data.example.allow
  policy:
EOF

for file in "$@"; do
    echo "  - |"
    cat $file | sed 's/^/    /'
done
