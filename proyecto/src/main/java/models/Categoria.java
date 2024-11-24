package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;



public class Categoria {
    public static boolean agregarCategoria(Connection connection, String descripcion) {
        String sql = "CALL proyecto.crear_categoria(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, descripcion);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarCategoria(Connection connection, int id, String descripcion) {
        String sql = "CALL proyecto.modificar_categoria(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, descripcion);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarCategoria(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_categoria(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}