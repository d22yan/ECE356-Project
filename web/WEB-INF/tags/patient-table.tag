<%-- 
    Document   : patient-table
    Created on : 19-Mar-2014, 10:17:46 PM
    Author     : root
--%>

<%@tag description="Patient Table" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="generic" %>

<%
    String query = null;    
    Model.User user = (Model.User) request.getSession().getAttribute("user");
    
    if (user.getGroupName() == "doctor") 
        query = Database.Query.DoctorPatientList(user.getRoleId());
    else if (user.getGroupName() == "staff") 
        query = Database.Query.DoctorPatientList(user.getRoleId());
    else 
        query = Database.Query.DefaultPatientList();
%>

<generic:table-template query="<%=query%>"></generic:table-template>