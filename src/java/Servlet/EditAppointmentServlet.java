/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Servlet;

import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Tony Fu
 */
@WebServlet(name = "EditAppointmentServlet", urlPatterns = {"/EditAppointmentServlet"})
public class EditAppointmentServlet extends HttpServlet {

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
        PrintWriter out = response.getWriter();
        User user = (Model.User) request.getSession().getAttribute("user");
        try {
            
            int appId = Integer.parseInt( request.getParameter("appointmentId") );
            int docId = Integer.parseInt( request.getParameter("doctor") );
            int patId = Integer.parseInt( request.getParameter("patient") );
            
            String inputStartDate = request.getParameter("startTime");
            String inputEndDate = request.getParameter("endTime");
            
            SimpleDateFormat preformatter = new SimpleDateFormat("MM/dd/yyyy hh:mm aa");
            Date startDate = preformatter.parse(inputStartDate);
            Date endDate = preformatter.parse(inputEndDate);
            
            if ( !Database.Manager.verifyAppointment(startDate, endDate, docId, appId) )
            {
                throw new ParseException("", 0);
            }
            
            SimpleDateFormat postformatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");         
            String sqlStartDate = postformatter.format(startDate);
            String sqlEndDate = postformatter.format(endDate);
            
            if (user == null) 
                throw new ClassNotFoundException();
            
            Database.Manager.modifyAppointment(appId, docId, patId, sqlStartDate, sqlEndDate);
            
            response.sendRedirect(user.getGroupName()); //redirect to group page
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(LoginServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.getSession().setAttribute("user", null);
            response.sendRedirect(""); //redirect to root
        } catch (SQLException ex) {
            Logger.getLogger(LoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex){
            request.getSession().setAttribute("errorMsg", "Invalid Input");
            response.sendRedirect(user.getGroupName()); //redirect to root
        } finally {
            out.close();
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
