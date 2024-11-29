package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;



public class Categoria {
    public static boolean agregarCategoria(Connection connection, String descripcion) {
        String sql = "CALL proyecto.crear_categoria(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, descripcion);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarCategoria(Connection connection, int id, String descripcion) {
        String sql = "CALL proyecto.modificar_categoria(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, descripcion);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarCategoria(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_categoria(?)";
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
    
    public static void menuCategorias(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Categorías ---");
            System.out.println("1. Crear categoría");
            System.out.println("2. Modificar categoría");
            System.out.println("3. Eliminar categoría");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese la descripción de la categoría: ");
                    String descripcionCa = scanner.nextLine();

                    if (agregarCategoria(connection, descripcionCa)) {
                        System.out.println("Categoría agregada exitosamente.");
                    } else {
                        System.out.println("Ocurrió un error al agregar la categoría.");
                    }
                    break;
                case 2:
                    System.out.print("Ingrese el id de la categoría a modificar: ");
                    int idModificarCa = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese la nueva descripción de la categoría: ");
                    String nuevaDescripcionCa = scanner.nextLine();
                    

                    if (modificarCategoria(connection, idModificarCa, nuevaDescripcionCa)) {
                        System.out.println("Categoría modificada exitosamente.");
                    } else {
                        System.out.println("Ocurrió un error al modificar la categoría.");
                    }
                    break;
                case 3:
                    System.out.print("Ingrese el id de la categoría a eliminar: ");
                    int idEliminarCa = scanner.nextInt();

                    if (eliminarCategoria(connection, idEliminarCa)) {
                        System.out.println("Categoría eliminada exitosamente.");
                    } else {
                        System.out.println("Ocurrió un error al eliminar la categoría.");
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