# Comparación entre Hardwares de IA

Comparativa de las cuatro plataformas de IA probadas a lo largo del
proyecto Novacreux: una GPU de consumo (PC local), un módulo de Edge AI
sobre Raspberry Pi, y dos plataformas NVIDIA de gama alta orientadas a
Edge AI / entrenamiento.

## Tabla de comparación

| | NVIDIA 4060 Ti 16GB | Raspberry Pi + HAT AI2+ | NVIDIA Spark |
|---|---|---|---|
| **Arquitectura** | Ada Lovelace | ARM Cortex-A76 + NPU Hailo-8 | Blackwell |
| **VRAM / Memoria** | 16GB GDDR6 | 8GB LPDDR4 (RAM) + 26 TOPS NPU | 48–96GB, hasta 128GB |
| **TDP** | 165W | 5W – 12W | 100W – 240W |
| **Uso típico** | IA local, modelos de hasta 24B en VRAM, gaming | Edge AI, visión artificial, IoT, inferencia ligera | Entrenamiento, inferencia, modelos de 70B–400B |
| **Ventaja** | Coste "bajo", accesible, baja latencia | Ultra bajo consumo, ideal para IA embebida, muy portátil | Escalabilidad, paralelización, gran memoria |
| **Limitaciones** | VRAM limitada, no apta para modelos grandes | No apto para modelos grandes, potencia limitada | Coste, consumo, complejidad |

### NVIDIA Jetson Orin Nano (referencia adicional)

Representa el nivel de Edge AI y robótica: arquitectura Ampere, pensada para
ejecutar IA directamente sobre otros dispositivos (drones, cámaras, robots,
IoT). Rendimiento de 40 TOPS con un consumo muy ajustado (7–15W).

- **Ventaja:** procesamiento en tiempo real en el borde (sin depender de la
  nube) y compatibilidad con el ecosistema JetPack.
- **Limitación:** potencia bruta menor que una GPU de escritorio y memoria
  compartida limitada (8GB) — soporta modelos de 1 a 7B de parámetros.

## Consumos de energía y coste anual aproximado

Muchos de estos servicios están encendidos 24/7, por lo que el consumo
energético (y su coste) es tan importante de medir como el rendimiento en
tokens/segundo antes de decidir qué hardware poner en producción. Cálculos
aproximados con precios medios:

| Hardware | Consumo medio (W) | Coste aprox. / año (€) | Tokens por segundo (según modelo) |
|---|---|---|---|
| Homelab Server (Ubuntu, servicios base) | ~6W | 12€ | — |
| PC IA en local (4060 Ti 16GB) | ~150W | 130€ | 12–18 tokens/s (modelo 24B) |
| Raspberry Pi 5 + AI HAT | ~12W | 10€ | 3–5 tokens/s (modelo 3B) |
| NVIDIA Jetson Orin Nano | ~15W | 13€ | 10–15 tokens/s |
| NVIDIA Spark | ~10W | 12€ | 15–22 tokens/s |

> **Nota:** el consumo del PC de IA local varía drásticamente según si la
> GPU está en reposo o procesando un modelo a plena carga; la cifra de
> ~150W corresponde a carga activa, no a consumo idle.

## Conclusión práctica

- Para **prototipar y estudiar IA local con buen rendimiento y coste
  contenido** → GPU de consumo tipo RTX 4060 Ti.
- Para **IA embebida, portátil y de bajísimo consumo** (visión en campo,
  IoT) → Raspberry Pi + HAT AI2+.
- Para **entrenamiento o inferencia de modelos grandes (70B+)** en un
  entorno profesional/académico → NVIDIA Spark.
- Para **robótica y Edge AI en tiempo real** con buena eficiencia
  energética → NVIDIA Jetson Orin Nano.
