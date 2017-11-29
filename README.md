# Istio's Mixer: Policy Enforcement with Custom Adapters

This repository contains the configuration and scripts used for the demo portion
of the presentation. The slides for the presentation can be found [here](https://schd.ws/hosted_files/kccncna17/ad/Istio%27s%20Mixer_%20Policy%20Enforcement%20with%20Custom%20Adapters.pdf).

## Steps

Create a new Kubernetes cluster using minikube (v0.22.0 or later):

```bash
minikube start --cpus=4 --memory=4096
```

Verify kube-system pods are up and running:

```bash
kubectl get pod -n kube-system
```

> The steps below follow the Istio docs from https://istio.io/docs/setup/kubernetes/quick-start.html.

Download the latest version of Istio:

```bash
curl -L https://git.io/getLatestIstio | sh -
```

You will need to use `istioctl` below. Add it to your PATH:

```bash
export PATH="$PATH:$PWD/istio-0.2.12/bin"
```

Deploy the Istio control plane:

```bash
kubectl apply -f istio-0.2.12/install/kubernetes/istio.yaml
```

Verify the Istio deployment is healthy:

```bash
kubectl get svc -n istio-system
kubectl get pods -n istio-system
```

> The istio-ingress service EXTERNAL-IP will be pending. You will have to use
> the IP address of the guest VM to access the cluster.

Update the Istio deployment to use the OPA-enabled Mixer image:

```bash
kubectl set image deployment istio-mixer mixer=tsandall/mixer:dev4 -n istio-system
```

Create the "authz" and "opa" CRDs:

```bash
kubectl create -f manifests/authz-crd.yaml
kubectl create -f manifests/opa-crd.yaml
```

Configure the OPA adapter and load the policies:

```bash
istioctl create -f manifests/mixer-authz.yaml
istioctl create -f <(./scripts/gen-opa-handler.sh policies/allow_all/*.rego)
```

At this point, Istio should be deployed and OPA should be enabled inside Mixer.

Deploy the BookInfo app to start testing:

```bash
kubectl apply -f <(istioctl kube-inject -f manifests/bookinfo.yaml)
```

Run the following command to obtain the URL of the ingress:

```bash
echo $(kubectl get po -n istio-system -l istio=ingress -n istio-system -o 'jsonpath={.items[0].status.hostIP}'):$(kubectl get svc istio-ingress -n istio-system -n istio-system -o 'jsonpath={.spec.ports[0].nodePort}')
```

Point your browser at `http://192.168.99.102:30612/productpage`. This should
successfully serve the BookInfo app.

To test the final version of the policy shown in the demo, update the OPA
adapter's configuration:

```bash
istioctl replace -f <(./scripts/gen-opa-handler.sh policies/final/*.rego)
```

If you refresh the page, the reviews should no longer be displayed. Login as
"alice" to confirm that the policy is working as expected.
