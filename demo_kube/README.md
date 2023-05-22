# Testing and demonstration

## Storage
Deploy persistent storage. Note one PVC with Pod is using correct storageclass and in Azure there will be disk encrypted using DES of that app. In second example PVC try to use incorrect storage class of other team and this gets blocked.

```bash
helm upgrade -i storage charts/storage
helm upgrade -i storage-misuse charts/storage_misuse
```

## Secrets
SecretProviderClass test.

```bash
# Create secrets
export key_vault_name_app101=$(az keyvault list -g cluster01 --query "[?contains(name,'app101-')].name" -o tsv)
export key_vault_name_app201=$(az keyvault list -g cluster01 --query "[?contains(name,'app201-')].name" -o tsv)
az keyvault secret set -n mysecret --vault-name $key_vault_name_app101 --value MySuperSecret101!
az keyvault secret set -n mysecret --vault-name $key_vault_name_app201 --value MySuperSecret201!

# Get identity info
export identity_client_id_app101=$(az identity show -n app101 -g cluster01 --query clientId -o tsv)
export identity_client_id_app201=$(az identity show -n app201 -g cluster01 --query clientId -o tsv)
export tenant_id=$(az identity show -n app101 -g cluster01 --query tenantId -o tsv)

# Install Helm chart
helm upgrade -i secrets charts/secrets \
    --set key_vault_name_app101=$key_vault_name_app101 \
    --set key_vault_name_app201=$key_vault_name_app201 \
    --set identity_client_id_app101=$identity_client_id_app101 \
    --set identity_client_id_app201=$identity_client_id_app201 \
    --set tenant_id=$tenant_id


# Connect to Pod and check if secret is there
cat /mnt/mysecretpath/mysecret && echo

# Cleanup
helm delete secrets
```

## Networking

```bash
helm upgrade -i network charts/network 
```

Test scenarios:
- Exec to app101 container and from there curl to app101-2 (inter-namespace communication, should work)
- Exec to app101 container and from there curl to app102.app101.svc.cluster.local (intra-namespace communication, should NOT work)
- Exec to app101 container and from there curl to app102.10.0.2.4.nip.io (communication out-in, should work)
- Exec to app101 container and from there curl to app103.10.0.2.5.nip.io (communication out-in, will work, but if not desired could be prevented)
- Exec to app101 container and from there curl to app101-misuse (should work, internal access within app is no problem)
- Exec to app101 container and from there curl to app101-misuse.10.0.2.5.nip.io  (should NOT work, internal app will refuse traffic from external ingress)

## RBAC

```bash
az login --use-device-code  # Login as aks-u1@tkubica.biz
az aks install-cli
az aks get-credentials --resource-group cluster01 --name cluster01
kubectl get pods -n app101  # ok
kubectl get pods -n app102  # ok
kubectl get pods -n app103  # NOT ok
```



## Debugging


```bash
helm upgrade -i debug charts/debug


```