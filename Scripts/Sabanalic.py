import pandas as pd
import numpy as np
from oauth2client.service_account import ServiceAccountCredentials
import gspread
from openpyxl import load_workbook
import datetime

# Autenticación de Google Sheets
scope = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
credentials = ServiceAccountCredentials.from_json_keyfile_name('credentials.json', scope)
gc = gspread.authorize(credentials)

# Cargar los datos desde un archivo CSV
reporte_df = pd.read_csv("reporte_completo_Licserver.csv", 
                         usecols=lambda column: column not in ["institucion", "id", "fecha_inicio", "fecha_fin", "rol"],
                         encoding='latin1')

# Filtrar registros
reporte_df = reporte_df[~reporte_df['clave'].str.contains('0412|23_AA_I_PD|0209')]

# Crear y modificar columnas
reporte_df['grupo'] = reporte_df['grupo'].str.split(' ').str[0]
reporte_df['grupos'] = reporte_df['grupo'].str.extract(r'^(.*?)_(.*?)_.*$')[0] + "_" + reporte_df['grupo'].str.extract(r'^(.*?)_(.*?)_.*$')[1]

# Contar y marcar para eliminar
reporte_df['conteo'] = reporte_df.groupby(['matricula', 'clave', 'grupos']).cumcount() + 1
reporte_df['comprueba'] = np.where((reporte_df['conteo'] >= 2) & (reporte_df['modalidad'] == 'Ejecutiva'), 'Quitar', 'Dejar')
reporte_df = reporte_df[reporte_df['conteo'] == 1]
reporte_df = reporte_df[reporte_df['comprueba'] != 'Quitar']
reporte_df.drop(columns=['comprueba'], inplace=True)

# Cargar datos de exclusión
excluir_df = pd.read_csv("excluir_reporte_completo.csv", encoding='latin1')
reporte_df = reporte_df[~reporte_df['matricula'].isin(excluir_df['matricula'])]

# Cargar y seleccionar columnas de facultades
facultades_df = pd.read_csv("Facultades_utel.csv", usecols=[0, 3, 4])
facultades_df.columns = ['code', 'Clave programa']
reporte_df = pd.merge(reporte_df, facultades_df, on='code', how='left')

# Cargar datos de tablita_links
tablita_links_df = pd.read_csv("tablitalinks.csv", encoding='latin1')

# Cargar y manipular links
links_df = pd.read_csv("tablitalinks.csv", encoding='latin1')
links_df['clave_materia'] = links_df['clave'].str.extract(r'.*_(.*)$')
links_df[['inicio_plus', 'clave_materia']] = links_df['clave'].str.split('_', expand=True)[[2, 3]]
links_df['inicio_plus'] = pd.to_numeric(links_df['inicio_plus'])
links_df['clavem'] = links_df['clave_materia'] + "_" + links_df['asignatura'] + "_" + links_df['inicio_plus'].astype(str)
links_df = links_df.drop_duplicates(subset=['clavem'])
links_df = pd.merge(links_df, tablita_links_df, on='aula', how='left')
links_df['links'] = links_df['aulalink'] + links_df['materia_id']

# Unir links al reporte principal
reporte_df = pd.merge(reporte_df, links_df[['clave_materia', 'links']], on='clave_materia', how='left')

# Cargar y preparar datos académicos
opacad_df = pd.read_csv("opacademicap.csv", encoding='latin1')
opacad_df = opacad_df.drop(columns=['Tipo.de.grupo', 'Bimestre.materia'])
opacad_df['Matricula.de.profesor'] = pd.to_numeric(opacad_df['Matricula.de.profesor'])
opacad = pd.concat([opacad_df[opacad_df['Clave'].notna()]])

# Combinar y seleccionar columnas específicas
academico_df = opacad.copy()
academico_df['clave_g'] = academico_df['Clave'] + "_" + academico_df['Grupo']
academico_df['Profesor'] = academico_df['Nombre.titular'] + " " + academico_df['Apellidos.titular']
columns = ['clave_g', 'Matricula.GCA', 'Nombre.completo.de.GCA', 'Correo.electronico.GCA', 'Matricula.RE', 'Nombre.completo.de.RE', 'Correo.electronico.RE', 'clave_materia', 'Nombre.de.materia', 'Grupo', 'Matricula.de.profesor', 'Profesor', 'Correo']
academico_df = academico_df[columns]
academico_df.columns = ['clave_g', 'Matricula GCA', 'Nombre completo de GCA', 'Correo electronico GCA', 'Matricula RE', 'Nombre completo de RE', 'Correo electronico RE', 'clave_materia', 'Nombre de materia', 'Grupo', 'Matricula de profesor', 'Profesor', 'Correo']

# Final merge
final_df = pd.merge(reporte_df, academico_df, on='clave_g', how='left')

# Exportar a CSV
final_df.to_csv("final_output.csv", index=False)
