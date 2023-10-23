use("proyecto2")

  db.getCollection('genres').aggregate([
    {
      $match: {
        nombre: { $regex: 'adventure', $options: 'i' } //genero a buscar
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