<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get the expense ID from request
    String idStr = request.getParameter("id");
    
    if(idStr != null && !idStr.isEmpty()) {
        try {
            int id = Integer.parseInt(idStr);

            // Database connection
            String url = "jdbc:mysql://localhost:3306/expense_tracker";
            String user = "root";
            String password = "root";

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement stmt = conn.prepareStatement("DELETE FROM expenses WHERE id = ?")) {

                stmt.setInt(1, id);
                int rows = stmt.executeUpdate();

                if(rows > 0) {
                    session.setAttribute("message", "Expense deleted successfully!");
                } else {
                    session.setAttribute("message", "Expense deletion failed!");
                }
            }
        } catch(Exception e) {
            session.setAttribute("message", "Error: " + e.getMessage());
        }
    } else {
        session.setAttribute("message", "Invalid expense ID!");
    }

    // Redirect back to dashboard
    response.sendRedirect("dashboard.jsp");
%>