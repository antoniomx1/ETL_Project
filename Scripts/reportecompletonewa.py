import subprocess
import csv
import time
from confignew import conexiones_esquemas
from concurrent.futures import ThreadPoolExecutor
from drive_upload import subir_o_actualizar_archivo

# Ruta al archivo SQL con el query
ruta_sql_file = "C:/Users/jvelazhe/Desktop/Moodle_Replicas/SQL_Querys/completolic1.sql"
ruta_sql_file2 = "C:/Users/jvelazhe/Desktop/Moodle_Replicas/SQL_Querys/completolic2.sql"
# Ruta al archivo CSV con las categorías
categorias_file = "C:/Users/jvelazhe/Desktop/Moodle_Replicas/idcategorys/idcategoryante.csv"

# Ruta al archivo de salida consolidado
output_file = "C:/Users/jvelazhe/Desktop/Moodle_Replicas/Load/reportecompletosep-oct24.csv"

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

    if not salida:
        print(f"No se encontraron resultados para el esquema {conexion_esquema['nombre']}.")
        return []

    encabezados = salida[0].strip().split("\t")
    datos = salida[1:]
    registros = [dict(zip(encabezados, fila.strip().split("\t"))) for fila in datos]

    tiempo_fin = time.time()  # Tiempo de fin
    duracion = tiempo_fin - tiempo_inicio
    print(f'La ejecución para el esquema {conexion_esquema["nombre"]} tomó {duracion:.2f} segundos.')

    # Agregar una columna con el nombre del esquema, pero llamándola 'aula'
    for registro in registros:
        registro["aula"] = conexion_esquema["nombre"]

    return registros

def ejecutar_query_concurrente(conexion_esquema, query):
    """
    Función para preparar y ejecutar el query en un esquema de manera concurrente.
    """
    esquema = conexion_esquema["nombre"]
    categorias = ','.join(categorias_esquemas.get(esquema, []))
    query_con_categoria = query + ' (' + categorias + ')' + query2 + ' (' + categorias + ')' if categorias else query
    try:
        return ejecutar_query(conexion_esquema, query_con_categoria)
    except IndexError as e:
        print(f"Error al procesar el esquema {esquema}: {e}")
        return []

# Leer el contenido del archivo SQL
with open(ruta_sql_file, 'r', encoding='latin1') as archivo_sql:
    query = archivo_sql.read().strip()
    
with open(ruta_sql_file2, 'r', encoding='latin1') as archivo_sql2:
    query2 = archivo_sql2.read().strip()    

# Leer las categorías del archivo CSV
categorias_esquemas = {}
with open(categorias_file, newline="") as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        categorias_esquemas[row[0]] = row[1:]

# Usar ThreadPoolExecutor para ejecutar las consultas en paralelo
resultados = []
with ThreadPoolExecutor(max_workers=10) as executor:
    futures = [executor.submit(ejecutar_query_concurrente, conexion_esquema, query) for conexion_esquema in conexiones_esquemas]

    # Consolidar los resultados de todas las consultas
    for future in futures:
        resultados.extend(future.result())

# Escribir el archivo CSV consolidado
if resultados:
    encabezados = list(resultados[0].keys())
    with open(output_file, 'w', newline='', encoding='utf-8-sig') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=encabezados)
        writer.writeheader()
        writer.writerows(resultados)

print(f'Todos los resultados se han consolidado en {output_file}')
subir_o_actualizar_archivo(
    nombre_archivo='reportecompletosep-oct24.csv',
    ruta_archivo= output_file,
    carpeta_id='1f34V5wP275qC6pcM8PrpnWWOkKBx65cz'
)