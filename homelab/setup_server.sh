#!/usr/bin/env bash
#
# setup_server.sh — Bootstrap básico para el homelab Novacreux sobre
# Ubuntu Server (sin GUI).
#
# Automatiza la parte repetitiva de la instalación: actualizar el sistema,
# instalar Docker, añadir el usuario actual al grupo docker, instalar
# Fail2ban y Tailscale, y dejar preparados los directorios de cada servicio
# para copiar en ellos su docker-compose.yml correspondiente.
#
# Uso:
#   chmod +x setup_server.sh
#   ./setup_server.sh
#
# Este script es OPCIONAL: cada paso puede ejecutarse también a mano
# siguiendo el README principal y la memoria del proyecto (docs/).

set -euo pipefail

echo "==> Actualizando el sistema..."
sudo apt update && sudo apt full-upgrade -y

echo "==> Instalando Docker..."
sudo apt install docker.io -y
sudo usermod -aG docker "$USER"

echo "==> Instalando Fail2ban..."
sudo apt install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl enable --now fail2ban

echo "==> Instalando Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh
echo "    Ejecuta 'sudo tailscale up' manualmente para autenticar este equipo."

echo "==> Creando directorios de trabajo para cada servicio..."
mkdir -p ~/pihole ~/uptime-kuma ~/netdata ~/immich-app
sudo mkdir -p /opt/n8n

echo "==> Listo."
echo ""
echo "Siguientes pasos manuales:"
echo "  1. newgrp docker   (o cierra sesión y vuelve a entrar, para aplicar el grupo docker)"
echo "  2. sudo tailscale up"
echo "  3. Copia el docker-compose.yml correspondiente de homelab/docker-compose/"
echo "     dentro de cada directorio de servicio y ajusta contraseñas/env antes de"
echo "     levantar cada contenedor con: sudo docker compose up -d"
echo "  4. Aplica homelab/configs/fail2ban_jail.local sobre /etc/fail2ban/jail.local"
echo "     y reinicia el servicio: sudo systemctl restart fail2ban"
