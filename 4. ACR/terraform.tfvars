# ========================================
# CONFIGURACIÓN DE VARIABLES
# ========================================

# Resource Group existente (donde está tu AKS)
resource_group_name = "rg-cloud-lab" #CAMBIAR al nombre de tu RG

# Región (debe coincidir con tu RG)
location = "eastus"

# Nombre del ACR (debe ser único globalmente)
acr_name = "acrdevopslab01" #CAMBIAR por algo único

# SKU del ACR
acr_sku = "Basic"

# Usuario admin del ACR: deshabilitado. AKS autentica por managed identity (AcrPull).
acr_admin_enabled = false

# Nombre del AKS existente
aks_name = "aks-e08" #CAMBIAR al nombre de tu AKS

# Tags personalizados
tags = {
  owner      = "erick.iza"
  managed-by = "terraform"
  env        = "lab"
}