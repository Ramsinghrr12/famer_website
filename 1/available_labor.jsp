<%@ page import="java.sql.*" %>
<%
    // Database connection details
    String url = "jdbc:mysql://localhost:3306/labor_db";
    String user = "ramsingh";
    String password = "Ramsingh12@";

    // SQL query to fetch available labor
    String query = "SELECT * FROM labor WHERE availability > 0";

    // Establish database connection
    Connection conn = DriverManager.getConnection(url, user, password);
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery(query);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Available Labor</title>

    <style>

body {
    font-family: Arial, sans-serif;
    margin: 20px;
}

h1 {
    color: #333;
}

table {
    border-collapse: collapse;
    width: 100%;
}

th, td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

th {
    background-color: #f2f2f2;
}

form {
    margin-top: 20px;
}

label {
    display: block;
    margin-bottom: 5px;
}

input[type="number"] {
    padding: 5px;
    margin-bottom: 10px;
}

button[type="submit"] {
    padding: 8px 16px;
    background-color: #4CAF50;
    color: white;
    border: none;
    cursor: pointer;
}

    </style>
</head>
<body>
    <h1>Available Labor</h1>
    <table id="labor-table">
        <thead>
            <tr>
                <th>Labor ID</th>
                <th>Name</th>
                <th>Availability</th>
            </tr>
        </thead>
        <tbody>
            <% while (rs.next()) { %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getInt("availability") %></td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <a href="book_labor.jsp">Book Labor</a>

    <script>

    // Add event listener for form submission
document.getElementById('book-labor-form').addEventListener('submit', function(event) {
    event.preventDefault(); // Prevent form submission

    // Get form values
    var laborId = document.getElementById('laborId').value;
    var quantity = document.getElementById('quantity').value;

    // Perform form validation
    if (laborId === '' || quantity === '') {
        alert('Please fill in all fields.');
        return;
    }

    // Send AJAX request to check labor availability
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'check_availability.jsp', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var response = xhr.responseText;
                if (response === 'available') {
                    // Send AJAX request to update labor availability
                    var updateXhr = new XMLHttpRequest();
                    updateXhr.open('POST', 'book_labor.jsp', true);
                    updateXhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                    updateXhr.onreadystatechange = function() {
                        if (updateXhr.readyState === XMLHttpRequest.DONE && updateXhr.status === 200) {
                            // Display success message
                            alert('Labor booked successfully!');
                            // Redirect to the available labor page
                            window.location.href = 'available_labor.jsp';
                        }
                    };
                    updateXhr.send('laborId=' + laborId + '&quantity=' + quantity);
                } else {
                    alert(response);
                }
            } else {
                alert('An error occurred. Please try again.');
            }
        }
    };
    xhr.send('laborId=' + laborId + '&quantity=' + quantity);
});
    
    
    
    </script>
</body>
</html>

<%
    // Close database resources
    rs.close();
    stmt.close();
    conn.close();
%>