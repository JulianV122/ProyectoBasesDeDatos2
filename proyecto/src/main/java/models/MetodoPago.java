package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

public class MetodoPago {

    // Agregar un método de pago
    public static boolean agregarMetodoPago(Connection connection, String descripcion, String identificador) {
        String sql = "CALL proyecto.crear_metodo_pago(?, ?)";
        try {
            if (descripcion.isEmpty() || identificador.isEmpty()) {
                System.out.println("Error: La descripción y el identificador no pueden estar vacíos.");
                return false;
            }

            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, descripcion);         
            stmt.setString(2, identificador);     
            stmt.execute();                         
            stmt.close();                           
            return true;                            

        } catch (SQLException e) {
            System.out.println("Error al agregar el método de pago: " + e.getMessage());     
            return false;                            
        }
    }

    // Modificar un método de pago
    public static boolean modificarMetodoPago(Connection connection, int id, String descripcion, String identificador) {
        String sql = "CALL proyecto.modificar_metodo_pago(?, ?, ?)";
        try {
            if (descripcion.isEmpty() || identificador.isEmpty()) {
                System.out.println("Error: La descripción y el identificador no pueden estar vacíos.");
                return false;
            }

            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);                    
            stmt.setString(2, descripcion);        
            stmt.setString(3, identificador);      
            stmt.execute();                         
            stmt.close();                           

            return true;                           

        } catch (SQLException e) {
            System.out.println("Error al modificar el método de pago: " + e.getMessage());  
            return false;                          
        }
    }

    // Eliminar un método de pago
    public static boolean eliminarMetodoPago(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_metodo_pago(?)";
        try {
            // Validación de ID
            if (id <= 0) {
                System.out.println("Error: El ID del método de pago no es válido.");
                return false;
            }

            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);                   
            stmt.execute();                         
            stmt.close();                           
            return true;                            

        } catch (SQLException e) {
            System.out.println("Error al eliminar el método de pago: " + e.getMessage()); 
            return false;                          
        }
    }

    // Menú de métodos de pago
    public static void menuMetodosPago(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Métodos de Pago ---");
            System.out.println("1. Crear Método de Pago");
            System.out.println("2. Modificar Método de Pago");
            System.out.println("3. Eliminar Método de Pago");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese la descripción del método de pago: ");
                    String descripcion = scanner.nextLine();
                    System.out.print("Ingrese el identificador del método de pago: ");
                    String identificador = scanner.nextLine();
                    if (agregarMetodoPago(connection, descripcion, identificador)) {
                        System.out.println("Método de pago creado correctamente.");
                    } else {
                        System.out.println("No se pudo crear el método de pago.");
                    }
                    break;
                case 2:
                    System.out.print("Ingrese el ID del método de pago a modificar: ");
                    int idModificar = scanner.nextInt();
                    scanner.nextLine(); // Limpiar el buffer
                    System.out.print("Ingrese la nueva descripción: ");
                    String nuevaDescripcion = scanner.nextLine();
                    System.out.print("Ingrese el nuevo identificador: ");
                    String nuevoIdentificador = scanner.nextLine();
                    if (modificarMetodoPago(connection, idModificar, nuevaDescripcion, nuevoIdentificador)) {
                        System.out.println("Método de pago modificado correctamente.");
                    } else {
                        System.out.println("No se pudo modificar el método de pago.");
                    }
                    break;
                case 3:
                    System.out.print("Ingrese el ID del método de pago a eliminar: ");
                    int idEliminar = scanner.nextInt();
                    if (eliminarMetodoPago(connection, idEliminar)) {
                        System.out.println("Método de pago eliminado correctamente.");
                    } else {
                        System.out.println("No se pudo eliminar el método de pago.");
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
