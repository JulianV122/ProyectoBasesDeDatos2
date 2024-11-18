

package models;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionPostgres {
    private static ConexionPostgres instance;
    private Connection connection;
    private String url = "jdbc:postgresql://localhost:5433/postgres";
    private String username = "postgres";
    private String password = "martin";

    private ConexionPostgres(){
        try {
            Class.forName("org.postgresql.Driver");
            this.connection = DriverManager.getConnection(url, username, password);
            System.out.println("Conexión Postgres exitosa");
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("Database Connection Creation Failed : " + ex.getMessage());
        }
    }

    public static Connection getConnection() {
        return getInstance().connection;
    }

    public static ConexionPostgres getInstance() {
        if (instance == null) {
            instance = new ConexionPostgres();
        } 

        return instance;
    }
}
