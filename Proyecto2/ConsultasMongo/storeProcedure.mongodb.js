use("proyecto2");

db.getCollection('games').aggregate([
    {
      $match: {
        $or: [
          { "nombre": { $regex: "^halo 3", $options: "i" } },
          { "igdb_id": "" }
        ]
      }
    }
]).toArray();  