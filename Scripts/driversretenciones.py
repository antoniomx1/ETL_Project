import gspread
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import os
import pickle
import pandas as pd

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

def download_sheet_and_save_as_csv(sheet_key, worksheet_title, csv_path):
    sheet = gc.open_by_key(sheet_key)
    worksheet = sheet.worksheet(worksheet_title)
    data = worksheet.get_all_values()
    
    df = pd.DataFrame(data[1:], columns=data[0])
    df = df.apply(lambda col: col.map(lambda text: text.encode('latin-1', 'replace').decode('latin-1') if isinstance(text, str) else text))
    
    df.to_csv(csv_path, index=False, encoding='latin-1')
    print(f"Se generó un archivo CSV en la ruta: '{csv_path}' de la hoja de Google Sheet: '{worksheet_title}'.")

# Lista de hojas y rutas para descargar
sheets_to_download = [
    ('1lWPjZkB904wbLbeLTk2QBeozoOnPfQEpTbDs0_yLOBg', 'RetencionesBajas', 'G:/Mi unidad/Source/drivederetenciones.csv'),
    ('1lWPjZkB904wbLbeLTk2QBeozoOnPfQEpTbDs0_yLOBg', 'Correspondencias Coach', 'G:/Mi unidad/Source/coach.csv'),
    ('1lWPjZkB904wbLbeLTk2QBeozoOnPfQEpTbDs0_yLOBg', 'Correspondencia EE', 'G:/Mi unidad/Source/ee.csv'),
    ('1lWPjZkB904wbLbeLTk2QBeozoOnPfQEpTbDs0_yLOBg', 'Make', 'G:/Mi unidad/Source/retencionesopm.csv')
]

# Ejecuta la función para cada hoja
for sheet_key, worksheet_title, csv_path in sheets_to_download:
    download_sheet_and_save_as_csv(sheet_key, worksheet_title, csv_path)
