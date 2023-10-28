import json
import csv

# Leer el archivo "plataformas.csv" y crear un diccionario que mapee IDs de plataforma a nombres
plataformas_dict = {}
with open("./data/plataformas.csv", "r") as plataformas_file:
    reader = csv.reader(plataformas_file)
    next(reader)  # Saltar la primera línea con encabezados
    for row in reader:
        plataforma_id = int(row[1])
        plataforma_nombre = row[0]
        plataformas_dict[plataforma_id] = plataforma_nombre

# Leer el archivo "Videojuego_Plataforma.csv" y crear un diccionario que mapee IDs de juegos a plataformas y datos de lanzamiento
plataformas_por_juego = {}
with open("./data/Videojuego_Plataforma.csv", "r") as plataformas_juego_file:
    reader = csv.reader(plataformas_juego_file)
    next(reader)  # Saltar la primera línea con encabezados
    for row in reader:
        juego_id = int(row[0])
        plataforma_id = int(row[1])
        fecha = row[2]
        region = row[3]

        # Crear un diccionario para representar los datos de lanzamiento
        datos_lanzamiento = {"fecha": fecha, "region": region}

        # Agregar la plataforma y datos de lanzamiento al juego correspondiente
        if juego_id not in plataformas_por_juego:
            plataformas_por_juego[juego_id] = []
        if plataforma_id in plataformas_dict:
            plataformas_por_juego[juego_id].append({"nombre": plataformas_dict[plataforma_id], "datos_lanzamiento": datos_lanzamiento})
        else:
            print(f"Plataforma ID {plataforma_id} no encontrado en el diccionario.")

# Leer el JSON original
with open("./data_02/games_with_languages.json", "r") as json_file:
    juegos_json = json.load(json_file)

# Función para agregar plataformas a un juego en el formato deseado
def agregar_plataformas_a_juego(juego):
    igdb_id = juego["igdb_id"]
    plataformas_juego = plataformas_por_juego.get(igdb_id, [])
    plataformas_formateadas = []
    
    # Crear un diccionario para agrupar lanzamientos por nombre de plataforma
    plataformas_dict = {}
    
    for p in plataformas_juego:
        nombre_plataforma = p["nombre"]
        lanzamiento = {"fecha": p["datos_lanzamiento"]["fecha"], "region": p["datos_lanzamiento"]["region"]}
        
        if nombre_plataforma not in plataformas_dict:
            plataformas_dict[nombre_plataforma] = []
        
        plataformas_dict[nombre_plataforma].append(lanzamiento)
    
    # Formatear las plataformas
    for nombre, lanzamientos in plataformas_dict.items():
        plataforma_formato = {"nombre": nombre, "lanzamientos": lanzamientos}
        plataformas_formateadas.append(plataforma_formato)
    
    # Validación: No agregar "plataformas" si el array está vacío
    if plataformas_formateadas:
        juego["plataformas"] = plataformas_formateadas
    elif "plataformas" in juego:
        del juego["plataformas"]

# Agregar plataformas al formato deseado a cada juego
cont = 1
for juego in juegos_json:
    print(cont)
    cont += 1
    agregar_plataformas_a_juego(juego)

# Guardar el resultado en un nuevo archivo JSON
with open("./data_02/games_with_platforms.json", "w") as json_file:
    json.dump(juegos_json, json_file, indent=4)

print("Archivo JSON 'games_with_platforms.json' creado con éxito.")
