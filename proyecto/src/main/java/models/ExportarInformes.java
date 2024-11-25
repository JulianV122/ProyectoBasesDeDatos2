package models;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

public class ExportarInformes{
    // Método para obtener los datos de la tabla informes
    public static List<Map<String, Object>> obtenerInformes(Connection connection) throws SQLException {
        List<Map<String, Object>> informes = new ArrayList<>();
        String query = "SELECT id, tipo_informe, fecha, datos_json FROM proyecto.informes";

        try {
            CallableStatement stmt = connection.prepareCall(query);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> informe = new HashMap<>();
                informe.put("id", rs.getInt("id"));
                informe.put("tipo_informe", rs.getString("tipo_informe"));
                informe.put("fecha", rs.getDate("fecha"));
                informe.put("datos_json", rs.getString("datos_json"));
                informes.add(informe);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return informes;
    }

    // Método para exportar los datos a un archivo Excel
    public static void exportarAExcel(List<Map<String, Object>> informes, String nombreArchivo) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Informes");

        // Crear cabeceras
        String[] headers = {"ID", "Tipo Informe", "Fecha", "Datos JSON"};
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(crearEstiloCabecera(workbook));
        }

        // Crear filas de datos
        int rowNum = 1;
        for (Map<String, Object> informe : informes) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue((Integer) informe.get("id"));
            row.createCell(1).setCellValue((String) informe.get("tipo_informe"));
            row.createCell(2).setCellValue(informe.get("fecha").toString());
            row.createCell(3).setCellValue((String) informe.get("datos_json"));
        }

        // Ajustar el tamaño de las columnas
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        // Guardar el archivo
        try (FileOutputStream fileOut = new FileOutputStream(nombreArchivo)) {
            workbook.write(fileOut);
        }

        workbook.close();
        System.out.println("Archivo Excel generado: " + nombreArchivo);
    }

    // Método para crear un estilo para las cabeceras
    private static CellStyle crearEstiloCabecera(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        return style;
    }

    // Método para exportar los datos a un archivo PDF
    public static void exportarAPDF(List<Map<String, Object>> informes, String nombreArchivo) throws FileNotFoundException, DocumentException {
        // Crear el documento PDF
        Document document = new Document();
        PdfWriter.getInstance(document, new FileOutputStream(nombreArchivo));

        document.open();

        // Crear la tabla con un número de columnas igual al número de cabeceras
        String[] headers = {"ID", "Tipo Informe", "Fecha", "Datos JSON"};
        PdfPTable table = new PdfPTable(headers.length);
        table.setWidthPercentage(100); // Usar el 100% del ancho de la página
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);

        // Crear estilo para las cabeceras
        com.itextpdf.text.Font boldFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.TIMES_ROMAN, 12, com.itextpdf.text.Font.BOLD);

        // Añadir cabeceras
        for (String header : headers) {
            PdfPCell headerCell = new PdfPCell(new Paragraph(header, boldFont));
            headerCell.setHorizontalAlignment(Element.ALIGN_CENTER); // Centrar texto
            headerCell.setVerticalAlignment(Element.ALIGN_MIDDLE); // Centrar verticalmente
            table.addCell(headerCell);
        }

        // Añadir filas de datos
        for (Map<String, Object> informe : informes) {
            table.addCell(new PdfPCell(new Paragraph(informe.get("id").toString())));
            table.addCell(new PdfPCell(new Paragraph(informe.get("tipo_informe").toString())));
            table.addCell(new PdfPCell(new Paragraph(informe.get("fecha").toString())));
            table.addCell(new PdfPCell(new Paragraph(informe.get("datos_json").toString())));
        }

        // Añadir la tabla al documento
        document.add(table);
        document.close();

        System.out.println("Archivo PDF generado: " + nombreArchivo);
    }
}