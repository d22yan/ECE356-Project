<%-- 
    Document   : index
    Created on : 10-Mar-2014, 9:28:16 PM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="generic" tagdir="/WEB-INF/tags" %>

<generic:page-template title="Home">
    <jsp:body>
        <!-- Example row of columns -->
        <div class="row">
          <div class="col-md-4">
            <h2>Patients</h2>
            <p>Please sign in to view your appointments, visitation records, and update your profile.</p>
            <p>If you don't have an account yet, just ask any staff member and we'll set you up!</p>
            <p><a class="btn btn-default" href="#" role="button">Sign in &raquo;</a></p>
          </div>
          <div class="col-md-4">
            <h2>Doctors</h2>
            <p>Please sign in to view your appointments, access patient information for your own patients, or grant permission to view your patients to other doctors.</p>
            <p>If you have trouble accessing your account, ask the admin for help!</p>
            <p><a class="btn btn-default" href="#" role="button">Sign in &raquo;</a></p>
         </div>
          <div class="col-md-4">
            <h2>Staff</h2>
            <p>Please sign in to schedule appointments, create patient accounts, view and update patient information, and assign patients to doctors.</p>
            <p>If you have trouble accessing your account, ask the admin for help!</p>
            <p><a class="btn btn-default" href="#" role="button">Sign in &raquo;</a></p>
          </div>
        </div>
    </jsp:body>
</generic:page-template>