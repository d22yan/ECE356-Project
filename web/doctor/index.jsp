<%-- 
    Document   : doctor
    Created on : Mar 17, 2014, 6:26:07 PM
    Author     : Lewis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="generic" tagdir="/WEB-INF/tags" %>

<generic:page-template title="Doctor">
    <jsp:body>
        <generic:appointment-table></generic:appointment-table>
        <generic:patient-table></generic:patient-table>
    </jsp:body>
</generic:page-template>