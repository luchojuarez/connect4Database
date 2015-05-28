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


-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERT EN LA TABLA Usuario <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


INSERT    INTO Usuario(DNI,Nombre,Apellido) 
          VALUES (1, 'Marcelo',  'Barovero'),
                 (3, 'Gabriel',  'Mercado'),
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



INSERT    INTO Partida(Fecha_inicio,Fecha_fin,Estado,UserJ1,UserJ2,idGrid) 
          VALUES (now(),now(),'Terminado',1,2,1),
                 (now(),now(),'Terminado',3,4,1),
                 (now(),now(),'Terminado',5,6,1);


-- para probar el trigger de solapamiento de fechas crear una partida que no haya terminado
-- o dos partidas que involucren a los mismos jugadores o a uno de los dos el mismo dia...



-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT EN LA TABLA Partida <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<







-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN INSERT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************
