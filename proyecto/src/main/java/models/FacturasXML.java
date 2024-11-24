package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FacturasXML {

    public static String obtenerDatosClienteXML(Connection connection, int facturaId) {
        String sql = "SELECT proyecto.obtener_datos_cliente_xml(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String result = rs.getString(1);
                rs.close();
                stmt.close();
                return result;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String obtenerDetallesFacturaXML(Connection connection, int facturaId) {
        String sql = "SELECT proyecto.obtener_detalles_factura_xml(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String result = rs.getString(1);
                rs.close();
                stmt.close();
                return result;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String obtenerTotalDescuento(Connection connection, int facturaId) {
        String sql = "SELECT proyecto.obtener_total_descuento(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String result = rs.getString(1);
                rs.close();
                stmt.close();
                return result;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
