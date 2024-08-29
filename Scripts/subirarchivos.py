import shutil
import datetime

# Definir la función para copiar y renombrar archivos
def upload_and_rename(file_name, source_folder, destination_folder, prefix, extension="csv"):
    # Obtener la fecha actual en el formato deseado
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    
    # Construir el nuevo nombre del archivo con la fecha
    new_file_name = f"{prefix}_{today}.{extension}"
    
    # Construir la ruta completa del archivo fuente y destino
    source_path = f"{source_folder}/{file_name}.{extension}"
    destination_path = f"{destination_folder}/{new_file_name}"
    
    # Copiar y renombrar el archivo
    shutil.copy2(source_path, destination_path)
    print(f"Archivo {file_name} copiado y renombrado a {destination_path}")

# Definir las ubicaciones de origen y destino
source_folder = "C:/Users/jvelazhe/Desktop/Sabana_NR_Retencion/Output"

# Copiar y renombrar archivos específicos a sus destinos
upload_and_rename("Sabana", source_folder, "G:/Mi unidad/Niveles", "Sabana")
upload_and_rename("Latam", source_folder, "G:/Mi unidad/Niveles LATAM", "Sabana_LATAM")
upload_and_rename("Semi", source_folder, "G:/Mi unidad/Niveles Ejecutivas", "Sabana_Ejecutivas")
upload_and_rename("Sabana", source_folder, "G:/Mi unidad/fuentesfronts", "Sabana")
upload_and_rename("Sabana", source_folder, "G:/Mi unidad/source", "Sabana")

