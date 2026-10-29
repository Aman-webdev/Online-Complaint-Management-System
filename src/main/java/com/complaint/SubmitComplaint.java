
package com.complaint;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SubmitComplaint")
public class SubmitComplaint extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("student_name");
        String email = request.getParameter("email");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String priority = request.getParameter("priority");

        String sql = "INSERT INTO complaints "
                + "(student_name, email, category, description, priority) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, category);
            ps.setString(4, description);
            ps.setString(5, priority);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("viewComplaints.jsp?success=1");
            } else {
                response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Complaint could not be saved."
                );
            }

        } catch (Exception e) {
            throw new ServletException(
                "Error saving complaint to the database.", e
            );
        }
    }
}
