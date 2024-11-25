package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Factura {

    public static boolean agregarFactura(Connection connection, String codigo, java.sql.Date fecha, double subtotal, double totalImpuestos, double total, String estadoF, int idCliente, int idMetodoPago) {
        String sql = "CALL proyecto.crear_factura(?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, codigo);
            stmt.setDate(2, fecha);
            stmt.setDouble(3, subtotal);
            stmt.setDouble(4, totalImpuestos);
            stmt.setDouble(5, total);
            stmt.setString(6, estadoF);
            stmt.setInt(7, idCliente);
            stmt.setInt(8, idMetodoPago);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarFactura(Connection connection, int id, String codigo, java.sql.Date fecha, double subtotal, double totalImpuestos, double total, String estadoF, int idCliente, int idMetodoPago) {
        String sql = "CALL proyecto.modificar_factura(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, codigo);
            stmt.setDate(3, fecha);
            stmt.setDouble(4, subtotal);
            stmt.setDouble(5, totalImpuestos);
            stmt.setDouble(6, total);
            stmt.setString(7, estadoF);
            stmt.setInt(8, idCliente);
            stmt.setInt(9, idMetodoPago);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarFactura(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_factura(?)";
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

    public static boolean agregarClienteAFactura(Connection connection, int facturaId, int clienteId) {
        String sql = "SELECT proyecto.agregar_cliente_a_factura(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setInt(2, clienteId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean agregarProductoADetalleFactura(Connection connection, int facturaId, int productoId, int cantidad) {
        String sql = "SELECT proyecto.agregar_producto_a_detalle_factura(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setInt(2, productoId);
            stmt.setInt(3, cantidad);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean calcularImpuestosFactura(Connection connection, int facturaId) {
        String sql = "SELECT proyecto.calcular_impuestos_factura(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean aplicarDescuentoFactura(Connection connection, int facturaId, String tipoDescuento, double valorDescuento) {
        String sql = "SELECT proyecto.aplicar_descuento_factura(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setString(2, tipoDescuento);
            stmt.setDouble(3, valorDescuento);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean agregarMetodoPagoAFactura(Connection connection, int facturaId, int metodoPagoId) {
        String sql = "SELECT proyecto.agregar_metodo_pago_a_factura(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setInt(2, metodoPagoId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }
}
