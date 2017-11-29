#!/usr/bin/env bash

istioctl replace -f <(./gen-opa-handler.sh)
