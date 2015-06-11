--  conect4_dataBase_Insert.sql

-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************

-- PROYECTO CONNECT4 BASE DE DATOS 2015
-- INTEGRANTES:
--    > CHAIJALE, MARTIN
--    > JUAREZ, LUCIANO
--    > CIBILS, JUAN IGNACIO

-- MOTOR DE BASE DE DATOS UTILIZADO: POSTGRES
-- INSERCIONES

-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************

  SET SEARCH_PATH = 'connect4_db';

-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERT EN LA TABLA Usuario <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


INSERT    INTO Usuario(DNI,Nombre,Apellido) 
          VALUES (1, 'Marcelo',  'Barovero'),
                 (4, 'Gabriel',  'Mercado'),
                 (2, 'Jonathan', 'Maidana'),
                 (6, 'Ramiro',   'Funes Mori'),
                 (3, 'Leonel',   'Vangioni'),
                 (8, 'Carlos',   'Sanchez'),
                 (23, 'Leonardo', 'Ponzio'),
                 (5, 'Matias',   'Kraneviter'),
                 (7, 'Ariel',    'Rojas'),
                 (11,'Rodrigo',  'Mora'),
                 (19,'Teofilo',  'Gutierrez'),
                 (35,'Pablo',  'Aimar'),
                 (15,'Leonardo',  'Pisculichi'),
                 (0,'Marcelo',  'Gallardo');


-- >>Para probar trigger de auditoria de usuarios eliminados descomentar o presionar opcion "r" del
--      programa java
-- DELETE FROM Usuario WHERE DNI=4;


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT EN LA TABLA Usuario <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERT EN LA TABLA Grilla <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

INSERT    INTO Grilla(X,Y) 
          VALUES (6,7);-- DEFAULT



-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT EN LA TABLA Grilla <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERT EN LA TABLA Partida <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



INSERT    INTO Partida(Fecha_inicio,Fecha_fin,Estado,UserJ1,UserJ2,idGrilla,Ganador) 
          VALUES ('2015-06-09 15:30:00','2015-06-09 16:50:00','Terminado',1,2,1,2),
                 ('2015-06-09 18:40:00','2015-06-09 19:50:00','Terminado',1,2,1,1),
                ('2015-06-10 15:40:00','2015-06-10 15:45:00','Terminado',35,15,1,35),
                ('2015-06-11 15:40:00','2015-06-11 15:45:00','Terminado',35,15,1,35),
                ('2015-06-09 14:00:00','2015-06-09 15:50:00','Terminado',6,19,1,19),
                ('2015-06-09 20:00:00','2015-06-09 20:10:00','Terminado',6,19,1,6),
                ('2015-06-09 13:15:00','2015-06-09 15:45:00','Terminado',11,7,1,11),
                ('2015-06-09 07:00:00','2015-06-09 15:00:00','Terminado',23,5,1,23),
                ('2015-06-10 12:40:00','2015-06-10 13:45:00','Terminado',23,5,1,5),
                ('2015-06-11 15:40:00','2015-06-11 15:45:00','Terminado',5,23,1,23),
                ('2015-06-12 22:40:00','2015-06-13 23:45:00','Terminado',5,23,1,23),
                ('2015-07-15 12:00:00','2015-07-15 12:05:00','Terminado',0,23,1,0);


-- para probar el trigger de solapamiento de fechas crear una partida que 
-- involucren a los mismos jugadores o a uno de los dos el mismo dia o en el mismo intervalo de tiempo...

-- DESCOMENTAR PARA PROBAR EL SOLAPAMIENTO DE FECHAS
-- PARA QUE NO TE LO DEJE INSERTAR TENES QUE CREAR DOS PARTIDAS CON ALGUN USUARIO EN COMUN Y EL MISMO DIA
-- INSERT    INTO Partida(Fecha_inicio,Fecha_fin,Estado,UserJ1,UserJ2,idGrilla,Ganador) 
--           VALUES ('2015-06-09 15:30:00','2015-06-09 16:50:00','Terminado',1,2,1,2),



-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT EN LA TABLA Partida <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERT EN LA TABLA Ficha <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

INSERT    INTO Ficha(X,Y) 
          VALUES (0,0),
                 (1,0),
                 (0,1),
                 (1,1),
                 (0,2),
                 (1,2),
                 (0,3);
-- GANA UserJ1 
-- _____________
-- |-|-|-|-|-|-|
-- |-|-|-|-|-|-|
-- |-|-|-|-|-|-|
-- |1|-|-|-|-|-|
-- |1|2|-|-|-|-|
-- |1|2|-|-|-|-|
-- |1|2|-|-|-|-|
-- -------------

-- INSERT    INTO Ficha(X,Y) 
--           VALUES (0,0),


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT EN LA TABLA Ficha <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERT EN LA TABLA OrdenF <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

INSERT    INTO OrdenF(Nro_Partida,X,Y,Nro_ficha) 
          VALUES (1,0,0,1),
                 (1,1,0,2),
                 (1,0,1,3),
                 (1,1,1,4),
                 (1,0,2,5),
                 (1,1,2,6),
                 (1,0,3,7);
-- GANA UserJ1 
-- _____________
-- |-|-|-|-|-|-|
-- |-|-|-|-|-|-|
-- |-|-|-|-|-|-|
-- |1|-|-|-|-|-|
-- |1|2|-|-|-|-|
-- |1|2|-|-|-|-|
-- |1|2|-|-|-|-|
-- -------------

-- DESCOMENTAR PARA PROBAR EL CONTROL DE FICHAS
-- ANTES DESCOMENTAR LA INSERCION EN LA TABLA FICHA QUE ME CREA LA FICHA CON ID=8 CON X=0 AND Y=0
-- INSERT    INTO OrdenF(Nro_Partida,X,Y,Nro_ficha) 
--           VALUES (1,0,0,8),


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT EN LA TABLA OrdenF <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************
