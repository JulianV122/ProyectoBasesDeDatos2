package connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import io.github.cdimascio.dotenv.Dotenv;

public class ConexionPostgres {
    private static ConexionPostgres instance;
    private Connection connection;
    private String url;
    private String username;
    private String password;

    private ConexionPostgres(){
        Dotenv dotenv = Dotenv.load();
        this.url = dotenv.get("DB_URL");
        this.username = dotenv.get("DB_USERNAME");
        this.password = dotenv.get("DB_PASSWORD");

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

    public static void closeConnection() {
        try {
            instance.connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}