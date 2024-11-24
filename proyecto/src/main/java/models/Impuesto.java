package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class Impuesto {
    public static boolean agregarImpuesto(Connection connection, String nombre, float porcentaje) {
        String sql = "CALL proyecto.crear_impuesto(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, nombre);
            stmt.setFloat(2, porcentaje);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarImpuesto(Connection connection, int id, String nombre, float porcentaje) {
        String sql = "CALL proyecto.modificar_impuesto(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, nombre);
            stmt.setFloat(3, porcentaje);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarImpuesto(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_impuesto(?)";
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
