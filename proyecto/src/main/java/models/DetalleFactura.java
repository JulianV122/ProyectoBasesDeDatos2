package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

public class DetalleFactura {

    public static boolean crearDetalleFactura(Connection connection, int cantidad, double valorTotal, float descuento,
            int productoId, int facturaId) {
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

    public static boolean modificarDetalleFactura(Connection connection, int id, int cantidad, double valorTotal,
            float descuento, int productoId, int facturaId) {
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

    public static void menuDetallesFactura(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Detalle Factura ---");
            System.out.println("1. Crear Detalle Factura");
            System.out.println("2. Modificar Detalle Factura");
            System.out.println("3. Eliminar Detalle Factura");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese la cantidad: ");
                    int cantidad = scanner.nextInt();
                    System.out.print("Ingrese el valor total: ");
                    double valorTotal = scanner.nextDouble();
                    System.out.print("Ingrese el descuento: ");
                    float descuento = scanner.nextFloat();
                    System.out.print("Ingrese el id del producto: ");
                    int productoId = scanner.nextInt();
                    System.out.print("Ingrese el id de la factura: ");
                    int facturaId = scanner.nextInt();

                    crearDetalleFactura(connection, cantidad, valorTotal, descuento, productoId,
                            facturaId);
                    break;
                case 2:
                    System.out.print("Ingrese el id del detalle de factura a modificar: ");
                    int idModificarDF = scanner.nextInt();
                    System.out.print("Ingrese la nueva cantidad: ");
                    int nuevaCantidad = scanner.nextInt();
                    System.out.print("Ingrese el nuevo valor total: ");
                    double nuevoValorTotal = scanner.nextDouble();
                    System.out.print("Ingrese el nuevo descuento: ");
                    float nuevoDescuento = scanner.nextFloat();
                    System.out.print("Ingrese el nuevo ID del producto: ");
                    int nuevoProductoId = scanner.nextInt();
                    System.out.print("Ingrese el nuevo ID de la factura: ");
                    int nuevaFacturaId = scanner.nextInt();

                    modificarDetalleFactura(connection, idModificarDF, nuevaCantidad,
                            nuevoValorTotal, nuevoDescuento, nuevoProductoId, nuevaFacturaId);
                    break;
                case 3:
                    System.out.print("Ingrese el id del detalle de factura a eliminar: ");
                    int idEliminarDF = scanner.nextInt();

                    eliminarDetalleFactura(connection, idEliminarDF);
                    break;
                case 0:
                    System.out.println("Regresando al Menú Principal...");
                    break;
                default:
                    System.out.println("Opción no válida. Intente nuevamente.");
            }
        } while (option != 0);
    }
}
