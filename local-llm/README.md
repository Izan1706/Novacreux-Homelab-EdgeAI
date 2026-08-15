# IA en Local (PC con GPU dedicada)

Despliegue de un stack de IA generativa 100% local sobre un PC de usuario
con GPU dedicada NVIDIA (probado con una **RTX 4060 Ti 16GB**), capaz de
generar texto, leer imágenes y PDFs, con los datos permaneciendo siempre en
un entorno cerrado y privado.

## Antes de empezar

### 1. Requisitos de hardware

Este despliegue ha sido testado y optimizado para la siguiente configuración:

| Componente | Recomendación |
|---|---|
| **GPU** | NVIDIA GeForce RTX 4060 Ti (16GB VRAM). La VRAM es el factor crítico para cargar modelos como Mistral 24B sin recurrir a la RAM del sistema, lo que ralentizaría mucho el proceso. |
| **SO** | Linux (Ubuntu/Debian recomendado), con drivers NVIDIA actualizados y soporte CUDA. |
| **Almacenamiento** | SSD con al menos 40GB libres para pesos de modelos y contenedores. |

### 2. Dependencias de software

- **Docker** — para aislar la interfaz de usuario (Open WebUI).
- **Python 3.10+** — necesario para entornos virtuales (p.ej. ComfyUI).
- **Privilegios sudo** — para gestión de servicios systemd y permisos Docker.

## 1. Instalación de Ollama

Ollama actúa como backend / "cerebro" encargado de ejecutar los modelos de
IA en local.

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Este comando descarga los binarios, crea el usuario de sistema `ollama` y
configura el servicio para que arranque junto con el sistema. Durante la
instalación deberías ver una línea confirmando que se ha detectado la GPU:
`NVIDIA GPU installed`, algo crucial para la aceleración por hardware.

**Verificación del servicio** — accede desde el navegador a la API local de
Ollama:

```
http://localhost:11434
```

Si ves el mensaje `Ollama is running`, la instalación se ha completado
correctamente.

### Descarga de modelos (LLM)

```bash
ollama pull [nombre_modelo]
```

Se recomienda buscar antes qué modelo conviene ejecutar según tu VRAM
disponible; cada modelo tiene sus propias características. Ejemplo con
Mistral Nemo (12B, eficiente):

```bash
ollama pull mistral-nemo
```

> Ojo con el nombre exacto del modelo: un nombre mal escrito o una versión
> inexistente devuelve `Error: pull model manifest: file does not exist`.

## 2. Despliegue de Open WebUI

Interfaz web (tipo ChatGPT) que se conecta automáticamente al servicio local
de Ollama, desplegada como contenedor Docker aislado.

Instalación de Docker (si no está ya instalado):

```bash
sudo apt update
sudo apt install docker.io -y
```

Añade tu usuario al grupo `docker` para no depender de `sudo` en cada
comando, y aplica el cambio de grupo:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Despliegue del contenedor:

```bash
docker run -d --network host \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

**Explicación de flags:**

| Flag | Función |
|---|---|
| `--network host` | Comparte la red con el PC (vital para que Open WebUI vea a Ollama en `localhost:11434`). |
| `--restart always` | Si el PC se reinicia, el contenedor arranca solo. |
| `-v open-webui:...` | Guarda tus chats y configuración en un volumen persistente. |

## 3. Exposición de Ollama a la red

Ver [`ollama_service_config.md`](./ollama_service_config.md) para el detalle
completo de por qué y cómo se edita el bind address de Ollama
(`OLLAMA_HOST=0.0.0.0`), necesario si quieres que otros servicios de la red
(n8n, otros dispositivos con Open WebUI, etc.) puedan consultarlo.

## 4. Monitorización de la GPU en tiempo real

Ver [`glances_monitoring.md`](./glances_monitoring.md) para desplegar
Glances vía Docker y poder ver en directo el uso de CPU/GPU/RAM mientras se
ejecutan modelos de IA.

## Funcionalidades adicionales

Una vez levantados Ollama + Open WebUI, la interfaz permite:

- Chat de texto con cualquier modelo descargado.
- Lectura y análisis de imágenes (modelos con soporte de visión, p.ej.
  familia Qwen-VL).
- Lectura y consulta de documentos PDF.
- Integración con automatizaciones externas (p.ej. vía n8n, ver
  `/homelab/docker-compose/docker-compose_n8n.yml`).

## Seguridad

Al exponer Ollama con `OLLAMA_HOST=0.0.0.0` pasa a escuchar en todas las
interfaces de red, no solo en `127.0.0.1`. Se recomienda:

- Mantener este servicio únicamente accesible dentro de la red privada /
  tailnet (ver VPN con Tailscale en `/homelab/configs/tailscale_setup.md`),
  nunca expuesto directamente a internet.
- Aplicar permisos y usuarios de sistema dedicados en vez de ejecutar todo
  como root.
