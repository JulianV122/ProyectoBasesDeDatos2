package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;
import java.sql.Date;

public class Auditoria {
    public static boolean crearAuditoria(Connection connection, Date fecha, String nombreCliente, int cantidad,
            String nombreProducto, double total) {
        String sql = "CALL proyecto.crear_auditoria(?::date, ?::varchar, ?::int, ?::varchar, ?::numeric)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setDate(1, fecha);
            stmt.setString(2, nombreCliente);
            stmt.setInt(3, cantidad);
            stmt.setString(4, nombreProducto);
            stmt.setDouble(5, total);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean editarAuditoria(Connection connection, int id, Date fecha, String nombreCliente, int cantidad,
            String nombreProducto, double total) {
        String sql = "CALL proyecto.editar_auditoria(?::int, ?::date, ?::varchar, ?::int, ?::varchar, ?::numeric)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setDate(2, fecha);
            stmt.setString(3, nombreCliente);
            stmt.setInt(4, cantidad);
            stmt.setString(5, nombreProducto);
            stmt.setDouble(6, total);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarAuditoria(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_auditoria(?)";
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

    public static void menuAuditorias(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Auditorías ---");
            System.out.println("1. Crear auditoría");
            System.out.println("2. Editar auditoría");
            System.out.println("3. Eliminar auditoría");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese la fecha (YYYY-MM-DD): ");
                    String fechaStr = scanner.nextLine();
                    Date fecha = Date.valueOf(fechaStr);
                    System.out.print("Ingrese el nombre del cliente: ");
                    String nombreCliente = scanner.nextLine();
                    System.out.print("Ingrese la cantidad: ");
                    int cantidad = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese el nombre del producto: ");
                    String nombreProducto = scanner.nextLine();
                    System.out.print("Ingrese el total: ");
                    double total = scanner.nextDouble();

                    crearAuditoria(connection, fecha, nombreCliente, cantidad, nombreProducto, total);
                    break;
                case 2:
                    System.out.print("Ingrese el id de la auditoría a editar: ");
                    int idEditar = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese la nueva fecha (YYYY-MM-DD): ");
                    String NuevaFechaStr = scanner.nextLine();
                    Date NuevaFecha = Date.valueOf(NuevaFechaStr);
                    System.out.print("Ingrese el nuevo nombre del cliente: ");
                    String nuevoNombreCliente = scanner.nextLine();
                    System.out.print("Ingrese la nueva cantidad: ");
                    int nuevaCantidad = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese el nuevo nombre del producto: ");
                    String nuevoNombreProducto = scanner.nextLine();
                    System.out.print("Ingrese el nuevo total: ");
                    double nuevoTotal = scanner.nextDouble();

                    editarAuditoria(connection, idEditar, NuevaFecha, nuevoNombreCliente, nuevaCantidad,
                            nuevoNombreProducto, nuevoTotal);
                    break;
                case 3:
                    System.out.print("Ingrese el id de la auditoría a eliminar: ");
                    int idEliminar = scanner.nextInt();

                    eliminarAuditoria(connection, idEliminar);
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
