
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String message = request.getParameter("message");
    String success = request.getParameter("success");

    int total = 0;
    int pending = 0;
    int inProgress = 0;
    int resolved = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/complaint_db", "root", "");
             Statement countStmt = con.createStatement();
             ResultSet countRs = countStmt.executeQuery(
                "SELECT COUNT(*) AS total, " +
                "SUM(CASE WHEN status='Pending' THEN 1 ELSE 0 END) AS pending, " +
                "SUM(CASE WHEN status='In Progress' THEN 1 ELSE 0 END) AS inprogress, " +
                "SUM(CASE WHEN status='Resolved' THEN 1 ELSE 0 END) AS resolved " +
                "FROM complaints")) {

            if (countRs.next()) {
                total = countRs.getInt("total");
                pending = countRs.getInt("pending");
                inProgress = countRs.getInt("inprogress");
                resolved = countRs.getInt("resolved");
            }
        }
    } catch (Exception e) {
        application.log("Unable to load complaint summary", e);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Complaint Records | Complaint Portal</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f3f6fb;
    color: #263449;
}

nav {
    background: #142b4a;
    padding: 16px 6%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
}

.brand {
    color: white;
    font-size: 21px;
    font-weight: bold;
}

nav a {
    color: white;
    text-decoration: none;
    margin-left: 18px;
    font-size: 14px;
}

nav a:hover {
    color: #8ec5ff;
}

.hero {
    background: linear-gradient(120deg, #173e70, #2879bd);
    color: white;
    padding: 38px 6%;
}

.hero h1 {
    margin: 0 0 10px;
    font-size: 32px;
}

.hero p {
    margin: 0;
    line-height: 1.6;
    color: #e4efff;
}

.container {
    width: 90%;
    max-width: 1250px;
    margin: 28px auto;
}

.alert {
    padding: 13px 16px;
    border-radius: 8px;
    margin-bottom: 18px;
    background: #dcfce7;
    color: #166534;
}

.summary {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 16px;
    margin-bottom: 24px;
}

.summary-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 3px 12px rgba(0,0,0,0.05);
    border-top: 4px solid #2879bd;
}

.summary-card p {
    color: #66758a;
    margin: 0 0 10px;
    font-size: 14px;
}

.summary-card h2 {
    margin: 0;
    font-size: 29px;
}

.panel {
    background: white;
    padding: 24px;
    border-radius: 12px;
    box-shadow: 0 3px 12px rgba(0,0,0,0.05);
}

.panel-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 14px;
    margin-bottom: 18px;
}

.panel-heading h2 {
    margin: 0;
    font-size: 22px;
}

.actions {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.btn {
    display: inline-block;
    border: none;
    border-radius: 7px;
    padding: 10px 15px;
    font-size: 13px;
    font-weight: bold;
    text-decoration: none;
    cursor: pointer;
}

.btn-blue {
    background: #2879bd;
    color: white;
}

.btn-blue:hover {
    background: #1d6098;
}

.btn-light {
    background: #e8f1fb;
    color: #194d7c;
}

.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 950px;
}

th {
    background: #edf3fa;
    color: #29435f;
    text-align: left;
    padding: 14px 12px;
    font-size: 13px;
}

td {
    padding: 14px 12px;
    border-bottom: 1px solid #e8edf3;
    font-size: 13px;
    vertical-align: top;
}

tr:hover td {
    background: #f8fbff;
}

.description {
    min-width: 180px;
    max-width: 260px;
    white-space: normal;
    overflow-wrap: anywhere;
}

.status {
    display: inline-block;
    border-radius: 20px;
    padding: 6px 10px;
    font-size: 12px;
    font-weight: bold;
    white-space: nowrap;
}

.status-pending {
    background: #fff0c2;
    color: #875b00;
}

.status-progress {
    background: #dbeafe;
    color: #1d4ed8;
}

.status-resolved {
    background: #dcfce7;
    color: #166534;
}

select {
    padding: 8px;
    border: 1px solid #ccd6e2;
    border-radius: 6px;
    margin-bottom: 7px;
    max-width: 130px;
}

.empty {
    padding: 35px 15px;
    text-align: center;
    color: #68788d;
}

footer {
    text-align: center;
    padding: 24px;
    margin-top: 35px;
    background: #142b4a;
    color: #d9e5f4;
    font-size: 13px;
    line-height: 1.8;
}

@media (max-width: 800px) {
    .summary {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    nav {
        align-items: flex-start;
        flex-direction: column;
    }

    nav a {
        margin: 0 12px 0 0;
    }

    .panel {
        padding: 15px;
    }
}

@media (max-width: 450px) {
    .summary {
        grid-template-columns: 1fr 1fr;
        gap: 10px;
    }

    .summary-card {
        padding: 14px;
    }

    .summary-card h2 {
        font-size: 24px;
    }
}
</style>
</head>

<body>

<nav>
    <div class="brand">🛡️ Complaint Portal</div>
    <div>
        <a href="index.html">Home</a>
        <a href="complaint.jsp">Submit Complaint</a>
        <a href="viewComplaints.jsp">Complaint Records</a>
        <a href="dashboard.jsp">Dashboard</a>
    </div>
</nav>

<section class="hero">
    <h1>Complaint Records</h1>
    <p>View submitted complaints, check their current status, and update them when required.</p>
</section>

<div class="container">

    <% if ("updated".equals(message)) { %>
        <div class="alert">Complaint status updated successfully!</div>
    <% } %>

    <% if ("1".equals(success)) { %>
        <div class="alert">Complaint submitted successfully!</div>
    <% } %>

    <div class="summary">
        <div class="summary-card">
            <p>Total Complaints</p>
            <h2><%= total %></h2>
        </div>

        <div class="summary-card">
            <p>Pending</p>
            <h2><%= pending %></h2>
        </div>

        <div class="summary-card">
            <p>In Progress</p>
            <h2><%= inProgress %></h2>
        </div>

        <div class="summary-card">
            <p>Resolved</p>
            <h2><%= resolved %></h2>
        </div>
    </div>

    <div class="panel">
        <div class="panel-heading">
            <h2>All Submitted Complaints</h2>

            <div class="actions">
                <a href="complaint.jsp" class="btn btn-blue">+ New Complaint</a>
                <a href="dashboard.jsp" class="btn btn-light">Dashboard</a>
                <a href="index.html" class="btn btn-light">Home</a>
            </div>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student Name</th>
                        <th>Email</th>
                        <th>Category</th>
                        <th>Description</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Update Status</th>
                    </tr>
                </thead>

                <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");

                        try (Connection con = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/complaint_db", "root", "");
                             PreparedStatement ps = con.prepareStatement(
                                "SELECT * FROM complaints ORDER BY created_at DESC");
                             ResultSet rs = ps.executeQuery()) {

                            boolean hasRecords = false;

                            while (rs.next()) {
                                hasRecords = true;

                                String status = rs.getString("status");
                                String statusClass = "status-pending";

                                if ("In Progress".equals(status)) {
                                    statusClass = "status-progress";
                                } else if ("Resolved".equals(status)) {
                                    statusClass = "status-resolved";
                                }
                %>
                    <tr>
                        <td><%= rs.getInt("complaint_id") %></td>
                        <td><%= rs.getString("student_name") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("category") %></td>
                        <td class="description"><%= rs.getString("description") %></td>
                        <td><%= rs.getString("priority") %></td>
                        <td>
                            <span class="status <%= statusClass %>">
                                <%= status %>
                            </span>
                        </td>
                        <td><%= rs.getTimestamp("created_at") %></td>
                        <td>
                            <form action="UpdateComplaintStatus" method="post">
                                <input type="hidden" name="complaint_id"
                                       value="<%= rs.getInt("complaint_id") %>">

                                <select name="status" required>
                                    <option value="Pending"
                                        <%= "Pending".equals(status) ? "selected" : "" %>>
                                        Pending
                                    </option>

                                    <option value="In Progress"
                                        <%= "In Progress".equals(status) ? "selected" : "" %>>
                                        In Progress
                                    </option>

                                    <option value="Resolved"
                                        <%= "Resolved".equals(status) ? "selected" : "" %>>
                                        Resolved
                                    </option>
                                </select>

                                <button type="submit" class="btn btn-blue">
                                    Update
                                </button>
                            </form>
                        </td>
                    </tr>
                <%
                            }

                            if (!hasRecords) {
                %>
                    <tr>
                        <td colspan="9" class="empty">
                            No complaints found. Submit your first complaint to get started.
                        </td>
                    </tr>
                <%
                            }
                        }
                    } catch (Exception e) {
                        application.log("Error loading complaint records", e);
                %>
                    <tr>
                        <td colspan="9" class="empty">
                            Unable to load complaint records. Please check the database connection
                            and server logs.
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<footer>
    <strong>Online Complaint Management System</strong><br>
    Academic Mini Project | Student Support and Complaint Management<br>
    Built with Java, JSP, MySQL and Python
</footer>

</body>
</html>
