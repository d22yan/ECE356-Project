<%-- 
    Document   : legal
    Created on : Mar 17, 2014, 6:26:07 PM
    Author     : Lewis
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="generic" tagdir="/WEB-INF/tags" %>


<generic:page-template title="Patient" tabbed="true">
    <jsp:body>
        <generic:tab-template id="patient-profile-tab" label="Profile" isActive="true">
            <jsp:body>
                <generic:patient-profile></generic:patient-profile>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="appointment-tab" label="Appointments">
            <jsp:body>
                <generic:appointment-table></generic:appointment-table>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="patient-record-tab" label="Patient Records">
            <jsp:body>
                <a href='${pageContext.request.contextPath}/patientRecord.jsp?patientId=${user.getRoleId()}' target='_blank' class="btn btn-primary">go to patient record</a>
            </jsp:body>
        </generic:tab-template>
    </jsp:body>
</generic:page-template>
