package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class Inventario {
    public static boolean agregarInventario(Connection connection, String fecha, String tipoMovimiento,
            String observaciones, int idProducto) {
        String sql = "CALL proyecto.crear_inventario(?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, fecha);
            stmt.setString(2, tipoMovimiento);
            stmt.setString(3, observaciones);
            stmt.setInt(4, idProducto);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean actualizarInventario(Connection connection, int id, String fecha, String tipoMovimiento,
            String observaciones, int idProducto) {
        String sql = "CALL proyecto.editar_inventario(?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, fecha);
            stmt.setString(3, tipoMovimiento);
            stmt.setString(4, observaciones);
            stmt.setInt(5, idProducto);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarInventario(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_inventario(?)";
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
