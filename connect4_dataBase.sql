
--    CREATE SCHEMA connect4_db
--     AUTHORIZATION postgres;
  SET SEARCH_PATH = 'connect4_db';


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




create or replace function function_solapamiento_fecha()
returns trigger as $$
  begin
  if (new.Fecha_inicio = old.Fecha_fin) then
    return old;
  end if;
  end;
$$ language plpgsql;


create trigger trigger_solapamiento_fecha
before insert on Partida
for each row execute procedure function_solapamiento_fecha();


-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FIN LEOPARDOS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************
-- **********http://www.swapbytes.com/como-implementar-auditoria-simple-postgresql/*************