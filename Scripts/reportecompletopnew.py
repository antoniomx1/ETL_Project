import subprocess
import csv
import time
from configp import conexiones_esquemas
from concurrent.futures import ThreadPoolExecutor

# Ruta al archivo SQL con el query
ruta_sql_file = "C:/Users/jvelazhe/Desktop/Moodle_Replicas/SQL_Querys/PosgraCompleto.sql"

# Ruta al archivo CSV con las categorías
categorias_file = "C:/Users/jvelazhe/Desktop/Moodle_Replicas/idcategorys/idcategoryPnew.csv"

# Carpeta de salida para los archivos CSV
output_folder = "C:/Users/jvelazhe/Desktop/Moodle_Replicas/Output/completoposgranew/"

def ejecutar_query(conexion_esquema, query):
    """
    Función para ejecutar el query en un esquema.
    """
    tiempo_inicio = time.time()  # Tiempo de inicio

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

    encabezados = salida[0].strip().split("\t")
    datos = salida[1:]

    with open(f'{output_folder}{conexion_esquema["nombre"]}.csv', 'w', newline='', encoding='utf-8-sig') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(encabezados)
        writer.writerows(map(lambda x: x.strip().split("\t"), datos))
    
    tiempo_fin = time.time()  # Tiempo de fin

    # Calcular la duración y retornarla
    duracion = tiempo_fin - tiempo_inicio
    return f'La ejecución para el esquema {conexion_esquema["nombre"]} tomó {duracion:.2f} segundos.'

def ejecutar_query_concurrente(conexion_esquema, query):
    """
    Función para preparar y ejecutar el query en un esquema de manera concurrente.
    """
    esquema = conexion_esquema["nombre"]
    categorias = ','.join(categorias_esquemas.get(esquema, []))
    query_con_categoria = query + ' (' + categorias + ')'       if categorias else query
    return ejecutar_query(conexion_esquema, query_con_categoria)

# Leer el contenido del archivo SQL
with open(ruta_sql_file, 'r', encoding='latin1') as archivo_sql:
    query = archivo_sql.read().strip()


# Leer las categorías del archivo CSV
categorias_esquemas = {}
with open(categorias_file, newline="") as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        categorias_esquemas[row[0]] = row[1:]

# Usar ThreadPoolExecutor para ejecutar las consultas en paralelo
with ThreadPoolExecutor(max_workers=10) as executor:
    futures = [executor.submit(ejecutar_query_concurrente, conexion_esquema, query) for conexion_esquema in conexiones_esquemas]

# Iterar sobre los resultados futuros e imprimir el tiempo de ejecución
for future in futures:
    print(future.result())
