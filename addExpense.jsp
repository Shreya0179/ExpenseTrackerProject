<!DOCTYPE html>
<html>
<head>
    <title>Add Expense</title>
</head>
<body>

    <h2>Add Expense</h2>

    <form action="addExpense" method="post">
        Title: <input type="text" name="title" required><br><br>
        Amount: <input type="number" name="amount" step="0.01" required><br><br>
        Category: <input type="text" name="category" required><br><br>
        Date: <input type="date" name="date" required><br><br>

        <button type="submit">Add Expense</button>
    </form>

</body>
</html>