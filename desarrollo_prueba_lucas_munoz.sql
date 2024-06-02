--Creo mi base de datos
CREATE DATABASE prueba_sql_lucas_munoz_437;
\c prueba_sql_lucas_munoz_437;
--Procedemos con la creacion de tablas a partir de modelo presentado 
-- en la prueba.
--Creación tabla peliculas
CREATE TABLE peliculas(
id INT,
nombre VARCHAR(255),
anno INT,
PRIMARY KEY (id)
);
--Creación tabla tags
CREATE TABLE tags(
id INT,
tag VARCHAR(32),
PRIMARY KEY (id)
);
--Dado que el modelo nos presena una relación de muchos datos a muchos 
--datos (o N a N como propone la materia) se hace necesario crear una 
--tabla pivote para poder establecer relaciones entre ambas tablas.
CREATE TABLE peliculas_tags(
peliculas_id INT,
tags_id INT,
foreign key(peliculas_id) references peliculas(id),
foreign key(tags_id) references tags(id)
);
--Esta tabla intermedia va a tener las foreign key a las tablas de peliculas y tags ya creadas. 
--Verificamos cuales son las tablas creadas:
\d
--Si ahora queremos ver las relaciones que existen entre nuestras tablas ejecutamos los siguientes comando:
\d peliculas;
\d tags;
\d peliculas_tags;


--Procedemos entonces a ingresar los datos según lo solicita el desafío:
---Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la segunda película debe tener 2 tags asociados:
-- Primero ingresamos los datos de las 5 peliculas
INSERT INTO peliculas (id, nombre, anno) VALUES 
(1,'quinto elemento',1997),
(2,'forest gump',1994),
(3,'rescatando al soldado ryan',1998),
(4,'naufrago',2000),
(5,'armagedon', 1998);
-- Revisamos los datos ingresados:
SELECT * FROM peliculas;
-- Luego ingresamos los datos asociados a los tags que serían nuestros generos cinematográficos.
INSERT INTO tags (id, tag) VALUES
(1, 'accion'),
(2, 'ciencia ficcion'),
(3, 'drama'),
(4, 'comedia'),
(5, 'romance'),
(6, 'belico'),
(7, 'suspenso');
SELECT * FROM tags;
-- Y por ultimo establecemos las relaciones que solicita el desafío. La primera pelicula debe tener 3 tags asociados y la sgunda debe tener 2 tags asociados:
INSERT INTO peliculas_tags (peliculas_id, tags_id) VALUES 
(1,1),
(1,2),
(1,7),
(2,4),
(2,5),
(4,3);
SELECT * FROM peliculas_tags;
-- Procedemos a desarrollar el punto 3 el cual solicita: Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.
-- Para entender bien lo que haremos primero, desde la tabla peliculas, mostramos el id y nombre de cada pelicula
SELECT p.id, p.nombre FROM peliculas as p;

SELECT * FROM peliculas_tags;
-- Luego, desde la tabla pivote "peliculas_tags" agrupamos por el id de cada pelicula y contamos la cantidad de tags asociados a cada id.
SELECT pt.peliculas_id, COUNT(pt.peliculas_id) as cantidad_tags FROM peliculas_tags AS pt GROUP BY pt.peliculas_id ORDER BY pt.peliculas_id ASC;

-- Finalmente, hacemos un LEFT JOIN entre ambas tablas paramostrar el valor 0 en aquellas peliculas que no tienen tags asociados.
SELECT p.id, p.nombre, COUNT(pt.peliculas_id) as cantidad_tags FROM peliculas as p LEFT JOIN peliculas_tags as pt ON p.id =pt.peliculas_id GROUP BY p.nombre, p.id ORDER BY p.id ASC;

--*************************************************************************MODELO 2**************************************************************
--Para desarrollar este ejercicio en primer lugar creamos las tablas a partir del modelo que nos presenta el desafío:
-- Creación de tabla preguntas
CREATE TABLE preguntas(
id INT,
pregunta VARCHAR(255),
respuesta_correcta VARCHAR,
PRIMARY KEY (id)
);
-- Creacion de tabla usuarios
CREATE TABLE usuarios(
id INT,
nombre VARCHAR(255),
edad INT,
PRIMARY KEY (id)
);
--Creacion tabla respuestas donde se definen las forein keys que harán referencia a la tabla de preguntas y tabla de usuarios respectivamente.
CREATE TABLE respuestas(
id INT,
respuesta VARCHAR(255),
preguntas_id INT,
usuarios_id INT,
PRIMARY KEY (id),
foreign key(preguntas_id) references preguntas(id),
foreign key(usuarios_id) references usuarios(id)
);
--Punto 5: Agrega 5 usuarios y 5 preguntas:
--- a. La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes.
--- b. La segunda pregunta debe estar contestada correctamente solo por un usuario.
--- c. Las otras tres preguntas deben tener respuestas incorrectas.
--- Nota: Contestada correctamente significa que la respuesta indicada en la tabla respuestas es exactamente igual al texto indicado en la tabla de preguntas.

INSERT INTO usuarios (id, nombre, edad) VALUES
(1,'Lucas',23),
(2,'Alison',17),
(3,'Enzo',30),
(4,'Carla',34),
(5,'Juan',44);
--Revisamos la información ingresada
SELECT * FROM usuarios;
-- Insertamos la info para la tabla preguntas
INSERT INTO preguntas(id, pregunta, respuesta_correcta) VALUES
(1,'¿Nombre de la capital de la X región de Chile?','puerto montt'),
(2,'¿Cual es el voltaje de un puerto USB?','5 volt'),
(3,'¿Cuantos jugadores juegan por equipo  en el basquetball? (ingrese el número)','5'),
(4,'¿Cuantos días tiene una semana? (ingrese el numero)','7'),
(5,'¿Cuando se celebra el día de las glorias navales en Chile?','21 de mayo');
--Revisamos la información ingresada
SELECT * FROM preguntas;
-- Ingresamos la información para tabla respuestas
INSERT INTO respuestas(id, respuesta, preguntas_id, usuarios_id) VALUES
(1,'puerto montt',1,1),
(2,'puerto montt',1,2),
(3,'5 volt',2,4),
(4,'11',3,5),
(5,'7',3,4),
(6,'5',4,3),
(7,'18 de septiembre',5,2),
(8,'1 de octubre',5,1);
--Revisamos la información ingresada:
SELECT * FROM respuestas;
-- Punto 6: Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).
-- Para resolver esta pregunta en primer lugar como se indica, se pide mostrar los totales POR usuario. Por tanto, mostramos el id y nombre de cada usuario de la tabla usuarios
SELECT u.id, u.nombre FROM usuarios AS u;
-- Luego, hacemos un cruce entre la tabla preguntas y la tabla respuestas a efectos de mostrar solo las preguntas cuya respuesta es la correcta:
SELECT * FROM preguntas AS p INNER JOIN respuestas AS r ON p.id=r.preguntas_id WHERE p.respuesta_correcta=r.respuesta;
-- Finalmente hacemos un LEFT join entre ambas tablas comparando el id del usuario y realizando el conteo de la cantidad existente de respuestas correctas por usuario.
SELECT u.id, u.nombre, COUNT(res.respuesta_correcta) FROM usuarios AS u LEFT JOIN (SELECT * FROM preguntas AS p INNER JOIN respuestas AS r ON p.id=r.preguntas_id WHERE p.respuesta_correcta=r.respuesta) AS res ON u.id=res.usuarios_id GROUP BY u.id ORDER BY u.id ASC;
--******************************************************************************************************
-- PUNTO 7: Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente
-- Como se solicita indicar un valor para CADA pregunta, partimos por mostrar el id y contenido de cada pregunta desde la tabla preguntas
SELECT p.id, p.pregunta FROM preguntas as p;
-- Luego, hacemos un cruce entre la tabla preguntas y la tabla respuestas a efectos de mostrar solo las preguntas cuya respuesta es la correcta:
SELECT * FROM preguntas AS p INNER JOIN respuestas AS r ON p.id=r.preguntas_id WHERE p.respuesta_correcta=r.respuesta;
-- Finalmente, hacemos un LEFT JOIN entre ambas tablas comparando el id de la pregunta y realizamos el conteo de preguntas respondidas correctamente
SELECT p.id, p.pregunta, COUNT(res.preguntas_id) FROM preguntas as p LEFT JOIN (SELECT * FROM preguntas AS p INNER JOIN respuestas AS r ON p.id=r.preguntas_id WHERE p.respuesta_correcta=r.respuesta) AS res ON p.id=res.preguntas_id GROUP BY p.id ORDER BY p.id ASC;

--******************************************************************************************************
-- PUNTO 8:implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la implementación borrando el primer usuario
--El siguiente desafío nos pide aplicar lo que es el borrado en cascada y esto lo ahcemos porque al ejecutar la siguiente linea de codigo, donde intamos
--borrar al usuario 1, postgres nos advierte que estariamos alterando la integridad denuestros datos y arroja un error. 
--Esto pues hay respuestas asociadas a este usuario.
DELETE FROM usuarios WHERE id=1;
-- Para yo borrar al usuario uno tengo que borrar ademas todas las relaciones que el usuario pueda tener y para esto ralizo un borrado en cascada. Si ejecutamos
-- la siguiente query vemos que para cada usuario su id esta tomada por la tabla respuestas. Procedemos a borrar esta restricción y a replantearla considerando
-- ahora el borrado en cascada.
ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuarios_id_fkey;
\d respuestas;
ALTER TABLE respuestas ADD FOREIGN KEY  (usuarios_id) REFERENCES usuario (id) ON DELETE CASCADE;
\d respuestas;
DELETE FROM usuarios WHERE id=1;
SELECT * FROM usuarios;
--******************************************************************************************************
-- PUNTO 9: Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
-- Vemos que al ejecutar esta línea arroja un error por que indica que hay un campo existente que no la cumple.
ALTER TABLE usuarios ADD CHECK (edad>=18);
--Debemos corregir la edad existente que no cumple con esta restricción
UPDATE usuarios SET edad=20 WHERE id=2;
-- Aplicamos la restrcción.
ALTER TABLE usuarios ADD CHECK (edad>=18);
-- Revisamos
\d usuarios;
-- Ejecutamos una prueba la cual marca un error. (enrealidad funciona bien, se aplica la restricción)
INSERT INTO usuarios (id, nombre, edad) VALUES (6, 'everto', 15);
--******************************************************************************************************
-- PUNTO 10:  Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único
ALTER TABLE usuarios ADD COLUMN email VARCHAR(255) UNIQUE;
--Revisamos
\d usuarios;
-- Vemos el detalle de nuestra tabla
SELECT * FROM usuarios;
-- Ingresamos un par de datos para probar esta restricción (mail repetido)
INSERT INTO usuarios (id, nombre, edad, email) VALUES (6, 'Robinson', 41, 'email_1@gmail.com');
-- La siguiente línea marca un error pues el mail ya existe.
INSERT INTO usuarios (id, nombre, edad, email) VALUES (7, 'Marcelo', 38, 'email_1@gmail.com');
-- La siguiente línea se ingresa sin problemas.
INSERT INTO usuarios (id, nombre, edad, email) VALUES (7, 'Marcelo', 38, 'email_2@gmail.com');

