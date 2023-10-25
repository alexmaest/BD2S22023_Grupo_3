use("proyecto2")

function consulta5(nombreGenero) {
  return db.getCollection('genres').aggregate([
    {
      $match: {
        nombre: { $regex: nombreGenero, $options: 'i' } //genero a buscar
      }
    },
    {
      $unwind: "$juegos",
    },
    {
      $sort: {
        "juegos.calificacion_general": -1,
        "juegos.calificacion_profesional": -1,
      },
    },
    {
      $project: {
        _id: 0,
        "juegos.igdb_id": 1,
        "juegos.nombre": 1,
        "juegos.calificacion_general": 1,
        "juegos.plataformas": 1,
        "juegos.calificacion_profesional": 1,
        "nombre": 1,
      },
    },
  ]).toArray();
}

consulta5("adventure"); //agregar el nombre a buscar aqui

//Consulta que muestre el top los juegos por genero, ordenados por 
//rating