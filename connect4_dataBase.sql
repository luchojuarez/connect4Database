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
 idGrilla integer,
 win integer,
CONSTRAINT FKJ1 FOREIGN KEY (UserJ1) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKJ2 FOREIGN KEY (UserJ2) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKwin FOREIGN KEY (win) REFERENCES Usuario(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKGrilla FOREIGN KEY (idGrilla) REFERENCES Grilla(id) ON DELETE CASCADE ON UPDATE CASCADE);




CREATE TABLE OrdenF(
 Nro_Partida integer NOT NULL,
 X integer NOT NULL,
 Y integer NOT NULL,
 Nro_ficha integer NOT NULL,
 Id_ficha integer NOT NULL,
CONSTRAINT FKpartida FOREIGN KEY (Nro_Partida) REFERENCES Partida(Nro_Partida) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKfichaX FOREIGN KEY (X) REFERENCES Ficha(X) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKfichaY FOREIGN KEY (Y) REFERENCES Ficha(Y) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FKid_ficha FOREIGN KEY (Id_ficha) REFERENCES Ficha(Id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT PK PRIMARY KEY (Nro_Partida,X,Y,Id_ficha));


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
  partidaNulaJ1 date;
  partidaNulaJ2 date;
  begin
    partidaNulaJ1 := (select Fecha_fin from Partida where UserJ1=new.UserJ1 or UserJ2=new.UserJ1);
    partidaNulaJ2 := (select Fecha_fin from Partida where UserJ1=new.UserJ2 or UserJ2=new.UserJ2);
    if ((partidaNulaJ1 is NULL)and(partidaNulaJ2 is NULL)) then -- si los user nunca jugaron..
      return new;
    ELSIF ((partidaNulaJ1 is not NULL)or(partidaNulaJ2 is not NULL)) then
  	 raise exception 'PartidaNoFinalizadaException';-- sino por ahora tiro una exception
    end if;
  end;
$$ language plpgsql;


select Fecha_fin from Partida where UserJ1=3 or UserJ2=3;

create trigger leopardo_solapamiento_fecha
before insert into Partida
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
    idgrilla integer;
    xGrilla integer;
    yGrilla integer;
    xFicha integer;
    yFicha integer;
  
  BEGIN
    -- buscamos el idGrilla de la partida correspondiente para saber sus dimensiones
    idgrilla := (SELECT idGrilla FROM Partida WHERE new.Nro_Partida = Partida.Nro_Partida);
    -- buscamos el x del idGrilla buscado anteriormente
    xGrilla := (SELECT X FROM Grilla WHERE idgrilla = Grilla.Id);
    -- buscamos el y del idGrilla buscado anteriormente
    yGrilla := (SELECT Y FROM Grilla WHERE idgrilla = Grilla.Id);

    -- si el "x" y el "y" estan en un rango valido
    IF((new.X <= xGrilla) and (new.Y <= yGrilla)) THEN

      -- vemos si ese x esta vacio o no
      xFicha := (SELECT X FROM OrdenF WHERE ((new.Nro_Partida = OrdenF.Nro_Partida) and (new.X = OrdenF.X)));
      -- si esta vacio ...
      IF(xFicha IS NULL) THEN
        -- y el "y" es 0, (osea la base del tablero) insertamos
        IF(new.Y = 0) THEN
          return new;
        ELSE 
          raise exception 'como esta columna esta vacia el unico valor valido es la base.. osea con Y=0 ';
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
