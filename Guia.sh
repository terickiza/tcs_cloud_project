--
##INSTALACION DE DOCKER 
#Preparar el sistema para la instalación de Docker
sudo apt-get update   
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#Instalar Docker Engine, CLI y Containerd
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#Habilitar y arrancar el servicio de Docker
sudo systemctl enable --now docker
#Agregar el usuario actual al grupo de Docker para ejecutar comandos sin sudo
sudo usermod -aG docker $USER
# Cerrar sesión y volver a entrar o ejecutar:
newgrp docker
#Verificar la instalación de Docker ejecutando el comando hello-world
docker version
docker run --rm hello-world
--
#INSTALACION DE KUBCTL
sudo apt-get update
sudo apt-get install -y kubectl
sudo snap install kubectl --clasic
--
#iNSTALACIÓN DE AZURE CLI EN UBUNTU SERVER
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli
--
#Comandos para iniciar sesión en Azure CLI
az version
#Iniciar sesión en Azure CLI utilizando el código de dispositivo
az login --use-device-code
--
#Subir la imagen a ACR | ESTRUCTURA
az login
az acr login --name <nombre-del-registro>
docker tag <nombre-de-la-imagen>:<tag> <nombre-del-registro>.azurecr.io/<nombre-de-la-imagen>:<tag>
docker push <nombre-del-registro>.azurecr.io/<nombre-de-la-imagen>:<tag>  
#Ejemplo
az login
az acr login --name acrdevopslab01.azurecr.io
docker tag devops-api:v1 acrdevopslab01.azurecr.io/devops-api:v1
docker push acrdevopslab01.azurecr.io/devops-api:v1
az acr repository list --name acrdevopslab01 -o table  #Listar los repositorios en el registro de contenedores
docker pull acrdevopslab01.azurecr.io/devops-api:v1  #Descargar la imagen desde el registro de contenedores
#Listar ACR
az acr list -o table
--
#Cargar imagen de ACR para AKS
az aks show \                       #Validar que el clúster de AKS tiene acceso al registro de contenedores
  --resource-group rg-cloud-lab \
  --name acrdevopslab01-aks-dev \
  --query "servicePrincipalProfile"
  #Habilitar admin en el registro de contenedores
az acr update \
  --name acrdevopslab01 \
  --admin-enabled true

  #Ver usuario y clave del ACR
  az acr credential show \
  --name acrdevopslab01 \
  --query "{username:username, password:passwords[0].value}"
        #"password": "3qo42tb7D7iwbZ9UYqy6cxq8EAxJK0FTWNiDq9x7t9n6bArZunmRJQQJ99CBACYeBjFEqg7NAAACAZCRTCg4",
        #"username": "acrdevopslab01"
#Dar acceso al clúster de AKS al registro de contenedores
az aks update \
  --resource-group rg-cloud-lab \
  --name acrdevopslab01-aks-dev \
  --attach-acr acrdevopslab01
--
#Crear un secreto de Kubernetes para acceder al registro de contenedores
kubectl create secret docker-registry acr-secret \
  --docker-server=acrdevopslab01.azurecr.io \
  --docker-username=<username> \
  --docker-password=<password>
    #Ejemplo    
kubectl create secret docker-registry acr-secret \
  --docker-server=acrdevopslab01.azurecr.io \
  --docker-username=acrdevopslab01 \
  --docker-password=3qo42tb7D7iwbZ9UYqy6cxq8EAxJK0FTWNiDq9x7t9n6bArZunmRJQQJ99CBACYeBjFEqg7NAAACAZCRTCg4    
 #Descargar credenciales del AKS
az aks get-credentials \
  --resource-group rg-cloud-lab \
  --name acrdevopslab01-aks-dev
#Verificar que el clúster de AKS tiene acceso al registro de contenedores
kubectl get secret acr-secret 
--
#Exponer el depliegue como un servicio de tipo LoadBalancer para acceder a la aplicación desde el exterior del clúster
kubectl expose deployment devops-api \
  --type=LoadBalancer \
  --port 80 \
  --target-port 5000
--
kubectl get nodes #Listar los nodos en el clúster de Kubernetes

##PODS
kubectl get pods #Listar los pods en el clúster de Kubernetes
kubectl get svc #Listar los servicios en el clúster de Kubernetes
kubectl get deployments #Listar los despliegues en el clúster de Kubernetes
kubectl describe pod <nombre-del-pod> #Obtener detalles de un pod específico
kubectl logs <nombre-del-pod> #Ver los logs de un pod específico
kubectl exec -it <nombre-del-pod> -- /bin/bash #Acceder a un pod específico y ejecutar comandos dentro de él

#TEST
curl -X POST http://20.115.252.13/DevOps \
  -H "Content-Type: application/json" \
  -d '{
        "message": "Hola",
        "to": "Erick",
        "from": "Azure AKS Microservice Platform",
        "timeToLifeSec": 45
      }'
