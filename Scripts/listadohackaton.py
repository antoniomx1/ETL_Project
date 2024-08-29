import os
import pickle
import pandas as pd
import gspread
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

# Define los scopes necesarios para el acceso a Sheets y Drive
SCOPES = ['https://www.googleapis.com/auth/spreadsheets', 'https://www.googleapis.com/auth/drive']

# Path al archivo token.pickle que almacena tus tokens de acceso y refresco
token_pickle = 'token.pickle'
credentials = None

# Intenta cargar credenciales existentes
if os.path.exists(token_pickle):
    with open(token_pickle, 'rb') as token:
        credentials = pickle.load(token)

# Si las credenciales no son válidas o están expiradas, realiza el flujo de OAuth
if not credentials or not credentials.valid:
    if credentials and credentials.expired and credentials.refresh_token:
        credentials.refresh(Request())
    else:
        flow = InstalledAppFlow.from_client_secrets_file('C:/Users/jvelazhe/Desktop/Moodle_Replicas/Scripts/jvelazhe.json', SCOPES)
        credentials = flow.run_local_server(port=0)

    # Guarda las credenciales para futuros usos
    with open(token_pickle, 'wb') as token:
        pickle.dump(credentials, token)

# Autoriza a gspread con estas credenciales
gc = gspread.authorize(credentials)

# Crear el servicio de Google Drive
service = build('drive', 'v3', credentials=credentials)

# ID de la carpeta
folder_id = '13gLS0Ya_bwp2mMWUUcSBzJ9NGevjayRS'

# Función para listar los archivos en la carpeta
def list_files_in_folder(folder_id):
    query = f"'{folder_id}' in parents"
    results = service.files().list(q=query, fields="files(id, name)").execute()
    items = results.get('files', [])
    return items

# Listar los archivos y guardarlos en un DataFrame
files = list_files_in_folder(folder_id)
df = pd.DataFrame(files)

# Ruta para guardar el archivo CSV
ruta = 'G:/Mi unidad/Source/listadohackaton.csv'

# Guardar el DataFrame en un archivo CSV
df.to_csv(ruta, index=False, encoding='latin-1')

print(f"Se generó un archivo CSV en la ruta: '{ruta}' con la lista de archivos de la carpeta de Google Drive con ID: '{folder_id}'")
