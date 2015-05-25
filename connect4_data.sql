insert into Usuario (DNI, Nombre, Apellido)
	values 
	(1,'Juan','Perez'),
	(2,'Jose','Garcia'),
	(3,'Marcela','A'),
	(4,'Carlos','Gardel'),
	(5,'Luciano','Juarez'),
	(6,'Luca','Prodan'),
	(7,'Carlos','Solari'),
	(8,'Roberto','Mollo');

insert into Grid (X,Y)
	values
	(6,7),
	(7,8),
	(6,7),
	(2,10),
	(9,6);

insert into Partida (Fecha_inicio, Fecha_fin, Estado, UserJ1, UserJ2, idGrid)
	values
	('2014-05-23','2014-05-23','Finished',1,2,1),
	('2014-05-24',NULL,'to be continued...',6,4,2),
	('2014-08-23','2014-08-23','Finished',3,5,3),
	('2015-01-23','2015-01-23','Finished',6,1,4);

insert into Ganador (Nro_Partida,DNIUser)
	values
	(1,2),
	(4,6),
	(3,5),
	(1,6);