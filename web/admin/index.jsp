<%-- 
    Document   : index
    Created on : 30-Mar-2014, 4:17:29 PM
    Author     : root
--%>

<%@page import="java.util.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="generic" tagdir="/WEB-INF/tags" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<generic:page-template title="Admin" tabbed="true">
    <jsp:body>
        <generic:tab-template id="audit-trail-tab" label="Audit Trail" isActive="true">
            <jsp:body>
                <c:forTokens var="historyTable" items="appointment,assigned_patient,assigned_staff,doctor,grant_permission,patient,patient_record,staff,user_account" delims=",">
                    <a href="${pageContext.request.contextPath}/auditTrail.jsp?historyTable=${historyTable}" target="_blank" class="btn btn-primary btn-standalone">
                        go to <c:out value="${historyTable}"/> history table
                    </a>
                </c:forTokens>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="create-role-tab" label="Create Role">
            <jsp:body>
                <generic:create-role createPatient="true" createStaff="true" createDoctor="true"></generic:create-role>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="doctor-tab" label="Doctors">
            <jsp:body>
                <generic:doctor-table></generic:doctor-table>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="patient-record-tab" label="Patient Records">
            <jsp:body>
                <a href="${pageContext.request.contextPath}/patientRecord.jsp?" target="_blank" class="btn btn-primary btn-standalone">
                    view all patient records
                </a>
            </jsp:body>
        </generic:tab-template>
    </jsp:body>
</generic:page-template>