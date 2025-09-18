/*3*/
db.Hotel.countDocuments();

/*4*/
db.Hotel.find({"comodidades.tipo": "spa", pet_friendly: "si", "comodidades.tipo": "pileta"}).sort({nombre:1}); 

/*5*/
db.Hotel.updateOne({}{});

/*6*/
db.Hotel.find({"promociones.porcentaje": 10},{nombre:1});

/*7*/
db.Hotel.find({promociones.motivo: "jubilados"});

/*9*/
db.Hotel.find(
  { "lugaresRecreacion.tipo": "museo", "lugaresRecreacion.nombre": "MALBA" },
  { nombre:1, direccion:1, telefono:1, _id:0 }
);

/*10*/
let hotel = db.Hotel.aggregate([ { $sample: { size: 1 } } ]).next();
db.Hotel.updateOne(
  { _id: hotel._id },
  { $push: {
      promociones: {
        motivo: "promo septiembre",
        porcentaje: 12,
        fecha_inicio: ISODate("2025-09-10"),
        fecha_fin: ISODate("2025-10-10")
      }
    },
    $currentDate: { ultima_actualizacion: true }
  }

/*12*/
db.Hotel.find({
  promociones: {
    $elemMatch: {
      motivo: { $regex: /(jubil|estudiant)/i }
    }
  }
}, { nombre:1, promociones:1 });
/*
5. Agregar un campo “ultima_actualizacion” con la 
fecha actual a todos los documentos de hoteles. 
Siempre que se actualice el documento se debe setear 
ese valor en la fecha actual.
7. Mostrar todos los hoteles que tengan descuento 
para jubilados.
8. Actualizar los hoteles que tengan el número de 
la Policía en sus números útiles por el siguiente
número: 0800-911.
9. Mostrar el nombre, dirección y teléfono de los
hoteles que tengan como punto de interés el museo
MALBA.
10.Agregar una promoción que inicie el 2025-09-10
 y termine el 2025-10-10.
Elegir un hotel al azar.
11.Mostrar el nombre del hotel, sus servicios y
comodidades para aquel que posea el máximo descuento.
12.Mostrar los hoteles que tengan descuento para
jubilados o para estudiantes.
13.Mostrar los hoteles que tengan spa, pileta y
además alguna promoción vigente mayor al 20%.
14.Mostrar todos los hoteles (nombre, dirección y
teléfono) que no tengan promociones.
15.Mostrar los mensajes recibidos del hotel con id 2.
16.Mostrar todos los hoteles (nombre, dirección y teléfono) que tienen, al menos,
tres promociones.
17.Explicar para qué sirve el operador de $elemMatch y dar un ejemplo.
18.Mostrar todos los hoteles que tengan dentro de “números útiles” el teléfono de
emergencias médicas.
19.Mostrar los hoteles con sus promociones vigentes al día de hoy.
20.Borrar todos los documentos de la collection que no ofrezcan comodidades.
Tener en cuenta tanto los casos en los que existe como en los que no existe el
campo.
21.Utilizando el método updateMany() dar un ejemplo de cada uno de los
siguientes operadores: $inc, $max, $mul, $rename, $unset, $pop, $pull y $push.
*/
