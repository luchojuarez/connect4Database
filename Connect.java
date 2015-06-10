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
	    // >> CONECCION A LA BASE DE DATOS
		try{
					
		    String driver = "org.postgresql.Driver";
		    String url = "jdbc:postgresql://localhost:5432/postgres";
		    String username = "postgres";
		    String password = "root"; 
		    System.out.println();
		    System.out.println( "Connect 4" );
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
	    // >> MENU
		String respuesta;
		char[] charArray;
		char res;
		do {
			System.out.println("Presione i (MINUSCULA) para Insertar Usuarios");
			System.out.println("Presione r (MINUSCULA) para Eliminar Usuarios");
			System.out.println("Presione 0 Listar Partidas de ''X'' Jugador");
			System.out.println("Presione 1 Listar Todas Las Partidas");
			System.out.println("Presione 2 Listar Usuarios");
			System.out.println("Presione 3 Listar ExUsuarios");
			System.out.println("Presione 4 Listar Partidas Ganadas de ''X'' Jugador");
			System.out.println("Presione 5 Listar Cantidad de Partidas Ganadas de Cada Jugador");
			System.out.println("Presione 6 Listar la Partida Mas Larga");
			System.out.println("Presione 7 Listar Todos Los Ganadores");
			System.out.println("Presione 8 Listar Todos Los Usuarios que no jugaron nunca");
			System.out.println("Presione s (MINUSCULA) para salir");
			Scanner escaneo = new Scanner(System.in);
			respuesta = escaneo.nextLine();
			charArray = respuesta.toCharArray();
			res = charArray[0];
		} while ((res != 'i') && (res!='r')&& (res!='0')&& (res!='1')&& (res!='2')&& (res!='3')&& (res!='4')&& (res!='5')&& (res!='6')&&(res!='7')&&(res!='8')&&(res!='s'));
		
		switch (res) {
			case 'i': insert(connection);
				break;
			case 'r': remove(connection);
				break;
			case '0': listGames(connection);
				break;
			case '1': listAllGames(connection);
				break;
			case '2': listUserMan(connection);
				break;
			case '3': listExUserMan(connection);
				break;
			case '4': gamesWin(connection);
				break;
			case '5': cantGamesWin(connection);
				break;
			case '6': gameMoreLong(connection);
				break;
			case '7': theWinners(connection);
				break;
			case '8': neverPlayConnect(connection);
				break;
			case 's': System.out.println("bye");
				break;
		}
	}

	public static void insert(Connection connection){
	    // >> INSERTAR
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
	    // >> ELIMINAR
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
	    // >> LISTADO DE PARTIDAS DE "X" JUGADOR
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
	    // >> LISTADO DE PARTIDAS
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
	    // >> LISTADO DE USUARIOS
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
	    // >> LISTADO DE USUARIOS ELIMINADOS
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
	    // >> PARTIDAS GANADAS DE  ''X'' JUGADOR
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
	    // >> CANTIDAD DE PARTIDAS GANADAS DE CADA JUGADOR 
		try{
			String query =  "SELECT COUNT(Nro_Partida), Nombre, Apellido FROM (Partida JOIN Usuario ON (Partida.Ganador = Usuario.DNI ))GROUP BY DNI";
		    PreparedStatement statement = connection.prepareStatement(query);
		    ResultSet resultSet = statement.executeQuery();

		    while(resultSet.next()) {
				System.out.print("Cantidad: " + resultSet.getString(1));
				System.out.print("<> Nombre: " + resultSet.getString(2));
				System.out.print("<> Apellido: " + resultSet.getString(3));
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
	    // >> LA PARTIDA MAS LARGA DE CADA JUGADOR
		try{
	        
	        String query = "SELECT MAX(Fecha_fin - Fecha_inicio), Nombre, Apellido FROM (Partida JOIN Usuario ON (Partida.UserJ1 = Usuario.DNI OR Partida.UserJ2 = Usuario.DNI )) GROUP BY  DNI ORDER BY Apellido";
			// String queryJ2 = "(SELECT MAX(Fecha_fin - Fecha_inicio),UserJ1 FROM Partida GROUP BY UserJ1 ) UNION (SELECT MAX(Fecha_fin - Fecha_inicio),UserJ2 FROM Partida GROUP BY UserJ2)";
		    PreparedStatement statement = connection.prepareStatement(query);
		    ResultSet resultSet = statement.executeQuery();

		    while(resultSet.next()) {
				System.out.print("Duracion: " + resultSet.getString(1));
				System.out.print(" <> Nombre: " + resultSet.getString(2));
				System.out.print(" <> Apellido: " + resultSet.getString(3));
				// System.out.println(" Nro partida: " + resultSet.getString(4));
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

	        String queryWin = "SELECT DISTINCT ON(DNI) Nombre,Apellido,EXTRACT(day  FROM Fecha_fin),EXTRACT(month  FROM Fecha_fin),EXTRACT(year  FROM Fecha_fin) FROM Partida JOIN  Usuario on (Partida.Ganador = Usuario.DNI) ";
		    PreparedStatement statementWin = connection.prepareStatement(queryWin);
		    ResultSet resultSetWin = statementWin.executeQuery();

			while(resultSetWin.next()){
				System.out.println();
				System.out.println("Los Ganadores Son... : "+resultSetWin.getString(1)+", "+resultSetWin.getString(2)+" <> Gano en la Fecha: "+resultSetWin.getString(3)+"/"+resultSetWin.getString(4)+"/"+resultSetWin.getString(5));
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
	    // >> USUARIOS QUE NO HAYAN JUGADO NUNCA 
		try{
			String query = "SELECT * FROM Usuario WHERE DNI NOT IN (SELECT DNI FROM (Usuario JOIN  Partida ON Partida.UserJ1 = Usuario.DNI OR Partida.UserJ2 = Usuario.DNI)) ORDER BY Apellido   "; 
		    PreparedStatement statement = connection.prepareStatement(query);
		    ResultSet resultSet = statement.executeQuery();

		    while(resultSet.next()) {
				System.out.print(" DNI: " + resultSet.getString(1));
				System.out.print(" <> Nombre: " + resultSet.getString(2));
				System.out.print(" <> Apellido: " + resultSet.getString(3));
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
		    // >> USUARIOS QUE NO HAYAN JUGADO NUNCA (CONSUTA CON SUBCONSULTA) >>>LISTO<<<
// 	>> LLENAR LA BASE PARA PODER PROBAR TODO >>>LISTO<<<

// 	>> INFORME
// 	>> VER SI LA PROFE SOLUCIONO LA CONSULTA DE LA PARTIDA MAS LARGA QUE LO QUE LE FALTA ES 
    	// QUE TE MUESTRE EL NUMERO DE PARTIDA
}