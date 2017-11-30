#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

istioctl replace -f <($DIR/gen-opa-handler.sh $DIR/../policies/demo/*.rego)
