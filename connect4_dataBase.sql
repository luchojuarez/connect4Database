--  conect4_dataBase.sql

-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************

-- PROYECTO CONNECT4 BASE DE DATOS 2015
-- INTEGRANTES:
--    > CHAIJALE, MARTIN
--    > JUAREZ, LUCIANO
--    > CIBILS, JUAN IGNACIO

-- MOTOR DE BASE DE DATOS UTILIZADO: POSTGRES
-- CREACIONES DE TABLAS Y TRIGGERS

-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************



  CREATE SCHEMA connect4_db
    AUTHORIZATION postgres;
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
 Fecha timestamp,
 DNI integer,
 Nombre varchar(50),
 Apellido varchar(50),
 meElimino character(45) NOT NULL);

CREATE TABLE Grilla(
 Id serial UNIQUE NOT NULL PRIMARY KEY,
 X integer,
 Y integer);


CREATE TABLE Ficha(
 X integer NOT NULL,
 Y integer NOT NULL,
CONSTRAINT PKficha PRIMARY KEY (X,Y));

CREATE TABLE Partida(
 Nro_Partida serial UNIQUE NOT NULL PRIMARY KEY,
 Fecha_inicio timestamp,
 Fecha_fin timestamp,
 Estado valor_tipo_estado,
 UserJ1 integer,
 UserJ2 integer,
 idGrilla integer,
 Ganador integer,
CONSTRAINT FKJ1 FOREIGN KEY (UserJ1) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKJ2 FOREIGN KEY (UserJ2) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKganador FOREIGN KEY (Ganador) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKGrilla FOREIGN KEY (idGrilla) REFERENCES Grilla(Id) ON DELETE CASCADE ON UPDATE CASCADE);




CREATE TABLE OrdenF(
 Nro_Partida integer NOT NULL,
 X integer NOT NULL,
 Y integer NOT NULL,
 Nro_ficha integer NOT NULL,
CONSTRAINT FKpartida FOREIGN KEY (Nro_Partida) REFERENCES Partida(Nro_Partida) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKficha FOREIGN KEY (X,Y) REFERENCES Ficha(X,Y) ON DELETE CASCADE ON UPDATE CASCADE,
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
  insert into ExUsuario (Fecha,DNI,Nombre,Apellido,meElimino) 
              values (now(),old.DNI,old.Nombre,old.Apellido,USER);

  return new;
  end;
$$ language plpgsql;

create trigger leopardo_auditoria_usuarios_eliminados
after delete on Usuario
for each row execute procedure function_auditoria_usuarios_eliminados();


-- >>>>>>>>>>>>>>>>>>>>> FIN LEOPARDO PARA LA AUDITORIA DE USUARIOS ELIMINADOS <<<<<<<<<<<<<<<<<<<<




-- >>>>>>>>>>>>>>>>>>>>> LEOPARDO PARA EL SOLAPAMIENTO DE FECHAS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- LA IDEA ES BUSCAR LA ULTIMA Fecha_fin DE LOS DOS USUARIOS A INSERTAR, TANTO CUANDO ESTAN
-- COMO UserJ1 Y UserJ2, Y DE AHI CHECKEAMOS, SI LOS 4 CASOS 
-- (2 NULL / 1 NULL Y 1 NO NULL / 1 NO NULL Y 1 NULL / 2 NO NULL) Y DESPUES CHEKEAR QUE CUANDO
-- SON NO NULL VER SI LA MAX Fecha_fin QUE TIENEN ES DISTINTA A LA ACTUAL QUE ES LA QUE INSERTAMOS  

create or replace function function_solapamiento_fecha()
returns trigger as $$
  declare 
  maxJ1 timestamp;
  maxJ2 timestamp;
  begin
    -- busco la maxima fecha_fin(la ultima fecha) del jugador 1
    maxJ1 := (select max(Fecha_fin) from Partida where UserJ1=new.UserJ1 or UserJ2=new.UserJ1 );
    -- busco la maxima fecha_fin(la ultima fecha) del jugador 2
    maxJ2 := (select max(Fecha_fin) from Partida where UserJ1=new.UserJ2 or UserJ2=new.UserJ2 );
    -- si dos son null significa que los user nunca jugaron..entonces inserto
    IF ((maxJ1 is NULL)and(maxJ2 is NULL)) THEN 
      return new;
    ELSE
      -- si si da el caso en donde maxJ1 no es null, checkeo que el que no es null
      -- la ultima fecha de este sea distinta a la que se va a insertar, si lo es inserto..
      IF((maxJ1 is not NULL)and(maxJ2 is NULL)) THEN
        IF(maxJ1 != new.Fecha_fin) THEN
          return new;
        ELSE
          -- sino tiro una exception
          raise exception 'Solapamiento de fechas!...PartidaNoFinalizadaException';
        END IF;
      ELSE    
        -- si si da el caso en donde maxJ2 no es null, checkeo que el que no es null
        -- la ultima fecha de este sea distinta a la que se va a insertar, si lo es inserto..
        IF((maxJ1 is  NULL)and(maxJ2 is not NULL)) THEN
          IF(maxJ2 != new.Fecha_fin) THEN
            return new;
          ELSE
            -- sino tiro una exception
            raise exception 'Solapamientos de fechas!...PartidaNoFinalizadaException';
          END IF;
        ELSE    
          -- si si da el caso en donde maxJ1 y maxJ2 no es null, checkeo que 
          -- la ultima fecha de los dos sea distinta a la que se va a insertar, si lo es inserto..
          IF((maxJ1 is not  NULL)and(maxJ2 is not NULL)) THEN
            IF((maxJ1 != new.Fecha_fin) and (maxJ2 != new.Fecha_fin)) THEN
              return new;
            ELSE
              -- sino tiro una exception
              raise exception 'Solapamiento de fechas!...PartidaNoFinalizadaException';    
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;        
  END;
$$ language plpgsql;


create trigger leopardo_solapamiento_fecha
before insert on Partida
for each row execute procedure function_solapamiento_fecha();


-- >>>>>>>>>>>>>>>>>>>>> FIN LEOPARDO PARA EL SOLAPAMIENTO DE FECHAS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




-- >>>>>>>>>>>>>>>>>>>>>>> LEOPARDO PARA EL CONTROL DE RANGO DE LAS FICHAS <<<<<<<<<<<<<<<<<<<<<<<
  -- LA IDEA ES QUE SE CREE UNA FICHA EN LA TABLA FICHA Y CUANDO CREAMOS LA FILA EN LA TABLA
  -- ORDENF AHI VERIFICAR SI ESAS FICHAS QUE SE PASAN COMO CLAVES FORANEAS ESTAN EN UN
  -- RANGO VALIDO EN LA GRILLA QUE CORRESPONDE AL ID_GRILLA CORRESPONDIENTE A ESA FILA
  -- (NO SE CHECKEA EN LA TABLA FICHA PORQUE COMO SABES A QUE GRILLA VA A CORRESPONDER???)

  -- checkea que cuando se inserta una ficha, si es el mismo nro de partida las FICHAS
  -- no pueden ser iguales x=x "y" y=y (no se pueden insertar dos fichas en la misma posicion)
  -- tmb  se checkea que esten en rango de las 
  -- dimensiones de la grilla

create or replace function function_check_rango_fichas ()
returns trigger as $$
  
  declare
    idgri integer;
    xGrilla integer;
    yGrilla integer;
    xFicha integer;
    yFicha integer;
  
  BEGIN
    -- buscamos el idGrilla de la partida correspondiente para saber sus dimensiones
    idgri := (SELECT idGrilla FROM Partida WHERE new.Nro_Partida = Partida.Nro_Partida);
    -- buscamos el x del idGrilla buscado anteriormente
    xGrilla := (SELECT X FROM Grilla WHERE idgri = Grilla.Id);
    -- buscamos el y del idGrilla buscado anteriormente
    yGrilla := (SELECT Y FROM Grilla WHERE idgri = Grilla.Id);

    -- si el "x" y el "y" estan en un rango valido
    IF((new.X <= xGrilla) and (new.Y <= yGrilla)) THEN

      -- vemos si ese x esta vacio o no
      xFicha := (SELECT X FROM OrdenF WHERE ((new.Nro_Partida = OrdenF.Nro_Partida) and (new.X = OrdenF.X) and (new.Y = OrdenF.Y)));
      -- si esta vacio ...
      IF(xFicha IS NULL) THEN
        -- y el "y" es 0, (osea la base del tablero) insertamos
        IF(new.Y = 0) THEN
          return new;
        ELSE 
          yFicha := (SELECT MAX(Y) FROM OrdenF WHERE ((new.Nro_Partida = OrdenF.Nro_Partida) and (new.X = OrdenF.X)));
          IF(new.Y = yFicha+1) THEN
            return new;
          ELSE  
            raise exception 'como esta columna esta vacia el unico valor valido es la base.. osea con Y=0 ';
          END IF;  
        END IF;  
      ELSE  
        -- si no esta vacio el x (osea que la columna tiene fichas) 
        -- vemos que el "Y" sea valido (osea que este arriba de la ultima ficha colocada en esa columna)   
        -- buscamos el maximo "Y" de la columna del "X"
        yFicha := (SELECT MAX(Y) FROM OrdenF WHERE ((new.Nro_Partida = OrdenF.Nro_Partida) and (new.X = OrdenF.X)));
        -- si el "Y" a insertar es 1 mayor al maximo "y" de la columna insertamos..
        IF(new.Y = yFicha+1) THEN
          return new;  
        ELSE 
          raise exception 'el "Y" a insertar no es valido';
        END IF;  
      END IF;  
    ELSE
      raise exception 'las posiciones de los (X,Y) a insertar estan fuera del rango de la grilla';
    END IF;        
  END;
$$ language plpgsql;

create trigger leopardo_function_check_rango_fichas
  before insert on OrdenF
for each row execute procedure function_check_rango_fichas();

 -- AL CONTROLAR EL RANGO EN LA TABLA OrdenF SE PUEDE DAR EL CASO DE QUE LA TABLA Ficha 
 -- ESTE LLENA DE FICHAS QUE NUNCA SE INGRESARON EN NINGUNA PARTIDA PORQUE FUERON INVALIDAS
 -- ESTO VA A PROVOCAR QUE UNA TABLA ESTE LLENA DE DATOS INVALIDOS Y DESPUES SI TUVIERAMOS 
 -- QUE HACER ALGO CON LOS DATOS DE DICHA TABLA NO SABRIAMOS QUE DATOS SON VALIDOS Y CUALES NO
 -- >>> UNA SOLUCION A ESO SERIA CONTROLARLO DESDE JAVA COSA DE QUE SI NO SE INSERTO EN LA TABLA OrdenF
 --     HACER UN ROLLBACK EN LA TABLA Ficha COSA DE QUE NO SE LLENE DE DATOS INVALIDOS


-- >>>>>>>>>>>>>>>>>>>>> FIN LEOPARDO PARA EL CONTROL DE RANGO DE LAS FICHAS <<<<<<<<<<<<<<<<<<<<<<<



-- *********************************************************************************************
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN LEOPARDOS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- *********************************************************************************************
