<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:mysql://localhost:3306/expense_tracker";
    String user = "root";
    String password = "root";

    String message = "";
    int id = 0;
    String title = "";
    double amount = 0;
    String category = "";
    String date = "";

    // If "id" parameter exists, fetch the existing expense details
    if(request.getParameter("id") != null) {
        id = Integer.parseInt(request.getParameter("id"));
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try(Connection conn = DriverManager.getConnection(url, user, password);
                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM expenses WHERE id = ?")) {
                stmt.setInt(1, id);
                ResultSet rs = stmt.executeQuery();
                if(rs.next()) {
                    title = rs.getString("title");
                    amount = rs.getDouble("amount");
                    category = rs.getString("category");
                    date = rs.getDate("date").toString();
                }
            }
        } catch(Exception e) {
            message = "Error fetching expense: " + e.getMessage();
        }
    }

    // Handle form submission
    if(request.getMethod().equalsIgnoreCase("POST")) {
        try {
            id = Integer.parseInt(request.getParameter("id"));
            title = request.getParameter("title");
            amount = Double.parseDouble(request.getParameter("amount"));
            category = request.getParameter("category");
            date = request.getParameter("date");

            Class.forName("com.mysql.cj.jdbc.Driver");
            try(Connection conn = DriverManager.getConnection(url, user, password);
                PreparedStatement stmt = conn.prepareStatement(
                    "UPDATE expenses SET title=?, amount=?, category=?, date=? WHERE id=?"
                )) {
                stmt.setString(1, title);
                stmt.setDouble(2, amount);
                stmt.setString(3, category);
                stmt.setDate(4, java.sql.Date.valueOf(date));
                stmt.setInt(5, id);

                int rows = stmt.executeUpdate();
                if(rows > 0) {
                    message = "Expense updated successfully!";
                    // Redirect back to dashboard after update
                    response.sendRedirect("dashboard.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
                } else {
                    message = "Failed to update expense.";
                }
            }
        } catch(Exception e) {
            message = "Error updating expense: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Expense</title>
    <style>
        body { font-family: Arial; background:#f3f4f6; display:flex; justify-content:center; align-items:center; height:100vh; margin:0; }
        .container { background:white; padding:30px 40px; border-radius:12px; width:400px; box-shadow:0 4px 15px rgba(0,0,0,0.1); }
        h2 { text-align:center; color:#333; margin-bottom:25px; }
        input[type="text"], input[type="number"], input[type="date"] { width:100%; padding:10px; margin:8px 0; border-radius:6px; border:1px solid #ccc; }
        button { width:100%; padding:12px; background:#007BFF; color:white; border:none; border-radius:6px; cursor:pointer; margin-top:10px; }
        button:hover { background:#0056b3; }
        .message { text-align:center; font-weight:bold; color:red; margin-top:10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Update Expense</h2>
    <form action="updateExpense.jsp" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <label>Title:</label>
        <input type="text" name="title" value="<%= title %>" required>
        <label>Amount:</label>
        <input type="number" step="0.01" name="amount" value="<%= amount %>" required>
        <label>Category:</label>
        <input type="text" name="category" value="<%= category %>" required>
        <label>Date:</label>
        <input type="date" name="date" value="<%= date %>" required>
        <button type="submit">Update Expense</button>
    </form>
    <% if(!message.isEmpty()) { %>
        <p class="message"><%= message %></p>
    <% } %>
</div>
</body>
</html>
