import cv2
import ollama
import os

# Forzamos a que el cliente de Python mire al puerto de Hailo
os.environ["OLLAMA_HOST"] = "http://localhost:8000"

MODELO = "qwen3-vl:latest"
VIDEO_PATH = "traffic.mp4"

def procesar_video():
    cap = cv2.VideoCapture(VIDEO_PATH)
    if not cap.isOpened():
        print(f"Error: No se encuentra el archivo {VIDEO_PATH}")
        return

    fps = cap.get(cv2.CAP_PROP_FPS)

    # Sacamos un frame del segundo 1
    cap.set(cv2.CAP_PROP_POS_MSEC, 1000)
    ret, frame = cap.read()
    cap.release()

    if ret:
        # Redimensionamos para que el chip vuele (40 TOPS!)
        frame = cv2.resize(frame, (640, 480))
        cv2.imwrite("frame_ia.jpg", frame)

        print(f"Consultando a Qwen3-VL sobre {VIDEO_PATH}...")

        try:
            res = ollama.chat(
                model=MODELO,
                messages=[{
                    'role': 'user',
                    'content': 'Que ves en este video? Describe los objetos y la accion principal.',
                    'images': ['frame_ia.jpg']
                }]
            )
            print("\nNARRACION DE LA IA:")
            print(res['message']['content'])
        except Exception as e:
            print(f"Error en la comunicacion con el chip: {e}")

if __name__ == "__main__":
    procesar_video()
