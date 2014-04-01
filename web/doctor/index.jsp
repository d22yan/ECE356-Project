<%-- 
    Document   : doctor
    Created on : Mar 17, 2014, 6:26:07 PM
    Author     : Lewis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="generic" tagdir="/WEB-INF/tags" %>

<generic:page-template title="Doctor" tabbed="true">
    <jsp:body>
        <generic:tab-template id="user-information-tab" label="Information" isActive="true">
            <jsp:body>
                <generic:user-information></generic:user-information>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="appointment-tab" label="Appointments">
            <jsp:body>
                <generic:appointment-table></generic:appointment-table>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="patient-tab" label="Patients">
            <jsp:body>
                <generic:patient-table></generic:patient-table>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="patient-records-tab" label="Patient Records">
            <jsp:body>
                <a href="${pageContext.request.contextPath}/patientRecord.jsp?patientId=0" target="_blank" class="btn btn-primary btn-standalone">
                    view my patient records
                </a>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="assign-tab" label="Grant Permission">
            <jsp:body>
                <a href="${pageContext.request.contextPath}/doctorAssign.jsp?doctorId=${user.getRoleId()}" target="_blank" class="btn btn-primary btn-standalone">
                    go to permissions
                </a>
            </jsp:body>
        </generic:tab-template>
    </jsp:body>
</generic:page-template>