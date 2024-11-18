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
    }
}
