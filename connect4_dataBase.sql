
  CREATE SCHEMA connect4_db
    AUTHORIZATION postgres;
  SET SEARCH_PATH = 'connect4_db';


CREATE TABLE User(
 DNI integer UNIQUE NOT NULL PRIMARY KEY,
 Nombre varchar(50),
 Apellido varchar(50));

CREATE TABLE ExUser(
 Id integer UNIQUE NOT NULL PRIMARY KEY,
 Fecha date,
 DNI INTEGER,
CONSTRAINT FKdni FOREIGN KEY (DNI) REFERENCES User(DNI) ON DELETE CASCADE);


CREATE TABLE Partida(
 Nro_Partida integer UNIQUE NOT NULL PRIMARY KEY,
 Fecha_inicio date,
 Fecha_fin date,-- LA HORA TE LA PONE JUNTO CON LA FECHA
 UserJ1 integer,
 UserJ2 integer,
 idGrid integer,
CONSTRAINT FKJ1 FOREIGN KEY (UserJ1) REFERENCES User(DNI) ON DELETE CASCADE,
CONSTRAINT FKJ2 FOREIGN KEY (UserJ2) REFERENCES User(DNI) ON DELETE CASCADE,
CONSTRAINT FKGrid FOREIGN KEY (idGrid) REFERENCES Grid(id) ON DELETE CASCADE);


CREATE TABLE Grid(
 Id integer UNIQUE NOT NULL PRIMARY KEY,
 X integer,
 Y integer);


CREATE TABLE Ficha(
 Id integer UNIQUE NOT NULL PRIMARY KEY,
 X integer,
 Y integer);

CREATE TABLE OrdenF(
 Nro_Partida integer NOT NULL,
 Id integer NOT NULL,
 Nro_ficha integer NOT NULL,
CONSTRAINT FKpartida FOREIGN KEY (Nro_Partida) REFERENCES Partida (Nro_Partida),
CONSTRAINT FKid_ficha FOREIGN KEY (Id) REFERENCES Ficha (Id),
CONSTRAINT PK PRIMARY KEY (Nro_Partida,Id));


