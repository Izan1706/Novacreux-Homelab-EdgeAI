# Analizador de Vídeo con IA (Raspberry Pi + Hailo HAT AI2+)

Script de análisis de vídeo con visión artificial, pensado para ejecutarse
sobre una Raspberry Pi 5 con el módulo **HAT AI2+** (chip Hailo-10H, 40 TOPS
de rendimiento). Extrae un fotograma de un vídeo pregrabado y consulta a un
modelo de IA multimodal (visión) qué está ocurriendo en la escena.

En un entorno real, este mismo patrón puede usarse para detectar riesgos
laborales, humo, intrusiones u otros eventos sin intervención humana, y
disparar notificaciones o protocolos automáticos a partir de la descripción
generada por la IA.

## Qué hace el script

1. Configura la variable de entorno `OLLAMA_HOST` para que el cliente de
   Python de Ollama apunte al servidor local que expone el chip Hailo en el
   puerto `8000` (en vez del puerto estándar 11434 de Ollama en CPU/GPU).
2. Define el modelo (`qwen3-vl:latest`) y la ruta del vídeo a analizar
   (`traffic.mp4`).
3. Abre el vídeo con OpenCV, salta al segundo 1 y extrae ese fotograma.
4. Redimensiona el fotograma a 640×480 px (para que la inferencia en el chip
   sea rápida) y lo guarda como `frame_ia.jpg`.
5. Envía esa imagen al modelo **Qwen3-VL** (variante *VL* = *Vision
   Language*, especializada en análisis de imágenes) junto con una
   instrucción para que describa los objetos y la acción principal.
6. Imprime en pantalla la narración devuelta por el modelo.
7. Si ocurre un error de comunicación con el chip, lo captura e informa por
   consola.

## Requisitos previos

- Raspberry Pi 5 con módulo **AI HAT+ 2 / HAT AI2+** (chip Hailo-10H) ya
  configurado — ver [`/edge-ai/raspberry-pi-setup/README.md`](../raspberry-pi-setup/README.md).
- Drivers Hailo instalados: `sudo apt install hailo-h10-all -y`
- Servidor `hailo-ollama` en ejecución sobre el puerto 8000, sirviendo el
  modelo `Qwen3-VL-2B-Instruct.hef`:

  ```bash
  hailo-ollama run Qwen3-VL-2B-Instruct.hef
  ```

  Verificación: `http://[IP_RASPBERRY]:8000` debería devolver
  `hailo-ollama is running`.

## Instalación

Se recomienda trabajar dentro de un entorno virtual dedicado:

```bash
mkdir narrador_ia && cd narrador_ia
python3 -m venv venv
source venv/bin/activate

pip install --default-timeout=1000 --retries 10 opencv-python ollama hailo-python-api
```

Copia `analyze_video.py` y tu vídeo de prueba (p.ej. `traffic.mp4`) dentro
de ese mismo directorio.

## Ejecución

```bash
python3 analyze_video.py
```

Salida esperada:

```
Consultando a Qwen3-VL sobre traffic.mp4...

NARRACION DE LA IA:
<descripción generada por el modelo sobre la escena del vídeo>
```

## Notas

- El vídeo de entrada (`traffic.mp4`) no se incluye en este repositorio;
  sustitúyelo por tu propio fichero de prueba y ajusta `VIDEO_PATH` en el
  script si usas otro nombre.
- Este script analiza un único fotograma fijo (segundo 1) como
  prueba de concepto. Para un caso de uso en producción (vigilancia
  continua, por ejemplo) se recomienda adaptar el bucle de captura para
  muestrear fotogramas periódicamente en lugar de un único instante.
- Se evaluó también usar **Gradio** para exponer una interfaz web
  interactiva sobre este análisis, pero finalmente se descartó en la
  versión final del proyecto en favor de la salida por consola.
