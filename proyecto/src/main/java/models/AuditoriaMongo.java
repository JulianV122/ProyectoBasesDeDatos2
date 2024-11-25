package models;


import com.mongodb.client.MongoCollection;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;
import java.util.Date;

import org.bson.Document;


public class AuditoriaMongo {
    
    public static void consultarAuditoria(MongoCollection<Document> collection){
        for (Document cursor : collection.find()) {
            System.out.println(cursor.toJson());
        }
    };

    public static void insertarAuditoria(MongoCollection<Document> collection, String id,Date fecha, String nombreCliente, Integer cantidad, String producto, Double total){
        Document document = new Document("id",id)
                .append("fecha", fecha)
                .append("nombreCliente", nombreCliente)
                .append("cantidad", cantidad)
                .append("producto", producto)
                .append("total", total);
        collection.insertOne(document);
    };

    public static void eliminarAuditoria(MongoCollection<Document> collection, String id){
        collection.deleteOne(eq("id", id)); 
    };

    public static void actualizarAuditoria(MongoCollection<Document> collection, String id,String nombreCliente, Integer cantidad, String producto, Double total){
        collection.updateOne(eq("id",id),set("nombreCliente",nombreCliente));
        collection.updateOne(eq("id",id),set("cantidad",cantidad));
        collection.updateOne(eq("id",id),set("producto",producto));
        collection.updateOne(eq("id",id),set("total",total));
    };
}
