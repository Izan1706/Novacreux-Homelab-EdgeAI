# Monitorización en IA — Glances

Como método de monitorización en directo del PC de IA local se usa
**Glances**, un contenedor Docker no muy habitual pero que permite ver de
forma muy cómoda datos de CPU, memoria, red, disco y contenedores mientras
se están ejecutando modelos de IA — muy útil para detectar cuellos de
botella (p.ej. si un modelo se está ejecutando en CPU en vez de GPU por
falta de VRAM).

## Despliegue

```bash
docker run -d \
  --name glances \
  --restart always \
  --network host \
  --pid host \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -e GLANCES_OPT="-w" \
  nicolargo/glances
```

| Flag | Función |
|---|---|
| `--network host` / `--pid host` | Visibilidad completa sobre procesos y red del host. |
| `--privileged` | Necesario para leer ciertas métricas de hardware. |
| `-v /var/run/docker.sock:...:ro` | Permite a Glances listar y medir el resto de contenedores Docker en ejecución. |
| `-e GLANCES_OPT="-w"` | Lanza Glances en modo servidor web. |

## Acceso

Desde el navegador, añadiendo la IP del PC junto al puerto de Glances:

```
http://[IP_SERVER]:61208
```

Desde ahí se puede ver en tiempo real: uso de CPU por core, memoria (activa
/ inactiva / caché), red por interfaz, I/O de disco, sensores de
temperatura, y la lista de contenedores Docker en ejecución ordenados por
consumo de CPU — útil para comprobar, por ejemplo, si `ollama serve` está
consumiendo los recursos esperados mientras responde a un prompt.
