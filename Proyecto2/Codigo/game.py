import pandas as pd
import json

# Leer el archivo "juegos_sin_parrafos" en un DataFrame de pandas
juegos_df = pd.read_csv("./data/juegos_sin_parrafos.csv")

# Leer los archivos CSV de "motores" y "Videojuego_Motor"
motores_df = pd.read_csv("./data/motores.csv")
videojuego_motor_df = pd.read_csv("./data/Videojuego_Motor.csv")

# Leer el archivo CSV de "Videojuego_Tema"
videojuego_tema_df = pd.read_csv("./data/Videojuego_Tema.csv")

# Leer el archivo CSV de "temas"
temas_df = pd.read_csv("./data/temas.csv")

# Leer el archivo "series.csv"
series_df = pd.read_csv("./data/series.csv")

# Leer el archivo "tipos.csv"
tipos_df = pd.read_csv("./data/tipos.csv")

# Leer el archivo "franquicias.csv"
franquicias_df = pd.read_csv("./data/franquicias.csv")

# Leer el archivo "empresas.csv"
empresas_df = pd.read_csv("./data/empresas.csv")

# Leer el archivo "Videojuego_Empresa.csv"
videojuego_empresa_df = pd.read_csv("./data/Videojuego_Empresa_02.csv")

# Leer el archivo "Videojuego_Genero.csv"
videojuego_genero_df = pd.read_csv("./data/Videojuego_Genero.csv")

# Leer el archivo "generos.csv"
generos_df = pd.read_csv("./data/generos.csv")

# Leer el archivo "Videojuego_Perspectiva.csv"
videojuego_perspectiva_df = pd.read_csv("./data/Videojuego_Perspectiva.csv")

# Leer el archivo "perspectivas.csv"
perspectivas_df = pd.read_csv("./data/perspectivas.csv")

# Leer el archivo "Videojuego_CatEdad.csv"
videojuego_catedad_df = pd.read_csv("./data/Videojuego_CatEdad.csv")

# Leer el archivo "cat_edad.csv"
cat_edad_df = pd.read_csv("./data/cat_edad.csv")

# Leer el archivo "titulos.csv"
titulos_df = pd.read_csv("./data/titulos.csv")

# Realizar la unión de datos en función de igdb_id
result_df = pd.merge(juegos_df, videojuego_motor_df, left_on="igdb_id", right_on="Videojuego_Id", how="left")

# Agregar los nombres de los motores en función de Motor_Id
result_df = pd.merge(result_df, motores_df, left_on="Motor_Id", right_on="id", how="left")

# Realizar la unión de datos en función de Videojuego_Id (para temas)
result_df = pd.merge(result_df, videojuego_tema_df, left_on="igdb_id", right_on="Videojuego_Id", how="left")

# Agregar los nombres de los temas en función de Tema_Id
result_df = pd.merge(result_df, temas_df, left_on="Tema_Id", right_on="id", how="left")

# Realizar la unión de datos en función de Videojuego_Id (para empresas)
result_df = pd.merge(result_df, videojuego_empresa_df, left_on="igdb_id", right_on="Videojuego_Id", how="left")

# Agregar los nombres de las empresas en función de Empresa_Id
result_df = pd.merge(result_df, empresas_df, left_on="Empresa_Id", right_on="id", how="left")

# Realizar la unión de datos en función de Videojuego_Id (para géneros)
result_df = pd.merge(result_df, videojuego_genero_df, left_on="igdb_id", right_on="Videojuego_Id", how="left", suffixes=("_juego", "_genero"))

# Realizar la unión de datos en función de Genero_Id
result_df = pd.merge(result_df, generos_df, left_on="Genero_Id", right_on="id", how="left", suffixes=("_juego", "_genero"))

# Realizar la unión de datos en función de igdb_id (para perspectivas)
result_df = pd.merge(result_df, videojuego_perspectiva_df, left_on="igdb_id", right_on="Videojuego_Id", how="left")

# Realizar la unión de datos en función de Perspectiva_Id
result_df = pd.merge(result_df, perspectivas_df, left_on="Perspectiva_Id", right_on="id", how="left", suffixes=("_juego", "_perspectiva"))

# Realizar la unión de datos en función de igdb_id (para categorías de edad)
result_df = pd.merge(result_df, videojuego_catedad_df, left_on="igdb_id", right_on="Videojuego_CatEdad_Id", how="left")

# Realizar la unión de datos en función de Categoria_Edad_Id
result_df = pd.merge(result_df, cat_edad_df, left_on="Categoria_Edad_Id", right_on="id_cat_edad", how="left", suffixes=("_juego", "_catedad"))

# Realizar la unión de datos en función de "game_id" (para títulos)
result_df = pd.merge(result_df, titulos_df, left_on="igdb_id", right_on="game_id", how="left")

# Crear una lista de documentos en el formato deseado
documentos = []
cont = 1
for igdb_id, group in result_df.groupby("igdb_id"):
    print(cont)
    #if cont == 20:
    #    break
    cont += 1
    documento = {
        "tipo": int(group["tipo"].values[0]),
        "nombre": group["nombre"].values[0],
        "igdb_id": int(igdb_id),
    }

    if not group["calificacion_general"].isna().all():
        documento["calificacion_general"] = group["calificacion_general"].values[0]

    if not group["fecha_lanzamiento_general"].isna().all():
        documento["fecha_lanzamiento_general"] = group["fecha_lanzamiento_general"].values[0]

    if not group["critic_rating"].isna().all():
        documento["critic_rating"] = group["critic_rating"].values[0]

    if not group["calificacion_profesional"].isna().all():
        documento["calificacion_profesional"] = group["calificacion_profesional"].values[0]

    if not group["member_ratings"].isna().all():
        documento["member_ratings"] = group["member_ratings"].values[0]

    if not group["franquicia"].isna().all():
        documento["franquicia"] = group["franquicia"].values[0]

    if not group["total_calificaciones"].isna().all():
        documento["total_calificaciones"] = group["total_calificaciones"].values[0]

    if not group["tipo"].isna().all():
        # Reemplazar el valor en "tipo" con el nombre correspondiente del archivo "tipos.csv"
        tipo_id = group["tipo"].values[0]
        if not pd.isna(tipo_id):
            tipos_match = tipos_df[tipos_df["id"] == tipo_id]
            if not tipos_match.empty:
                tipo_nombre = tipos_match["name"].values[0]
                documento["tipo"] = tipo_nombre

    if not group["franquicia"].isna().all():
        # Reemplazar el valor en "franquicia" con el nombre correspondiente del archivo "franquicias.csv"
        franquicia_id = group["franquicia"].values[0]
        if not pd.isna(franquicia_id):
            franquicias_match = franquicias_df[franquicias_df["id"] == franquicia_id]
            if not franquicias_match.empty:
                franquicia_nombre = franquicias_match["name"].values[0]
                documento["franquicia"] = franquicia_nombre

    if not group["serie"].isna().all():
        # Reemplazar el valor en "serie" con el nombre correspondiente del archivo "series.csv"
        serie_id = group["serie"].values[0]
        if not pd.isna(serie_id):
            series_match = series_df[series_df["id"] == serie_id]
            if not series_match.empty:
                serie_nombre = series_match["name"].values[0]
                documento["serie"] = serie_nombre

    # Agregar motores sin duplicados
    motores = [{"nombre": nombre} for nombre in set(group["name_x"].dropna().values)]
    if motores:
        documento["motores"] = motores

    # Agregar empresas sin duplicados
    empresas = [{"nombre": nombre} for nombre in set(group["company_name"].dropna().values)]
    if empresas:
        documento["empresas"] = empresas

    # Agregar géneros sin duplicados
    generos = [{"tipo_genero": tipo} for tipo in set(group["tipo_genero"].dropna().values)]
    if generos:
        documento["generos"] = generos

    # Agregar temas sin duplicados
    temas = [{"tipo": tipo} for tipo in set(group["name_y"].dropna().values)]
    if temas:
        documento["temas"] = temas

    # Agregar perspectivas sin duplicados
    perspectivas = [{"tipo_perspectiva": tipo} for tipo in set(group["tipo_perspectiva"].dropna().values)]
    if perspectivas:
        documento["perspectivas"] = perspectivas

    # Agregar categorías de edad sin duplicados
    catedades = [{"tipo_cat_edad": tipo} for tipo in set(group["tipo_cat_edad"].dropna().values)]
    if catedades:
        documento["categorias_edad"] = catedades

    # Agregar títulos con comentarios sin duplicados y sin valores NaN
    titulos = []
    titulos_set = set()  # Conjunto para rastrear títulos duplicados
    for _, row in group.iterrows():
        titulo_nombre = row["title"]
        comentario = row["comment"]
        if not pd.isna(titulo_nombre) or not pd.isna(comentario):
            if titulo_nombre not in titulos_set:
                titulo = {}
                if not pd.isna(titulo_nombre):
                    titulo["nombre"] = titulo_nombre
                if not pd.isna(comentario):
                    titulo["comentario"] = comentario
                titulos.append(titulo)
                titulos_set.add(titulo_nombre)
    if titulos:
        documento["titulos"] = titulos
            
    documentos.append(documento)

# Guardar el resultado en un archivo JSON final
with open("juegos_con_franquicias.json", "w") as json_file:
    json.dump(documentos, json_file, indent=4)

print("Archivo JSON 'juegos_con_motores_empresas_generos_temas_serie_perspectivas_categorias_edad_titulos.json' creado con éxito.")