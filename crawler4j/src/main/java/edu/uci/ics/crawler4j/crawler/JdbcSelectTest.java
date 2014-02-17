package edu.uci.ics.crawler4j.crawler;
import java.sql.*;

public class JdbcSelectTest {

	public static void main(String[] args) {
		try {
      
	   
			try {
				Class.forName("com.mysql.jdbc.Driver").newInstance();
			} catch (InstantiationException e) {
					e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
			Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/sap", "root", "root");
			Statement stmt = conn.createStatement();
			String strSelect = "select * from html";
			System.out.println("The SQL query is: " + strSelect); // Echo For debugging
			System.out.println();
			ResultSet rset = stmt.executeQuery(strSelect);
			System.out.println("The records selected are:");
			int rowCount = 0;
			while(rset.next()) {   // Move the cursor to the next row
				int id          = rset.getInt("id");
				String Category = rset.getString("html");
				String Tabcol1  = rset.getString("name");
				//String Tabcol2  = rset.getString("tabcol2");            
				System.out.println(id + ", " + Category + ", " + Tabcol1);
				++rowCount;
			}
			System.out.println("Total number of records = " + rowCount);
		} catch(SQLException ex) {
			ex.printStackTrace();
		}
	}
}