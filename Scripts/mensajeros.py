import subprocess
import csv
import time
import datetime
from config import conexiones_esquemas
from concurrent.futures import ThreadPoolExecutor

# Ruta al archivo CSV con las categorías
categorias_file = "C:/Users/jvelazhe/Desktop/Moodle_Replicas/idcategorys/idcategory.csv"

# Carpeta de salida para los archivos CSV
output_folder = "C:/Users/jvelazhe/Desktop/Moodle_Replicas/Output/mensajeros/"

def get_week_dates(start_date, weeks_ahead=0):
    start_date = datetime.datetime.strptime(start_date, '%Y-%m-%d') + datetime.timedelta(weeks=weeks_ahead)
    end_date = start_date + datetime.timedelta(days=6)
    return start_date.strftime('%Y-%m-%d'), end_date.strftime('%Y-%m-%d')

def ejecutar_query(conexion_esquema, start_date, end_date):
    """
    Función para ejecutar el query en un esquema con fechas específicas.
    """
    tiempo_inicio = time.time()  # Tiempo de inicio

    query = f"""
SELECT 
    mm.conversationid,
    mu1.username as De,
    mu2.username as Para,
    from_unixtime(mm.timecreated,'%Y-%m-%d %H:%i') as 'Fecha_envio'
FROM 
    mdl_messages mm
JOIN mdl_message_conversation_members mmcm ON mmcm.conversationid = mm.conversationid 
JOIN mdl_user mu1 ON mu1.id = mm.useridfrom
JOIN mdl_user mu2 ON mu2.id = mmcm.userid
WHERE 
    mm.timecreated >= UNIX_TIMESTAMP('{start_date}') 
    AND mm.timecreated <= UNIX_TIMESTAMP('{end_date}')
    AND mm.useridfrom <> mmcm.userid
    AND mu1.username LIKE '0198%'
    """

    comando = [
        "mysql",
        "--default-character-set=utf8mb4",
        "-u" + conexion_esquema["usuario"],
        "-p" + conexion_esquema["password"],
        "-h" + conexion_esquema["host"],
        "-P" + conexion_esquema["puerto"],
        "-D" + conexion_esquema["nombre"],
        "-e",
        query,
        "--batch",
        "--raw",
    ]

    proceso = subprocess.Popen(comando, stdout=subprocess.PIPE, text=True, encoding='latin1')
    salida = proceso.stdout.readlines()

    if not salida:
        print(f"No se recibieron datos para el esquema {conexion_esquema['nombre']}")
        return f"No se recibieron datos para el esquema {conexion_esquema['nombre']}. La consulta puede haber fallado."

    encabezados = salida[0].strip().split("\t")
    datos = salida[1:]

    filename = f'{output_folder}{conexion_esquema["nombre"]}_{start_date}_to_{end_date}.csv'
    with open(filename, 'w', newline='', encoding='utf-8-sig') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(encabezados)
        writer.writerows(map(lambda x: x.strip().split("\t"), datos))
    
    tiempo_fin = time.time()  # Tiempo de fin

    # Calcular la duración y retornarla
    duracion = tiempo_fin - tiempo_inicio
    return f'La ejecución para el esquema {conexion_esquema["nombre"]} tomó {duracion:.2f} segundos.'

# Leer las categorías del archivo CSV
categorias_esquemas = {}
with open(categorias_file, newline="") as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        categorias_esquemas[row[0]] = row[1:]

# Usar ThreadPoolExecutor para ejecutar las consultas en paralelo
current_week = 0  # Comienza desde la primera semana
total_weeks = 8  # Define cuántas semanas quieres procesar
for current_week in range(total_weeks):
    start_date, end_date = get_week_dates('2024-06-17', weeks_ahead=current_week)
    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = [executor.submit(ejecutar_query, conexion_esquema, start_date, end_date) for conexion_esquema in conexiones_esquemas]
        # Iterar sobre los resultados futuros e imprimir el tiempo de ejecución
        for future in futures:
            print(future.result())

