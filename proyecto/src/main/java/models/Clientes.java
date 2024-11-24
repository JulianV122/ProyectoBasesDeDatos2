package models;


import java.sql.CallableStatement;
import java.sql.Connection;
//import java.sql.ResultSet;
import java.sql.SQLException;


public class Clientes {
    public static boolean agregarCliente(Connection connection, String documento, String nombre, String direccion,
            String telefono, String email, String ciudad, String departamento) {
        String sql = "CALL proyecto.crear_cliente(?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, documento);
            stmt.setString(2, nombre);
            stmt.setString(3, direccion);
            stmt.setString(4, telefono);
            stmt.setString(5, email);
            stmt.setString(6, ciudad);
            stmt.setString(7, departamento);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarCliente(Connection connection, int id, String documento, String nombre,
            String direccion, String telefono, String email, String ciudad, String departamento) {
        String sql = "CALL proyecto.editar_cliente(?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, documento);
            stmt.setString(3, nombre);
            stmt.setString(4, direccion);
            stmt.setString(5, telefono);
            stmt.setString(6, email);
            stmt.setString(7, ciudad);
            stmt.setString(8, departamento);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarCliente(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_cliente(?)";
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
