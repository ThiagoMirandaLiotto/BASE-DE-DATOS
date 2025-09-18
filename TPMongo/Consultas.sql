/*3*/
db.Hotel.countDocuments();

/*4*/
db.Hotel.find({"comodidades.tipo": "spa", pet_friendly: "si", "comodidades.tipo": "pileta"}).sort({nombre:1}); 

/*5*/
db.Hotel.updateMany(
  {},  
  {$set: {"ultima_actualizacion": new Date()}}
);

/*6*/
db.Hotel.find({"promociones.porcentaje": 10},{nombre:1});

/*7*/
db.Hotel.find({promociones.motivo: "jubilados"});

/*8*/
db.Hotel.updateMany(
  {"numeros utiles.nombre": "Policia"},  
  {$set: {"numeros utiles.$.numero": "0800-911"}}
);

/*9*/
db.Hotel.find(
  { "lugaresRecreacion.tipo": "museo", "lugaresRecreacion.nombre": "MALBA" },
  { nombre:1, direccion:1, telefono:1, _id:0 }
);

/*10*/
db.Hotel.updateOne(
  { _id: 2}, /*Hotel "al azar"*/
  { $push: {
      promociones: {
        motivo: "promo septiembre",
        porcentaje: 12,
        fecha_inicio: "2025-09-10",
        fecha_fin: "2025-10-10"
      }
    }
  }
);

/*11.*/
db.Hotel.find(
    {},
    { nombre: 1, comodidades: 1, "promociones.porcentaje": 1}).sort({"promociones.porcentaje":-1}).limit(1);

/*12*/
db.Hotel.find(
    {$or:[
        { "promociones.motivo": "jubilados" },
        { "promociones.motivo": "estudiantes" }]},
    { nombre: 1, promociones: 1 });

/*13*/
db.Hotel.find({
  "comodidades.tipo": "spa",
  "comodidades.tipo": "pileta",
  "promociones.porcentaje": { $gt: 20 },
  "promociones.fecha_inicio": { $lt: new Date() }, 
  "promociones.fecha_fin": { $gt: new Date() }}, 
  { nombre:1, comodidades:1, promociones:1 });

/*14*/
db.Hotel.find({
  $or:[
    {"promociones": {$exists: false} },
    {"promociones": {$size: 0} }
  ]},
  { nombre:1, direccion:1, telefono:1, _id:0 });

/*15*/
db.Hotel.find({"_id": ObjectId('68b97b73fe0d53b82c38ebff')},{"mensajes": 1})
db.Mensaje.find({"_id": 101, "_id": 102, "_id": 103, "_id": 104})

/*16*/
db.Hotel.find({"promociones.2": { $exists: "true" }},{"nombre": 1, "direccion": 1, "telefono": 1})

/*17*/
/*El operador ElemMatch retorna un documento cuando un array tiene 
al menos un elemento dentro de el que cumpla con todas las condiciones a la vez,
a diferencia de la manera usual de escribirlo, que si un elemento cumple con una
condicion y otro elemento cumple con otra condicion ya funciona*/
/*Ejemplo:
Teniendo un hotel con dos promociones distintas, 
una de "año nuevo" con 50% y una de "navidad" con 25%, y un hotel con
una de "año nuevo" con 25% y una de "navidad" con 50%.
Suponiendo que quiero buscar el hotel que tenga el año nuevo con 25% de descuento.
Si ejecuto la linea: */
db.Hotel.find({
    "promociones.nombre": "año nuevo",
    "promociones.porcentaje": 25,
})
/* Nos devolveria ambos hoteles. El segundo hotel esta bien, pero el primero lo devuelve
porque encuentra que se cumple la primera condicion al tener una promocion de año nuevo, y
a parte de eso se cumple la segunda condicion en la promocion de navidad, que tiene 25.
Esto sucede porque al usar este chequeo se fija de que se cumplan ambas condiciones a parte.
Sin embargo, utilizando ElemMatch:*/
db.Hotel.find({
    "promociones":{
        $elemMatch: {
            "nombre": "año nuevo",
            "porcentaje": 25,
        }
    }
})
/*nos devolveria solamente el segundo hotel, al revisar que ambas condiciones se cumplan si o si
en el mismo elemento del array*/

/*18*/
db.Hotel.find({
    "numeros utiles.nombre": "emergencias"
})

/*19*/
db.Hotel.find({
    "promociones":{
        $elemMatch: {
            "fecha_inicio": {$lt: new Date()},
            "fecha_fin": {$gt: new Date()}
        }
    }
});

/*20*/
db.Hotel.deleteMany({
  $or:[
    {"comodidades": {$exists: false} },
    {"comodidades": {$size: 0} }
  ]
});

/*21*/
/*hay ejemplos que no tienen sentido, pero sirven para entender el operador:*/
db.Hotel.updateMany(
  { _id: ObjectId("68b97b73fe0d53b82c38ebff") }, 
  { $inc: { telefono: 1 } } /*incrementa el numero que le pases*/
);

db.Hotel.updateMany(
  { _id: ObjectId("68b97b73fe0d53b82c38ebff") },
  { $max: { telefono: 5 } }/*se actualiza solo si el valor nuevo ("5") es mayor al valor viejo del telefono*/
);

db.Hotel.updateMany(
  { _id: ObjectId("68b97b73fe0d53b82c38ebff") },
  { $mul: { telefono: 2 } } /*multiplica el valor de telefono por el numero que le pongas al lado ("valor de telefono" por 2)*/
);

db.Hotel.updateMany(
  { _id: ObjectId("68b97b73fe0d53b82c38ebff") },
  { $rename: { "wifi": "internet" } }  /*renombra el campo Wifi como internet*/
);

db.Hotel.updateMany(
  { _id: ObjectId("68b97b73fe0d53b82c38ebff") },
  { $unset: { "cajas_seguridad": "" } } /*elimina el campo que le pongamos(cajas_seguridad")*/
);

db.Hotel.updateMany(
  { _id: ObjectId("68b97b73fe0d53b82c38ebff") },
  { $pop: { "mensajes": 1 } } /*elimina el ultimo mensaje, con -1 tambien podes eliminar el primero en ves del ultimo*/
);

db.Hotel.updateMany(
  { _id: ObjectId("68b97b73fe0d53b82c38ebff") },
  { $pull: { "mensajes": { $lt: 103 } } } /*si el id de los mensaje son menores a 103, se eliminan*/
);

db.Hotel.updateMany(
  { _id: ObjectId("68b97b73fe0d53b82c38ebff") },
  { $push: { "mensajes": { $lt: 103 } } } /*si todos los ids son menores a 103, agregamos el id 103*/
);


