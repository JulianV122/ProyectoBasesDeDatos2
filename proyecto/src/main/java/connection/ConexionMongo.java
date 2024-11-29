package connection;
import org.bson.Document;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
//import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;

import io.github.cdimascio.dotenv.Dotenv;

//import static com.mongodb.client.model.Filters.eq;
//import static com.mongodb.client.model.Filters.gt;
//import static com.mongodb.client.model.Filters.and;
//import static com.mongodb.client.model.Updates.set;
//import static com.mongodb.client.model.Sorts.ascending;
import com.mongodb.client.MongoClients;

public class ConexionMongo {
    private static ConexionMongo instance;
    private String uri;
    private MongoClient mongoClient;
    private MongoDatabase database;
    private MongoCollection<Document> collection;

    private ConexionMongo() {
        Dotenv dotenv = Dotenv.load();
        this.uri = dotenv.get("MONGO_URL");
        this.mongoClient = MongoClients.create(uri);
        this.database = mongoClient.getDatabase("proyecto");
        this.collection = database.getCollection("auditorias");
        System.out.println("Conexión MongoDB exitosa");
    }

    public static ConexionMongo getInstance() {
        if (instance == null) {
            instance = new ConexionMongo();
        }
        return instance;
    }

    public static MongoCollection<Document> getCollection() {
        return getInstance().collection;
    }
}