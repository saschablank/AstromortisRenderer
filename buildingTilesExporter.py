import cv2
import numpy as np
from pathlib import Path


def html_to_bgr(html_color):
    """Konvertiert eine HTML-Farbe (#RRGGBB) in das OpenCV-BGR-Format."""
    html_color = html_color.lstrip("#")  # Entfernt das '#'
    rgb = tuple(int(html_color[i:i+2], 16) for i in (0, 2, 4))  # In (R, G, B) umwandeln
    return np.array(rgb[::-1])  # In (B, G, R) umwandeln

def get_files():
    verzeichnis = Path("output\\buildings\\")
    dateien = [f.name for f in verzeichnis.iterdir() if f.is_file()]

    print(dateien)
    return dateien



files = get_files()
for file in files:
    if file.find(".png.import") == -1:
        # Bild laden (mit Alpha-Kanal)
        image = cv2.imread("output\\buildings\\" + file, cv2.IMREAD_UNCHANGED)


        # Prüfen, ob Bild einen Alpha-Kanal hat
        has_alpha = image.shape[2] == 4


        # Maske erstellen: Behalte Pixel, die NICHT die exclude_color haben und nicht transparent sind
        if has_alpha:
            alpha_channel = image[:, :, 3]
            alpha_mask = alpha_channel > 0  # Nicht transparent
            mask = alpha_mask


        # Indizes der relevanten Pixel finden
        coords = np.column_stack(np.where(mask))

        if coords.size == 0:
            print("Kein passender Bereich gefunden!")
        else:
            # Begrenzungsrechteck berechnen (min/max Koordinaten)
            y_min, x_min = coords.min(axis=0)
            y_max, x_max = coords.max(axis=0)

            # Bild zuschneiden
            cropped = image[y_min:y_max+1, x_min:x_max+1]

            # Ergebnis speichern
                    
                # Ergebnis speichern
        cv2.imwrite("output\\buildings\\final\\" + file, cropped)
        

            

