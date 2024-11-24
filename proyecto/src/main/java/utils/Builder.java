package utils;

import java.sql.Connection;

import models.Categoria;
import models.Clientes;
import models.Impuesto;
import models.Producto;

public class Builder {

    public static void buildClientes(Connection connection) {
        String[] documentos = {"123456789", "987654321", "456789123", "789123456", "321654987", "654987321", "147258369", "369258147", "258147369", "741852963"};
        String[] nombres = {"Juan Perez", "Maria Gomez", "Carlos Sanchez", "Ana Rodriguez", "Luis Fernandez", "Laura Martinez", "Jose Ramirez", "Marta Diaz", "Pedro Torres", "Sofia Morales"};
        String[] direcciones = {"Calle 1 # 2-3", "Carrera 4 # 5-6", "Avenida 7 # 8-9", "Calle 10 # 11-12", "Carrera 13 # 14-15", "Avenida 16 # 17-18", "Calle 19 # 20-21", "Carrera 22 # 23-24", "Avenida 25 # 26-27", "Calle 28 # 29-30"};
        String[] telefonos = {"3001234567", "3009876543", "3004567891", "3007891234", "3003216549", "3006549873", "3001472589", "3003692581", "3002581473", "3007418529"};
        String[] emails = {"juan.perez@example.com", "maria.gomez@example.com", "carlos.sanchez@example.com", "ana.rodriguez@example.com", "luis.fernandez@example.com", "laura.martinez@example.com", "jose.ramirez@example.com", "marta.diaz@example.com", "pedro.torres@example.com", "sofia.morales@example.com"};
        String[] ciudades = {"Bogota", "Medellin", "Cali", "Barranquilla", "Cartagena", "Bucaramanga", "Pereira", "Manizales", "Santa Marta", "Ibague"};
        String[] departamentos = {"Cundinamarca", "Antioquia", "Valle del Cauca", "Atlantico", "Bolivar", "Santander", "Risaralda", "Caldas", "Magdalena", "Tolima"};

        for (int i = 0; i < 10; i++) {
            Clientes.agregarCliente(connection, documentos[i], nombres[i], direcciones[i], telefonos[i], emails[i], ciudades[i], departamentos[i]);
        }
    }

    public static void buildProductos(Connection connection) {
        String[] codigos = {"123", "456", "789", "321", "654", "987", "741", "852", "963", "147"};
        String[] nombres = {"Producto 1", "Producto 2", "Producto 3", "Producto 4", "Producto 5", "Producto 6", "Producto 7", "Producto 8", "Producto 9", "Producto 10"};
        String[] descripciones = {"Descripcion 1", "Descripcion 2", "Descripcion 3", "Descripcion 4", "Descripcion 5", "Descripcion 6", "Descripcion 7", "Descripcion 8", "Descripcion 9", "Descripcion 10"};
        float[] precios = {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000};
        String[] medidas = {"unidad", "unidad", "unidad", "unidad", "unidad", "unidad", "unidad", "unidad", "unidad", "unidad"};
        int[] impuestos = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        int[] categorias = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        int[] stocks = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100};

        for (int i = 0; i < 10; i++) {
            Producto.agregarProducto(connection, codigos[i], nombres[i], descripciones[i], precios[i], medidas[i], impuestos[i], categorias[i], stocks[i]);
        }
    }

    public static void buildCategorias(Connection connection) {
        String[] descripciones = {"Categoria 1", "Categoria 2", "Categoria 3", "Categoria 4", "Categoria 5", "Categoria 6", "Categoria 7", "Categoria 8", "Categoria 9", "Categoria 10"};

        for (int i = 0; i < 10; i++) {
            Categoria.agregarCategoria(connection, descripciones[i]);
        }
    }

    public static void buildImpuestos(Connection connection) {
        String[] nombres = {"IVA", "Renta", "ICA", "Predial", "Consumo", "Ambiental", "Timbre", "Vehicular", "Turismo", "Seguridad"};
        float[] porcentajes = {19.0f, 33.0f, 9.0f, 1.2f, 8.0f, 2.5f, 0.5f, 3.0f, 4.0f, 1.0f};

        for (int i = 0; i < 10; i++) {
            Impuesto.agregarImpuesto(connection, nombres[i], porcentajes[i]);
        }
    }

    public static void buildAll(Connection connection) {
        buildImpuestos(connection);
        buildCategorias(connection);
        buildProductos(connection);
        buildClientes(connection);
    }
}
