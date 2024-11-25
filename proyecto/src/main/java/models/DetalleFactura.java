package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class DetalleFactura {

    public static boolean crearDetalleFactura(Connection connection, int cantidad, double valorTotal, float descuento, int productoId, int facturaId) {
        String sql = "CALL proyecto.crear_detalle_factura(?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, cantidad);
            stmt.setDouble(2, valorTotal);
            stmt.setFloat(3, descuento);
            stmt.setInt(4, productoId);
            stmt.setInt(5, facturaId);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarDetalleFactura(Connection connection, int id, int cantidad, double valorTotal, float descuento, int productoId, int facturaId) {
        String sql = "CALL proyecto.modificar_detalle_factura(?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setInt(2, cantidad);
            stmt.setDouble(3, valorTotal);
            stmt.setFloat(4, descuento);
            stmt.setInt(5, productoId);
            stmt.setInt(6, facturaId);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarDetalleFactura(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_detalle_factura(?)";
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
