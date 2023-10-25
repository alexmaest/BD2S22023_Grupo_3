  use("proyecto2")

  db.createView("consulta1", "games", [
  {
    $project: {
      nombre: 1,
      'plataformas.nombre': 1,
      calificacion_general: 1,
      calificacion_profesional: 1,
      'generos.tipo_genero': 1
    }
  },
  {
    $sort: {
      calificacion_general: -1,
      calificacion_profesional: -1,
      total_calificaciones: -1
    }
  },
  {
    $limit: 100
  }
]);

db.consulta1.find().toArray();


//Vista que muestre el top 100 de los juegos evaluado por Rating o 
//valoración según el sitio web. (nombre, plataforma, rating, genero