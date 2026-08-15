# Exposición de Ollama a la Red

Por defecto, Ollama solo escucha peticiones locales (`127.0.0.1`). Para que
el contenedor Docker de Open WebUI (o cualquier otro servicio de la red,
como n8n) pueda comunicarse con él, hay que permitir conexiones externas.

## 1. Editar el servicio systemd de Ollama

```bash
sudo systemctl edit ollama.service
```

Esto abre un editor sobre un fichero de override. Añade (o descomenta y
edita) la siguiente línea dentro del bloque `[Service]`:

```ini
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
```

Esto indica a Ollama que acepte conexiones desde cualquier interfaz de red,
incluyendo la interfaz virtual de Docker (necesario para que un contenedor
en modo `--network host` o similar pueda alcanzarlo).

## 2. Aplicar los cambios

```bash
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

## 3. Verificación

```bash
sudo systemctl status ollama
```

Y desde otro dispositivo de la red (o desde el propio contenedor de Open
WebUI), comprobar que responde:

```
http://[IP_SERVER]:11434
```

Debería devolver `Ollama is running`.

## Nota de seguridad

Exponer Ollama a `0.0.0.0` significa que cualquier dispositivo que alcance
esa IP y puerto podrá usar el modelo cargado. Se recomienda:

- Mantener esta exposición limitada a la red privada / VPN (Tailscale), y
  nunca hacer forwarding directo del puerto 11434 a internet.
- Si se necesita acceso externo real, hacerlo siempre a través de la VPN
  (ver `/homelab/configs/tailscale_setup.md`) y no abriendo el puerto en el
  router.
