resource_group_name     = "aks-as-a-service-monitoring"
location                = "swedencentral"
monitor_workspace_name  = "aks-monitoring321"
grafana_name            = "aks-grafana321"
ampls_name              = "ampls"
ampls_rg_name           = "aks-as-a-service-lz"
monitor_dcr_id          = "/subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/aks-as-a-service-monitoring/providers/Microsoft.Insights/dataCollectionRules/aks-prometheus"
monitor_subnet_id       = "/subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/aks-as-a-service-lz/providers/Microsoft.Network/virtualNetworks/hub/subnets/ampls"
monitor_amw_zone_id     = "/subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/aks-as-a-service-lz/providers/Microsoft.Network/privateDnsZones/privatelink.swedencentral.prometheus.monitor.azure.com"
grafana_subnet_id       = "/subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/aks-as-a-service-lz/providers/Microsoft.Network/virtualNetworks/hub/subnets/ampls"
grafana_zone_id         = "/subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/aks-as-a-service-lz/providers/Microsoft.Network/privateDnsZones/privatelink.grafana.azure.com"
grafana_admin_object_id = "b0797e57-4a37-4f7d-9def-b312831bc3d7"
