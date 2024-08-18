<%-- 

<%@ page import="java.sql.*" %>
<%
    // Database connection details
    String url = "jdbc:mysql://localhost:3306/labor_db";
    String user = "ramsingh";
    String password = "Ramsingh12@";

    // Handle form submission
    if (request.getMethod().equals("POST")) {
        int laborId = Integer.parseInt(request.getParameter("laborId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Update labor availability in the database
        Connection conn = DriverManager.getConnection(url, user, password);
        String updateQuery = "UPDATE labor SET availability = availability - ? WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(updateQuery);
        pstmt.setInt(1, quantity);
        pstmt.setInt(2, laborId);
        pstmt.executeUpdate();

        pstmt.close();
        conn.close();
    }

    // Fetch available labor data
    Connection conn = DriverManager.getConnection(url, user, password);
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM labor WHERE availability > 0");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Book Labor</title>


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

.error-message {
    color: red;
    font-weight: bold;
    margin-bottom: 10px;
}



    </style>
</head>
<body>
    <h1>Book Labor</h1>
    <table>
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
    <br>
    <form id="book-labor-form" method="post" action="book_labor.jsp">
        <label for="laborId">Labor ID:</label>
        <input type="number" id="laborId" name="laborId" required>
        <br>
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" required>
        <br>
        <button type="submit">Book Labor</button>
    </form>

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
                            // Reload the book_labor.jsp page to show updated labor availability
                            window.location.href = 'book_labor.jsp';
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





 --%>



 <%@ page import="java.sql.*, java.io.*" %>
<%
    String url = "jdbc:mysql://localhost:3306/labor_db";
    String user = "ramsingh";
    String password = "Ramsingh12@";
    String message = "";

    // Handle form submission for booking labor
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String laborIdStr = request.getParameter("laborId");
        String quantityStr = request.getParameter("quantity");

        int laborId = 0;
        int quantity = 0;
        boolean validInput = true;

        try {
            laborId = Integer.parseInt(laborIdStr);
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            validInput = false;
            message = "Invalid input. Please enter valid numbers.";
        }

        if (validInput) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                conn = DriverManager.getConnection(url, user, password);
                // Check availability
                String checkQuery = "SELECT availability FROM labor WHERE id = ?";
                pstmt = conn.prepareStatement(checkQuery);
                pstmt.setInt(1, laborId);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    int availability = rs.getInt("availability");
                    if (availability >= quantity) {
                        // Update availability
                        String updateQuery = "UPDATE labor SET availability = availability - ? WHERE id = ?";
                        pstmt = conn.prepareStatement(updateQuery);
                        pstmt.setInt(1, quantity);
                        pstmt.setInt(2, laborId);
                        pstmt.executeUpdate();
                        message = "Labor booked successfully!";
                    } else {
                        message = "Not enough labor available.";
                    }
                } else {
                    message = "Labor ID not found.";
                }
            } catch (SQLException e) {
                e.printStackTrace();
                message = "Database error: " + e.getMessage();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Book Labor</title>
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
        .message {
            color: green;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .error-message {
            color: red;
            font-weight: bold;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <h1>Book Labor</h1>
    <% if (!message.isEmpty()) { %>
        <div class="<%= message.startsWith("Labor booked successfully!") ? "message" : "error-message" %>"><%= message %></div>
    <% } %>
    <table>
        <thead>
            <tr>
                <th>Labor ID</th>
                <th>Name</th>
                <th>Availability</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    conn = DriverManager.getConnection(url, user, password);
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM labor WHERE availability > 0");

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        int availability = rs.getInt("availability");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= availability %></td>
            </tr>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<div class='error-message'>Database error: " + e.getMessage() + "</div>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </tbody>
    </table>
    <form method="post" action="book_labor.jsp">
        <label for="laborId">Labor ID:</label>
        <input type="number" id="laborId" name="laborId" required>
        <br>
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" required>
        <br>
        <button type="submit">Book Labor</button>
    </form>
</body>
</html>

