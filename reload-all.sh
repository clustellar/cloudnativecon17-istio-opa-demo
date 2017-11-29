#!/usr/bin/env bash

istioctl replace -f ./mixer-authz.yaml
./reload.sh
