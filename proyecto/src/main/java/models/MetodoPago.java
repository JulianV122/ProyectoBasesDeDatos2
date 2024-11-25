package models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class MetodoPago {

    // Agregar un método de pago
    public static boolean agregarMetodoPago(Connection connection, String descripcion, String identificador) {
        String sql = "CALL proyecto.crear_metodo_pago(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, descripcion);         
            stmt.setString(2, identificador);     
            stmt.execute();                         
            stmt.close();                           
            return true;                            
        } catch (SQLException e) {
            System.out.println(e.getMessage());     
            return false;                           
        }
    }

    // Modificar un método de pago
    public static boolean modificarMetodoPago(Connection connection, int id, String descripcion, String identificador) {
        String sql = "CALL proyecto.modificar_metodo_pago(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);                    
            stmt.setString(2, descripcion);        
            stmt.setString(3, identificador);      
            stmt.execute();                         
            stmt.close();                           
            return true;                           
        } catch (SQLException e) {
            e.printStackTrace();                  
            return false;                          
        }
    }

    // Eliminar un método de pago
    public static boolean eliminarMetodoPago(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_metodo_pago(?)";
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
}
