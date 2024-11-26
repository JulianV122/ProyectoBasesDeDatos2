package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;
import java.sql.ResultSet;

public class Producto {
    public static boolean agregarProducto(Connection connection, String codigo, String nombre, String descripcion,
            float precio, String medida, int impuestoId, int categoriaId, int stock) {
        String sql = "CALL proyecto.crear_producto(?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, codigo);
            stmt.setString(2, nombre);
            stmt.setString(3, descripcion);
            stmt.setFloat(4, precio);
            stmt.setString(5, medida);
            stmt.setInt(6, impuestoId);
            stmt.setInt(7, categoriaId);
            stmt.setInt(8, stock);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean modificarProducto(Connection connection, int id, String codigo, String nombre,
            String descripcion, float precio, String medida, int impuestoId, int categoriaId, int stock) {
        String sql = "CALL proyecto.modificar_producto(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, codigo);
            stmt.setString(3, nombre);
            stmt.setString(4, descripcion);
            stmt.setFloat(5, precio);
            stmt.setString(6, medida);
            stmt.setInt(7, impuestoId);
            stmt.setInt(8, categoriaId);
            stmt.setInt(9, stock);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarProducto(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_producto(?)";
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

    public static void obtenerProductos(Connection connection) {
        String sql = "SELECT * FROM proyecto.listar_productos()";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                System.out.println("---------------------------");
                System.out.println(rs.getInt("v_id"));
                System.out.println(rs.getString("v_codigo"));
                System.out.println(rs.getString("v_nombre"));
                System.out.println(rs.getString("v_descripcion"));
                System.out.println(rs.getFloat("v_precio"));
                System.out.println(rs.getString("v_medida"));
                System.out.println(rs.getInt("v_impuesto_id"));
                System.out.println(rs.getInt("v_categoria_id"));
                System.out.println(rs.getInt("v_stock"));
            }
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void menuProductos(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Productos ---");
            System.out.println("1. Crear Producto");
            System.out.println("2. Modificar Producto");
            System.out.println("3. Eliminar Producto");
            System.out.println("4. Listar Productos");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el código del producto: ");
                    String codigo = scanner.nextLine();
                    System.out.print("Ingrese el nombre del producto: ");
                    String nombre = scanner.nextLine();
                    System.out.print("Ingrese la descripción del producto: ");
                    String descripcion = scanner.nextLine();
                    System.out.print("Ingrese el precio del producto: ");
                    float precio = scanner.nextFloat();
                    scanner.nextLine();
                    System.out.print("Ingrese la medida del producto: ");
                    String medida = scanner.nextLine();
                    System.out.print("Ingrese el ID del impuesto: ");
                    int impuestoId = scanner.nextInt();
                    System.out.print("Ingrese el ID de la categoría: ");
                    int categoriaId = scanner.nextInt();
                    System.out.print("Ingrese el stock del producto: ");
                    int stock = scanner.nextInt();

                    agregarProducto(connection, codigo, nombre, descripcion, precio, medida, impuestoId,
                            categoriaId, stock);
                    break;
                case 2:
                    System.out.print("Ingrese el ID del producto a modificar: ");
                    int idModificar = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese el nuevo código: ");
                    String nuevoCodigo = scanner.nextLine();
                    System.out.print("Ingrese el nuevo nombre: ");
                    String nuevoNombre = scanner.nextLine();
                    System.out.print("Ingrese la nueva descripción: ");
                    String nuevaDescripcion = scanner.nextLine();
                    System.out.print("Ingrese el nuevo precio: ");
                    float nuevoPrecio = scanner.nextFloat();
                    scanner.nextLine();
                    System.out.print("Ingrese la nueva medida: ");
                    String nuevaMedida = scanner.nextLine();
                    System.out.print("Ingrese el nuevo ID del impuesto: ");
                    int nuevoImpuestoId = scanner.nextInt();
                    System.out.print("Ingrese el nuevo ID de la categoría: ");
                    int nuevoCategoriaId = scanner.nextInt();
                    System.out.print("Ingrese el nuevo stock: ");
                    int nuevoStock = scanner.nextInt();

                    modificarProducto(connection, idModificar, nuevoCodigo, nuevoNombre, nuevaDescripcion,
                            nuevoPrecio, nuevaMedida, nuevoImpuestoId, nuevoCategoriaId, nuevoStock);
                    break;
                case 3:
                    System.out.print("Ingrese el ID del producto a eliminar: ");
                    int idEliminar = scanner.nextInt();
                    eliminarProducto(connection, idEliminar);
                    break;
                case 4:
                    obtenerProductos(connection);
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
