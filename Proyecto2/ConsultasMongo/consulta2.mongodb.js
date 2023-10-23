use("proyecto2");

db.getCollection('games').aggregate([
  {
    $match: {
      nombre: {
        $regex: "zelda", //agregar el nombre a buscar aqui
        $options: "i",
      },
    },
  },
]).toArray();
