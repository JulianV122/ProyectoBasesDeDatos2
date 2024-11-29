package main;
import utils.*;
import models.*;
import connection.ConexionPostgres;
import connection.ConexionMongo;
import com.mongodb.client.MongoCollection;
import java.sql.Connection;
import java.util.Scanner;
import org.bson.Document;

public class Proyecto {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Connection connection = ConexionPostgres.getConnection();
        MongoCollection<Document> collection = ConexionMongo.getCollection();
        
        int mainOption;

        do {
            System.out.println("\n--- Menú Principal ---");
            System.out.println("1. Métodos de Pago");
            System.out.println("2. Facturas");
            System.out.println("3. Productos");
            System.out.println("4. Clientes");
            System.out.println("5. Inventarios");
            System.out.println("6. Categorías");
            System.out.println("7. Detalles de Factura");
            System.out.println("8. Impuestos");
            System.out.println("9. Auditoría");
            System.out.println("10. Auditoría MongoDB");
            System.out.println("11. Informes");
            System.out.println("12. Facturas XML");
            System.out.println("13. Exportar Informes");
            System.out.println("99. Build All");
            System.out.println("0. Salir");

            System.out.print("Seleccione una opción: ");
            mainOption = scanner.nextInt();
            scanner.nextLine();

            switch (mainOption) {
                case 1:
                    MetodoPago.menuMetodosPago(scanner, connection);
                    break;
                case 2:
                    Factura.menuFacturas(scanner, connection, collection);
                    break;
                case 3:
                    Producto.menuProductos(scanner, connection);
                    break;
                case 4:
                    Clientes.menuClientes(scanner, connection);
                    break;
                case 5:
                    Inventario.menuInventarios(scanner, connection);
                    break;
                case 6:
                    Categoria.menuCategorias(scanner, connection);
                    break;
                case 7:
                    DetalleFactura.menuDetallesFactura(scanner, connection);
                    break;
                case 8:
                    Impuesto.menuImpuestos(scanner, connection);
                    break;
                case 9:
                    Auditoria.menuAuditorias(scanner, connection);
                    break;
                case 10:
                    AuditoriaMongo.menuAuditoria(scanner, collection);
                    break;
                case 11:
                    Informe.menuInformes(scanner, connection);
                    break;
                case 12:                
                    FacturasXML.menuFacturasXML(scanner, connection);
                    break;
                case 13:
                    ExportarInformes.menuExportarInformes(scanner, connection);
                    break;
                case 99:
                    Builder.buildAll(connection, collection);
                    break;
                case 0:
                    System.out.println("Saliendo del sistema...");
                    break;
                default:
                    System.out.println("Opción no válida. Intente nuevamente.");
            }
        } while (mainOption != 0);

        scanner.close();
        ConexionPostgres.closeConnection();
    }
}
