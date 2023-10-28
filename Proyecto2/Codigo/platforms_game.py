import json
import csv

# Cargar datos de Videojuego_plataforma.csv y crear un diccionario de juegos por plataforma
juegos_por_plataforma = {}
with open('./data/Videojuego_plataforma.csv', 'r', encoding='utf-8') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    for row in csv_reader:
        platform_id = int(row['platform_id'])
        game_id = int(row['game_id'])
        fecha = row['date']
        region = row['region']
        juegos_por_plataforma.setdefault(platform_id, []).append((game_id, fecha, region))

# Cargar datos de juegos_sin_parrafos.csv y crear un diccionario de nombres de juegos por igdb_id
nombres_de_juegos = {}
with open('./data/juegos_sin_parrafos.csv', 'r', encoding='utf-8') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    for row in csv_reader:
        igdb_id = int(row['igdb_id'])
        nombre = row['nombre']
        nombres_de_juegos[igdb_id] = nombre

# Cargar el archivo plataformas_alpha.json
with open('plataformas_alpha.json', 'r', encoding='utf-8') as json_file:
    data = json.load(json_file)

# Actualizar el atributo "juegos" en el archivo JSON
for plataforma in data:
    plataforma_id = plataforma['_id']
    if plataforma_id in juegos_por_plataforma:
        juegos_de_plataforma = []
        for game_id, _, _ in juegos_por_plataforma[plataforma_id]:
            juegos_de_plataforma.append(game_id)
        plataforma['juegos'] = juegos_de_plataforma

# Guardar el nuevo JSON
with open('plataformas_actualizado_ids.json', 'w', encoding='utf-8') as json_file:
    json.dump(data, json_file, ensure_ascii=False, indent=4)
