use("proyecto2");

function consulta2(nombreJuego) {
  return db.getCollection('games').aggregate([
    {
      $match: {
        nombre: {
          $regex: nombreJuego,
          $options: "i",
        },
      },
    },
  ]).toArray();  
}

consulta2("zelda"); //agregar el nombre a buscar aqui

//Stored procedure que reciba un parámetro alfanumérico para 
//buscar juegos por nombre (palabras o aproximaciones). 