use("proyecto2")
db.getCollection('games').aggregate([
  {
    $match: {
      idiomas: {
        $exists: true,
        $ne: [],
      },
    },
  },
  {
    $project: {
      idiomas: 1,
      total_idiomas: {
        $size: "$idiomas",
      },
      tipo: 1,
      nombre: 1,
      igdb_id: 1,
      calificacion_general: 1,
      fecha_lanzamiento_general: 1,
      serie: 1,
      calificacion_profesional: 1,
      total_calificaciones: 1,
    },
  },
  {
    $sort: {
      total_idiomas: -1,
      calificacion_general: -1,
      calificacion_profesional: -1,
      total_calificaciones: -1,
    },
  },
  {
    $limit: 100,
  },
]).toArray();
