package main;

import models.*;
import org.bson.Document;
import com.mongodb.client.MongoCollection;
import java.sql.Connection;

public class Proyecto {

    public static void main(String[] args) {
        MongoCollection<Document> collection = ConexionMongo.getCollection();
        Connection connection = ConexionPostgres.getConnection();

        Producto.agregarProducto(connection, "123", "Producto 1", "Descripcion 1", 100, "unidad", 2, 4, 10);

        Producto.obtenerProductos(connection);
        
        Clientes.agregarCliente(connection, "1234", "Alberto", "Calle 1234", "31287637421", "Alberto@gmail.com", "Manizales", "Caldas");

        
        ConexionPostgres.closeConnection();

    }
}
