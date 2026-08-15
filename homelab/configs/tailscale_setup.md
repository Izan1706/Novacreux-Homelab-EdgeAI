# VPN — Tailscale

La VPN es un punto clave para poder usar los servicios del homelab de forma
remota y segura, sin necesidad de exponer puertos directamente a internet.

Se ha optado por **Tailscale** en lugar de montar Wireguard "a pelo": permite
conectarse desde prácticamente cualquier dispositivo (Ubuntu Server, Windows,
Android...) con una configuración mínima — instalar el cliente y autenticarse
con una cuenta — en vez de gestionar manualmente claves y peers.

> Mejora futura contemplada en el proyecto original: migrar a Wireguard puro
> para asegurar que la VPN corre 100% en local, sin depender de la
> infraestructura de coordinación de un proveedor externo.

## Instalación del cliente

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

Esto instala el cliente y abre el flujo de autenticación (login con cuenta
de correo) para adherir el dispositivo a tu tailnet privada.

## Funcionalidades usadas en este proyecto

- **Dashboard de administración** — lista todos los dispositivos (`Machines`)
  conectados a la tailnet, su versión de Tailscale, IP asignada y última
  conexión. Permite conectarse a cualquiera de ellos por SSH usando esa IP.
- **Access Controls (ACLs)** — control de acceso granular por usuario y
  dispositivo: quién puede llegar a qué destino y por qué puerto/protocolo.
  Mucho más seguro que dejar la red abierta por defecto entre todos los
  nodos.
- **Logs** — registro de cambios de configuración de la tailnet, útil para
  auditorías.
- **MagicDNS** — registra automáticamente nombres de dominio para cada
  dispositivo de la tailnet, permitiendo usar el nombre de la máquina en vez
  de su IP interna.
- **Funnels** — permite exponer un servicio local hacia la red a través de un
  puerto concreto, incluso a personas que no usan Tailscale (equivalente a
  montar una NAT con una ACL, pero gestionado desde el panel de Tailscale).

## Notas de seguridad

- Las IPs asignadas por Tailscale a cada máquina forman parte de la red
  privada del tailnet y no deberían compartirse públicamente.
- Se recomienda configurar Access Controls desde el primer momento en lugar
  de dejar la política "All users and devices → All ports and protocols" por
  defecto, especialmente si se van a añadir más usuarios a la tailnet.

Más información: https://tailscale.com/kb/
