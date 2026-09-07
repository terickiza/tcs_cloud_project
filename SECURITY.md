# Política de seguridad

## Reporte de vulnerabilidades

Si encuentras un problema de seguridad en este repositorio, **no abras un issue público**.
Escribe a: terickiza@gmail.com con el detalle y, si es posible, pasos de reproducción.
Se responderá en un plazo razonable y se acordará la divulgación.

## Alcance

Repositorio de portafolio con fines demostrativos. La infraestructura descrita
puede no estar desplegada.

## Manejo de secretos

- **Nunca** se versionan `*.tfstate`, `*.tfplan`, `.env`, `*.pem`, `*.key`, kubeconfig
  ni `backend.hcl` (ver `.gitignore`).
- Los valores sensibles (API keys, secretos de APIM, subscription IDs) se inyectan
  en tiempo de ejecución vía variables de entorno `TF_VAR_*` desde un *variable group*
  o Azure Key Vault, no como `default` en archivos `.tf`.
- El estado de Terraform vive en Azure Storage remoto con autenticación Azure AD.

## Historial

Versiones anteriores de este repo incluyeron por error un `terraform.tfstate` con
un `kube_config` de administrador de AKS y otros identificadores de Azure. Esas
credenciales **deben considerarse comprometidas**: se recomienda rotar los
certificados del clúster (`az aks rotate-certs`) y purgar los blobs del historial
de git (`git filter-repo`) antes de tratar el repo como limpio.
