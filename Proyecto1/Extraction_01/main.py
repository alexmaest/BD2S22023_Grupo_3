import requests
import datetime
import time
import csv
from enum import Enum

class Region(Enum):
    europe = 1
    north_america = 2
    australia = 3
    new_zealand = 4
    japan = 5
    china = 6
    asia = 7
    worldwide = 8
    korea = 9
    brazil = 10

params = {
    "fields": "game,platform,date,region",
    "limit": 500,
    "offset": 0
}

def obtain_data():
    total_data = []

    while True:
        games = obtain_offset(params['offset'])
        if not games:
            break

        for game in games:
            if 'date' in game:
                game['date'] = convert_unix_timestamp(game['date'])
                
            if 'region' in game and game['region'] is not None:
                region_number = int(game['region'])
                region_name = Region(region_number).name
                game['region'] = region_name

        total_data.extend(games)
        params['offset'] += params['limit']
        time.sleep(1)
        print(len(total_data))
        if len(total_data) >= 326328:
            break
    #print(total_data)
    return total_data

def convert_bool_to_int(data):
    for item in data:
        for key, value in item.items():
            if isinstance(value, bool):
                item[key] = int(value)
    return data

def convert_unix_timestamp(timestamp):
    try:
        return datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d')
    except:
        return None

def process_games(games):
    processed_games = []
    for game in games:
        if 'game' in game and 'platform' in game:
            games = game['game']
            for game_id in games:
                processed_game = {'ModoJuego_Id': 2, 'Videojuego_Id': game_id, 'Plataforma_Id': game['platform']}
                processed_games.append(processed_game)
    return processed_games

def obtain_offset(offset):
    params['offset'] = offset

    response = requests.post('https://api.igdb.com/v4/release_dates', headers={'Client-ID': 'kk13orxbx5oyw1ryul92wc4xqkejrp', 'Authorization': 'Bearer qqb6y6txmuiyy6v3tobundjj57oct3'}, data=f'fields {params["fields"]}; limit {params["limit"]}; offset {params["offset"]};')

    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: {response.status_code} - {response.text}")
        return []

def write(data):
    with open("Videojuego_Plataforma.csv", mode="w", newline="", encoding="utf-8") as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=["game","platform","date","region"])
        writer.writeheader()

        for row in data:
            # Elimina la columna "id" de cada fila
            if 'id' in row:
                del row['id']
            writer.writerow(row)

    print("Data saved")

def data_count():
    response = requests.post('https://api.igdb.com/v4/release_dates/count', headers={'Client-ID': 'kk13orxbx5oyw1ryul92wc4xqkejrp', 'Authorization': 'Bearer qqb6y6txmuiyy6v3tobundjj57oct3'}, data=f'fields {params["fields"]}; limit {params["limit"]}; offset {params["offset"]};')

    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: {response.status_code} - {response.text}")
        return []

def main():
    print(data_count())
    data = obtain_data()
    write(data)

if __name__ == "__main__":
    main()

#Lenguajes = 754539
#Juegos = 248116
#Franchises = 972 -> 1829
#Series = 6277 -> 7610
#Motores = 932 -> 1198
#Plataformas = 149 -> 200
#Titulos = 705 -> 97894
#Temas = 7 -> 22

#Limpieza de parrafos
'''
def obtain_data():
    total_data = []

    while True:
        games = obtain_offset(params['offset'])
        if not games:
            break

        for game in games:
            if 'summary' in game:
                game['summary'] = game['summary'].replace(',', '')  # Elimina las comas
            if 'id' in game and 'summary' in game and game['id'] != '' and game['summary'] != '':
                total_data.append(game)

        params['offset'] += params['limit']
        time.sleep(1)
        print(len(total_data))
        if len(total_data) >= 1000:
            break

    return total_data

def obtain_age_ratings_offset(offset):
    params['offset'] = offset

    response = requests.post(
        'https://api.igdb.com/v4/age_ratings',
        headers={'Client-ID': 'kk13orxbx5oyw1ryul92wc4xqkejrp', 'Authorization': 'Bearer qqb6y6txmuiyy6v3tobundjj57oct3'},
        data=f'fields rating; limit {params["limit"]}; offset {params["offset"]};'
    )

    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: {response.status_code} - {response.text}")
        return []
'''
#Inserción de parrafos por módulos
'''
def update_sql_database(data):
    try:
        conn = pyodbc.connect('DRIVER={SQL Server};SERVER=bd2-database.clvmoxwtkpmq.us-east-2.rds.amazonaws.com;DATABASE=proyecto1;UID=admin;PWD=s145n533g32l345e')
        cursor = conn.cursor()
        print("Se ha realizado la conexión satisfactoriamente")
        cont = 0
        for game in data:
            cont += 1
            if 'id' in game and 'storyline' in game:
                game_id = game['id']
                storyline = game['storyline'].replace(',', '')
                # Realiza la actualización en la base de datos
                print(game_id,"Historia 200k - 250k quedan ->",len(data) - cont)
                update_query = f"UPDATE Videojuego SET Historia = ? WHERE Id = ?"
                cursor.execute(update_query, (storyline, game_id))
                conn.commit()

        conn.close()
        
    except Exception as ex:
        print("Error durante la conexión: {}".format(ex))
    finally:
        print("La conexión ha finalizado")
'''

'''

def process_games(games, age_ratings_data):
    processed_games = []
    
    for game in games:
        if 'age_ratings' in game:
            themes = game['age_ratings']
            videojuego_id = game['id']
            
            for theme_id in themes:
                age_rating_description = age_ratings_data.get(theme_id, '')
                
                if age_rating_description:
                    processed_game = {'Videojuego_Id': videojuego_id, 'Categoria_Edad_Id': age_rating_description}
                    processed_games.append(processed_game)
    
    return processed_games
'''

#Games code
'''
# Mapeo de nombres de columnas
column_mapping = {
    "name": "Nombre",
    "first_release_date": "Fecha_lanzamiento_general",
    "summary": "Descripcion",
    "storyline": "Historia",
    "rating": "Calificacion_general",
    "rating_count": "Member_ratings",
    "aggregated_rating": "Calificacion_profesional",
    "aggregated_rating_count": "Critic_ratings",
    "total_rating_count": "Total_calificaciones",
    "category": "Tipo_Id",
    "collection": "Serie_Id",
    "franchise": "Franquicia_Id"
}

params = {
    "fields": "name,first_release_date,summary,storyline,rating,rating_count,total_rating_count,aggregated_rating,aggregated_rating_count,category,collection,franchise",
    "limit": 500,
    "offset": 0
}

def obtain_data():
    total_data = []

    while True:
        games = obtain_offset(params['offset'])
        if not games:
            break

        for game in games:
            if 'first_release_date' in game:
                game['first_release_date'] = convert_unix_timestamp(game['first_release_date'])

        total_data.extend(games)
        params['offset'] += params['limit']
        time.sleep(1)
        print(len(total_data))
        if len(total_data) >= 248127:
            break

    return total_data

def convert_unix_timestamp(timestamp):
    try:
        return datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d')
    except:
        return None
'''

#Videojuego_Tema
'''
params = {
    "fields": "themes",
    "limit": 500,
    "offset": 0
}

def obtain_data():
    total_data = []

    while True:
        games = obtain_offset(params['offset'])
        if not games:
            break

        total_data.extend(games)
        params['offset'] += params['limit']
        time.sleep(1)
        print(len(total_data))
        if len(total_data) >= 1000:
            break

    return process_games(total_data)

def process_games(games):
    processed_games = []
    
    for game in games:
        if 'themes' in game:
            themes = game['themes']
            for theme_id in themes:
                processed_game = {'Videojuego_Id': game['id'], 'Tema_Id': theme_id}
                processed_games.append(processed_game)
    
    return processed_games
'''
#Videojuego_CatEdad
'''
params = {
    "fields": "age_ratings",
    "limit": 500,
    "offset": 0
}

def obtain_age_ratings():
    age_ratings_data = {}

    while True:
        age_ratings = obtain_age_ratings_offset(params['offset'])
        if not age_ratings:
            break

        for rating in age_ratings:
            age_ratings_data[rating['id']] = rating['rating']
        
        params['offset'] += params['limit']
        print(len(age_ratings_data))
        time.sleep(1)

    return age_ratings_data

def obtain_age_ratings_offset(offset):
    params['offset'] = offset

    response = requests.post(
        'https://api.igdb.com/v4/age_ratings',
        headers={'Client-ID': 'kk13orxbx5oyw1ryul92wc4xqkejrp', 'Authorization': 'Bearer qqb6y6txmuiyy6v3tobundjj57oct3'},
        data=f'fields rating; limit {params["limit"]}; offset {params["offset"]};'
    )

    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: {response.status_code} - {response.text}")
        return []

def obtain_data(age_ratings_data):
    total_data = []

    while True:
        games = obtain_offset(params['offset'])
        if not games:
            break

        total_data.extend(games)
        params['offset'] += params['limit']
        time.sleep(1)
        print(len(total_data))
        if len(total_data) >= 248181:
            break

    return process_games(total_data, age_ratings_data)

def convert_unix_timestamp(timestamp):
    try:
        return datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d')
    except:
        return None

def obtain_offset(offset):
    params['offset'] = offset

    response = requests.post(
        'https://api.igdb.com/v4/games',
        headers={'Client-ID': 'kk13orxbx5oyw1ryul92wc4xqkejrp', 'Authorization': 'Bearer qqb6y6txmuiyy6v3tobundjj57oct3'},
        data=f'fields {params["fields"]}; limit {params["limit"]}; offset {params["offset"]};'
    )

    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: {response.status_code} - {response.text}")
        return []

def write(data):
    with open("Videojuego_CatEdad.csv", mode="w", newline="", encoding="utf-8") as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=None)

        all_columns = set()
        for row in data:
            all_columns.update(row.keys())

        writer.fieldnames = list(all_columns)
        writer.writeheader()

        for row in data:
            writer.writerow(row)

    print("Data saved")

def data_count():
    response = requests.post(
        'https://api.igdb.com/v4/games/count',
        headers={'Client-ID': 'kk13orxbx5oyw1ryul92wc4xqkejrp', 'Authorization': 'Bearer qqb6y6txmuiyy6v3tobundjj57oct3'},
        data=f'fields {params["fields"]}; limit {params["limit"]}; offset {params["offset"]};'
    )

    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: {response.status_code} - {response.text}")
        return []

def process_games(games, age_ratings_data):
    processed_games = []
    
    for game in games:
        if 'age_ratings' in game:
            themes = game['age_ratings']
            videojuego_id = game['id']
            
            for theme_id in themes:
                age_rating_description = age_ratings_data.get(theme_id, '')
                
                # Verificar que la descripción no esté vacía
                if age_rating_description:
                    processed_game = {'Videojuego_Id': videojuego_id, 'Categoria_Edad_Id': age_rating_description}
                    processed_games.append(processed_game)
    
    return processed_games


def main():
    age_ratings_data = obtain_age_ratings()
    print(data_count())
    data = obtain_data(age_ratings_data)
    write(data)
'''
#Parrafos
'''
params = {
    "fields": "summary",
    "limit": 500,
    "offset": 0
}

def obtain_data():
    total_data = []

    while True:
        games = obtain_offset(params['offset'])
        if not games:
            break

        for game in games:
            if 'summary' in game:
                game['summary'] = game['summary'].replace(',', '')  # Elimina las comas
            if 'id' in game and 'summary' in game and game['id'] != '' and game['summary'] != '':
                total_data.append(game)

        params['offset'] += params['limit']
        time.sleep(1)
        print(len(total_data))
        if len(total_data) >= 248167:
            break

    return total_data
'''