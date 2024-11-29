package models;

import java.sql.Date;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Informe {

    public static boolean crearInforme(Connection connection, String tipoInforme, Date fecha, String datosJson) {
        String sql = "CALL proyecto.crear_informe(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, tipoInforme);
            stmt.setDate(2, fecha);
            stmt.setString(3, datosJson);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean editarInforme(Connection connection, int id, String tipoInforme, Date fecha,
            String datosJson) {
        String sql = "CALL proyecto.editar_informe(?, ?, ?, ?::jsonb)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, tipoInforme);
            stmt.setDate(3, fecha);
            stmt.setString(4, datosJson);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarInforme(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_informe(?)";
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

    public static ResultSet obtenerInformeTop10(Connection connection) {
        String sql = "SELECT * FROM proyecto.informe_top10()";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int productoId = rs.getInt("producto_id");
                String codigo = rs.getString("codigo");
                String nombre = rs.getString("nombre");
                long totalVendido = rs.getLong("total_vendido");
                int facturaId = rs.getInt("factura_id");

                System.out.println("Producto ID: " + productoId + ", Código: " + codigo + ", Nombre: " + nombre
                        + ", Total Vendido: " + totalVendido + ", Factura ID: " + facturaId);
            }
            return rs;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void insertarInformeTop10(Connection connection) {
        String sql = "CALL proyecto.insertar_informe_top10()";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.execute();
            stmt.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static ResultSet obtenerInformeVentasMensual(Connection connection, int anio, int mes) {
        String sql = "SELECT * FROM proyecto.informe_ventas_mensual(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, anio);
            stmt.setInt(2, mes);
            return stmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void menuInformes(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Informes ---");
            System.out.println("1. Crear informe");
            System.out.println("2. Modificar informe");
            System.out.println("3. Eliminar informe");
            System.out.println("4. Obtener informe Top 10");
            System.out.println("5. Insertar informe Top 10");
            System.out.println("6. Obtener informe Ventas Mensual");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el tipo de informe: ");
                    String tipoInforme = scanner.nextLine();
                    System.out.print("Ingrese la fecha del informe (YYYY-MM-DD): ");
                    String fechaStr = scanner.nextLine();
                    Date fecha = Date.valueOf(fechaStr);
                    System.out.print("Ingrese los datos del informe: ");
                    String datosJson = scanner.nextLine();
                    if (crearInforme(connection, tipoInforme, fecha, datosJson)) {
                        System.out.println("Informe creado exitosamente.");
                    } else {
                        System.out.println("Error al crear el informe.");
                    }
                    break;
                case 2:
                    System.out.print("Ingrese el id del informe a modificar: ");
                    int idModificar = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese el tipo de informe: ");
                    String tipoInformeModificar = scanner.nextLine();
                    System.out.print("Ingrese la fecha del informe: ");
                    String nuevaFechaStr = scanner.nextLine();
                    Date nuevaFecha = Date.valueOf(nuevaFechaStr);
                    System.out.print("Ingrese los datos del informe: ");
                    String datosJsonModificar = scanner.nextLine();

                    if (editarInforme(connection, idModificar, tipoInformeModificar, nuevaFecha, datosJsonModificar)) {
                        System.out.println("Informe modificado exitosamente.");
                    } else {
                        System.out.println("Error al modificar el informe.");
                    }
                    break;
                case 3:
                    System.out.print("Ingrese el id del informe a eliminar: ");
                    int idEliminar = scanner.nextInt();
                    scanner.nextLine();

                    if (eliminarInforme(connection, idEliminar)) {
                        System.out.println("Informe eliminado exitosamente.");
                    } else {
                        System.out.println("Error al eliminar el informe.");
                    }
                    break;
                case 4:
                    ResultSet informeTop10 = obtenerInformeTop10(connection);
                    try {
                        while (informeTop10.next()) {
                            System.out.println("Producto_id: " +informeTop10.getInt("producto_id") + " | " + "Codigo: " + informeTop10.getString("codigo") + " | " + "Nombre: " + informeTop10.getString("nombre") + " | " + "Total vendido: " + informeTop10.getBigDecimal("total_vendido") + " | " + "Factura_id: " +  informeTop10.getInt("factura_id"));
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    break;
                case 5:
                    insertarInformeTop10(connection);                    
                    break;
                
                case 6:
                    System.out.print("Ingrese el año del informe: ");
                    int anio = scanner.nextInt();
                    System.out.print("Ingrese el mes del informe: ");
                    int mes = scanner.nextInt();
                    scanner.nextLine();

                    ResultSet informeVentasMensual = obtenerInformeVentasMensual(connection, anio, mes);
                    try {
                        while (informeVentasMensual.next()) {
                            System.out.println("ID Factura: " + informeVentasMensual.getInt("factura_id") + " | " + "Codigo Factura: " + informeVentasMensual.getString("codigo_factura") + " | " + "Fecha factura: " +  informeVentasMensual.getDate("fecha_factura") + " | " + "ID producto: " + informeVentasMensual.getInt("producto_id") + " | " + "Nombre producto: " +  informeVentasMensual.getString("producto_nombre") + " | " + "Cantidad vendida: " +  informeVentasMensual.getInt("cantidad_vendida") + " | " + "Valor total producto: " +  informeVentasMensual.getDouble("valor_total_producto") + " | " + "Subtotal mensual: " + informeVentasMensual.getDouble("subtotal_mensual") + " | " + "Impuestos mensuales: " +  informeVentasMensual.getDouble("impuestos_mensuales")  + " | " + "Total facturado: " + informeVentasMensual.getDouble("total_facturado"));
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
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
