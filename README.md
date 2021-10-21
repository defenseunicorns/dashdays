# dashdays

Terraform infrastructure supporting Dash Days

## Initial Setup for Everyone

1. Log into AWS account on the CLI and confirm visibility to cluster:

```bash
❯ aws eks list-clusters
{
    "clusters": [
        "dashdays-helmchart",
        "dashdays-uiux",
        "darcy-test-cluster",
        "dashdays-ctf"
    ]
}
```

1b. Ask @darcycleaver what his test cluster is for.

2.  Generate all the Kubeconfigs:

```bash
aws eks update-kubeconfig --name dashdays-ctf --kubeconfig ~/.kube/configs/dashdays-ctf.yaml --alias dashdays-ctf --region us-east-2  --role-arn arn:aws:iam::950698127059:role/unicorn-dash-days-eks-user

aws eks update-kubeconfig --name dashdays-helmchart --kubeconfig ~/.kube/configs/dashdays-helmchart.yaml --alias dashdays-helmchart --region us-east-2  --role-arn arn:aws:iam::950698127059:role/unicorn-dash-days-eks-user

aws eks update-kubeconfig --name dashdays-uiux --kubeconfig ~/.kube/configs/dashdays-uiux.yaml --alias dashdays-uiux --region us-east-2 --role-arn arn:aws:iam::950698127059:role/unicorn-dash-days-eks-user
```

## Helm Chart

Installed Flux as a pre-req to all of this.

Big Bang was installed on top of this cluster with the values file provided AND registry credentials that were since removed from git.

```bash
dashdays/helmchart/bigbang on  feature/initial_work [✘!?] on ☁️  leapfrog(us-east-2) on ☁️ tom@leapfrog.ai took 3s
❯ kustomize build . | k apply -f -
namespace/bigbang created
configmap/common-55k6f8kd2t created
configmap/environment-bd478ft2hd created
secret/common-bb-tcd74c266b created
secret/environment-bb-tcd74c266b created
helmrelease.helm.toolkit.fluxcd.io/bigbang created
```

Notable changes:

This addition was added to Gatekeeper to allow transition from upstream images to iron bank images:

```yaml
gatekeeper:
  values:
    violations:
      allowedDockerRegistries:
        enforcement: dryrun
```

```bash
dashdays/helmchart/bigbang on  feature/initial_work [!?⇡] on ☁️  leapfrog(us-east-2) on ☁️ tom@leapfrog.ai
❯ export KUBECONFIG=~/.kube/configs/dashdays-helmchart.yaml

dashdays/helmchart/bigbang on  feature/initial_work [!?⇡] on ☁️  leapfrog(us-east-2) on ☁️ tom@leapfrog.ai
❯ k get vs -A
NAMESPACE    NAME                                 GATEWAYS                  HOSTS                                   AGE
jaeger       jaeger                               ["istio-system/public"]   ["tracing.helm.tekton.bigbang.dev"]     74m
kiali        kiali                                ["istio-system/public"]   ["kiali.helm.tekton.bigbang.dev"]       74m
logging      kibana                               ["istio-system/public"]   ["kibana.helm.tekton.bigbang.dev"]      89m
monitoring   monitoring-monitoring-kube-grafana   ["istio-system/public"]   ["grafana.helm.tekton.bigbang.dev"]     75m
twistlock    console                              ["istio-system/public"]   ["twistlock.helm.tekton.bigbang.dev"]   74m

```

## CTF

### Setup

0. Installed flux

```bash
umbrella on  HEAD (34e5e71) [!?] on ☁️  (us-gov-west-1) on ☁️ tom@leapfrog.ai
❯ export KUBECONFIG=~/.kube/configs/dashdays-ctf.yaml

umbrella on  HEAD (34e5e71) [!?] on ☁️  (us-gov-west-1) on ☁️ tom@leapfrog.ai
❯ ./scripts/install_flux.sh -u runyontr -p ${REGISTRY1_PASSWORD}
REGISTRY_URL: registry1.dso.mil
REGISTRY_USERNAME: runyontr
namespace/flux-system created
Creating secret private-registry in namespace flux-system
secret/private-registry created
Installing flux from kustomization
Warning: resource namespaces/flux-system is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
namespace/flux-system configured
customresourcedefinition.apiextensions.k8s.io/alerts.notification.toolkit.fluxcd.io created
customresourcedefinition.apiextensions.k8s.io/buckets.source.toolkit.fluxcd.io created
customresourcedefinition.apiextensions.k8s.io/gitrepositories.source.toolkit.fluxcd.io created
customresourcedefinition.apiextensions.k8s.io/helmcharts.source.toolkit.fluxcd.io created
customresourcedefinition.apiextensions.k8s.io/helmreleases.helm.toolkit.fluxcd.io created
customresourcedefinition.apiextensions.k8s.io/helmrepositories.source.toolkit.fluxcd.io created
customresourcedefinition.apiextensions.k8s.io/kustomizations.kustomize.toolkit.fluxcd.io created
customresourcedefinition.apiextensions.k8s.io/providers.notification.toolkit.fluxcd.io created
customresourcedefinition.apiextensions.k8s.io/receivers.notification.toolkit.fluxcd.io created
serviceaccount/helm-controller created
serviceaccount/kustomize-controller created
serviceaccount/notification-controller created
serviceaccount/source-controller created
clusterrole.rbac.authorization.k8s.io/crd-controller-flux-system created
clusterrolebinding.rbac.authorization.k8s.io/cluster-reconciler-flux-system created
clusterrolebinding.rbac.authorization.k8s.io/crd-controller-flux-system created
service/notification-controller created
service/source-controller created
service/webhook-receiver created
deployment.apps/helm-controller created
deployment.apps/kustomize-controller created
deployment.apps/notification-controller created
deployment.apps/source-controller created
networkpolicy.networking.k8s.io/allow-egress created
networkpolicy.networking.k8s.io/allow-scraping created
networkpolicy.networking.k8s.io/allow-webhooks created
deployment.apps/helm-controller condition met
deployment.apps/source-controller condition met
deployment.apps/kustomize-controller condition met
deployment.apps/notification-controller condition met
```

```bash
dashdays/ctf/bigbang on  feature/initial_work [✘!?] on ☁️  leapfrog(us-east-2) on ☁️ tom@leapfrog.ai
❯ export KUBECONFIG=~/.kube/configs/dashdays-ctf.yaml

dashdays/ctf/bigbang on  feature/initial_work [✘!?] on ☁️  leapfrog(us-east-2) on ☁️ tom@leapfrog.ai
❯ k get nodes
NAME                                       STATUS   ROLES    AGE   VERSION
ip-10-0-1-68.us-east-2.compute.internal    Ready    <none>   8h    v1.21.4-eks-033ce7e
ip-10-0-2-194.us-east-2.compute.internal   Ready    <none>   8h    v1.21.4-eks-033ce7e
ip-10-0-3-231.us-east-2.compute.internal   Ready    <none>   8h    v1.21.4-eks-033ce7e

dashdays/ctf/bigbang on  feature/initial_work [✘!?] on ☁️  leapfrog(us-east-2) on ☁️ tom@leapfrog.ai
❯ kustomize build . | k apply -f -
namespace/bigbang unchanged
configmap/common-996455ft46 unchanged
configmap/environment-bd478ft2hd unchanged
secret/common-bb-tcd74c266b unchanged
secret/environment-bb-tcd74c266b unchanged
helmrelease.helm.toolkit.fluxcd.io/bigbang created
gitrepository.source.toolkit.fluxcd.io/bigbang created
```

The UI components for this project should be available

```bash
dashdays/ctf/bigbang on  feature/initial_work [!?⇡] on ☁️  leapfrog(us-east-2) on ☁️ tom@leapfrog.ai
❯ export KUBECONFIG=~/.kube/configs/dashdays-ctf.yaml

dashdays/ctf/bigbang on  feature/initial_work [!?⇡] on ☁️  leapfrog(us-east-2) on ☁️ tom@leapfrog.ai
❯ k get vs -A
NAMESPACE    NAME                                 GATEWAYS                  HOSTS                                    AGE
anchore      anchore-engine-api-service           ["istio-system/public"]   ["anchore-api.ctf.tekton.bigbang.dev"]   9m39s
anchore      anchore-enterprise-ui-service        ["istio-system/public"]   ["anchore.ctf.tekton.bigbang.dev"]       9m39s
jaeger       jaeger                               ["istio-system/public"]   ["tracing.ctf.tekton.bigbang.dev"]       66m
kiali        kiali                                ["istio-system/public"]   ["kiali.ctf.tekton.bigbang.dev"]         66m
logging      kibana                               ["istio-system/public"]   ["kibana.ctf.tekton.bigbang.dev"]        68m
monitoring   monitoring-monitoring-kube-grafana   ["istio-system/public"]   ["grafana.ctf.tekton.bigbang.dev"]       11m
twistlock    console                              ["istio-system/public"]   ["twistlock.ctf.tekton.bigbang.dev"]     9m37s
```

## UIUX

```bash
dashdays/uiux/bigbang on  feature/initial_work [✘!?] on ☁️  leapfrog(us-east-2) on ☁️ tom@leapfrog.ai
❯ k get vs -A
NAMESPACE   NAME     GATEWAYS                  HOSTS                                 AGE
jaeger      jaeger   ["istio-system/public"]   ["tracing.uiux.tekton.bigbang.dev"]   7m36s
kiali       kiali    ["istio-system/public"]   ["kiali.uiux.tekton.bigbang.dev"]     8m7s
logging     kibana   ["istio-system/public"]   ["kibana.uiux.tekton.bigbang.dev"]    8m8s
```

## SOPS

After creating the certs for ingress, and adding licenes and registry1 credentials, the values files for each
environment was encrypted with sops. To decrypt,

```bash
sops -d -i ctf/bigbang/values.yaml
sops -d -i helmchart/bigbang/values.yaml
```
