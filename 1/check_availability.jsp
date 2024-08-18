<%@ page import="java.sql.*" %>
<%
    // Database connection details
    String url = "jdbc:mysql://localhost:3306/labor_db";
    String user = "ramsingh";
    String password = "Ramsingh12@";

    int laborId = Integer.parseInt(request.getParameter("laborId"));
    int quantity = Integer.parseInt(request.getParameter("quantity"));

    // Check if requested quantity is available
    Connection conn = DriverManager.getConnection(url, user, password);
    String checkQuery = "SELECT availability FROM labor WHERE id = ?";
    PreparedStatement pstmt = conn.prepareStatement(checkQuery);
    pstmt.setInt(1, laborId);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
        int availableQuantity = rs.getInt("availability");
        if (quantity <= availableQuantity) {
            out.print("labors booked Sucessfully");
        } else {
            out.print("Requested quantity is not available. Currently available: " + availableQuantity);
        }
    } else {
        out.print("Invalid Labor ID.");
    }

    rs.close();
    pstmt.close();
    conn.close();
%>