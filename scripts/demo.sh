#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

which istioctl 2>&1 >/dev/null
if [ $? -ne 0 ]; then
    echo "Did you forget to add istio/bin to PATH?"
    exit 1
fi

echo "Loading allow all policy."
istioctl replace -f <($DIR/gen-opa-handler.sh $DIR/../policies/allow_all/*.rego)
echo "...Done"

read -p "Did you update the time in the demo policy?"
clear

echo "Press enter to kick off demo."
read


export DEMO_RUN_FAST=1
source $DIR/util.sh
clear


run "kubectl -n istio-system get deployments"
run "kubectl get deployments"
run "kubectl get crd"
run "kubectl -n istio-system get rules authz -o yaml"
run "kubectl -n istio-system get authz -o yaml"
run "kubectl -n istio-system get opa -o yaml"

clear

desc "Let's look at some policy!"

$DIR/reload.sh
fswatch -o -r $DIR/../policies/demo/ | xargs -n1 $DIR/reload.sh
