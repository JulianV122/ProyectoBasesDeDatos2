package models;

import com.mongodb.client.MongoCollection;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;
import java.util.Date;
import java.util.Scanner;

import org.bson.Document;

public class AuditoriaMongo {

    public static void consultarAuditoria(MongoCollection<Document> collection) {
        for (Document cursor : collection.find()) {
            System.out.println(cursor.toJson());
        }
    };

    public static void insertarAuditoria(MongoCollection<Document> collection, String id, Date fecha,
            String nombreCliente, Integer cantidad, String producto, Double total) {
        Document document = new Document("id", id)
                .append("fecha", fecha)
                .append("nombreCliente", nombreCliente)
                .append("cantidad", cantidad)
                .append("producto", producto)
                .append("total", total);
        collection.insertOne(document);
    };

    public static void eliminarAuditoria(MongoCollection<Document> collection, String id) {
        collection.deleteOne(eq("id", id));
    };

    public static void actualizarAuditoria(MongoCollection<Document> collection, String id, String nombreCliente,
            Integer cantidad, String producto, Double total) {
        collection.updateOne(eq("id", id), set("nombreCliente", nombreCliente));
        collection.updateOne(eq("id", id), set("cantidad", cantidad));
        collection.updateOne(eq("id", id), set("producto", producto));
        collection.updateOne(eq("id", id), set("total", total));
    };

    public static void menuAuditoria(Scanner scanner, MongoCollection<Document> collection) {
        int option;
        do {
            System.out.println("\n--- Menú Auditoría ---");
            System.out.println("1. Insertar Auditoría");
            System.out.println("2. Actualizar Auditoría");
            System.out.println("3. Eliminar Auditoría");
            System.out.println("4. Consultar Auditoría");
            System.out.println("0. Salir");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el id de la auditoría: ");
                    String id = scanner.nextLine();
                    System.out.print("Ingrese la fecha de la auditoría: ");
                    Date fecha = new Date();
                    scanner.nextLine();
                    System.out.print("Ingrese el nombre del cliente: ");
                    String nombreCliente = scanner.nextLine();
                    System.out.print("Ingrese la cantidad: ");
                    Integer cantidad = scanner.nextInt();
                    System.out.print("Ingrese el producto: ");
                    scanner.nextLine();
                    String producto = scanner.nextLine();
                    System.out.print("Ingrese el total: ");
                    Double total = scanner.nextDouble();
                    insertarAuditoria(collection, id, fecha, nombreCliente, cantidad, producto, total);
                    break;
                case 2:
                    System.out.print("Ingrese el id de la auditoría a actualizar: ");
                    String idActualizar = scanner.nextLine();
                    System.out.print("Ingrese el nombre del cliente: ");
                    String nombreClienteActualizar = scanner.nextLine();
                    System.out.print("Ingrese la cantidad: ");
                    Integer cantidadActualizar = scanner.nextInt();
                    System.out.print("Ingrese el producto: ");
                    scanner.nextLine();
                    String productoActualizar = scanner.nextLine();
                    System.out.print("Ingrese el total: ");
                    Double totalActualizar = scanner.nextDouble();
                    actualizarAuditoria(collection, idActualizar, nombreClienteActualizar, cantidadActualizar,
                            productoActualizar, totalActualizar);
                    break;
                case 3:
                    System.out.print("Ingrese el id de la auditoría a eliminar: ");
                    String idEliminar = scanner.nextLine();
                    eliminarAuditoria(collection, idEliminar);
                    break;
                case 4:
                    consultarAuditoria(collection);
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
