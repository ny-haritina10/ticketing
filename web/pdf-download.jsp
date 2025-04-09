<%@ page contentType="application/pdf" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.io.*" %>
<% 
    byte[] pdfData = (byte[]) request.getAttribute("pdfData");
    String fileName = (String) request.getAttribute("fileName");
    
    if (pdfData != null && pdfData.length > 0) {
        response.reset();
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        response.setContentLength(pdfData.length);
        
        try {
            OutputStream outStream = response.getOutputStream();
            outStream.write(pdfData);
            outStream.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>