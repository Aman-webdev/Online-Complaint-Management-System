
package com.complaint;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdateComplaintStatus")
public class UpdateComplaintStatus extends HttpServlet {

    private static final long serialVersionUID = 2574203222719002227L;

	@Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String idText = request.getParameter("complaint_id");
        String status = request.getParameter("status");

        if (idText == null ||
            !idText.matches("\\d+") ||
            status == null ||
            !(status.equals("Pending")
              || status.equals("In Progress")
              || status.equals("Resolved"))) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid complaint ID or status."
            );
            return;
        }

        String sql =
            "UPDATE complaints SET status = ? WHERE complaint_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, Integer.parseInt(idText));

            int updated = ps.executeUpdate();

            if (updated == 0) {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Complaint not found."
                );
                return;
            }

            response.sendRedirect(
                request.getContextPath()
                + "/viewComplaints.jsp?message=updated"
            );

        } catch (SQLException e) {
            throw new ServletException(
                "Could not update complaint status.", e
            );
        }
    }
}
