import pandas as pd
import gspread
from google.oauth2.service_account import Credentials

# Definir los scopes necesarios
scopes = [
    'https://www.googleapis.com/auth/spreadsheets',
    'https://www.googleapis.com/auth/drive'
]



# Conectar con Google Sheets usando las credenciales y los scopes
credentials = Credentials.from_service_account_file(
    'C:/Users/jvelazhe/Desktop/Moodle_Replicas/Scripts/credenciales.json',  # Usa el archivo JSON que has proporcionado
    scopes=scopes
)
gc = gspread.authorize(credentials)

# Abre la hoja de Google Sheets y selecciona la hoja adecuada
sheet = gc.open_by_key('1IIyjVyPLe2ndndZY_gcJUuUfA83_K_v30eY4ncEY41I')
worksheet = sheet.get_worksheet(0)  # Cambia el índice si no es la primera hoja
##Con este nos traemos el nombre de la sheet ##
sheet_title = sheet.title


# Lee los datos de la hoja en un DataFrame de pandas
data = worksheet.get_all_values()
df = pd.DataFrame(data[1:], columns=data[0])

# Elimina las columnas no deseadas

# Convierte la columna 'Matricula de profesor' a numérica
df['Matricula de profesor'] = pd.to_numeric(df['Matricula de profesor'], errors='coerce')

# Filtra las filas donde 'Clave' no es nulo
driveoperativo = df[df['Clave'].notna()]
opacad = df[df['Clave'].notna()]

# Guarda los DataFrames en archivos CSV con codificación UTF-8
# driveoperativo.to_csv('G://Mi unidad/Docentes/DriveOperativo.csv', index=False, encoding='latin-1')
opacad.to_csv('C:/Users/jvelazhe/Desktop/Sabana_NR_Retencion/opacademica.csv', index=False, encoding='latin-1')
opacad.to_csv('G:/Mi unidad/Source/opacademica.csv', index=False, encoding='latin-1')

print(f"Drive '{sheet_title}' actualizado con éxito!")


