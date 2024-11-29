package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.Scanner;

public class Inventario {
    public static boolean agregarInventario(Connection connection, Date fecha, String tipoMovimiento,
            String observaciones, int idProducto) {
        String sql = "CALL proyecto.crear_inventario(?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setDate(1, fecha);
            stmt.setString(2, tipoMovimiento);
            stmt.setString(3, observaciones);
            stmt.setInt(4, idProducto);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean actualizarInventario(Connection connection, int id, Date fecha, String tipoMovimiento,
            String observaciones, int idProducto) {
        String sql = "CALL proyecto.editar_inventario(?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setDate(2, fecha);
            stmt.setString(3, tipoMovimiento);
            stmt.setString(4, observaciones);
            stmt.setInt(5, idProducto);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarInventario(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_inventario(?)";
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

    public static void menuInventarios(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Inventarios ---");
            System.out.println("1. Crear Inventario");
            System.out.println("2. Modificar Inventario");
            System.out.println("3. Eliminar Inventario");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese la fecha (YYYY-MM-DD): ");
                    String fechastr = scanner.nextLine();
                    Date fecha = Date.valueOf(fechastr);
                    System.out.print("Ingrese el tipo de movimiento (ENTRADA o SALIDA): ");
                    String tipoMovimiento = scanner.nextLine();
                    System.out.print("Ingrese las observaciones: ");
                    String observaciones = scanner.nextLine();
                    System.out.print("Ingrese el ID del producto: ");
                    int idProducto = scanner.nextInt();

                    agregarInventario(connection, fecha, tipoMovimiento, observaciones, idProducto);
                    break;
                case 2:
                    System.out.print("Ingrese el ID del inventario a modificar: ");
                    int idModificar = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese la nueva fecha (YYYY-MM-DD): ");
                    String nuevaFechastr = scanner.nextLine();
                    Date nuevaFecha = Date.valueOf(nuevaFechastr);
                    System.out.print("Ingrese el nuevo tipo de movimiento: ");
                    String nuevoTipoMovimiento = scanner.nextLine();
                    System.out.print("Ingrese las nuevas observaciones: ");
                    String nuevasObservaciones = scanner.nextLine();
                    System.out.print("Ingrese el nuevo ID del producto: ");
                    int nuevoIdProducto = scanner.nextInt();

                    actualizarInventario(connection, idModificar, nuevaFecha, nuevoTipoMovimiento,
                            nuevasObservaciones, nuevoIdProducto);
                    break;
                case 3:
                    System.out.print("Ingrese el ID del inventario a eliminar: ");
                    int idEliminar = scanner.nextInt();
                    eliminarInventario(connection, idEliminar);
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
