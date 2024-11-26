package models;

import java.sql.CallableStatement;
import java.sql.Connection;
//import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Clientes {
    public static boolean agregarCliente(Connection connection, String documento, String nombre, String direccion,
            String telefono, String email, String ciudad, String departamento) {
        String sql = "CALL proyecto.crear_cliente(?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, documento);
            stmt.setString(2, nombre);
            stmt.setString(3, direccion);
            stmt.setString(4, telefono);
            stmt.setString(5, email);
            stmt.setString(6, ciudad);
            stmt.setString(7, departamento);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarCliente(Connection connection, int id, String documento, String nombre,
            String direccion, String telefono, String email, String ciudad, String departamento) {
        String sql = "CALL proyecto.editar_cliente(?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, documento);
            stmt.setString(3, nombre);
            stmt.setString(4, direccion);
            stmt.setString(5, telefono);
            stmt.setString(6, email);
            stmt.setString(7, ciudad);
            stmt.setString(8, departamento);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarCliente(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_cliente(?)";
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

    public static void menuClientes(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Clientes ---");
            System.out.println("1. Crear Cliente");
            System.out.println("2. Modificar Cliente");
            System.out.println("3. Eliminar Cliente");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el número de documento: ");
                    String documento = scanner.nextLine();
                    System.out.print("Ingrese el nombre del cliente: ");
                    String nombre = scanner.nextLine();
                    System.out.print("Ingrese la dirección del cliente: ");
                    String direccion = scanner.nextLine();
                    System.out.print("Ingrese el teléfono del cliente: ");
                    String telefono = scanner.nextLine();
                    System.out.print("Ingrese el email del cliente: ");
                    String email = scanner.nextLine();
                    System.out.print("Ingrese la ciudad del cliente: ");
                    String ciudad = scanner.nextLine();
                    System.out.print("Ingrese el departamento del cliente: ");
                    String departamento = scanner.nextLine();

                    agregarCliente(connection, documento, nombre, direccion, telefono, email, ciudad,
                            departamento);
                    break;
                case 2:
                    System.out.print("Ingrese el ID del cliente a modificar: ");
                    int idModificar = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese el nuevo número de documento: ");
                    String nuevoDocumento = scanner.nextLine();
                    System.out.print("Ingrese el nuevo nombre: ");
                    String nuevoNombre = scanner.nextLine();
                    System.out.print("Ingrese la nueva dirección: ");
                    String nuevaDireccion = scanner.nextLine();
                    System.out.print("Ingrese el nuevo teléfono: ");
                    String nuevoTelefono = scanner.nextLine();
                    System.out.print("Ingrese el nuevo email: ");
                    String nuevoEmail = scanner.nextLine();
                    System.out.print("Ingrese la nueva ciudad: ");
                    String nuevaCiudad = scanner.nextLine();
                    System.out.print("Ingrese el nuevo departamento: ");
                    String nuevoDepartamento = scanner.nextLine();

                    modificarCliente(connection, idModificar, nuevoDocumento, nuevoNombre, nuevaDireccion,
                            nuevoTelefono, nuevoEmail, nuevaCiudad, nuevoDepartamento);
                    break;
                case 3:
                    System.out.print("Ingrese el ID del cliente a eliminar: ");
                    int idEliminar = scanner.nextInt();
                    eliminarCliente(connection, idEliminar);
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
