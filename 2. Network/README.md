# Network Infrastructure - Azure VNet & Subnet

Configuración de infraestructura de red base en Azure usando **Terraform**. Este módulo provisiona una **Virtual Network (VNet)** y **Subnet** en un Azure Resource Group existente.

---

## 📋 Descripción General

Este proyecto define y despliega recursos de networking en Azure:

- **Virtual Network (VNet)**: Red virtual personalizada con espacio de direcciones configurables
- **Subnet**: Subred dentro de la VNet para alojar recursos como máquinas virtuales, contenedores u otros servicios
- **Resource Group**: Utiliza un grupo de recursos existente en Azure

### Características

✅ Basado en **Terraform IaC**  
✅ Configuración modular y parametrizada  
✅ Compatible con providers: `azurerm` ~> 4.0 y `random` ~> 3.6  
✅ Outputs para integración con otros módulos  
✅ Tags personalizables para auditoría y gestión de costos  

---

## 🏗️ Estructura de Archivos

```
2. Network/
├── main.tf             # Definición de recursos: VNet, Subnet
├── variables.tf        # Variables de entrada y valores por defecto
├── outputs.tf          # Valores de salida para otros módulos
├── providers.tf        # Configuración de providers (azurerm, random)
├── terraform.tfstate   # Estado actual de la infraestructura (generado)
├── terraform.tfstate.backup  # Backup del estado (generado)
└── README.md           # Este archivo
```

---

## 📝 Recursos Creados

### 1. **Virtual Network (VNet)**
```hcl
Nombre:           demo-aks-vnet (configurable)
Espacio:          10.40.0.0/16 (configurable)
Proveedor:        azurerm_virtual_network
Tags:             owner, managed-by, env
```

### 2. **Subnet**
```hcl
Nombre:           demo-aks-snet-aks (configurable)
Rango CIDR:       10.40.1.0/24 (configurable)
VNet:             Pertenece a la VNet creada
Políticas:        Private Endpoints habilitados
```

---

## 🔧 Variables de Configuración

### Requeridas

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `rg-cloud-lab` | Nombre del Resource Group existente | `rg-cloud-lab` |

### Opcionales (con valores por defecto)

| Variable | Descripción | Valor por Defecto |
|----------|-------------|-------------------|
| `vnet_e08` | Nombre de la VNet | `vnet-e08` |
| `vnet_e8_address_space` | Espacio de direcciones CIDR | `["10.58.0.0/16"]` |
| `subnet_e08` | Nombre de la Subnet | `snet-e08` |
| `subnet_e8_prefix` | Prefijo CIDR de la Subnet | `10.58.1.0/24` |
| `tags` | Tags comunes para los recursos | (ver `variables.tf`) |

---

## 📤 Outputs

Tras aplicar la configuración, se generan los siguientes valores de salida:

```hcl
resource_group_name    # Nombre del Resource Group
vnet_id                # ID de la Virtual Network
vnet_address_space     # Espacio de direcciones de la VNet
subnet_id              # ID de la Subnet
subnet_prefix          # Prefijo CIDR de la Subnet
```

Uso en otros módulos:
```hcl
data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "mystgaccount"
    container_name       = "tfstate"
    key                  = "network.tfstate"
  }
}

vnet_id = data.terraform_remote_state.network.outputs.vnet_id
```

---

## 🚀 Uso

### Requisitos Previos

1. **Terraform** instalado (versión ≥ 1.6.0)
   ```bash
   terraform version
   ```

2. **Azure CLI** instalado y autenticado
   ```bash
   az login
   ```

3. **Resource Group existente** en Azure
   ```bash
   az group list --query "[].name" -o table
   ```

### Pasos para Desplegar

#### 1. Inicializar Terraform
```bash
cd "2. Network"
terraform init
```

#### 2. Validar la Configuración
```bash
terraform fmt -check
terraform validate
```

#### 3. Crear un Plan (ver cambios sin aplicar)
```bash
terraform plan -out=tfplan
```

#### 4. Aplicar los Cambios
```bash
terraform apply tfplan
```

O directamente (se solicitará confirmación):
```bash
terraform apply
```

#### 5. Verificar los Outputs
```bash
terraform output
```

---

## 📊 Configuración Personalizada

### Ejemplo: Cambiar el Rango de IPs

Opción 1: Pasar variables por línea de comandos
```bash
terraform apply \
  -var="vnet_e8_address_space=[\"192.168.0.0/16\"]" \
  -var="subnet_e8_prefix=192.168.1.0/24"
```

Opción 2: Crear archivo `terraform.tfvars`
```hcl
# terraform.tfvars
rg-cloud-lab              = "rg-cloud-lab"
vnet_e08                  = "vnet-production"
vnet_e8_address_space     = ["172.16.0.0/16"]
subnet_e08                = "snet-production"
subnet_e8_prefix          = "172.16.1.0/24"

tags = {
  owner      = "devops-team"
  managed-by = "terraform"
  env        = "production"
}
```

Luego:
```bash
terraform apply -var-file="terraform.tfvars"
```

---

## 🔍 Verificación Post-Despliegue

### Listar recursos creados en Azure
```bash
# VNet
az network vnet list --resource-group rg-cloud-lab -o table

# Subnets
az network vnet subnet list \
  --resource-group rg-cloud-lab \
  --vnet-name vnet-e08 \
  -o table
```

### Verificar conectividad
```bash
# Obtener detalles de la Subnet
az network vnet subnet show \
  --resource-group rg-cloud-lab \
  --vnet-name vnet-e08 \
  --name snet-e08
```

---

## 🛡️ Seguridad y Buenas Prácticas

### ✅ Recomendaciones

1. **State Management**: Almacenar `terraform.tfstate` en **Azure Storage** remoto (no en git)
   ```hcl
   # En 1_01_backend.tf o archivo similar
   terraform {
     backend "azurerm" {
       resource_group_name  = "rg-tfstate"
       storage_account_name = "mystgaccount"
       container_name       = "tfstate"
       key                  = "network.tfstate"
     }
   }
   ```

2. **Network Security Groups (NSGs)**: Agregar reglas de seguridad (opcional)
   - Ver comentario en `main.tf` (líneas ~53-76)

3. **Private Endpoints**: Habilitar para servicios PaaS
   - Actualmente habilitado: `private_endpoint_network_policies = "Disabled"`

4. **DNS Personalizado**: Configurar servidores DNS en la VNet si es necesario

5. **Versionado**: Usar `.gitignore` para excluir estado local
   ```
   *.tfstate
   *.tfstate.*
   .terraform/
   .terraform.lock.hcl
   ```

---

## 🔄 Ciclo de Vida - Comandos Útiles

| Tarea | Comando |
|-------|---------|
| Inicializar | `terraform init` |
| Formatear código | `terraform fmt` |
| Validar | `terraform validate` |
| Ver cambios (dry-run) | `terraform plan` |
| Aplicar cambios | `terraform apply` |
| Destruir recursos | `terraform destroy` |
| Ver estado actual | `terraform state list` |
| Forzar actualización | `terraform state refresh` |
| Cambiar a otro workspace | `terraform workspace select <name>` |

---

## 🐛 Troubleshooting

### Error: Resource Group no encontrado
```
Error: Retrieving resource group "rg-cloud-lab" failed
```

**Solución:**
```bash
# Verificar que el RG existe
az group show --name rg-cloud-lab

# Listar todos los RGs
az group list -o table
```

### Error: Conflicto de direcciones IP
```
Error: the address space '10.40.0.0/16' overlaps with another vnet
```

**Solución:** Usar un rango CIDR diferente
```bash
terraform apply -var="vnet_e8_address_space=[\"10.50.0.0/16\"]"
```

### Estado corrupto o desincronizado
```bash
# Refrescar el estado
terraform refresh

# Validar estado
terraform validate

# Recrear recurso específico
terraform taint azurerm_virtual_network.vnet
terraform apply
```

---

## 📚 Enlaces Útiles

- [Documentación Terraform Azure VNet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
- [Documentación Terraform Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
- [Azure Networking Best Practices](https://docs.microsoft.com/en-us/azure/virtual-network/)
- [Terraform State Management](https://www.terraform.io/docs/language/state/remote.html)

---

## 👤 Autor y Versión

- **Versión**: 1.0
- **Creado**: 2024-2025
- **Actualizado**: Febrero 2026
- **Propietario**: erick.iza

---

## 📄 Licencia

Este proyecto forma parte del laboratorio Azure AKS Microservice Platform.

---

## 📞 Soporte

Para problemas o preguntas:
1. Revisar logs: `terraform logs`
2. Validar sintaxis: `terraform validate`
3. Consultar estado: `terraform state list`
4. Contactar al propietario del proyecto

---

**Última actualización**: 24 de febrero de 2026
