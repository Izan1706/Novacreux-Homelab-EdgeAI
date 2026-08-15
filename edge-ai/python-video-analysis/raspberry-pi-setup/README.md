# Raspberry Pi 5 + HAT AI2+ — Setup

Configuración de una **Raspberry Pi 5 (8GB RAM)** con el módulo adicional
**AI HAT+ 2** (chip Hailo-10H, ~26 TOPS) usada en este proyecto como
plataforma de Edge AI: ejecución local de un modelo de visión artificial
capaz de describir imágenes/vídeo, pensado para casos de uso como detección
de riesgos laborales, humo o cualquier objeto de interés sin intervención
humana ni dependencia de la nube.

## 1. Instalación del sistema operativo

Se utiliza el software oficial **Raspberry Pi Imager** desde un PC:

1. Conecta la tarjeta microSD al PC.
2. Abre Raspberry Pi Imager y selecciona el dispositivo: **Raspberry Pi 5**.
3. Selecciona el sistema operativo (Raspberry Pi OS 64-bit recomendado).
4. Selecciona la tarjeta SD como almacenamiento destino.
5. En **Personalización / Opciones avanzadas**, configura:
   - Hostname
   - Usuario y contraseña
   - Wi-Fi (si aplica) y configuración regional
   - **Habilitar SSH** (muy recomendable para no depender de teclado/monitor)
6. Escribe la imagen en la tarjeta SD.
7. Inserta la SD en la Raspberry Pi y arranca.

## 2. Instalación de dependencias y Ollama

Actualiza el sistema:

```bash
sudo apt update && sudo apt full-upgrade -y
```

Instala los drivers del módulo AI HAT2+ (chip Hailo):

```bash
sudo apt install dkms hailo-h10-all -y
```

Verifica que el HAT responde correctamente:

```bash
hailortcli fw-control identify
```

Salida esperada (resumen):

```
Executing on device: 0001:01:00.0
Identifying board
Control Protocol Version: 2
Firmware Version: 5.1.1 (release,app)
Device Architecture: HAILO10H
```

Instala Docker en modo rootless-friendly (evita que un contenedor
comprometido escale privilegios a nivel de kernel de la Pi):

```bash
sudo apt install uidmap dbus-user-session -y
sudo usermod -aG docker $USER
newgrp docker
```

Verifica el servicio Docker:

```bash
sudo systemctl status docker.service
```

Instala Ollama (en la Raspberry Pi, al no haber GPU NVIDIA/AMD, el aviso de
"CPU-only mode" es esperado — la inferencia pesada se delega al chip Hailo,
no a Ollama en CPU):

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

## 3. Instalación de OpenClaw (opcional)

[OpenClaw](https://openclaw.ai) es un agente de IA autónomo open source,
self-hosted, capaz de ejecutar acciones reales sobre el sistema. Se probó
como parte de la exploración de agentes de IA sobre Edge AI:

```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

El instalador detecta el sistema operativo y, si no encuentra Node.js
instalado, lo instala automáticamente junto con npm antes de instalar
OpenClaw.

## 4. Open WebUI sobre la Raspberry Pi

Igual que en el PC de IA local, se puede desplegar Open WebUI como interfaz
web para interactuar con los modelos servidos en la Pi. Ver
[`/local-llm/README.md`](../../local-llm/README.md) para el comando de
despliegue vía Docker (aplica igual aquí, con la salvedad de que el backend
de inferencia visual es el chip Hailo en vez de una GPU NVIDIA).

## 5. Analizador de vídeo con IA

El caso de uso final de este montaje — un script en Python que extrae un
fotograma de un vídeo y lo envía a un modelo de visión (Qwen3-VL) servido a
través del chip Hailo — está documentado en detalle en
[`/edge-ai/python-video-analysis/README.md`](../python-video-analysis/README.md).

## Comparativa frente a otras plataformas de IA embebida/edge probadas en
este proyecto (NVIDIA Spark, NVIDIA Jetson Orin Nano), ver
[`/edge-ai/hardware-benchmarks/comparison_table.md`](../hardware-benchmarks/comparison_table.md).
