import os
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

# Ruta al archivo JSON de credenciales
credenciales_json = 'credenciales.json'

# Autenticación con las credenciales
creds = None
if os.path.exists(credenciales_json):
    creds = service_account.Credentials.from_service_account_file(
        credenciales_json,
        scopes=['https://www.googleapis.com/auth/drive']
    )

# Crear cliente de Google Drive
drive_service = build('drive', 'v3', credentials=creds)

def subir_archivo_a_drive(nombre_archivo, ruta_archivo, carpeta_id):
    """
    Sube un archivo a Google Drive en una carpeta específica.

    Parámetros:
    - nombre_archivo: Nombre con el que se guardará el archivo en Drive.
    - ruta_archivo: Ruta local al archivo que se desea subir.
    - carpeta_id: ID de la carpeta de Google Drive donde se subirá el archivo.
    """
    file_metadata = {
        'name': nombre_archivo,
        'parents': [carpeta_id]
    }
    media = MediaFileUpload(ruta_archivo)
    file = drive_service.files().create(body=file_metadata,
                                        media_body=media,
                                        fields='id').execute()
    print(f"Archivo {nombre_archivo} subido con éxito, ID: {file.get('id')}")

# Ejemplo de uso:
subir_archivo_a_drive('moodle_aula101.csv', 'C:/Users/jvelazhe/Desktop/Output/moodle_aula101.csv', '10dDLxi0vVnKJpKKZEjPtD3xnI-furAVp')
