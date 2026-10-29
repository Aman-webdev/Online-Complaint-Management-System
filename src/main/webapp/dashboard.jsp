
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<%@ page import="com.complaint.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Complaint Dashboard</title>

<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: #f3f6fb;
        color: #263449;
        line-height: 1.6;
    }

    nav {
        background: white;
        padding: 16px 6%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px;
        box-shadow: 0 2px 10px #0000000a;
    }

    .brand {
        font-size: 19px;
        font-weight: bold;
        color: #17365d;
    }

    .nav-links {
        display: flex;
        flex-wrap: wrap;
        gap: 18px;
    }

    .nav-links a {
        text-decoration: none;
        color: #34445c;
        font-size: 14px;
        font-weight: bold;
    }

    .nav-links a:hover {
        color: #2878c8;
    }

    .container {
        max-width: 1150px;
        margin: auto;
        padding: 35px 24px;
    }

    .welcome {
        background: linear-gradient(125deg, #102b4e, #245b91);
        color: white;
        padding: 30px;
        border-radius: 14px;
        margin-bottom: 30px;
    }

    .welcome h1 {
        margin: 0 0 8px;
        font-size: 30px;
    }

    .welcome p {
        color: #e0eafa;
        margin: 0;
    }

    .section-title {
        color: #17365d;
        margin: 28px 0 15px;
        font-size: 21px;
    }

    .cards {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 18px;
    }

    .card {
        background: white;
        border: 1px solid #e5eaf1;
        border-radius: 12px;
        padding: 22px;
        box-shadow: 0 4px 15px #17365d08;
    }

    .card-label {
        color: #69778a;
        font-size: 14px;
        font-weight: bold;
    }

    .number {
        color: #17365d;
        font-size: 34px;
        font-weight: bold;
        margin-top: 8px;
    }

    .card-icon {
        font-size: 25px;
        margin-bottom: 8px;
    }

    .chart-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 22px;
        align-items: start;
    }

    .chart-card {
        background: white;
        border: 1px solid #e5eaf1;
        border-radius: 12px;
        padding: 20px;
        min-width: 0;
    }

    .chart-card h3 {
        color: #17365d;
        font-size: 17px;
        margin: 0 0 15px;
    }

    .chart-wrap {
        position: relative;
        height: 260px;
        width: 100%;
    }

    .recent-card {
        background: white;
        border: 1px solid #e5eaf1;
        border-radius: 12px;
        padding: 20px;
        overflow-x: auto;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }

    th, td {
        padding: 12px 10px;
        border-bottom: 1px solid #e8edf4;
        text-align: left;
    }

    th {
        color: #17365d;
        background: #f5f8fc;
    }

    .status {
        display: inline-block;
        padding: 4px 9px;
        border-radius: 15px;
        font-size: 12px;
        font-weight: bold;
        background: #edf1f6;
        color: #34445c;
    }

    .actions {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 25px;
    }

    .btn {
        display: inline-block;
        padding: 11px 16px;
        border-radius: 6px;
        text-decoration: none;
        font-size: 14px;
        font-weight: bold;
        background: #17365d;
        color: white;
    }

    .btn:hover {
        background: #245b91;
    }

    footer {
        background: #10243e;
        color: #dce6f4;
        text-align: center;
        padding: 20px;
        font-size: 13px;
    }

    @media (max-width: 850px) {
        .cards {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .chart-grid {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 500px) {
        .cards {
            grid-template-columns: 1fr;
        }

        .container {
            padding: 22px 14px;
        }

        .welcome h1 {
            font-size: 24px;
        }
    }
</style>
</head>

<body>

<nav>
    <div class="brand">🛡️ Complaint Portal</div>
    <div class="nav-links">
        <a href="index.html">Home</a>
        <a href="complaint.jsp">Submit Complaint</a>
        <a href="viewComplaints.jsp">Complaint Records</a>
        <a href="dashboard.jsp">Dashboard</a>
    </div>
</nav>

<div class="container">

    <div class="welcome">
        <h1>Complaint Dashboard</h1>
        <p>
            Welcome to your complaint overview. Monitor complaint
            statistics, review recent records, and track progress.
        </p>
    </div>

    <%
        int total = 0;
        int pending = 0;
        int inProgress = 0;
        int resolved = 0;

        String summarySql =
            "SELECT COUNT(*) AS total, " +
            "COALESCE(SUM(CASE WHEN status = 'Pending' " +
            "THEN 1 ELSE 0 END), 0) AS pending, " +
            "COALESCE(SUM(CASE WHEN status = 'In Progress' " +
            "THEN 1 ELSE 0 END), 0) AS in_progress, " +
            "COALESCE(SUM(CASE WHEN status = 'Resolved' " +
            "THEN 1 ELSE 0 END), 0) AS resolved " +
            "FROM complaints";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(summarySql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                total = rs.getInt("total");
                pending = rs.getInt("pending");
                inProgress = rs.getInt("in_progress");
                resolved = rs.getInt("resolved");
            }
        } catch (Exception e) {
            application.log("Dashboard summary loading error", e);
        }

        int academicCount = 0;
        int hostelCount = 0;
        int itCount = 0;
        int otherCount = 0;

        String categorySql =
            "SELECT category, COUNT(*) AS total " +
            "FROM complaints GROUP BY category";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(categorySql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String category = rs.getString("category");
                int count = rs.getInt("total");

                if ("Academic".equalsIgnoreCase(category)) {
                    academicCount += count;
                } else if ("Hostel".equalsIgnoreCase(category)) {
                    hostelCount += count;
                } else if ("IT Support".equalsIgnoreCase(category)) {
                    itCount += count;
                } else {
                    otherCount += count;
                }
            }
        } catch (Exception e) {
            application.log("Dashboard category loading error", e);
        }
    %>

    <h2 class="section-title">Complaint Overview</h2>

    <div class="cards">
        <div class="card">
            <div class="card-icon">📋</div>
            <div class="card-label">Total Complaints</div>
            <div class="number"><%= total %></div>
        </div>

        <div class="card">
            <div class="card-icon">⏳</div>
            <div class="card-label">Pending</div>
            <div class="number"><%= pending %></div>
        </div>

        <div class="card">
            <div class="card-icon">⚙️</div>
            <div class="card-label">In Progress</div>
            <div class="number"><%= inProgress %></div>
        </div>

        <div class="card">
            <div class="card-icon">✅</div>
            <div class="card-label">Resolved</div>
            <div class="number"><%= resolved %></div>
        </div>
    </div>

    <h2 class="section-title">Visual Complaint Analysis</h2>

    <div class="chart-grid">
        <div class="chart-card">
            <h3>Complaints by Status</h3>
            <div class="chart-wrap">
                <canvas id="statusChart"></canvas>
            </div>
        </div>

        <div class="chart-card">
            <h3>Complaints by Category</h3>
            <div class="chart-wrap">
                <canvas id="categoryChart"></canvas>
            </div>
        </div>
    </div>

    <h2 class="section-title">Recent Complaints</h2>

    <div class="recent-card">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Student Name</th>
                    <th>Category</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Date</th>
                </tr>
            </thead>

            <tbody>
            <%
                String recentSql =
                    "SELECT complaint_id, student_name, category, " +
                    "priority, status, created_at FROM complaints " +
                    "ORDER BY created_at DESC LIMIT 5";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(recentSql);
                     ResultSet rs = ps.executeQuery()) {

                    boolean found = false;

                    while (rs.next()) {
                        found = true;
            %>
                <tr>
                    <td><%= rs.getInt("complaint_id") %></td>
                    <td><%= rs.getString("student_name") %></td>
                    <td><%= rs.getString("category") %></td>
                    <td><%= rs.getString("priority") %></td>
                    <td>
                        <span class="status">
                            <%= rs.getString("status") %>
                        </span>
                    </td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                </tr>
            <%
                    }

                    if (!found) {
            %>
                <tr>
                    <td colspan="6">No complaints have been submitted yet.</td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    application.log("Recent complaints loading error", e);
            %>
                <tr>
                    <td colspan="6">Could not load recent complaints.</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <div class="actions">
        <a href="complaint.jsp" class="btn">✚ Submit Complaint</a>
        <a href="viewComplaints.jsp" class="btn">View All Complaints</a>
        <a href="index.html" class="btn">Back to Home</a>
    </div>

</div>

<footer>
    <strong>Online Complaint Management System</strong>
    <br>
    Academic Mini Project | Java, JSP, MySQL and Python
</footer>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    new Chart(document.getElementById('statusChart'), {
        type: 'doughnut',
        data: {
            labels: ['Pending', 'In Progress', 'Resolved'],
            datasets: [{
                data: [
                    <%= pending %>,
                    <%= inProgress %>,
                    <%= resolved %>
                ],
                backgroundColor: ['#E9A23B', '#4285C5', '#36A477'],
                borderWidth: 2,
                borderColor: '#ffffff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });

    new Chart(document.getElementById('categoryChart'), {
        type: 'bar',
        data: {
            labels: ['Academic', 'Hostel', 'IT Support', 'Other'],
            datasets: [{
                label: 'Number of Complaints',
                data: [
                    <%= academicCount %>,
                    <%= hostelCount %>,
                    <%= itCount %>,
                    <%= otherCount %>
                ],
                backgroundColor: ['#4285C5', '#36A477', '#E9A23B', '#8B78C6'],
                borderRadius: 5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            }
        }
    });
</script>

</body>
</html>
