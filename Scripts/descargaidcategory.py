import os
import io
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload, MediaIoBaseDownload

# Ruta al archivo JSON de credenciales y autenticación
credenciales_json = 'C:/Users/jvelazhe/Desktop/Moodle_Replicas/Scripts/credenciales.json'
creds = None
if os.path.exists(credenciales_json):
    creds = service_account.Credentials.from_service_account_file(
        credenciales_json,
        scopes=['https://www.googleapis.com/auth/drive']
    )

# Crear cliente de Google Drive
drive_service = build('drive', 'v3', credentials=creds)

def descargar_archivo_de_drive(nombre_archivo, carpeta_id, ruta_destino):
    """
    Descarga un archivo desde Google Drive a una ruta local.

    Parámetros:
    - nombre_archivo: Nombre del archivo a descargar.
    - carpeta_id: ID de la carpeta de Google Drive donde se encuentra el archivo.
    - ruta_destino: Ruta local donde se guardará el archivo.
    """
    # Buscar el archivo por nombre y carpeta
    query = f"name='{nombre_archivo}' and '{carpeta_id}' in parents"
    response = drive_service.files().list(q=query,
                                          spaces='drive',
                                          fields='files(id, name)').execute()
    # Asumir que el primer archivo encontrado es el que queremos
    for file in response.get('files', []):
        # ID del archivo a descargar
        file_id = file.get('id')
        request = drive_service.files().get_media(fileId=file_id)
        fh = io.BytesIO()
        downloader = MediaIoBaseDownload(fh, request)

        done = False
        while done is False:
            status, done = downloader.next_chunk()
            print(f"Descarga {int(status.progress() * 100)}%.")

        # Escribir el contenido al archivo local
        with open(ruta_destino, 'wb') as f:
            fh.seek(0)
            f.write(fh.read())
        print(f'Archivo {nombre_archivo} descargado con éxito en {ruta_destino}')
        break
    else:  # Si el bucle for no encuentra ningún archivo y se completa normalmente
        print(f"No se encontró el archivo {nombre_archivo} en la carpeta de Drive.")

# Ejemplo de uso:
descargar_archivo_de_drive('idcategory.csv', '1f34V5wP275qC6pcM8PrpnWWOkKBx65cz', 'C:/Users/jvelazhe/Desktop/Moodle_Replicas/idcategorys/idcategory.csv')