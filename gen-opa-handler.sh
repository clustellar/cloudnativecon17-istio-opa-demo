#!/usr/bin/env bash

FILE=$1
if [[ "" == "$FILE" ]]; then
    FILE=example.rego
fi


cat <<EOF
apiVersion: "config.istio.io/v1alpha2"
kind: opa
metadata:
  name: opa-handler
  namespace: istio-system
spec:
  policy:
    - |+
$(cat $FILE | sed 's/^/      /')
  checkMethod: "data.example.allow"
EOF
