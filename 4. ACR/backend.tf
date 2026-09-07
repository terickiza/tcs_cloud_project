# Estado remoto en Azure Storage (nunca estado local versionado).
# Configuración parcial: los valores se pasan en el pipeline con
#   terraform init -backend-config=backend.hcl
# o con -backend-config="key=..." individuales. No poner secretos aquí.
terraform {
  backend "azurerm" {
    use_azuread_auth = true
  }
}
