import os
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

# Ruta al archivo JSON de credenciales
credenciales_json = 'C:/Users/jvelazhe/Desktop/Moodle_Replicas/Scripts/credenciales.json'

# Autenticación con las credenciales
creds = None
if os.path.exists(credenciales_json):
    creds = service_account.Credentials.from_service_account_file(
        credenciales_json,
        scopes=['https://www.googleapis.com/auth/drive']
    )

# Crear cliente de Google Drive
drive_service = build('drive', 'v3', credentials=creds)

def subir_o_actualizar_archivo(nombre_archivo, ruta_archivo, carpeta_id):
    """
    Sube un archivo a Google Drive en una carpeta específica o actualiza el existente.

    Parámetros:
    - nombre_archivo: Nombre con el que se guardará el archivo en Drive.
    - ruta_archivo: Ruta local al archivo que se desea subir.
    - carpeta_id: ID de la carpeta de Google Drive donde se subirá o actualizará el archivo.
    """
    # Búsqueda del archivo en la carpeta especificada
    query = f"name = '{nombre_archivo}' and '{carpeta_id}' in parents and trashed = false"
    response = drive_service.files().list(q=query, spaces='drive', fields='files(id, name)').execute()
    files = response.get('files', [])

    media = MediaFileUpload(ruta_archivo)
    if files:
        # Si el archivo existe, se actualiza
        file_id = files[0].get('id')
        updated_file = drive_service.files().update(fileId=file_id, media_body=media).execute()
        print(f"Archivo existente {nombre_archivo} actualizado, ID: {updated_file.get('id')}")
    else:
        # Si no existe, se crea uno nuevo
        file_metadata = {'name': nombre_archivo, 'parents': [carpeta_id]}
        file = drive_service.files().create(body=file_metadata, media_body=media, fields='id').execute()
        print(f"Archivo {nombre_archivo} subido con éxito, ID: {file.get('id')}")

# Ejemplo de uso:
subir_o_actualizar_archivo('mensajerosrvr.csv', 'C:/Users/jvelazhe/Desktop/Moodle_Replicas/Load/mensajerosrvr.csv', '1f34V5wP275qC6pcM8PrpnWWOkKBx65cz')
