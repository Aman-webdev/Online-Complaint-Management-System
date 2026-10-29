
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Submit a Complaint</title>

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

    .hero {
        background: linear-gradient(125deg, #102b4e, #245b91);
        color: white;
        padding: 35px 6%;
    }

    .hero-inner {
        max-width: 1100px;
        margin: auto;
    }

    .hero h1 {
        margin: 0 0 8px;
        font-size: 30px;
    }

    .hero p {
        margin: 0;
        color: #e0eafa;
    }

    .page-layout {
        max-width: 1100px;
        margin: 35px auto;
        padding: 0 20px;
        display: grid;
        grid-template-columns: minmax(0, 1.7fr) minmax(240px, 1fr);
        gap: 25px;
        align-items: start;
    }

    .form-card, .info-card {
        background: white;
        padding: 28px;
        border: 1px solid #e5eaf1;
        border-radius: 12px;
        box-shadow: 0 5px 18px #17365d08;
    }

    .form-card h2, .info-card h2 {
        margin-top: 0;
        color: #17365d;
    }

    .intro {
        color: #69778a;
        font-size: 14px;
        margin-top: -5px;
        margin-bottom: 22px;
    }

    .form-group {
        margin-bottom: 18px;
    }

    label {
        display: block;
        font-weight: bold;
        font-size: 14px;
        margin-bottom: 7px;
        color: #34445c;
    }

    input, select, textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid #cfd8e5;
        border-radius: 6px;
        font-family: Arial, sans-serif;
        font-size: 14px;
        color: #263449;
        background: white;
    }

    input:focus, select:focus, textarea:focus {
        outline: none;
        border-color: #2878c8;
        box-shadow: 0 0 0 3px #2878c81a;
    }

    textarea {
        min-height: 130px;
        resize: vertical;
    }

    .hint {
        display: block;
        margin-top: 5px;
        color: #758297;
        font-size: 12px;
    }

    .required {
        color: #c0392b;
    }

    .submit-btn {
        display: inline-block;
        width: 100%;
        padding: 13px;
        border: none;
        border-radius: 6px;
        background: #17365d;
        color: white;
        font-size: 15px;
        font-weight: bold;
        cursor: pointer;
    }

    .submit-btn:hover {
        background: #245b91;
    }

    .info-item {
        padding: 15px 0;
        border-bottom: 1px solid #e8edf4;
    }

    .info-item:last-child {
        border-bottom: none;
    }

    .info-item h3 {
        color: #17365d;
        font-size: 15px;
        margin: 0 0 5px;
    }

    .info-item p {
        color: #69778a;
        font-size: 13px;
        margin: 0;
    }

    .notice {
        margin-top: 18px;
        padding: 14px;
        border-radius: 7px;
        background: #edf4fc;
        color: #284b73;
        font-size: 13px;
    }

    .back-link {
        display: inline-block;
        margin-top: 18px;
        color: #245b91;
        text-decoration: none;
        font-weight: bold;
        font-size: 14px;
    }

    footer {
        margin-top: 45px;
        background: #10243e;
        color: #dce6f4;
        text-align: center;
        padding: 20px;
        font-size: 13px;
    }

    @media (max-width: 750px) {
        .page-layout {
            grid-template-columns: 1fr;
            margin-top: 22px;
        }

        .form-card, .info-card {
            padding: 22px;
        }
    }

    @media (max-width: 480px) {
        nav {
            padding: 14px 5%;
        }

        .nav-links {
            gap: 12px;
        }

        .hero h1 {
            font-size: 25px;
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

<section class="hero">
    <div class="hero-inner">
        <h1>Submit a Complaint</h1>
        <p>
            Tell us about the issue so it can be recorded and its status
            can be managed through the complaint portal.
        </p>
    </div>
</section>

<div class="page-layout">

    <section class="form-card">
        <h2>Complaint Details</h2>

        <p class="intro">
            Fill in all required fields marked with an asterisk (*).
        </p>

        <form action="SubmitComplaint" method="post">

            <div class="form-group">
                <label for="student_name">
                    Student Name <span class="required">*</span>
                </label>

                <input type="text"
                       id="student_name"
                       name="student_name"
                       placeholder="Enter your full name"
                       maxlength="100"
                       required>
            </div>

            <div class="form-group">
                <label for="email">
                    Email Address <span class="required">*</span>
                </label>

                <input type="email"
                       id="email"
                       name="email"
                       placeholder="example@email.com"
                       maxlength="150"
                       required>
                <span class="hint">
                    Enter a valid email address.
                </span>
            </div>

            <div class="form-group">
                <label for="category">
                    Complaint Category <span class="required">*</span>
                </label>

                <select id="category" name="category" required>
                    <option value="">Select a category</option>
                    <option value="Academic">Academic</option>
                    <option value="Hostel">Hostel</option>
                    <option value="IT Support">IT Support</option>
                    <option value="Infrastructure">Infrastructure</option>
                    <option value="Other">Other</option>
                </select>
            </div>

            <div class="form-group">
                <label for="priority">
                    Priority <span class="required">*</span>
                </label>

                <select id="priority" name="priority" required>
                    <option value="Low">Low</option>
                    <option value="Medium" selected>Medium</option>
                    <option value="High">High</option>
                </select>

                <span class="hint">
                    Choose the priority that best describes your issue.
                </span>
            </div>

            <div class="form-group">
                <label for="description">
                    Complaint Description <span class="required">*</span>
                </label>

                <textarea id="description"
                          name="description"
                          placeholder="Describe your issue clearly..."
                          required></textarea>

                <span class="hint">
                    Include enough detail to explain the problem.
                </span>
            </div>

            <button type="submit" class="submit-btn">
                Submit Complaint →
            </button>

        </form>

        <a href="index.html" class="back-link">
            ← Back to Home
        </a>
    </section>

    <aside class="info-card">
        <h2>Before You Submit</h2>

        <div class="info-item">
            <h3>📝 1. Explain Clearly</h3>
            <p>
                Describe what happened and where the issue occurred.
            </p>
        </div>

        <div class="info-item">
            <h3>📂 2. Choose a Category</h3>
            <p>
                Select the category that best matches your complaint.
            </p>
        </div>

        <div class="info-item">
            <h3>⚡ 3. Set Priority</h3>
            <p>
                Choose Low, Medium, or High according to the urgency
                of your issue.
            </p>
        </div>

        <div class="info-item">
            <h3>📊 4. Check Progress</h3>
            <p>
                After submission, visit Complaint Records to see
                the current status of your complaint.
            </p>
        </div>

        <div class="notice">
            <strong>Important:</strong> Please provide accurate
            information. Your complaint will be recorded in the
            system after successful submission.
        </div>

        <a href="viewComplaints.jsp" class="back-link">
            View Complaint Records →
        </a>
    </aside>

</div>

<footer>
    <strong>Online Complaint Management System</strong>
    <br>
    Academic Mini Project | Java, JSP, MySQL and Python
</footer>

</body>
</html>
