 //  Connect.java

 // *************************************************************************************************
 // *************************************************************************************************
 // *************************************************************************************************

 // PROYECTO CONNECT4 BASE DE DATOS 2015
 // INTEGRANTES:
 //    > CHAIJALE, MARTIN
 //    > JUAREZ, LUCIANO
 //    > CIBILS, JUAN IGNACIO

 // APLICACION EN JAVA

 // *************************************************************************************************
 // *************************************************************************************************
 // *************************************************************************************************

import java.sql.*;
import java.util.Scanner;



public class Connect{
	public static void main(String[] args) {


		try{
					
		    String driver = "org.postgresql.Driver";
		    String url = "jdbc:postgresql://localhost:5432/postgres";
		    String username = "postgres";
		    String password = "root"; 
		    System.out.println( "Hello World!" );
		    System.out.println();


            Class.forName(driver);
		    // Establish network connection to database.
		    Connection connection = DriverManager.getConnection(url, username, password);

            String query = "SET SEARCH_PATH = 'connect4_db'";
		    PreparedStatement statement = connection.prepareStatement(query);
		    statement.execute();

		    mainMenu(connection);
		}
    	catch(ClassNotFoundException cnfe) {
        	System.err.println("Error loading driver: " + cnfe);
	    } 
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
    	    System.err.println("Error connecting: " + sqle);
    	}
		
	}

	public static void mainMenu(Connection connection){

		String respuesta;
		char[] charArray;
		char res;
		do {
			System.out.println("Presione 1 para Insertar Usuarios");
			System.out.println("Presione 2 para Eliminar Usuarios");
			System.out.println("Presione 3 Listar Partidas de ''X'' Jugador");
			System.out.println("Presione 4 Listar Todas Las Partidas");
			System.out.println("Presione 5 Listar Usuarios");
			System.out.println("Presione 6 Listar ExUsuarios");
			System.out.println("Presione 7 Listar Partidas Ganadas de ''X'' Jugador");
			System.out.println("Presione 8 Listar Cantidad de Partidas Ganadas de Cada Jugador");
			System.out.println("Presione 9 Listar la Partida Mas Larga");
			System.out.println("Presione 10 Listar Todos Los Ganadores");
			System.out.println("Presione 0 para salir");
			Scanner escaneo = new Scanner(System.in);
			respuesta = escaneo.nextLine();
			charArray = respuesta.toCharArray();
			res = charArray[0];
		} while ((res != '1') && (res!='2')&& (res!='3')&& (res!='4')&& (res!='5')&& (res!='6')&& (res!='7')&& (res!='8')&& (res!='9')&&(res!='0'));
		
		switch (res) {
			case '1': insert(connection);
				break;
			case '2': remove(connection);
				break;
			case '3': listGames(connection);
				break;
			case '4': listAllGames(connection);
				break;
			case '5': listUserMan(connection);
				break;
			case '6': listExUserMan(connection);
				break;
			case '7': gamesWin(connection);
				break;
			case '8': cantGamesWin(connection);
				break;
			case '9': gameMoreLong(connection);
				break;
			// case '10': theWinners(connection);
			// 	break;
			case '0': System.out.println("bye");
				break;
		}
	}

	public static void insert(Connection connection){

		try{
			connection.setAutoCommit(false);
			Scanner escaneo = new Scanner(System.in);
			System.out.print("Ingresa el DNI del Usuario a insertar:   ");	
			int	dni = escaneo.nextInt();

			// se chequea que el usuario no exista 
	        String query = "SELECT DNI FROM Usuario WHERE (DNI = '"+dni+"');";
		    PreparedStatement statement = connection.prepareStatement(query);
		    ResultSet resultSet =  statement.executeQuery();
			
			if ( !resultSet.next() ){

				escaneo = new Scanner(System.in);
				System.out.print("Ingresa el Nombre del Usuario a insertar:   ");	
				String	nom = escaneo.nextLine();

				escaneo = new Scanner(System.in);
				System.out.print("Ingresa el Apellido del Usuario a insertar:   ");	
				String	ap = escaneo.nextLine();

		        query = "INSERT INTO Usuario(DNI,Nombre,Apellido) VALUES ('"+dni+"','"+nom+"','"+ap+"');";
			    statement = connection.prepareStatement(query);
			    statement.execute();

				System.out.println();
                System.out.print("Insercion Exitosa...");

				System.out.println();
				System.out.println();
	    	}
	    	else{
				System.out.print("El DNI Ingresado ya se encuentra en la base de datos");	
				System.out.println();
				System.out.println();
	    	}
	    	connection.commit();
	    	mainMenu(connection);
	    }
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
            if (connection != null) {
                try {
					System.out.println();
                    System.err.print("La Insercion se deshace.");
                    connection.rollback();
	    			System.out.println();
					System.out.println();
			    	mainMenu(connection);
		            } 
                catch (SQLException excep) {
                    sqle.printStackTrace();
                }
            }
        }
	}
	public static void remove(Connection connection){
		try{
			connection.setAutoCommit(false);
			Scanner escaneo = new Scanner(System.in);
			System.out.print("Ingresa el DNI del Usuario a Eliminar:   ");	
			int	dni = escaneo.nextInt();

			// se chequea que el usuario exista 
	        String query = "SELECT DNI FROM Usuario WHERE (DNI = '"+dni+"');";
		    PreparedStatement statement = connection.prepareStatement(query);
		    ResultSet resultSet =  statement.executeQuery();
			
			if ( resultSet.next() ){

		        query = "DELETE FROM Usuario WHERE DNI = '"+dni+"';";
			    statement = connection.prepareStatement(query);
			    statement.execute();

				System.out.println();
                System.out.print("Eliminacion Exitosa...");

				System.out.println();
				System.out.println();
		    	mainMenu(connection);
		    }
	    	else{
				System.out.print("El DNI Ingresado NO se encuentra en la base de datos");	
				System.out.println();
				System.out.println();
		    	mainMenu(connection);
	    	}
	    	connection.commit();
	    }
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
            if (connection != null) {
                try {
					System.out.println();
                    System.err.print("La Eliminacion se deshace.");
                    connection.rollback();
	    			System.out.println();
					System.out.println();
			    	mainMenu(connection);
		            } 
                catch (SQLException excep) {
                    sqle.printStackTrace();
                }
            }
        }		
	}
	public static void listGames(Connection connection){
		try{

			Scanner escaneo = new Scanner(System.in);
			System.out.println("Ingresa el dni del jugador a consultar sus partidas");	
			int	dni = escaneo.nextInt();

	        String queryJ1 = "SELECT Nro_Partida,Fecha_inicio,Fecha_fin,UserJ2 FROM Partida WHERE UserJ1 = '" + dni +"';";
	        String queryJ2 = "SELECT Nro_Partida,Fecha_inicio,Fecha_fin,UserJ1 FROM Partida WHERE UserJ2 = '" + dni +"';";
		    PreparedStatement statementJ1 = connection.prepareStatement(queryJ1);
		    PreparedStatement statementJ2 = connection.prepareStatement(queryJ2);
		    ResultSet resultSetJ1 = statementJ1.executeQuery();
		    ResultSet resultSetJ2 = statementJ2.executeQuery();

		    while(resultSetJ1.next()) {
				System.out.print(" Nro_Partida: " + resultSetJ1.getString(1));
				System.out.print("; Fecha_inicio: " + resultSetJ1.getString(2));
				System.out.print("; Fecha_fin: " + resultSetJ1.getString(3)) ;
				System.out.print("; Contrincante: " + resultSetJ1.getString(4)) ;
				System.out.print("\n   ");
				System.out.print("\n   ");
	    	}
		    while(resultSetJ2.next()) {
				System.out.print(" Nro_Partida: " + resultSetJ2.getString(1));
				System.out.print("; Fecha_inicio: " + resultSetJ2.getString(2));
				System.out.print("; Fecha_fin: " + resultSetJ2.getString(3)) ;
				System.out.print("; Contrincante: " + resultSetJ2.getString(4)) ;
				System.out.print("\n   ");
				System.out.print("\n   ");
	    	}
			System.out.println();
			System.out.println();
	    	mainMenu(connection);
	    }
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
    	    System.err.println("Error connecting: " + sqle);
    	}
		
	}

	public static void listAllGames(Connection connection){
		try{

	        String query = "SELECT * FROM Partida";
		    PreparedStatement statement = connection.prepareStatement(query);
		    ResultSet resultSet = statement.executeQuery();

		    while(resultSet.next()) {
				System.out.print(" Nro_Partida: " + resultSet.getString(1));
				System.out.print("; Fecha_inicio: " + resultSet.getString(2));
				System.out.print("; Fecha_fin: " + resultSet.getString(3)) ;
				System.out.print("; Estado: " + resultSet.getString(4)) ;
				System.out.print("; Jugador 1: " + resultSet.getString(5)) ;
				System.out.print("; Jugador 2: " + resultSet.getString(6)) ;
				System.out.print("; Ganador: " + resultSet.getString(8)) ;
				System.out.print("\n   ");
				System.out.print("\n   ");
	    	}
			System.out.println();
			System.out.println();
	    	mainMenu(connection);
	    }
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
    	    System.err.println("Error connecting: " + sqle);
    	}
		
	}



	public static void listUserMan(Connection connection){

		try{

	        String query = "SELECT * FROM usuario ";
		    PreparedStatement statement = connection.prepareStatement(query);
		    ResultSet resultSet = statement.executeQuery();

		    while(resultSet.next()) {
				System.out.print(" DNI: " + resultSet.getString(1));
				System.out.print("; Nombre: " + resultSet.getString(2));
				System.out.print("; Apellido: " + resultSet.getString(3)) ;
				System.out.print("\n   ");
				System.out.print("\n   ");
	    	}
			System.out.println();
			System.out.println();
	    	mainMenu(connection);
	    }
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
    	    System.err.println("Error connecting: " + sqle);
    	}
    }

	public static void listExUserMan(Connection connection){

		try{

	        String query = "SELECT * FROM ExUsuario ";
		    PreparedStatement statement = connection.prepareStatement(query);
		    ResultSet resultSet = statement.executeQuery();

		    while(resultSet.next()) {
				System.out.print("; Fecha: " + resultSet.getString(2));
				System.out.print("; DNI: " + resultSet.getString(3)) ;
				System.out.print("; Nombre: " + resultSet.getString(4)) ;
				System.out.print("; Apellido: " + resultSet.getString(5)) ;
				System.out.print("; Me Elimino: " + resultSet.getString(6)) ;
				System.out.print("\n   ");
				System.out.print("\n   ");
	    	}
			System.out.println();
			System.out.println();
	    	mainMenu(connection);
	    }
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
    	    System.err.println("Error connecting: " + sqle);
    	}
		
	}

	public static void gamesWin(Connection connection){
		try{

			Scanner escaneo = new Scanner(System.in);
			System.out.println("Ingresa el dni del jugador a consultar sus Partidas Ganadas");	
			int	dni = escaneo.nextInt();

	        String queryJ1 = "SELECT Nro_Partida,Fecha_inicio,Fecha_fin,UserJ2 FROM Partida WHERE UserJ1 = '" + dni +"' AND UserJ1 = Ganador;";
	        String queryJ2 = "SELECT Nro_Partida,Fecha_inicio,Fecha_fin,UserJ1 FROM Partida WHERE UserJ2 = '" + dni +"' AND UserJ2 = Ganador;";
		    PreparedStatement statementJ1 = connection.prepareStatement(queryJ1);
		    PreparedStatement statementJ2 = connection.prepareStatement(queryJ2);
		    ResultSet resultSetJ1 = statementJ1.executeQuery();
		    ResultSet resultSetJ2 = statementJ2.executeQuery();

			System.out.print("Las Partidas Ganadas por "+ dni + " Son:");
			System.out.println();
			System.out.println();

		    while(resultSetJ1.next()) {
				System.out.print(" Nro_Partida: " + resultSetJ1.getString(1));
				System.out.print("; Fecha_inicio: " + resultSetJ1.getString(2));
				System.out.print("; Fecha_fin: " + resultSetJ1.getString(3)) ;
				System.out.print("; Contrincante: " + resultSetJ1.getString(4)) ;
				System.out.print("\n   ");
				System.out.print("\n   ");
	    	}
		    while(resultSetJ2.next()) {
				System.out.print(" Nro_Partida: " + resultSetJ2.getString(1));
				System.out.print("; Fecha_inicio: " + resultSetJ2.getString(2));
				System.out.print("; Fecha_fin: " + resultSetJ2.getString(3)) ;
				System.out.print("; Contrincante: " + resultSetJ2.getString(4)) ;
				System.out.print("\n   ");
				System.out.print("\n   ");
	    	}
			System.out.println();
			System.out.println();
	    	mainMenu(connection);
	    }
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
    	    System.err.println("Error connecting: " + sqle);
    	}
		
	}
	public static void cantGamesWin(Connection connection){
		try{
			String query =  "SELECT COUNT(Nro_Partida), Nombre, Apellido FROM (Partida JOIN Usuario ON (Partida.Ganador = Usuario.DNI ))GROUP BY DNI";
		    PreparedStatement statement = connection.prepareStatement(query);
		    ResultSet resultSet = statement.executeQuery();

		    while(resultSet.next()) {
				System.out.println(" Cantidad: " + resultSet.getString(1));
				System.out.println(" Nombre: " + resultSet.getString(2));
				System.out.println(" Apellido: " + resultSet.getString(3));
				System.out.print("\n   ");
				System.out.print("\n   ");
			}
			mainMenu(connection);
		}
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
    	    System.err.println("Error connecting: " + sqle);
    	}
    }


	

	public static void gameMoreLong(Connection connection){
		try{
	        // String queryJ2 = "SELECT DISTINCT(Nro_Partida) FROM ( SELECT MAX(Fecha_fin - Fecha_inicio), Nombre, Apellido,Nro_Partida FROM (Partida JOIN Usuario ON (Partida.UserJ1 = Usuario.DNI OR Partida.UserJ2 = Usuario.DNI )) GROUP BY  Nombre, Apellido,Nro_Partida  ORDER BY Apellido) dur";

	        // String queryJ2 = "SELECT MAX(Fecha_fin - Fecha_inicio), Nombre, Apellido,Nro_Partida FROM (Partida JOIN Usuario ON (Partida.UserJ1 = Usuario.DNI OR Partida.UserJ2 = Usuario.DNI )) GROUP BY  DNI ";
			String queryJ2 = "(SELECT MAX(Fecha_fin - Fecha_inicio),UserJ1 FROM Partida GROUP BY UserJ1 ) UNION (SELECT MAX(Fecha_fin - Fecha_inicio),UserJ2 FROM Partida GROUP BY UserJ2)";

		     //    String queryJ1 = "SELECT EXTRACT(hour  FROM Fecha_inicio),EXTRACT(minute  FROM Fecha_inicio),EXTRACT(second  FROM Fecha_inicio),EXTRACT(hour  FROM Fecha_fin),EXTRACT(minute  FROM Fecha_fin),EXTRACT(second  FROM Fecha_fin),EXTRACT(day  FROM Fecha_inicio),EXTRACT(month  FROM Fecha_inicio),EXTRACT(year  FROM Fecha_inicio),EXTRACT(day  FROM Fecha_fin),EXTRACT(month  FROM Fecha_fin),EXTRACT(year  FROM Fecha_fin),Nombre FROM Partida JOIN Usuario ON (Partida.UserJ1 = Usuario.DNI)";
			    // PreparedStatement statementJ1 = connection.prepareStatement(queryJ1);
			    // ResultSet resultSetJ1 = statementJ1.executeQuery();

		     //    String queryJ2 = "SELECT EXTRACT(hour  FROM Fecha_inicio),EXTRACT(minute  FROM Fecha_inicio),EXTRACT(second  FROM Fecha_inicio),EXTRACT(hour  FROM Fecha_fin),EXTRACT(minute  FROM Fecha_fin),EXTRACT(second  FROM Fecha_fin),EXTRACT(day  FROM Fecha_inicio),EXTRACT(month  FROM Fecha_inicio),EXTRACT(year  FROM Fecha_inicio),EXTRACT(day  FROM Fecha_fin),EXTRACT(month  FROM Fecha_fin),EXTRACT(year  FROM Fecha_fin),Nombre FROM Partida JOIN Usuario ON (Partida.UserJ2 = Usuario.DNI)";
		     //    // String queryJ2 = "SELECT EXTRACT(hour  FROM Fecha_inicio),EXTRACT(minute  FROM Fecha_inicio),EXTRACT(second  FROM Fecha_inicio),EXTRACT(hour  FROM Fecha_fin),EXTRACT(minute  FROM Fecha_fin),EXTRACT(second  FROM Fecha_fin) FROM Partida WHERE UserJ2 = '" + dni +"'";
			    PreparedStatement statementJ2 = connection.prepareStatement(queryJ2);
			    ResultSet resultSetJ2 = statementJ2.executeQuery();


			 //    while(resultSetJ1.next()) {
				// 	System.out.println(" Hora Inicio: " + resultSetJ1.getString(1));
				// 	System.out.println(" Minutos Inicio: " + resultSetJ1.getString(2));
				// 	System.out.println(" Segundos Inicio: " + resultSetJ1.getString(3));
				// 	System.out.println(" Dia Inicio: " + resultSetJ1.getString(7));
				// 	System.out.println(" Mes Inicio: " + resultSetJ1.getString(8));
				// 	System.out.println(" Año Inicio: " + resultSetJ1.getString(9));
				// 	System.out.println(" Hora Fin: " + resultSetJ1.getString(4));
				// 	System.out.println(" Minutos Fin: " + resultSetJ1.getString(5));
				// 	System.out.println(" Segundos Fin: " + resultSetJ1.getString(6));
				// 	System.out.println(" Dia Fin: " + resultSetJ1.getString(10));
				// 	System.out.println(" Mes Fin: " + resultSetJ1.getString(11));
				// 	System.out.println(" Año Fin: " + resultSetJ1.getString(12));
				// 	System.out.println(" Nombre J1: " + resultSetJ1.getString(13));
				// 	System.out.print("\n   ");
				// 	System.out.print("\n   ");
				// }

			    while(resultSetJ2.next()) {
					System.out.println(" duracion: " + resultSetJ2.getString(1));
					System.out.println(" nombre: " + resultSetJ2.getString(2));
					// System.out.println(" apellido: " + resultSetJ2.getString(3));
					// System.out.println(" nro partida: " + resultSetJ2.getString(4));
					System.out.print("\n   ");
					System.out.print("\n   ");
				}
		   	mainMenu(connection);
		}
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
    	    System.err.println("Error connecting: " + sqle);
    	}
    }
 




	public static void theWinners(Connection connection){
		// >> EL DIA QUE GANARON TODOS LOS JUGADORES QUE HAYAN GANADO
		try{

	        String queryWin = "SELECT DISTINCT(Ganador),Nombre,Apellido,EXTRACT(day  FROM Fecha_fin),EXTRACT(month  FROM Fecha_fin),EXTRACT(year  FROM Fecha_fin) FROM Partida JOIN  Usuario on (Partida.Ganador = Usuario.DNI) ";
		    PreparedStatement statementWin = connection.prepareStatement(queryWin);
		    ResultSet resultSetWin = statementWin.executeQuery();

			while(resultSetWin.next()){
				System.out.println();
				System.out.println("Los Ganadores Son... : "+resultSetWin.getString(2)+", "+resultSetWin.getString(3)+" <> Gano en la Fecha: "+resultSetWin.getString(4)+"/"+resultSetWin.getString(5)+"/"+resultSetWin.getString(6));
				System.out.println();
			}

		   	mainMenu(connection);
		}
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
    	    System.err.println("Error connecting: " + sqle);
    	}
    }

	public static void neverPlayConnect(Connection connection){
		// >> EL DIA QUE GANARON TODOS LOS JUGADORES QUE HAYAN GANADO
		try{

		   	mainMenu(connection);
		}
	    catch(SQLException sqle) {
    		sqle.printStackTrace();
    	    System.err.println("Error connecting: " + sqle);
    	}
    }

// FALTA:
// 	>> EL TEMA DE LOS PARAMETROS DE LAS CONSULTAS >>>LISTO<<<
// 	>> CHEKEAR AL INSERTAR SI YA EXISTE USUARIOS >>>LISTO<<<
// 	>> CHEKEAR AL ELIMINAR SI EXISTE USUARIOS 	>>>LISTO<<<
// 	>> COMMIT Y ROOLBACK (INSERT Y DELETE)	>>>LISTO<<<
// 	>> PARA PROBAR LOS COMMIT Y LOS ROLLBACK HACER UN EXECUTEQUERY EN VES DE UN EXECUTE SOLO
//     PARA QUE SE ROMPA PORQ ESAS CONSULTAS(INSERT Y DELETE) NO DEVUELVEN NADA.	>>>LISTO<<<	
//	>> COMENTAR PORGRAMA JAVA    >>>LISTO<<<

// 	>> CONSULTAS (ITEM 6)
    		// >> EL DIA QUE GANARON TODOS LOS JUGADORES QUE HAYAN GANADO >>>LISTO<<<
    		// >> TODOS LOS JUGADORES QUE JUGARON EL MISMO DIA???
// 	>> LLENAR LA BASE PARA PODER PROBAR TODO
    // >> USUARIOS QUE NO HAYAN JUGADO NUNCA (CONSUTA CON SUBCONSULTA)
}