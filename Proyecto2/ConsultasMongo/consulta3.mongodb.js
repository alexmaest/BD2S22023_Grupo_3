use("proyecto2");

function consulta3(nombreJuego) {
  return db.getCollection('games').aggregate([
    {
      $match: {
        nombre: {
          $regex: nombreJuego,
          $options: "i",
        },
      },
    },
    {
      $unwind: "$plataformas",
    },
    {
      $group: {
        _id: "$plataformas.nombre",
        juegos: { $push: "$$ROOT" },
      },
    },
  ]).toArray();  
}

consulta3("zelda"); //agregar el nombre a buscar aqui

//Stored procedure que reciba un parámetro el juego, que busque y 
//muestre la información y agrupe por plataforma.