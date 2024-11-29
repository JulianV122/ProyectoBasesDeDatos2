package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

public class DetalleFactura {

    public static boolean crearDetalleFactura(Connection connection, int cantidad, float descuento,
            int productoId, int facturaId) {
        String sql = "CALL proyecto.crear_detalle_factura(?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, cantidad);
            stmt.setFloat(2, descuento);
            stmt.setInt(3, productoId);
            stmt.setInt(4, facturaId);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarDetalleFactura(Connection connection, int id, int cantidad,
            float descuento, int productoId, int facturaId) {
        String sql = "CALL proyecto.modificar_detalle_factura(?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setInt(2, cantidad);
            stmt.setFloat(3, descuento);
            stmt.setInt(4, productoId);
            stmt.setInt(5, facturaId);
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
                    System.out.print("Ingrese el descuento: ");
                    float descuento = scanner.nextFloat();
                    System.out.print("Ingrese el id del producto: ");
                    int productoId = scanner.nextInt();
                    System.out.print("Ingrese el id de la factura: ");
                    int facturaId = scanner.nextInt();

                    if (crearDetalleFactura(connection, cantidad, descuento, productoId, facturaId)) {
                        System.out.println("Detalle de factura creado exitosamente.");
                    } else {
                        System.out.println("Error al crear el detalle de factura.");
                    }
                    break;
                case 2:
                    System.out.print("Ingrese el id del detalle de factura a modificar: ");
                    int idModificarDF = scanner.nextInt();
                    System.out.print("Ingrese la nueva cantidad: ");
                    int nuevaCantidad = scanner.nextInt();
                    System.out.print("Ingrese el nuevo descuento: ");
                    float nuevoDescuento = scanner.nextFloat();
                    System.out.print("Ingrese el nuevo ID del producto: ");
                    int nuevoProductoId = scanner.nextInt();
                    System.out.print("Ingrese el nuevo ID de la factura: ");
                    int nuevaFacturaId = scanner.nextInt();

                    if (modificarDetalleFactura(connection, idModificarDF, nuevaCantidad, nuevoDescuento,
                            nuevoProductoId, nuevaFacturaId)) {
                        System.out.println("Detalle de factura modificado exitosamente.");
                    } else {
                        System.out.println("Error al modificar el detalle de factura.");
                    }
                    break;
                case 3:
                    System.out.print("Ingrese el id del detalle de factura a eliminar: ");
                    int idEliminarDF = scanner.nextInt();

                    if (eliminarDetalleFactura(connection, idEliminarDF)) {
                        System.out.println("Detalle de factura eliminado exitosamente.");
                    } else {
                        System.out.println("Error al eliminar el detalle de factura.");
                    }
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
