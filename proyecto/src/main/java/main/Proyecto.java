package main;

import models.*;
import org.bson.Document;
import com.mongodb.client.MongoCollection;

import connection.ConexionMongo;
import connection.ConexionPostgres;

import java.sql.Connection;
import java.util.Scanner;
import java.sql.Date;

import utils.Builder;

public class Proyecto {

    public static void main(String[] args) {

        // Producto.agregarProducto(connection, "123", "Producto 1", "Descripcion 1",
        // 100, "unidad", 2, 4, 10);

        // Producto.obtenerProductos(connection);

        // Clientes.agregarCliente(connection, "1234", "Alberto", "Calle 1234",
        // "31287637421", "Alberto@gmail.com", "Manizales", "Caldas");

        Scanner scanner = new Scanner(System.in);
        int option;

        MongoCollection<Document> collection = ConexionMongo.getCollection();
        Connection connection = ConexionPostgres.getConnection();
        Builder.buildAll(connection);

        do {
            // Mostrar menú de opciones
            System.out.println("\nSeleccione el procedimiento a ejecutar:");
            System.out.println("1. Crear Método de Pago");
            System.out.println("2. Modificar Método de Pago");
            System.out.println("3. Eliminar Método de Pago");
            System.out.println("4. Crear Factura");
            System.out.println("5. Modificar Factura");
            System.out.println("6. Eliminar Factura");
            System.out.println("7. Crear Producto");
            System.out.println("8. Modificar Producto");
            System.out.println("9. Eliminar Producto");
            System.out.println("10. Crear Cliente");
            System.out.println("11. Modificar Cliente");
            System.out.println("12. Eliminar Cliente");
            System.out.println("13. Crear Inventario");
            System.out.println("14. Modificar Inventario");
            System.out.println("15. Eliminar Inventario");
            System.out.println("16. Crear categoría");
            System.out.println("17. Modificar categoría");
            System.out.println("18. Eliminar categoría");
            System.out.println("19. Crear Detalle Factura");
            System.out.println("20. Modificar Detalle Factura ");
            System.out.println("21. Eliminar Detalle Factura ");
            System.out.println("22. Crear impuesto");
            System.out.println("23. Modificar impuesto ");
            System.out.println("24. Eliminar impuesto ");
            System.out.println("0. Salir");

            System.out.print("Opción: ");
            option = scanner.nextInt();

            switch (option) {
                case 1:
                    System.out.print("Ingrese la descripción del método de pago: ");
                    String descripcion = scanner.nextLine();
                    System.out.print("Ingrese el identificador del método de pago : ");
                    String identificador = scanner.nextLine();
                    MetodoPago.agregarMetodoPago(connection, descripcion, identificador);
                    break;
                case 2:
                    System.out.print("Ingrese el id del método de pago a modificar: ");
                    int idModificar = scanner.nextInt();
                    System.out.print("Ingrese la nueva descripción del método de pago: ");
                    String nuevaDescripcion = scanner.nextLine();
                    System.out.print("Ingrese el nuevo identificador del método de pago: ");
                    String nuevoIdentificador = scanner.nextLine();
                    MetodoPago.modificarMetodoPago(connection, idModificar, nuevaDescripcion, nuevoIdentificador);
                    break;
                case 3:
                    System.out.print("Ingrese el id del método de pago a eliminar: ");
                    int idEliminar = scanner.nextInt();
                    MetodoPago.eliminarMetodoPago(connection, idEliminar);
                    break;
                case 4:
                    System.out.print("Ingrese el código de la factura: ");
                    String codigoFactura = scanner.nextLine();
                    System.out.print("Ingrese la fecha de la factura: ");
                    String fechaStr = scanner.nextLine();
                    Date fecha = Date.valueOf(fechaStr);
                    System.out.print("Ingrese el subtotal: ");
                    double subtotal = scanner.nextDouble();
                    System.out.print("Ingrese el total de impuestos: ");
                    double totalImpuestos = scanner.nextDouble();
                    System.out.print("Ingrese el total: ");
                    double total = scanner.nextDouble();
                    System.out.print("Ingrese el estado de la factura (PAGADA, PENDIENTE, EN PROCESO): ");
                    String estadoF = scanner.nextLine();
                    System.out.print("Ingrese el id del cliente: ");
                    int idCliente = scanner.nextInt();
                    System.out.print("Ingrese el id del método de pago: ");
                    int idMetodoPago = scanner.nextInt();
                    Factura.agregarFactura(connection, codigoFactura, fecha, subtotal, totalImpuestos, total,
                            estadoF, idCliente, idMetodoPago);
                    break;
                case 5:
                    System.out.print("Ingrese el id de la factura a modificar: ");
                    int idFacturaModificar = scanner.nextInt();
                    System.out.print("Ingrese el nuevo código de la factura: ");
                    String nuevoCodigoFactura = scanner.nextLine();
                    System.out.print("Ingrese la nueva fecha de la factura: ");
                    String nuevaFechaStr = scanner.nextLine();
                    Date nuevaFecha = Date.valueOf(nuevaFechaStr);
                    System.out.print("Ingrese el nuevo subtotal: ");
                    double nuevoSubtotal = scanner.nextDouble();
                    System.out.print("Ingrese el nuevo total de impuestos: ");
                    double nuevoTotalImpuestos = scanner.nextDouble();
                    System.out.print("Ingrese el nuevo total: ");
                    double nuevoTotal = scanner.nextDouble();
                    System.out.print("Ingrese el nuevo estado de la factura (PAGADA, PENDIENTE, EN PROCESO): ");
                    String nuevoEstadoF = scanner.nextLine();
                    System.out.print("Ingrese el nuevo id del cliente: ");
                    int nuevoIdCliente = scanner.nextInt();
                    System.out.print("Ingrese el nuevo id del método de pago: ");
                    int nuevoIdMetodoPago = scanner.nextInt();
                    Factura.modificarFactura(connection, idFacturaModificar, nuevoCodigoFactura, nuevaFecha,
                            nuevoSubtotal, nuevoTotalImpuestos, nuevoTotal, nuevoEstadoF, nuevoIdCliente,
                            nuevoIdMetodoPago);
                    break;
                case 6:
                    System.out.print("Ingrese el id de la factura a eliminar: ");
                    int idFacturaEliminar = scanner.nextInt();
                    Factura.eliminarFactura(connection, idFacturaEliminar);
                    break;
                case 7:
                    System.out.print("Ingrese el código del producto: ");
                    String codigo = scanner.nextLine();
                    System.out.print("Ingrese el nombre del producto: ");
                    String nombre = scanner.nextLine();
                    System.out.print("Ingrese la descripción del producto: ");
                    String descripcionP = scanner.nextLine();
                    System.out.print("Ingrese el precio del producto: ");
                    float precio = scanner.nextFloat();
                    System.out.print("Ingrese la medida del producto: ");
                    String medida = scanner.nextLine();
                    System.out.print("Ingrese el id del impuesto: ");
                    int impuestoId = scanner.nextInt();
                    System.out.print("Ingrese el id de la categoría: ");
                    int categoriaId = scanner.nextInt();
                    System.out.print("Ingrese el stock del producto: ");
                    int stock = scanner.nextInt();

                    Producto.agregarProducto(connection, codigo, nombre, descripcionP, precio, medida, impuestoId,
                            categoriaId, stock);
                    break;
                case 8:
                    System.out.print("Ingrese el id del producto a modificar: ");
                    int idModificarP = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese el nuevo código del producto: ");
                    String nuevoCodigo = scanner.nextLine();
                    System.out.print("Ingrese el nuevo nombre del producto: ");
                    String nuevoNombre = scanner.nextLine();
                    System.out.print("Ingrese la nueva descripción del producto: ");
                    String nuevaDescripcionP = scanner.nextLine();
                    System.out.print("Ingrese el nuevo precio del producto: ");
                    float nuevoPrecio = scanner.nextFloat();
                    scanner.nextLine();
                    System.out.print("Ingrese la nueva medida del producto: ");
                    String nuevaMedida = scanner.nextLine();
                    System.out.print("Ingrese el nuevo id del impuesto: ");
                    int nuevoImpuestoId = scanner.nextInt();
                    System.out.print("Ingrese el nuevo id de la categoría: ");
                    int nuevoCategoriaId = scanner.nextInt();
                    System.out.print("Ingrese el nuevo stock del producto: ");
                    int nuevoStock = scanner.nextInt();

                    Producto.modificarProducto(connection, idModificarP, nuevoCodigo, nuevoNombre,
                            nuevaDescripcionP, nuevoPrecio, nuevaMedida, nuevoImpuestoId, nuevoCategoriaId,
                            nuevoStock);
                    break;
                case 9:
                    System.out.print("Ingrese el id del producto a eliminar: ");
                    int idEliminarP = scanner.nextInt();
                    Producto.eliminarProducto(connection, idEliminarP);
                    break;
                case 10:
                    System.out.print("Ingrese el número de documento del cliente: ");
                    String documento = scanner.nextLine();
                    System.out.print("Ingrese el nombre del cliente: ");
                    String nombreC = scanner.nextLine();
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

                    Clientes.agregarCliente(connection, documento, nombreC, direccion, telefono, email, ciudad,
                            departamento);
                    break;
                case 11:
                    System.out.print("Ingrese el id del cliente a modificar: ");
                    int idModificarC = scanner.nextInt();
                    System.out.print("Ingrese el nuevo número de documento del cliente: ");
                    String nuevoDocumento = scanner.nextLine();
                    System.out.print("Ingrese el nuevo nombre del cliente: ");
                    String nuevoNombreC = scanner.nextLine();
                    System.out.print("Ingrese la nueva dirección del cliente: ");
                    String nuevaDireccion = scanner.nextLine();
                    System.out.print("Ingrese el nuevo teléfono del cliente: ");
                    String nuevoTelefono = scanner.nextLine();
                    System.out.print("Ingrese el nuevo email del cliente: ");
                    String nuevoEmail = scanner.nextLine();
                    System.out.print("Ingrese la nueva ciudad del cliente: ");
                    String nuevaCiudad = scanner.nextLine();
                    System.out.print("Ingrese el nuevo departamento del cliente: ");
                    String nuevoDepartamento = scanner.nextLine();

                    Clientes.modificarCliente(connection, idModificarC, nuevoDocumento, nuevoNombreC,
                            nuevaDireccion, nuevoTelefono, nuevoEmail, nuevaCiudad, nuevoDepartamento);
                    break;
                case 12:
                    System.out.print("Ingrese el id del cliente a eliminar: ");
                    int idEliminarC = scanner.nextInt();
                    Clientes.eliminarCliente(connection, idEliminarC);
                    break;
                case 13:
                    System.out.print("Ingrese la fecha del inventario: ");
                    String fechaI = scanner.nextLine();
                    System.out.print("Ingrese el tipo de movimiento (ENTRADA o SALIDA): ");
                    String tipoMovimiento = scanner.nextLine();
                    System.out.print("Ingrese las observaciones del inventario: ");
                    String observaciones = scanner.nextLine();
                    System.out.print("Ingrese el id del producto: ");
                    int idProducto = scanner.nextInt();

                    Inventario.agregarInventario(connection, fechaI, tipoMovimiento, observaciones, idProducto);
                    break;
                case 14:
                    System.out.print("Ingrese el id del inventario a actualizar: ");
                    int idActualizar = scanner.nextInt();
                    System.out.print("Ingrese la nueva fecha del inventario : ");
                    String nuevaFechaI = scanner.nextLine();
                    System.out.print("Ingrese el nuevo tipo de movimiento (ENTRADA o SALIDA): ");
                    String nuevoTipoMovimiento = scanner.nextLine();
                    System.out.print("Ingrese las nuevas observaciones del inventario: ");
                    String nuevasObservaciones = scanner.nextLine();
                    System.out.print("Ingrese el nuevo id del producto: ");
                    int nuevoIdProducto = scanner.nextInt();

                    Inventario.actualizarInventario(connection, idActualizar, nuevaFechaI, nuevoTipoMovimiento,
                            nuevasObservaciones, nuevoIdProducto);
                    break;
                case 15:
                    System.out.print("Ingrese el id del inventario a eliminar: ");
                    int idEliminarI = scanner.nextInt();
                    Inventario.eliminarInventario(connection, idEliminarI);
                    break;
                case 16:
                    System.out.print("Ingrese la descripción de la categoría: ");
                    String descripcionCa = scanner.nextLine();

                    Categoria.agregarCategoria(connection, descripcionCa);
                    break;
                case 17:
                    System.out.print("Ingrese el id de la categoría a modificar: ");
                    int idModificarCa = scanner.nextInt();
                    System.out.print("Ingrese la nueva descripción de la categoría: ");
                    String nuevaDescripcionCa = scanner.nextLine();

                    Categoria.modificarCategoria(connection, idModificarCa, nuevaDescripcionCa);
                    break;
                case 18:
                    System.out.print("Ingrese el id de la categoría a eliminar: ");
                    int idEliminarCa = scanner.nextInt();

                    Categoria.eliminarCategoria(connection, idEliminarCa);
                    break;
                case 19:
                    System.out.print("Ingrese la cantidad: ");
                    int cantidad = scanner.nextInt();
                    System.out.print("Ingrese el valor total: ");
                    double valorTotal = scanner.nextDouble();
                    System.out.print("Ingrese el descuento: ");
                    float descuento = scanner.nextFloat();
                    System.out.print("Ingrese el id del producto: ");
                    int productoId = scanner.nextInt();
                    System.out.print("Ingrese el id de la factura: ");
                    int facturaId = scanner.nextInt();

                    DetalleFactura.crearDetalleFactura(connection, cantidad, valorTotal, descuento, productoId,
                            facturaId);
                    break;
                case 20:
                    System.out.print("Ingrese el id del detalle de factura a modificar: ");
                    int idModificarDF = scanner.nextInt();
                    System.out.print("Ingrese la nueva cantidad: ");
                    int nuevaCantidad = scanner.nextInt();
                    System.out.print("Ingrese el nuevo valor total: ");
                    double nuevoValorTotal = scanner.nextDouble();
                    System.out.print("Ingrese el nuevo descuento: ");
                    float nuevoDescuento = scanner.nextFloat();
                    System.out.print("Ingrese el nuevo ID del producto: ");
                    int nuevoProductoId = scanner.nextInt();
                    System.out.print("Ingrese el nuevo ID de la factura: ");
                    int nuevaFacturaId = scanner.nextInt();

                    DetalleFactura.modificarDetalleFactura(connection, idModificarDF, nuevaCantidad,
                            nuevoValorTotal, nuevoDescuento, nuevoProductoId, nuevaFacturaId);
                    break;
                case 21:
                    System.out.print("Ingrese el id del detalle de factura a eliminar: ");
                    int idEliminarDF = scanner.nextInt();

                    DetalleFactura.eliminarDetalleFactura(connection, idEliminarDF);
                    break;
                case 22:
                    System.out.print("Ingrese el nombre del impuesto: ");
                    String nombreIm = scanner.nextLine();
                    System.out.print("Ingrese el porcentaje del impuesto: ");
                    float porcentaje = scanner.nextFloat();

                    Impuesto.agregarImpuesto(connection, nombreIm, porcentaje);
                    break;
                case 23:
                    System.out.print("Ingrese el id del impuesto a modificar: ");
                    int idModificarIm = scanner.nextInt();
                    System.out.print("Ingrese el nuevo nombre del impuesto: ");
                    String nuevoNombreIm = scanner.nextLine();
                    System.out.print("Ingrese el nuevo porcentaje del impuesto: ");
                    float nuevoPorcentaje = scanner.nextFloat();

                    Impuesto.modificarImpuesto(connection, idModificarIm, nuevoNombreIm, nuevoPorcentaje);
                    break;
                case 24:
                    System.out.print("Ingrese el id del impuesto a eliminar: ");
                    int idEliminarIm = scanner.nextInt();

                    Impuesto.eliminarImpuesto(connection, idEliminarIm);
                    break;
                case 0:
                    System.out.println("Saliendo...");
                    break;
                default:
                    System.out.println("Opción no válida. Intente nuevamente.");
            }
        } while (option != 0);

        scanner.close();
        ConexionPostgres.closeConnection();

    }
}