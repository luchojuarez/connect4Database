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

    //         query = "SELECT * FROM usuario ";
		  //   statement = connection.prepareStatement(query);
		  //   ResultSet resultSet = statement.executeQuery();
		  //         // Print results.
		  //   while(resultSet.next()) {

		  //       System.out.print(" DNI: " + resultSet.getString(1));
		  //       System.out.print("; Nombre: " + resultSet.getString(2));
		  //       System.out.print("; Apellido: " + resultSet.getString(3)) ;
				// System.out.print("\n   ");
				// System.out.print("\n   ");
	   //  	}

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
			System.out.println("Presione 3 Listar Partidas");
			System.out.println("Presione 4 Listar Usuarios");
			System.out.println("Presione 0 para salir");
			Scanner escaneo = new Scanner(System.in);
			respuesta = escaneo.nextLine();
			charArray = respuesta.toCharArray();
			res = charArray[0];
		} while ((res != '1') && (res!='2')&& (res!='3')&& (res!='4')&&(res!='0'));
		
		switch (res) {
			case '1': insert(connection);
				break;
			case '2': remove(connection);
				break;
			case '3': listGames(connection);
				break;
			case '4': listUserMan(connection);
				break;
			case '0': System.out.println("bye");
				break;
		}
	}

	public static void insert(Connection connection){

	}
	public static void remove(Connection connection){
		
	}
	public static void listGames(Connection connection){
		
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


}