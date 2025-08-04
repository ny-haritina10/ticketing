package controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Properties;

import annotation.AnnotationController;
import annotation.AnnotationGetMapping;
import annotation.AnnotationRequestParam;
import annotation.AnnotationURL;
import modelview.ModelView;

@AnnotationController(name = "export_api_controller")
public class ExportAPIController {

    private final String TOKEN;
    private final String API_EXPORT_ENDPOINT;
    
    public ExportAPIController() {
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream(".env")) {
            
            if (input == null) {
                System.err.println("ERROR: .env file not found in classpath!");
                API_EXPORT_ENDPOINT = null; 
                TOKEN = null;
            } else {
                props.load(input);

                API_EXPORT_ENDPOINT = props.getProperty("API_EXPORT_ENDPOINT");
                TOKEN = props.getProperty("TOKEN");
                
                if (API_EXPORT_ENDPOINT == null || TOKEN == null) {
                    throw new RuntimeException("DEPENDENCIES not found in .env file");
                }
            }

        } catch (IOException e) {
            System.err.println("Error loading .env file: " + e.getMessage());
            e.printStackTrace(); 
            throw new RuntimeException("Fatal error loading .env file", e); 
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/api/export")
    public ModelView exportToPDF(@AnnotationRequestParam(name = "id") Integer id) {
        try {
            String apiUrl = API_EXPORT_ENDPOINT + id;
            
            URL url = new URL(apiUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Accept", "application/pdf");
            connection.setRequestProperty("Authorization", "Bearer " + TOKEN);
            
            int responseCode = connection.getResponseCode();            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                InputStream inputStream = connection.getInputStream();
                ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                
                int bytesRead;
                byte[] data = new byte[4096]; 
                while ((bytesRead = inputStream.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, bytesRead);
                }
                
                buffer.flush();
                byte[] pdfBytes = buffer.toByteArray();
                buffer.close();
                inputStream.close();
                connection.disconnect();
                
                ModelView mv = new ModelView("pdf-download.jsp");
                mv.add("pdfData", pdfBytes);
                mv.add("fileName", "reservation_" + id + ".pdf");
                
                return mv;
            } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED || 
                    responseCode == HttpURLConnection.HTTP_FORBIDDEN) {
                ModelView errorMv = new ModelView("error.jsp");
                errorMv.add("errorMessage", "Authentication failed. Please check your credentials.");
                return errorMv;
            } else {
                ModelView errorMv = new ModelView("error.jsp");
                errorMv.add("errorMessage", "Failed to retrieve PDF. Status code: " + responseCode);
                return errorMv;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            ModelView errorMv = new ModelView("error.jsp");
            errorMv.add("errorMessage", "Error: " + e.getMessage());
            return errorMv;
        }
    }
}