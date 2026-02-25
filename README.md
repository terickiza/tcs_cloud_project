# 🚀 Azure AKS Microservice Platform

## Descripción

**Azure AKS Microservice Platform** es una solución integral de infraestructura en la nube para Azure que implementa una arquitectura moderna basada en **Kubernetes (AKS)**, **redes virtuales** y una **aplicación microservices**.

El proyecto automatiza el despliegue de todos los componentes necesarios utilizando **Terraform** como Infrastructure as Code (IaC) y proporciona una aplicación Flask REST API containerizada con Docker.

---

## 📋 Estructura del Proyecto

```
azure-aks-platform/
│
├── 1. App/                          # Microservicio Flask
│   ├── app.py                       # Aplicación Python con REST API
│   ├── Dockerfile                   # Imagen Docker
│   ├── deployment_ms01.yaml         # Manifest Kubernetes
│   ├── requirements.txt             # Dependencias Python
│   └── README.md                    # Documentación detallada
│
├── 2. Network/                      # Infraestructura de Red (Terraform)
│   ├── main.tf                      # VNet y Subnet
│   ├── variables.tf                 # Variables
│   ├── outputs.tf                   # Salidas
│   ├── providers.tf                 # Configuración de proveedores
│   ├── terraform.tfvars             # Valores de variables
│   └── README.md                    # Documentación
│
├── 3. AKS/                          # Cluster Kubernetes (Terraform)
│   ├── aks.tf                       # Configuración de AKS
│   ├── data-network.tf              # Referencias de red
│   ├── variables.tf                 # Variables
│   ├── outputs.tf                   # Salidas
│   ├── providers.tf                 # Configuración de proveedores
│   ├── terraform.tfvars             # Valores de variables
│   └── README.md                    # Documentación
│
├── SoluciónCloud/                   # Manifests Kubernetes adicionales
│   ├── azure-pipelines.yaml         # CI/CD Pipeline
│   ├── deploy.yaml                  # Deployment adicional
│   └── ...otros manifests
│
├── Guia.sh                          # Guía de instalación y comandos útiles
├── .gitignore                       # Exclusiones de Git
└── README.md                        # Este archivo
```

---

## 🎯 Requisitos Previos

### Software Necesario
- **Terraform** 1.0 o superior
- **Azure CLI** 2.0 o superior
- **kubectl** 1.20 o superior
- **Docker** 20.10 o superior (para development)
- **Git** 2.0 o superior

### Acceso a Azure
- Suscripción activa en Azure
- Credenciales configuradas en Azure CLI
- Permisos necesarios para crear recursos (Contributor o superior)

### Recursos Existentes
- Resource Group: `rg-cloud-lab` (debe existir previamente)

---

## ⚡ Guía de Inicio Rápido

### Paso 1: Clonar el Repositorio
```bash
git clone https://github.com/terickiza/azure-aks-platform.git
cd azure-aks-platform
```

### Paso 2: Autenticarse en Azure
```bash
az login --use-device-code
az account show  # Verificar suscripción activa
```

### Paso 3: Desplegar la Red (2. Network)
```bash
cd "2. Network"
terraform init
terraform plan -out=tfplan
terraform apply tfplan
cd ..
```

### Paso 4: Desplegar AKS (3. AKS)
```bash
cd "3. AKS"
terraform init
terraform plan -out=aks.tfplan
terraform apply aks.tfplan
cd ..
```

### Paso 5: Obtener Credenciales de Kubernetes
```bash
az aks get-credentials --resource-group rg-cloud-lab --name aks-e08
kubectl cluster-info
```

### Paso 6: Desplegar Aplicación (1. App)
```bash
cd "1. App"
kubectl apply -f deployment_ms01.yaml
cd ..
```

### Paso 7: Validar Despliegue
```bash
kubectl get pods
kubectl get svc
# Obtener IP pública y probar API
```

---

## 🔗 Orden de Despliegue

**IMPORTANTE**: Respetar este orden para evitar errores de dependencias.

```
1. 2. Network     → Crear VNet y Subnet (Terraform)
2. 3. AKS         → Crear cluster Kubernetes (Terraform)
3. 1. App         → Desplegar aplicación (kubectl)
```

---

## 🗑️ Orden de Destrucción (Cleanup)

**IMPORTANTE**: Destruir en orden INVERSO para evitar errores.

```
1. 3. AKS         → Destruir cluster (terraform destroy) - PRIMERO
2. 2. Network     → Destruir red (terraform destroy) - SEGUNDO
3. 1. App         → Limpiar deployments (kubectl delete) - TERCERO
```

---

## 📚 Documentación Detallada

Para información específica y detallada, consulta los README en cada directorio:

- **[1. App/README.md](1.%20App/README.md)** - Aplicación Flask, API REST, Docker, Kubernetes
- **[2. Network/README.md](2.%20Network/README.md)** - Infraestructura de red, VNet, Subnet, Terraform
- **[3. AKS/README.md](3.%20AKS/README.md)** - Cluster AKS, nodos, configuración, Terraform

---

## 🛠️ Guía de Instalación Completa

El archivo [Guia.sh](Guia.sh) contiene todos los comandos paso a paso para:
- ✅ Instalar Docker, kubectl y Azure CLI
- ✅ Subir imágenes a Azure Container Registry (ACR)
- ✅ Conectar ACR con AKS
- ✅ Configurar secretos de Kubernetes
- ✅ Desplegar y monitorear aplicaciones
- ✅ Pruebas de API

```bash
# Ver la guía completa
cat Guia.sh
```

---

## 🔍 Infraestructura en Azure

### Red (Network)
- **VNet**: `vnet-e08` (10.58.0.0/16)
- **Subnet**: `snet-e08` (10.58.1.0/24)
- **Resource Group**: `rg-cloud-lab`
- **Región**: East US

### Kubernetes (AKS)
- **Cluster**: `aks-e08`
- **CNI**: Azure Container Networking Interface
- **RBAC**: Habilitado
- **Workload Identity**: Habilitado
- **Node Pool**: Standard_B2s (1 nodo inicial)

### Aplicación
- **Runtime**: Python 3.7+
- **Framework**: Flask 2.3.0
- **API Endpoint**: POST `/DevOps`
- **Puerto**: 5000 (interno) → 80 (externo)

---

## 🚨 Variables de Ambiente Críticas

Asegúrate de que estas variables estén configuradas antes de ejecutar Terraform:

```bash
# Azure
export AZURE_SUBSCRIPTION_ID="<tu-subscription-id>"
export AZURE_TENANT_ID="<tu-tenant-id>"

# Terraform
export TF_VAR_location="eastus"
export TF_VAR_resource_group_name="rg-cloud-lab"
```

---

## 📞 Soporte y Contacto

- **Autor**: Erick Iza
- **Email**: terickiza@gmail.com
- **Versión**: 1.0.0
- **Fecha**: Febrero 2026

---

## 📄 Licencia

Este proyecto está licenciado bajo la **Licencia MIT**. Consulta el archivo `LICENSE` para más detalles.

---

## 🌐 Enlaces Útiles

- [Documentación de Terraform](https://www.terraform.io/docs)
- [Documentación de Azure AKS](https://docs.microsoft.com/en-us/azure/aks/)
- [Documentación de Kubernetes](https://kubernetes.io/docs)
- [Documentación de Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
- [Docker Documentation](https://docs.docker.com)
- [Repositorio GitHub](https://github.com/terickiza/azure-aks-platform)

---

## ✅ Validación de Estatus

Para verificar que todo está correctamente configurado:

```bash
# Verificar autenticación
az account show

# Verificar conexión a Kubernetes
kubectl cluster-info

# Verificar recursos
kubectl get all
kubectl get nodes
kubectl get pods

# Verificar terrraform
terraform version
```

---

**Última Actualización**: Febrero 25, 2026

---

*Para más información, consulta los README específicos de cada carpeta o la [Guía de Instalación](Guia.sh).*
