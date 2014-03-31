/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author root
 */
@WebServlet(name = "AssignStaff", urlPatterns = {"/AssignStaff"})
public class AssignStaff extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        if (request.getParameter("doctorId") != null) {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String[] staffIdList = request.getParameterValues("selected[]");
            ResultSet assignedStaff = Database.Manager.getAssignedStaff(doctorId);
            Database.Manager.clearAssignedStaff(doctorId);
            for (String staffId : staffIdList) {
                if (!staffId.equals("null")) {
                    Database.Manager.addAssignedStaff(doctorId, Integer.parseInt(staffId), false);
                }
            }
            try {
                while (assignedStaff.next()) {
                    if (assignedStaff.getBoolean("view_patient_permission")) {
                        Database.Manager.grantStaffPermission(assignedStaff.getInt("doctor_id"), assignedStaff.getInt("staff_id"));
                    }
                }
            } catch (SQLException ex) {
                Logger.getLogger(AssignStaff.class.getName()).log(Level.SEVERE, null, ex);
            }
            try (PrintWriter out = response.getWriter()) {
                out.println(1);
            }
        } else {
            out.println(0);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
