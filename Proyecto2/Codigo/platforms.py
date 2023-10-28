import csv
import json

# ENUM para tipo
tipo_enum = {
    "1": "console",
    "2": "arcade",
    "3": "platform",
    "4": "operating_system",
    "5": "portable_console",
    "6": "computer"
}

# ENUM para familia
familia_enum = {
    "5": "Nintendo",
    "4": "Linux",
    "2": "Xbox",
    "3": "Sega",
    "1": "PlayStation"
}

# Mapeo de regiones según el enum
region_enum = {
    "1": "europe",
    "2": "north_america",
    "3": "australia",
    "4": "new_zealand",
    "5": "japan",
    "6": "china",
    "7": "asia",
    "8": "worldwide",
    "9": "korea",
    "10": "brazil"
}

data = []

# Crea un diccionario para almacenar todos los datos del archivo "plataformas_alpha.csv"
csv_data = {}

# Abre el archivo "plataformas_alpha.csv" y lee los datos
with open("./data/plataformas_alpha.csv", mode="r", encoding="utf-8") as csv_file:
    csv_reader = csv.DictReader(csv_file)

    for row in csv_reader:
        csv_data[row["id"]] = row

# Crea un diccionario para almacenar todos los datos del archivo "plataformas_versiones.csv"
versions_data = {}

# Abre el archivo "plataformas_versiones.csv" y lee los datos
with open("./data/plataformas_versiones.csv", mode="r", encoding="utf-8") as versions_file:
    versions_reader = csv.DictReader(versions_file)

    for row in versions_reader:
        versions_data[row["id"]] = row

# Crea un diccionario para almacenar todos los datos del archivo "plataformas_release_date.csv"
release_date_data = {}

# Abre el archivo "plataformas_release_date.csv" y lee los datos
with open("./data/plataformas_release_date.csv", mode="r", encoding="utf-8") as release_date_file:
    release_date_reader = csv.DictReader(release_date_file)

    for row in release_date_reader:
        release_date_data[row["id"]] = {"fecha": row["human"], "region": row["region"]}

# Crea un diccionario para almacenar todos los datos del archivo "plataformas_version_companies.csv"
version_companies_data = {}

# Abre el archivo "plataformas_version_companies.csv" y lee los datos
with open("./data/plataformas_version_companies.csv", mode="r", encoding="utf-8") as version_companies_file:
    version_companies_reader = csv.DictReader(version_companies_file)

    for row in version_companies_reader:
        version_companies_data[row["id"]] = {"company": row["company"]}

# Crea un diccionario para almacenar todos los datos del archivo "empresas.csv"
company_data = {}

# Abre el archivo "empresas.csv" y lee los datos
with open("./data/empresas.csv", mode="r", encoding="utf-8") as company_file:
    company_reader = csv.DictReader(company_file)

    for row in company_reader:
        company_data[row["id"]] = {"company_name": row["company_name"]}

# Procesa los datos del archivo "plataformas_alpha.csv"
for id, row in csv_data.items():
    json_data = {
        "_id": int(row.get("id")),
        "igdb_platform_id": int(row.get("id")),
        "nombre": row.get("name"),
    }

    # Agrega generación si está presente y no es 0
    generation = row.get("generation")
    if generation:
        generacion = int(generation)
        if generacion > 0:
            json_data["generacion"] = generacion

    # Agrega tipo si está presente
    category = row.get("category")
    if category:
        tipo_name = tipo_enum.get(category)
        if tipo_name:
            json_data["tipo"] = tipo_name

    # Agrega familia si está presente
    platform_family = row.get("platform_family")
    if platform_family:
        familia_name = familia_enum.get(platform_family)
        if familia_name:
            json_data["familia"] = familia_name

    # Agrega nombre alternativo si está presente
    alternative_name = row.get("alternative_name")
    if alternative_name:
        json_data["nombre_alternativo"] = alternative_name

    # Procesa el primer elemento del array "versions" para buscar fechas de lanzamiento y descripción
    versions_str = row.get("versions")
    if versions_str:
        versions = json.loads(versions_str.replace("'", "\""))
        if versions and len(versions) > 0:
            version_id = versions[0]
            if str(version_id) in versions_data:
                platform_version = versions_data[str(version_id)]
                platform_version_release_dates_str = platform_version.get("platform_version_release_dates")
                if platform_version_release_dates_str:
                    release_date_ids = json.loads(platform_version_release_dates_str.replace("'", "\""))
                    if release_date_ids:
                        release_dates = []
                        for release_date_id in release_date_ids:
                            if str(release_date_id) in release_date_data:
                                release_date_info = release_date_data[str(release_date_id)]
                                region = region_enum.get(release_date_info["region"].lower(), release_date_info["region"])
                                release_dates.append({"fecha": release_date_info["fecha"], "region": region})
                        if release_dates:
                            json_data["fechas_lanzamiento"] = release_dates

                # Obtiene la descripción desde el primer elemento del array "versions"
                version_description = platform_version.get("summary")
                if version_description:
                    json_data["descripcion"] = version_description

    # Busca empresas asociadas
    version_companies_str = platform_version.get("companies")
    if version_companies_str:
        version_companies_ids = json.loads(version_companies_str.replace("'", "\""))
        if version_companies_ids:
            company_names = []
            for company_id in version_companies_ids:
                company_id = str(company_id)
                if company_id in version_companies_data:
                    company_id_in_companies = version_companies_data[company_id]["company"]
                    if company_id_in_companies in company_data:
                        company_names.append({"nombre": company_data[company_id_in_companies]["company_name"]})
            if company_names:
                json_data["empresas"] = company_names

    data.append(json_data)

# Escribe los datos en un archivo JSON
with open("plataformas_alpha.json", mode="w", encoding="utf-8") as json_file:
    json.dump(data, json_file, ensure_ascii=False, indent=4)

print("Datos convertidos y guardados en plataformas_alpha.json")
