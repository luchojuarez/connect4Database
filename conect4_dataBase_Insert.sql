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
                 (19,'Teofilo',  'Gutierrez');


-- descomentar para probar trigger de auditoria de usuarios eliminados
-- DELETE FROM Usuario WHERE DNI=1;


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT EN LA TABLA Usuario <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERT EN LA TABLA Grilla <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

INSERT    INTO Grilla(X,Y) 
          VALUES (6,7);-- DEFAULT



-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT EN LA TABLA Grilla <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERT EN LA TABLA Partida <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



INSERT    INTO Partida(Fecha_inicio,Fecha_fin,Estado,UserJ1,UserJ2,idGrilla) 
          VALUES (now(),now(),'Terminado',1,2,1);


-- para probar el trigger de solapamiento de fechas crear una partida que no haya terminado
-- o dos partidas que involucren a los mismos jugadores o a uno de los dos el mismo dia...

-- DESCOMENTAR PARA PROBAR EL SOLAPAMIENTO DE FECHAS
-- PARA QUE NO TE LO DEJE INSERTAR TENES QUE CREAR DOS PARTIDAS CON ALGUN USUARIO EN COMUN Y EL MISMO DIA
-- INSERT    INTO Partida(Fecha_inicio,Fecha_fin,Estado,UserJ1,UserJ2,idGrid) 
--           VALUES (now(),now(),'Terminado',1,2,1),



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

INSERT    INTO OrdenF(Nro_Partida,X,Y,Nro_ficha,Id_ficha) 
          VALUES (1,0,0,1,1),
                 (1,1,0,2,2),
                 (1,0,1,3,3),
                 (1,1,1,4,4),
                 (1,0,2,5,5),
                 (1,1,2,6,6),
                 (1,0,3,7,7);
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
-- INSERT    INTO OrdenF(Nro_Partida,X,Y,Nro_ficha,Id_ficha) 
--           VALUES (1,0,0,8,8),


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT EN LA TABLA OrdenF <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************
