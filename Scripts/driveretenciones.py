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

# Ahora puedes acceder a tus hojas de cálculo como de costumbre
sheet = gc.open_by_key('1lWPjZkB904wbLbeLTk2QBeozoOnPfQEpTbDs0_yLOBg')
worksheet = sheet.worksheet('RetencionesBajas')
data = worksheet.get_all_values()
sheet_title = sheet.title

# Crea un DataFrame de pandas con los datos obtenidos
df = pd.DataFrame(data[1:], columns=data[0])

def replace_non_encodable(text):
    if isinstance(text, str):
        return text.encode('latin-1', 'replace').decode('latin-1')
    return text



df = df.apply(lambda col: col.map(replace_non_encodable))

# Guarda los DataFrames en archivos CSV con codificación Latin-1
ruta= 'C:/Users/jvelazhe/Desktop/Sabana_NR_Retencion/drivederetenciones.csv'
ruta2= 'G:/Mi unidad/Source/drivederetenciones.csv'
df.to_csv(ruta, index=False, encoding='latin-1')

print(f"Se genero un archivo csv en la ruta: '{ruta}' de la hoja googlesheet:  '{sheet_title}' ")

