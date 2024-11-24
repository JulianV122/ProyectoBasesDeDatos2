package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Informe {

    public static boolean crearInforme(Connection connection, String tipoInforme, String fecha, String datosJson) {
        String sql = "CALL proyecto.crear_informe(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, tipoInforme);
            stmt.setString(2, fecha);
            stmt.setString(3, datosJson);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean editarInforme(Connection connection, int id, String tipoInforme, String fecha,
            String datosJson) {
        String sql = "CALL proyecto.editar_informe(?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, tipoInforme);
            stmt.setString(3, fecha);
            stmt.setString(4, datosJson);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarInforme(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_informe(?)";
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

    public static ResultSet obtenerInformeTop10(Connection connection) {
        String sql = "SELECT * FROM proyecto.informe_top10()";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            return stmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static ResultSet insertarInformeTop10(Connection connection) {
        String sql = "SELECT * FROM proyecto.insertar_informe_top10()";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            return stmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static ResultSet obtenerInformeVentasMensual(Connection connection, int anio, int mes) {
        String sql = "SELECT * FROM proyecto.informe_ventas_mensual(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, anio);
            stmt.setInt(2, mes);
            return stmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
