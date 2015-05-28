-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************

-- PROYECTO CONNECT4 BASE DE DATOS 2015
-- INTEGRANTES:
--    > CHAIJALE, MARTIN
--    > JUAREZ, LUCIANO
--    > CIBILS, JUAN IGNACIO

-- MOTOR DE BASE DE DATOS UTILIZADO: POSTGRES

-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************



--    CREATE SCHEMA connect4_db
--     AUTHORIZATION postgres;
  SET SEARCH_PATH = 'connect4_db';


CREATE DOMAIN  valor_tipo_estado AS VARCHAR(50) 
  CHECK (Value in ('En Curso','Terminado')); 

-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CREATE TABLES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************

CREATE TABLE Usuario(
 DNI integer UNIQUE NOT NULL  PRIMARY KEY,
 Nombre varchar(50),
 Apellido varchar(50));

CREATE TABLE ExUsuario(
 Id serial UNIQUE NOT NULL,
 Fecha date,
 DNI integer,
 meElimino character(45) NOT NUL);
--CONSTRAINT FKdni FOREIGN KEY (DNI) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE Grilla(
 Id serial UNIQUE NOT NULL PRIMARY KEY,
 X integer,
 Y integer);


CREATE TABLE Ficha(
 Id serial UNIQUE NOT NULL PRIMARY KEY,
 X integer UNIQUE NOT NULL,
 Y integer UNIQUE NOT NULL,
CONSTRAINT PKficha PRIMARY KEY (Id,X,Y));


CREATE TABLE Partida(
 Nro_Partida serial UNIQUE NOT NULL PRIMARY KEY,
 Fecha_inicio date,
 Fecha_fin date,-- LA HORA TE LA PONE JUNTO CON LA FECHA
 Estado valor_tipo_estado,
 UserJ1 integer,
 UserJ2 integer,
 idGrid integer,
 win integer,
CONSTRAINT FKJ1 FOREIGN KEY (UserJ1) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKJ2 FOREIGN KEY (UserJ2) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKwin FOREIGN KEY (win) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKGrid FOREIGN KEY (idGrid) REFERENCES Grid(id) ON DELETE CASCADE ON UPDATE CASCADE);




CREATE TABLE OrdenF(
 Nro_Partida integer NOT NULL,
 X integer NOT NULL,
 Y integer NOT NULL,
 Nro_ficha integer NOT NULL,
CONSTRAINT FKpartida FOREIGN KEY (Nro_Partida) REFERENCES Partida(Nro_Partida) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKid_fichaX FOREIGN KEY (X) REFERENCES Ficha(X) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKid_fichaY FOREIGN KEY (Y) REFERENCES Ficha(Y) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT PK PRIMARY KEY (Nro_Partida,X,Y));


-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN CREATE TABLES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************






-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> LEOPARDOS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************

-- >>>>>>>>>>>>>>>>>>>>> LEOPARDO PARA LA AUDITORIA DE USUARIOS ELIMINADOS <<<<<<<<<<<<<<<<<<<<<<<

create or replace function function_auditoria_usuarios_eliminados ()
returns trigger as $$
  begin
  insert into ExUsuario (Fecha,DNI,meElimino) 
              values (now(),old.DNI,USER);
  return new;
  end;
$$ language plpgsql;

create trigger leopardo_auditoria_usuarios_eliminados
after delete on Usuario
for each row execute procedure function_auditoria_usuarios_eliminados();


-- >>>>>>>>>>>>>>>>>>>>> FIN LEOPARDO PARA LA AUDITORIA DE USUARIOS ELIMINADOS <<<<<<<<<<<<<<<<<<<<




-- >>>>>>>>>>>>>>>>>>>>> LEOPARDO PARA EL SOLAPAMIENTO DE FECHAS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- DE QUE TIPO TIENEN Q SER PARTIDANULAJ1 Y EL OTRO Y VER COMO SE MANEJAN LOS SET
-- PORQ TE PUEDE DEVOLVER VARIAS COSAS ESOS SELECT
-- Y PORQUE NO ME DEVUELVE NULL CUANDO ME LO TENDRIA QUE DEVOLVER(osea cuando los user nunca jugaron)
-- DESPUES TENGO QUE CHECKEAR EL MAXIMO DE LAS FECHAS DE LOS USUARIOS Y QUE ELLAS SEAN DISTINTAS
-- A LA NOW() OSEA A LA QUE ESTOY POR INGRESAR XQ PUEDO JUGAR UNA PARTIDA POR DIA SIEMPRE Y CUANDO
-- HAYA TERMINADO LA PARTIDA ACTUAL... Y COMO SUPONEMOS QUE SABEMOS LA FECHA_FIN SOLO ES CHECKEAR 
-- QUE SEA DISTINTA A LA FECHA_FIN

create or replace function function_solapamiento_fecha()
returns trigger as $$
  declare 
  maxJ1 date;
  maxJ2 date;
  begin
    maxJ1 := (select max(Fecha_fin) from Partida where UserJ1=new.UserJ1 or UserJ2=new.UserJ1 );
    maxJ2 := (select max(Fecha_fin) from Partida where UserJ1=new.UserJ2 or UserJ2=new.UserJ2 );
    if ((maxJ1 is NULL)and(maxJ2 is NULL)) then -- si los user nunca jugaron..
      return new;
    else
      if (((maxJ1 is not NULL)and(maxJ2 is NULL)) or ((maxJ1 is  NULL)and(maxJ2 is not NULL)) or ((maxJ1 is not  NULL)and(maxJ2 is not NULL))) then
    	 raise exception 'PartidaNoFinalizadaException';-- sino por ahora tiro una exception
      end if; 
    end if;
  end;
$$ language plpgsql;


select Fecha_fin from Partida where UserJ1=3 or UserJ2=3;

create trigger leopardo_solapamiento_fecha
before insert into Partida
for each row execute procedure function_solapamiento_fecha();


-- >>>>>>>>>>>>>>>>>>>>> FIN LEOPARDO PARA EL SOLAPAMIENTO DE FECHAS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




-- >>>>>>>>>>>>>>>>>>>>>>> LEOPARDO PARA EL CONTROL DE RANGO DE LAS FICHAS <<<<<<<<<<<<<<<<<<<<<<<

create or replace function function_check_rango_fichas ()
returns trigger as $$
  
  declare
    xGrilla integer;
    yGrilla integer;
  
  begin


  if()
    insert into Ficha (X,Y) 
                values (new.X,new.Y);
    return new;
  end;
$$ language plpgsql;

create trigger leopardo_function_check_rango_fichas
  before insert into Ficha
for each row execute procedure function_check_rango_fichas();

-- como veo de que partida es la ficha a ingresar

-- >>>>>>>>>>>>>>>>>>>>> FIN LEOPARDO PARA EL CONTROL DE RANGO DE LAS FICHAS <<<<<<<<<<<<<<<<<<<<<<<






-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN LEOPARDOS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************
-- **********http://www.swapbytes.com/como-implementar-auditoria-simple-postgresql/*************







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
