<%-- 
    Document   : legal
    Created on : Mar 17, 2014, 6:26:07 PM
    Author     : Lewis
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="generic" tagdir="/WEB-INF/tags" %>


<generic:page-template title="Patient">
    <jsp:body>
         <a href='${pageContext.request.contextPath}/patientRecord.jsp?patientId=${user.getRoleId()}' target='_blank'>goto patientRecord</a>
         <generic:patient-profile></generic:patient-profile>
    </jsp:body>
</generic:page-template>
