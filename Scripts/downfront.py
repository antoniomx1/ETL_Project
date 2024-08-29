import os
import io
import time

from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload

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

def descargar_carpeta_de_drive(carpeta_id, ruta_destino):
    """
    Descarga todos los archivos de una carpeta de Google Drive a una ruta local.
    
    Parámetros:
    - carpeta_id: ID de la carpeta de Google Drive de donde descargar los archivos.
    - ruta_destino: Ruta local donde se guardarán los archivos.
    """
    start_time = time.time()

    query = f"'{carpeta_id}' in parents"
    response = drive_service.files().list(q=query,
                                          spaces='drive',
                                          fields='files(id, name)').execute()
    for file in response.get('files', []):
        file_id = file.get('id')
        file_name = file.get('name')
        file_path = os.path.join(ruta_destino, file_name)
        request = drive_service.files().get_media(fileId=file_id)
        fh = io.BytesIO()
        downloader = MediaIoBaseDownload(fh, request)

        done = False
        while not done:
            status, done = downloader.next_chunk()
            print(f"Descargando {file_name} {int(status.progress() * 100)}%.")

        # Escribir el contenido al archivo local
        with open(file_path, 'wb') as f:
            fh.seek(0)
            f.write(fh.read())
        print(f'Archivo {file_name} descargado con éxito en {file_path}')
        
    end_time = time.time()
    print(f'Todos los archivos han sido descargados. Duración total: {end_time - start_time:.2f} segundos')

# Ejemplo de uso:
descargar_carpeta_de_drive('1IsQzoYeGi_Ykj5Nnov9tBAGGwupYpTVf', 'C:/Users/jvelazhe/Desktop/FRONTS/')
