import json

# Crear un diccionario con la información de idiomas
idiomas_dict = {
    1: "Arabic",
    2: "Chinese (Simplified)",
    3: "Chinese (Traditional)",
    4: "Czech",
    5: "Danish",
    6: "Dutch",
    7: "English",
    8: "English (UK)",
    9: "Spanish (Spain)",
    10: "Spanish (Mexico)",
    11: "Finnish",
    12: "French",
    13: "Hebrew",
    14: "Hungarian",
    15: "Italian",
    16: "Japanese",
    17: "Korean",
    18: "Norwegian",
    19: "Polish",
    20: "Portuguese (Portugal)",
    21: "Portuguese (Brazil)",
    22: "Russian",
    23: "Swedish",
    24: "Turkish",
    25: "Thai",
    26: "Vietnamese",
    27: "German",
    28: "Ukrainian"
}

# Crear un diccionario con la información de tipos de soporte
tipo_soporte_dict = {
    1: "Audio",
    2: "Subtitles",
    3: "Interface"
}

# Crear un diccionario para mapear IDs de juegos a listas de idiomas
idiomas_por_juego = {}

# Leer el archivo "Videojuego_Idioma.csv" y crear diccionarios que mapeen IDs a nombres
with open("./data/Videojuego_Idioma.csv", "r") as idiomas_file:
    next(idiomas_file)  # Saltar la primera línea con encabezados
    for line in idiomas_file:
        partes = line.strip().split(",")
        igdb_id = int(partes[1])
        id_idioma = int(partes[0])
        tipo_soporte_id = int(partes[2])
        if igdb_id not in idiomas_por_juego:
            idiomas_por_juego[igdb_id] = []
        idiomas_por_juego[igdb_id].append({"nombre": id_idioma, "tipo": tipo_soporte_id})

# Leer el JSON original
with open("./data_02/games.json", "r") as json_file:
    juegos_json = json.load(json_file)

# Función para agregar idiomas a un juego en el formato deseado
def agregar_idiomas_a_juego(juego):
    igdb_id = juego["igdb_id"]
    idiomas_juego = idiomas_por_juego.get(igdb_id, [])
    idiomas_formateados = {}
    
    for idioma in idiomas_juego:
        nombre_idioma = idiomas_dict.get(idioma["nombre"], "Desconocido")
        tipo_soporte = tipo_soporte_dict.get(idioma["tipo"], "Desconocido")
        
        if nombre_idioma not in idiomas_formateados:
            idiomas_formateados[nombre_idioma] = {"nombre": nombre_idioma, "implementaciones": []}
        
        idiomas_formateados[nombre_idioma]["implementaciones"].append({"tipo": tipo_soporte})
    
    # Filtra y elimina los idiomas con arrays vacíos
    idiomas_filtrados = [idioma for idioma in idiomas_formateados.values() if idioma["implementaciones"]]
    
    if idiomas_filtrados:
        juego["idiomas"] = idiomas_filtrados
    elif "idiomas" in juego:
        del juego["idiomas"]

# Agregar idiomas al formato deseado a cada juego
cont = 1
for juego in juegos_json:
    print(cont)
    cont += 1
    agregar_idiomas_a_juego(juego)

# Guardar el resultado en un nuevo archivo JSON
with open("./data_02/games_with_languages.json", "w") as json_file:
    json.dump(juegos_json, json_file, indent=4)

print("Archivo JSON 'games_with_languages.json' creado con éxito.")
