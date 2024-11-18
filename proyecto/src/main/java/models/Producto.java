package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.ResultSet;

public class Producto {
    public static boolean agregarProducto(Connection connection, String codigo, String nombre, String descripcion,
            float precio, String medida, int impuestoId, int categoriaId, int stock) {
        String sql = "CALL proyecto.crear_producto(?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, codigo);
            stmt.setString(2, nombre);
            stmt.setString(3, descripcion);
            stmt.setFloat(4, precio);
            stmt.setString(5, medida);
            stmt.setInt(6, impuestoId);
            stmt.setInt(7, categoriaId);
            stmt.setInt(8, stock);
            stmt.execute();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarProducto(Connection connection, int id, String codigo, String nombre,
            String descripcion, float precio, String medida, int impuestoId, int categoriaId, int stock) {
        String sql = "CALL proyecto.modificar_producto(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, codigo);
            stmt.setString(3, nombre);
            stmt.setString(4, descripcion);
            stmt.setFloat(5, precio);
            stmt.setString(6, medida);
            stmt.setInt(7, impuestoId);
            stmt.setInt(8, categoriaId);
            stmt.setInt(9, stock);
            stmt.execute();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarProducto(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_producto(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.execute();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void obtenerProductos(Connection connection) {
        String sql = "SELECT * FROM proyecto.listar_productos()";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                System.out.println("---------------------------");
                System.out.println(rs.getInt("v_id"));
                System.out.println(rs.getString("v_codigo"));
                System.out.println(rs.getString("v_nombre"));
                System.out.println(rs.getString("v_descripcion"));
                System.out.println(rs.getFloat("v_precio"));
                System.out.println(rs.getString("v_medida"));
                System.out.println(rs.getInt("v_impuesto_id"));
                System.out.println(rs.getInt("v_categoria_id"));
                System.out.println(rs.getInt("v_stock"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
