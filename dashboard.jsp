<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:mysql://localhost:3306/expense_tracker";
    String user = "root";
    String password = "root";

    String message = "";

    // Handle form submission
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String title = request.getParameter("title");
        String amountStr = request.getParameter("amount");
        String category = request.getParameter("category");
        String date = request.getParameter("date");

        try {
            double amount = Double.parseDouble(amountStr);
            Class.forName("com.mysql.cj.jdbc.Driver");
            try(Connection conn = DriverManager.getConnection(url, user, password);
                PreparedStatement stmt = conn.prepareStatement(
                    "INSERT INTO expenses(title, amount, category, date) VALUES(?, ?, ?, ?)"
                )) {
                stmt.setString(1, title);
                stmt.setDouble(2, amount);
                stmt.setString(3, category);
                stmt.setDate(4, java.sql.Date.valueOf(date));
                int rows = stmt.executeUpdate();
                if(rows > 0) message = "Expense added successfully!";
                else message = "Failed to add expense.";
            }
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Expense Tracker Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f3f4f6; margin:0; padding:0; }
        .container { width:90%; margin:20px auto; }
        h2 { text-align:center; margin-top:20px; color:#333; }
        table { width:100%; margin:20px 0; border-collapse: collapse; background:white; }
        th, td { border:1px solid #333; padding:8px 12px; text-align:center; }
        th { background-color:#007BFF; color:white; }
        .form-container { margin-bottom:20px; background:white; padding:20px; border-radius:8px; }
        .form-container input { padding:10px; margin:5px; width: calc(25% - 10px); }
        .form-container button { padding:10px 20px; background:#007BFF; color:white; border:none; border-radius:5px; cursor:pointer; }
        .form-container button:hover { background:#0056b3; }
        .message { text-align:center; font-weight:bold; color:green; margin-bottom:10px; }
        .action-btn { padding:5px 10px; margin:0 2px; border:none; border-radius:5px; cursor:pointer; }
        .edit { background:#ffc107; color:white; }
        .delete { background:#dc3545; color:white; }
    </style>
</head>
<body>
<div class="container">
<h2>💰 Expense Tracker Dashboard 💰</h2>

<%
    String sessionMessage = (String) session.getAttribute("message");
    if(sessionMessage != null) {
%>
    <p class="message"><%= sessionMessage %></p>
<%
        session.removeAttribute("message"); // clear it after showing
    }
%>


<div class="form-container">
    <!-- POST to the same page -->
    <form action="dashboard.jsp" method="post">
        <input type="text" name="title" placeholder="Title" required>
        <input type="number" step="0.01" name="amount" placeholder="Amount" required>
        <input type="text" name="category" placeholder="Category" required>
        <input type="date" name="date" required>
        <button type="submit">Add Expense</button>
    </form>
</div>

<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM expenses ORDER BY date DESC");
%>

<table>
    <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Amount</th>
        <th>Category</th>
        <th>Date</th>
        <th>Actions</th>
    </tr>
<%
        while(rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("title") %></td>
        <td>$<%= String.format("%.2f", rs.getDouble("amount")) %></td>
        <td><%= rs.getString("category") %></td>
        <td><%= rs.getDate("date") %></td>
        <td>
            <form action="updateExpense.jsp" method="get" style="display:inline;">
                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <button class="action-btn edit">Edit</button>
            </form>
            <form action="deleteExpense.jsp" method="post" style="display:inline;">
                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <button class="action-btn delete">Delete</button>
            </form>
        </td>
    </tr>
<%
        }
    } catch(Exception e) { out.println("<p style='color:red;'>Error: "+e.getMessage()+"</p>"); }
    finally {
        try{ if(rs!=null) rs.close(); } catch(Exception e){}
        try{ if(stmt!=null) stmt.close(); } catch(Exception e){}
        try{ if(conn!=null) conn.close(); } catch(Exception e){}
    }
%>
</table>
</div>
</body>
</html>