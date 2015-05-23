
--    CREATE SCHEMA connect4_db
--     AUTHORIZATION postgres;
  SET SEARCH_PATH = 'connect4_db';

-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>LEOPARDOS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************
create or replace function function_auditoria_usuarios_eliminados ()
returns trigger as $$
  begin
  insert into ExUser (Fecha,DNI,meElimino) 
              values (now(),old.DNI,USER);
  return new;
  end;
$$ language plpgsql;

create trigger leopardo_auditoria_usuarios_eliminados
after delete on Usuario
for each row execute procedure function_auditoria_usuarios_eliminados();





-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FIN LEOPARDOS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************
-- http://www.swapbytes.com/como-implementar-auditoria-simple-postgresql/


-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>CREATE TABLES<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************

CREATE TABLE Usuario(
 DNI integer UNIQUE NOT NULL  PRIMARY KEY,
 Nombre varchar(50),
 Apellido varchar(50));

CREATE TABLE ExUser(
 Id serial UNIQUE NOT NULL,
 Fecha date,
 DNI integer,
 meElimino character(45) NOT NUL);
--CONSTRAINT FKdni FOREIGN KEY (DNI) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE Grid(
 Id serial UNIQUE NOT NULL PRIMARY KEY,
 X integer,
 Y integer);


CREATE TABLE Ficha(
 X integer UNIQUE NOT NULL,
 Y integer UNIQUE NOT NULL,
CONSTRAINT PKficha PRIMARY KEY (X,Y));


CREATE TABLE Partida(
 Nro_Partida serial UNIQUE NOT NULL PRIMARY KEY,
 Fecha_inicio date,
 Fecha_fin date,-- LA HORA TE LA PONE JUNTO CON LA FECHA
 Estado varchar(20),
 UserJ1 integer,
 UserJ2 integer,
 idGrid integer,
CONSTRAINT FKJ1 FOREIGN KEY (UserJ1) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKJ2 FOREIGN KEY (UserJ2) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKGrid FOREIGN KEY (idGrid) REFERENCES Grid(id) ON DELETE CASCADE ON UPDATE CASCADE);


CREATE TABLE Ganador(
 Nro_Partida integer,
 DNIUser integer,
CONSTRAINT FKnroP FOREIGN KEY (Nro_Partida) REFERENCES Partida(Nro_Partida) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKUser FOREIGN KEY (DNIUser) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT PKwin PRIMARY KEY (Nro_Partida,DNIUser));


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
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FIN CREATE TABLES<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************


insert into Usuario (DNI, Nombre, Apellido)
	values 
	(1,'Juan','Perez'),
	(2,'Jose','Garcia'),
	(3,'Marcela','A'),
	(4,'Carlos','Gardel'),
	(5,'Luciano','Juarez'),
	(6,'Luca','Prodan');

