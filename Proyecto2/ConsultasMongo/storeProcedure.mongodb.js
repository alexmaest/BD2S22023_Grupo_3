use("proyecto2");

function storeProcedureEnunciado(nombreJuego, idJuego) {
  if (nombreJuego.length <= 3 && idJuego == 0) {
    return "El nombre del juego debe tener al menos 4 caracteres y el id debe ser mayor a 0";
  }
  return db.getCollection('games').aggregate([
    {
      $match: {
        $or: [
          { "nombre": { $regex: "^"+nombreJuego, $options: "i" } },
          { "igdb_id": idJuego }
        ]
      }
    }
]).toArray();  
}

storeProcedureEnunciado("halo", 0); //agregar el nombre a buscar aqui

