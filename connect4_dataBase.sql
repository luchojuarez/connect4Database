
  CREATE SCHEMA connect4_db
    AUTHORIZATION postgres;
  SET SEARCH_PATH = 'connect4_db';


CREATE TABLE Usuario(
 DNI integer UNIQUE NOT NULL,
 Nombre varchar(50),
 Apellido varchar(50),
PRIMARY KEY (DNI));

CREATE TABLE ExUser(
 Id integer UNIQUE NOT NULL,
 Fecha date,
PRIMARY KEY (Id));

CREATE TABLE Eliminado(
 DNI integer NOT NULL,
 Id integer NOT NULL,
FOREIGN KEY (DNI) REFERENCES Usuario (DNI),
FOREIGN KEY (Id) REFERENCES ExUser (Id),
PRIMARY KEY (DNI,Id));

CREATE TABLE Partida(
 Nro_Partida integer UNIQUE NOT NULL,
 Fecha_inicio date,
 Fecha_fin date,
PRIMARY KEY (Nro_Partida));

CREATE TABLE Grilla(
 Id integer UNIQUE NOT NULL,
 X integer,
 Y integer,
PRIMARY KEY (Id));

CREATE TABLE Utiliza(
 Nro_Partida integer NOT NULL,
 Id integer NOT NULL,
FOREIGN KEY (Nro_Partida) REFERENCES Partida (Nro_Partida),
FOREIGN KEY (Id) REFERENCES Grilla (Id),
PRIMARY KEY (Nro_Partida,Id));

CREATE TABLE Ficha(
 Id integer UNIQUE NOT NULL,
 X integer,
 Y integer,
PRIMARY KEY (Id));

CREATE TABLE OrdenF(
 Nro_Partida integer NOT NULL,
 Id integer NOT NULL,
 Nro_ficha integer NOT NULL,
FOREIGN KEY (Nro_Partida) REFERENCES Partida (Nro_Partida),
FOREIGN KEY (Id) REFERENCES Ficha (Id),
PRIMARY KEY (Nro_Partida,Id));

CREATE TABLE Jugador_1(
 Nro_Partida integer NOT NULL,
 DNI integer NOT NULL,
FOREIGN KEY (Nro_Partida) REFERENCES Partida (Nro_Partida),
FOREIGN KEY (DNI) REFERENCES Usuario (DNI),
PRIMARY KEY (Nro_Partida,DNI));

CREATE TABLE Jugador_2(
 DNI integer NOT NULL,
 Nro_Partida integer NOT NULL,
FOREIGN KEY (DNI) REFERENCES Usuario (DNI),
FOREIGN KEY (Nro_Partida) REFERENCES Partida (Nro_Partida),
PRIMARY KEY (DNI,Nro_Partida));

