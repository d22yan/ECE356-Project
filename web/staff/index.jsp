<%-- 
    Document   : legal
    Created on : Mar 17, 2014, 6:26:07 PM
    Author     : Lewis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="generic" tagdir="/WEB-INF/tags" %>

<generic:page-template title="Staff" tabbed="true">
    <jsp:body>
        <generic:tab-template id="appointment-tab" label="Appointments" isActive="true">
            <jsp:body>
                <generic:appointment-table></generic:appointment-table>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="patient-tab" label="Patients">
            <jsp:body>
                <generic:patient-table></generic:patient-table>
            </jsp:body>
        </generic:tab-template>
        <generic:tab-template id="create-role-tab" label="Create Patient">
            <jsp:body>
                <generic:create-role createPatient="true" createStaff="false" createDoctor="false"></generic:create-role>
            </jsp:body>
        </generic:tab-template>
    </jsp:body>
</generic:page-template>