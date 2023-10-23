use("proyecto2");

db.getCollection('games').aggregate([
  {
    $match: {
      nombre: {
        $regex: "zelda", //nombre a buscar
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
