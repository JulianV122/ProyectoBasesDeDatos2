package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Scanner;

public class FacturasXML {

    public static void obtenerDatosClienteXML(Connection connection, int facturaId) {
        String sql = "SELECT * FROM proyecto.obtener_datos_cliente_xml(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String nombre_cliente = rs.getString("nombre_cliente");
                String documento_cliente = rs.getString("documento_cliente");
                String direccion_cliente = rs.getString("direccion_cliente");
                System.out.println("Nombre: " + nombre_cliente);
                System.out.println("Documento: " + documento_cliente);
                System.out.println("Dirección: " + direccion_cliente);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void obtenerDetallesFacturaXML(Connection connection, int facturaId) {
        String sql = "SELECT * FROM proyecto.obtener_detalles_factura_xml(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String nombre_producto = rs.getString("nombre_producto");
                String id_producto = rs.getString("id_producto");
                String cantidad = rs.getString("cantidad");
                String valor_total = rs.getString("valor_total");
                String descuento = rs.getString("descuento");
                System.out.println("Nombre Producto: " + nombre_producto);
                System.out.println("ID Producto: " + id_producto);
                System.out.println("Cantidad: " + cantidad);
                System.out.println("Valor Total: " + valor_total);
                System.out.println("Descuento: " + descuento);
                System.out.println("-------------------------------");
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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

    public static void menuFacturasXML(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Menú Facturas XML ---");
            System.out.println("1. Obtener Datos Cliente XML");
            System.out.println("2. Obtener Detalles Factura XML");
            System.out.println("3. Obtener Total Descuento");
            System.out.println("0. Salir");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el id de la factura: ");
                    int facturaId = scanner.nextInt();
                    obtenerDatosClienteXML(connection, facturaId);
                    break;
                case 2:
                    System.out.print("Ingrese el id de la factura: ");
                    int facturaId2 = scanner.nextInt();
                    obtenerDetallesFacturaXML(connection, facturaId2);
                    break;
                case 3:
                    System.out.print("Ingrese el id de la factura: ");
                    int facturaId3 = scanner.nextInt();
                    System.out.println(obtenerTotalDescuento(connection, facturaId3));
                    break;
                case 0:
                    System.out.println("Regresando al Menú Principal...");
                    break;
                default:
                    System.out.println("Opción inválida.");
                    break;
            }
        } while (option != 0);
    }
}
