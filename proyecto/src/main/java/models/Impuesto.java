package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

public class Impuesto {
    public static boolean agregarImpuesto(Connection connection, String nombre, float porcentaje) {
        String sql = "CALL proyecto.crear_impuesto(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, nombre);
            stmt.setFloat(2, porcentaje);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarImpuesto(Connection connection, int id, String nombre, float porcentaje) {
        String sql = "CALL proyecto.modificar_impuesto(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, nombre);
            stmt.setFloat(3, porcentaje);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarImpuesto(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_impuesto(?)";
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

    public static void menuImpuestos(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Impuestos ---");
            System.out.println("1. Crear impuesto");
            System.out.println("2. Modificar impuesto");
            System.out.println("3. Eliminar impuesto");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el nombre del impuesto: ");
                    String nombreIm = scanner.nextLine();
                    System.out.print("Ingrese el porcentaje del impuesto: ");
                    float porcentaje = scanner.nextFloat();

                    if (agregarImpuesto(connection, nombreIm, porcentaje)) {
                        System.out.println("Impuesto agregado correctamente.");
                    } else {
                        System.out.println("Error al agregar el impuesto.");
                    }
                    break;
                case 2:
                    System.out.print("Ingrese el id del impuesto a modificar: ");
                    int idModificarIm = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese el nuevo nombre del impuesto: ");
                    String nuevoNombreIm = scanner.nextLine();
                    System.out.print("Ingrese el nuevo porcentaje del impuesto: ");
                    float nuevoPorcentaje = scanner.nextFloat();

                    if (modificarImpuesto(connection, idModificarIm, nuevoNombreIm, nuevoPorcentaje)) {
                        System.out.println("Impuesto modificado correctamente.");
                    } else {
                        System.out.println("Error al modificar el impuesto.");
                    }
                    break;
                case 3:
                    System.out.print("Ingrese el id del impuesto a eliminar: ");
                    int idEliminarIm = scanner.nextInt();

                    if (eliminarImpuesto(connection, idEliminarIm)) {
                        System.out.println("Impuesto eliminado correctamente.");
                    } else {
                        System.out.println("Error al eliminar el impuesto.");
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
