# PoC of enterprise container platform in Azure

## Deploy solution
If you do not have infrastructure (networking and jump server) ready, you can deploy example here:

```bash
# Go to demo infrastructure folder
cd demo_infra

# Deploy infrastructure
terraform init
terraform apply -auto-approve
```

Then deploy cluster. For bootstrapping ArgoCD you do not need line-of-sight to Kubernetes APIs, but you need to create GitHub token than can read our private repo.

```bash
# Go to cluster folder
cd clusters/cluster01

# Deploy infrastructure
terraform init
terraform apply -auto-approve

# Deployment created runtime.yaml in cluster folder, make sure you commit it to Git

# Bootstrap ArgoCD via Azure API (no need to have access to Kubernetes API)
export REPO_TOKEN=mytoken
cd ../../charts/argocd_bootstrap/
az aks command invoke -n cluster01 -g cluster01 -f . -c \
    "kubectl create namespace argocd; 
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml; 
    helm upgrade -i argocd-bootstrap . --set repo_token=$REPO_TOKEN --set cluster_name=cluster01"

```

*Note: at this point there is race condition issue with writing Keys to KeyVault via private endpoint as it takes some time for jump server to get correct private endpoint IP and even when dependency is there it fails. Until we find way how to deal with that simply rerun terraform apply and it will finish.*

For debugging and testing since AKS is private, connect to jump server and work on it. I recommend using satiromarra.code-sftp extension to VS Code to synchronize your local files with jump server on the fly.

```bash
# Debug from jump server

## Connect to jump server
ssh tomas@20.166.57.174

## Get cluster credentials -> admin credentials for testing, will be forbidden in production
az aks get-credentials -n cluster01 -g cluster01 --admin --overwrite

## Port forwarding local to jump (and from there you can forward ArgoCD UI Pod)
ssh -L 8081:127.0.0.1:8080 tomas@20.166.57.174
```

For testing and demonstration see [here](demo_kube/README.md)

## Development
1. Create new branch
2. Modify file charts/argocd_bootstrap/templates/argocd_cluster.yaml to point to your new branch by changing targetRevision
3. Modify file charts/argocd_cluster/templates/configurations.yaml to point to your new branch by changing targetRevision
4. Modify file charts/argocd_cluster/templates/apim_gw.yaml to point to your new branch by changing targetRevision
5. Re-bootstrap your ArgoCD by
```
export REPO_TOKEN=mytoken
cd ../../charts/argocd_bootstrap/
az aks command invoke -n cluster01 -g cluster01 -f . -c \
    "kubectl create namespace argocd; 
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml; 
    helm upgrade -i argocd-bootstrap . --set repo_token=$REPO_TOKEN --set cluster_name=cluster01"
```
1. Now you can develop Terraform code, Helm templates etc. When merging back to main discard changes in targetRevision (or modify it back to "main")

## Desired state architecture
```mermaid
graph LR;
    subgraph Git
        manifest{manifest.yaml}
        runtime{runtime.yaml}
    end;

    manifest{manifest.yaml} -- YAML consumed --> terraform_root
    manifest -- YAML consumed --> argocd_cluster
    terraform_root .-> runtime{runtime.yaml}

    subgraph Terraform
        terraform_root --> aks-system;
        terraform_root --> aks-apps;

        aks-system .-> aks(AKS with extensions and addons)
        aks-system .-> system_nodepool(Nodepool for system components)
        aks-system .-> shared_nodepools(Nodepools for shared compute environments)
        aks-system .-> dedicated_nodepools(Nodepools for dedicated compute environments)
        aks-system .-> encrypt_system(encryption resources for system storage and KMS/Etcd)
        aks-system .-> auditing
        aks-system .-> rbac_system(RBAC for system, kubelet and users kubeconfig)
        aks-apps .-> rbac(RBAC for namespaces)
        aks-apps .-> kv(Key Vaults for applications)
        aks-apps .-> encrypt_apps(encryption resources for applications storage)
        aks-apps .-> identities(application identities with federation)
    end;

 

    subgraph ArgoCD
        argocd_cluster --> ingress_internal;
        argocd_cluster --> ingress_external;
        argocd_cluster --> TBD-external-dns;
        argocd_cluster --> TBD-cert-manager;
        argocd_cluster --> configurations;
        configurations .-> namespaces;
        configurations .-> network_policies;
        configurations .-> storage_classes;
        configurations .-> service_accounts;
        configurations .-> resource_quotas;
    end;

    runtime .-> service_accounts
```

## Automation steps
```mermaid
graph TD;
    tf[Terraform apply] --> install[Install ArgoCD via Azure API command invoke]
    tf .-> runtime{runtime.yaml}
    manifest{manifest.yaml} .-> tf
    install --> bootstrap[Bootstrap ArgoCD App of Apps via Azure API command invoke]
    bootstrap --> argocd[ArgoCD pulls Kubernetes configurations and components]
    runtime .-> argocd
    manifest .-> argocd
```

## Compute isolation
```mermaid
flowchart TD
    subgraph cluster
        subgraph system_nodepool
            ingress_internal
            ingress_external
            core-dns
            argocd
        end
        subgraph shared_nodepools
            subgraph standard
                standard-app1 --> pod1_app1
                standard-app1 --> pod2_app1
                standard-app2 --> pod1_app2
            end
            subgraph high-mem
                standard-app2 --> pod2_app2
            end
        end
        subgraph dedicated_nodepools
            subgraph confidential_app3_nodepool
                confidential_app3 --> pod1_app3
                confidential_app3 --> pod2_app3
            end
            subgraph confidential_app4_nodepool
                confidential_app4 --> pod1_app4
                confidential_app4 --> pod2_app4
            end
        end
    end
```

## Storage encryption
```mermaid
flowchart LR
    subgraph cluster_nodes
        subgraph system_nodepool
            ingress_internal
            ingress_external
            core_dns
            argocd
        end
        subgraph shared_nodepools
            standard_app1 --> standard_app1_disk
            standard_app2 --> standard_app2_disk
        end
        subgraph dedicated_nodepools
            subgraph confidential-app3-nodepool
                confidential_app3 --> confidential_app3_disk
            end
            subgraph confidential_app4_nodepool
                confidential_app4 --> confidential_app4_disk
            end
        end
    end
    subgraph cluster_control_plane
        Etcd
    end
    Etcd --KMS-key--> system_keyvault
    system_nodepool --encryption_key--> system_keyvault
    shared_nodepools --encryption_key--> system_keyvault
    dedicated_nodepools --encryption_key--> system_keyvault
    standard_app1_disk --encryption_key--> standard_app1_keyvault
    standard_app2_disk --encryption_key--> standard_app2_keyvault
    confidential_app3_disk --encryption_key--> confidential_app3_keyvault
    confidential_app4_disk --encryption_key--> confidential_app4_keyvault
```
    
## Network view
```mermaid
flowchart TD
    subgraph api_subnet
        api_server
    end;

    api_subnet --> main_subnet
    api_subnet --> confidential_app3_subnet
    api_subnet --> confidential_app4_subnet

    subgraph main_subnet
        subgraph standard_app1_namespace
            subgraph standard_app1_component1
                standard_app1_service1 --> standard_app1_pod1
                standard_app1_service1 --> standard_app1_pod2
            end
            subgraph standard_app1_component2
                standard_app1_pod1 --> standard_app1_service2
                standard_app1_pod2 --> standard_app1_service2
                standard_app1_service2 --> standard_app1_pod3
                standard_app1_service2 --> standard_app1_pod4
            end
            standard_app1_pod3 --> standard_app1_egress_policy
            standard_app1_pod4 --> standard_app1_egress_policy
        end
        subgraph standard_app2_namespace
            subgraph standard_app2_component
                standard_app2_service --> standard_app2_pod1
                standard_app2_service --> standard_app2_pod2
            end
            standard_app2_pod1 --> standard_app2_egress_policy
            standard_app2_pod2 --> standard_app2_egress_policy
        end
    end

    subgraph confidential_app3_subnet
        subgraph confidential_app3_namespace
            confidential_app3_service --> confidential_app3_pod1
            confidential_app3_service --> confidential_app3_pod2
        end
        confidential_app3_pod1 --> confidential_app3_egress_policy
        confidential_app3_pod2 --> confidential_app3_egress_policy
    end
    subgraph confidential_app4_subnet
        subgraph confidential_app4_namespace
            confidential_app4_service --> confidential_app4_pod1
            confidential_app4_service --> confidential_app4_pod2
        end
        confidential_app4_pod1 --> confidential_app4_egress_policy
        confidential_app4_pod2 --> confidential_app4_egress_policy
    end

    subgraph inbound_internal_subnet
        ingress_internal
        api_management_internal
    end
    subgraph inbound_external_subnet
        ingress_external
        api_management_external
    end
    users --> ingress_internal
    users --> ingress_external
    users --> api_management_external
    ingress_internal --> standard_app1_service1
    ingress_external --> standard_app2_service
    ingress_internal --> confidential_app3_service
    ingress_external --> confidential_app4_service
    api_management_external --> standard_app2_service
    api_management_external --> confidential_app4_service

    subgraph customer_firewall
        confidential_app4_egress_policy --> fw_interface1
        confidential_app3_egress_policy --> fw_interface2
        standard_app1_egress_policy --> fw_interface3
        standard_app2_egress_policy --> fw_interface3
    end
```

## Policies
10 security policies are implemented
- Policies are applied in default configuration to all applications
- On per-application basis exclusions can be managed:
  - Whole policy can be excluded from application
  - Where possible more granular exclusions are available based on image name/path
- Allowed image policy is applied by default to all applications
- On per-application basis regex list can be overridden
  - Application can get less restrictive by opening access to more paths without allowing the same for other applications
  - Override list replaces default completely so application can get more restrictive eg. by being specific to level of registry/repo/image:tag