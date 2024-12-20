package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

import com.mongodb.client.MongoCollection;
import org.bson.Document;

public class Factura {

    public static boolean agregarFactura(Connection connection, String codigo, Date fecha, String estadoF,
            int idCliente, int idMetodoPago) {
        String sql = "CALL proyecto.agregar_factura(?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, codigo);
            stmt.setDate(2, fecha);
            stmt.setString(3, estadoF);
            stmt.setInt(4, idCliente);
            stmt.setInt(5, idMetodoPago);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean modificarFactura(Connection connection, int id, Date fecha, String estadoF, int idCliente,
            int idMetodoPago) {
        String sql = "CALL proyecto.modificar_factura(?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setDate(2, fecha);
            stmt.setString(3, estadoF);
            stmt.setInt(4, idCliente);
            stmt.setInt(5, idMetodoPago);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarFactura(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_factura(?)";
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

    public static boolean agregarClienteAFactura(Connection connection, int facturaId, int clienteId) {
        String sql = "SELECT proyecto.agregar_cliente_a_factura(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setInt(2, clienteId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean agregarProductoADetalleFactura(MongoCollection<Document> collection, Connection connection, int facturaId, int productoId,
            int cantidad) {
        String sql = "SELECT proyecto.agregar_producto_a_detalle_factura(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setInt(2, productoId);
            stmt.setInt(3, cantidad);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();

            int idDetalle = 0;
            String ultimoDetalleSql = "SELECT MAX(id) FROM proyecto.detalles_facturas";
            CallableStatement ultimoDetalleStmt = connection.prepareCall(ultimoDetalleSql);
            ResultSet ultimoDetalleRs = ultimoDetalleStmt.executeQuery();
            if (ultimoDetalleRs.next()) {
                idDetalle = ultimoDetalleRs.getInt(1);
            }
            ultimoDetalleRs.close();
            ultimoDetalleStmt.close();

            String detalleSql = "SELECT * FROM proyecto.obtener_detalle_factura_info(?)";
            CallableStatement detalleStmt = connection.prepareCall(detalleSql);
            detalleStmt.setInt(1, idDetalle);
            ResultSet detalleRs = detalleStmt.executeQuery();
            if (detalleRs.next()) {
                Date fecha = detalleRs.getDate("fecha_factura");
                String nombreCliente = detalleRs.getString("nombre_cliente");
                int cantidadD = detalleRs.getInt("cantidad");
                String producto = detalleRs.getString("nombre_producto");
                double total = detalleRs.getDouble("total_venta");

                AuditoriaMongo.insertarAuditoria(collection, idDetalle, fecha, nombreCliente, cantidadD, producto, total);

            }
            detalleRs.close();
            detalleStmt.close();

            
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean calcularImpuestosFactura(Connection connection, int facturaId) {
        String sql = "SELECT proyecto.calcular_impuestos_factura(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean aplicarDescuentoFactura(Connection connection, int facturaId, String tipoDescuento,
            double valorDescuento) {
        String sql = "SELECT proyecto.aplicar_descuento_factura(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setString(2, tipoDescuento);
            stmt.setDouble(3, valorDescuento);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean agregarMetodoPagoAFactura(Connection connection, int facturaId, int metodoPagoId) {
        String sql = "SELECT proyecto.agregar_metodo_pago_a_factura(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setInt(2, metodoPagoId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static int obtenerUltimaFacturaId(Connection connection) {
        String sql = "SELECT MAX(id) FROM proyecto.facturas";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Menú de Facturas
    public static void menuFacturas(Scanner scanner, Connection connection, MongoCollection<Document> collection) {
        int option;
        do {
            System.out.println("\n--- Facturas ---");
            System.out.println("1. Crear Factura");
            System.out.println("2. Modificar Factura");
            System.out.println("3. Eliminar Factura");
            System.out.println("4. Agregar Cliente a Factura");
            System.out.println("5. Agregar Producto a Detalle de Factura");
            System.out.println("6. Calcular Impuestos de Factura");
            System.out.println("7. Aplicar Descuento a Factura");
            System.out.println("8. Agregar Método de Pago a Factura");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el código de la factura: ");
                    String codigoFactura = scanner.nextLine();
                    System.out.print("Ingrese la fecha de la factura (YYYY-MM-DD): ");
                    String fechaStr = scanner.nextLine();
                    Date fecha = Date.valueOf(fechaStr);
                    scanner.nextLine();
                    System.out.print("Ingrese el estado de la factura (PAGADA, PENDIENTE, EN PROCESO): ");
                    System.out.println("Seleccione el estado de la factura:");
                    System.out.println("1. PAGADA");
                    System.out.println("2. PENDIENTE");
                    System.out.println("3. EN PROCESO");
                    int estadoOption = scanner.nextInt();
                    scanner.nextLine();
                    String estadoF;
                    switch (estadoOption) {
                        case 1:
                            estadoF = "PAGADA";
                            break;
                        case 2:
                            estadoF = "PENDIENTE";
                            break;
                        case 3:
                            estadoF = "EN PROCESO";
                            break;
                        default:
                            System.out.println("Opción no válida. Se establecerá el estado como PENDIENTE.");
                            estadoF = "PENDIENTE";
                    }
                    System.out.print("Ingrese el ID del cliente: ");
                    int idCliente = scanner.nextInt();
                    System.out.print("Ingrese el ID del método de pago: ");
                    int idMetodoPago = scanner.nextInt();
                    if (agregarFactura(connection, codigoFactura, fecha, estadoF,
                            idCliente, idMetodoPago)) {
                        System.out.println("\nFactura greada correctamente.");
                    } else {
                        System.out.println("\nNo se pudo crear la factura.");
                    }
                    break;
                case 2:
                    System.out.print("Ingrese el ID de la factura a modificar: ");
                    int idFacturaModificar = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese la nueva fecha de la factura (YYYY-MM-DD): ");
                    String nuevaFechaStr = scanner.nextLine();
                    Date nuevaFecha = Date.valueOf(nuevaFechaStr);
                    scanner.nextLine();
                    System.out.print("Ingrese el estado de la factura (PAGADA, PENDIENTE, EN PROCESO): ");
                    System.out.println("Seleccione el estado de la factura:");
                    System.out.println("1. PAGADA");
                    System.out.println("2. PENDIENTE");
                    System.out.println("3. EN PROCESO");
                    int estadoOptionn = scanner.nextInt();
                    scanner.nextLine();
                    String nuevoEstadoF;
                    switch (estadoOptionn) {
                        case 1:
                            nuevoEstadoF = "PAGADA";
                            break;
                        case 2:
                            nuevoEstadoF = "PENDIENTE";
                            break;
                        case 3:
                            nuevoEstadoF = "EN PROCESO";
                            break;
                        default:
                            System.out.println("Opción no válida. Se establecerá el estado como PENDIENTE.");
                            nuevoEstadoF = "PENDIENTE";
                    }
                    System.out.print("Ingrese el nuevo ID del cliente: ");
                    int nuevoIdCliente = scanner.nextInt();
                    System.out.print("Ingrese el nuevo ID del método de pago: ");
                    int nuevoIdMetodoPago = scanner.nextInt();
                    if (modificarFactura(connection, idFacturaModificar, nuevaFecha, nuevoEstadoF, nuevoIdCliente,
                            nuevoIdMetodoPago)) {
                        System.out.println("\nFactura modificada correctamente.");
                    } else {
                        System.out.println("\nNo se pudo modificar la factura.");
                    }
                    break;
                case 3:
                    System.out.print("Ingrese el ID de la factura a eliminar: ");
                    int idFacturaEliminar = scanner.nextInt();
                    if (eliminarFactura(connection, idFacturaEliminar)) {
                        System.out.println("\nFactura eliminada correctamente.");
                    } else {
                        System.out.println("\nNo se pudo eliminar la factura.");
                    }
                    break;
                case 4:
                    System.out.print("Ingrese el ID de la factura: ");
                    int idFactura = scanner.nextInt();
                    System.out.print("Ingrese el ID del cliente: ");
                    int idClienteF = scanner.nextInt();
                    if (agregarClienteAFactura(connection, idFactura, idClienteF)) {
                        System.out.println("\nCliente agregado a la factura correctamente.");
                    } else {
                        System.out.println("\nNo se pudo agregar el cliente a la factura.");
                    }
                    break;
                case 5:
                    System.out.print("Ingrese el ID de la factura: ");
                    int idFacturaD = scanner.nextInt();
                    System.out.print("Ingrese el ID del producto: ");
                    int idProducto = scanner.nextInt();
                    System.out.print("Ingrese la cantidad: ");
                    int cantidad = scanner.nextInt();
                    if (agregarProductoADetalleFactura(collection, connection, idFacturaD, idProducto, cantidad)) {
                        System.out.println("\nProducto agregado al detalle de la factura correctamente.");
                    } else {
                        System.out.println("\nNo se pudo agregar el producto al detalle de la factura.");
                    }
                    break;
                case 6:
                    System.out.print("Ingrese el ID de la factura: ");
                    int idFacturaImp = scanner.nextInt();
                    if (calcularImpuestosFactura(connection, idFacturaImp)) {
                        System.out.println("\nImpuestos calculados correctamente.");
                    } else {
                        System.out.println("\nNo se pudieron calcular los impuestos.");
                    }
                    break;
                case 7:
                    System.out.print("Ingrese el ID de la factura: ");
                    int idFacturaDesc = scanner.nextInt();
                    System.out.print("Seleccione el tipo de descuento:");
                    System.out.println("\n1. POR_PRODUCTO");
                    System.out.println("2. VALOR");
                    int tipoDescuentoOption = scanner.nextInt();
                    String tipoDescuento;
                    switch (tipoDescuentoOption) {
                        case 1:
                            tipoDescuento = "POR_PRODUCTO";
                            break;
                        case 2:
                            tipoDescuento = "VALOR";
                            break;
                        default:
                            System.out.println("Opción no válida. Se establecerá el descuento como POR_PRODUCTO.");
                            tipoDescuento = "POR_PRODUCTO";
                    }
                    System.out.print("Ingrese el valor del descuento: ");
                    double valorDescuento = scanner.nextDouble();
                    if (aplicarDescuentoFactura(connection, idFacturaDesc, tipoDescuento, valorDescuento)) {
                        System.out.println("\nDescuento aplicado correctamente.");
                    } else {
                        System.out.println("\nNo se pudo aplicar el descuento.");
                    }
                    break;
                case 8:
                    System.out.print("Ingrese el ID de la factura: ");
                    int idFacturaMP = scanner.nextInt();
                    System.out.print("Ingrese el ID del método de pago: ");
                    int idMetodoPagoF = scanner.nextInt();
                    if (agregarMetodoPagoAFactura(connection, idFacturaMP, idMetodoPagoF)) {
                        System.out.println("\nMétodo de pago agregado a la factura correctamente.");
                    } else {
                        System.out.println("\nNo se pudo agregar el método de pago a la factura.");
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
