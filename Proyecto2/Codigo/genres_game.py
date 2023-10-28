import pandas as pd
import json
import math

# Leer el archivo de géneros
generos_df = pd.read_csv('./data/generos.csv')
generos_dict = dict(zip(generos_df['id'], generos_df['tipo_genero']))

# Leer el archivo de relaciones entre videojuegos y géneros
videojuego_genero_df = pd.read_csv('./data/Videojuego_Genero.csv')

# Leer el archivo de juegos sin párrafos
juegos_df = pd.read_csv('./data/juegos_sin_parrafos.csv')

# Leer el archivo de relaciones entre videojuegos y plataformas
videojuego_plataforma_df = pd.read_csv('./data/Videojuego_Plataforma.csv')

# Leer el archivo de plataformas
plataformas_df = pd.read_csv('./data/plataformas.csv')
plataformas_dict = dict(zip(plataformas_df['plataforma_id'], plataformas_df['plataforma_name']))

# Crear un diccionario para mapear el IGDB_ID a la información del juego
juego_info_dict = {}
for _, row in juegos_df.iterrows():
    igdb_id = row['igdb_id']
    nombre = row['nombre']
    calificacion_general = row['calificacion_general']
    calificacion_profesional = row['calificacion_profesional']

    # Validar si los valores son NaN y reemplazarlos con None
    if math.isnan(calificacion_general):
        calificacion_general = None
    if math.isnan(calificacion_profesional):
        calificacion_profesional = None

    juego_info_dict[int(igdb_id)] = {
        'nombre': nombre,
        'calificacion_general': calificacion_general,
        'calificacion_profesional': calificacion_profesional,
        'plataformas': []  # Agregar un atributo para las plataformas
    }

# Agregar plataformas a los juegos
for _, row in videojuego_plataforma_df.iterrows():
    igdb_id = int(row['game_id'])
    plataforma_id = int(row['platform_id'])
    plataforma_nombre = plataformas_dict.get(plataforma_id)
    if igdb_id in juego_info_dict and plataforma_nombre:
        if plataforma_nombre not in juego_info_dict[igdb_id]['plataformas']:
            juego_info_dict[igdb_id]['plataformas'].append(plataforma_nombre)

# Crear la lista de juegos para cada género
generos_conjuegos = {}
for _, row in videojuego_genero_df.iterrows():
    igdb_genre_id = int(row['Genero_Id'])  # Convertir a int
    igdb_id = int(row['Videojuego_Id'])  # Convertir a int
    genero_nombre = generos_dict.get(igdb_genre_id, 'Desconocido')
    juego_info = juego_info_dict.get(igdb_id)
    if igdb_genre_id not in generos_conjuegos:
        generos_conjuegos[igdb_genre_id] = {
            'igdb_genre_id': igdb_genre_id,
            'nombre': genero_nombre,
            'juegos': []
        }
    if juego_info:
        # Validar si los valores no son None y no agregarlos al diccionario si son None
        if juego_info['calificacion_general'] is not None or juego_info['calificacion_profesional'] is not None:
            generos_conjuegos[igdb_genre_id]['juegos'].append({
                'igdb_id': igdb_id,
                'nombre': juego_info['nombre'],
                'calificacion_general': juego_info['calificacion_general'],
                'calificacion_profesional': juego_info['calificacion_profesional'],
                'plataformas': juego_info['plataformas']  # Agregar plataformas al juego
            })

# Quitar atributos con valores None
for genero in generos_conjuegos.values():
    for juego in genero['juegos']:
        juego_copy = juego.copy()
        for key, value in juego_copy.items():
            if value is None:
                del juego[key]

# Convertir el resultado en una lista de géneros
generos_result = list(generos_conjuegos.values())

# Convertir a JSON
json_result = json.dumps(generos_result, default=str, indent=4)  # Usar default=str para manejar tipos no serializables

# Guardar el JSON en un archivo
with open('output_03.json', 'w') as file:
    file.write(json_result)

# Imprimir un mensaje de confirmación
print('JSON guardado en output_04.json')
