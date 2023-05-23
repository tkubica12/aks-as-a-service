## Deploy solution
CI/CD is TBD and will be part of this repo.

If you do not have infrastructure ready, you can deploy example here (make sure you have access to VNET and private DNS configured properly - see next section).

```bash
# Go to demo infrastructure folder
cd demo_infra

# Deploy infrastructure
terraform init
terraform apply -auto-approve
```

This will create example hub and spoke topology with Azure Firewall, Azure VPN and jump server. T. Since solution is using private endpoints your deployment server needs to be in VNET - in demo solution you can use either jump server or connect via P2S VPN.

In **VPN** option download configuration of Azure VPN Client from portal (or configure your own OpenVPN client) a add following to XML configuration to make sure DNS resolving works:

```xml
  <clientconfig>
    <dnsservers>
      <dnsserver>10.80.3.4</dnsserver>
    </dnsservers>
    <dnssuffixes>
      <dnssuffix>.privatelink.northeurope.azmk8s.io</dnssuffix>
      <dnssuffix>.northeurope.azmk8s.io</dnssuffix>
      <dnssuffix>.privatelink.vaultcore.azure.net</dnssuffix>
      <dnssuffix>.vault.azure.net</dnssuffix>
    </dnssuffixes>
  </clientconfig>
```

Another option is to connect to **jump server** and work on it. I recommend using satiromarra.code-sftp extension to VS Code to **synchronize your local files with jump server** on the fly.

```bash
# Debug from jump server

## Connect to jump server
ssh tomas@20.166.57.174

## Get cluster credentials -> admin credentials for testing, will be forbidden in production
az aks get-credentials -n cluster01 -g cluster01 --admin --overwrite-existing

## Port forwarding local to jump (and from there you can forward ArgoCD UI Pod)
ssh -L 8081:127.0.0.1:8080 tomas@20.166.57.174
```

Then deploy cluster. 

*Note: at this point there is race condition issue with writing Keys to KeyVault via private endpoint. Azurerm Terraform provider currently do list operation on keys before private endpoint and DNS is configured even you have dependencies OK (it correctly do not start to deploy resource, but try to read on data plane and fails). There is issue open for this so hopefully this limitation of API gets overcome at some point. In meantime you can use AzApi to deploy Key Vault to overcome this: https://github.com/hashicorp/terraform-provider-azurerm/issues/9738#issuecomment-1442701113 or just re-run terraform after failure.*

For bootstrapping ArgoCD you do not need line-of-sight to Kubernetes APIs, but you need to create GitHub token than can read our private repo.

```bash
# Go to cluster folder
cd clusters/cluster01

# Deploy infrastructure
terraform init
terraform apply -auto-approve

# Deployment created runtime.yaml in cluster folder, make sure you commit it to Git

# Bootstrap ArgoCD via Azure API (no need to have access to Kubernetes API)
export REPO_TOKEN=mytoken
cd ./charts/argocd_bootstrap/
az aks command invoke -n cluster01 -g cluster01 -f . -c \
    "kubectl create namespace argocd; 
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml; 
    helm upgrade -i argocd-bootstrap . --set repo_token=$REPO_TOKEN --set cluster_name=cluster01"
```

*Note: you can also leverage AKS GitOps extension that is using Flux, but CRDs will be different in that case. Also there is feature request on GitHub to implement extension for ArgoCD also - add thumbs up if this is what you want: https://github.com/Azure/AKS/issues/3308*





For testing and demonstration see [/demo_kube/README.md](/demo_kube/README.md)