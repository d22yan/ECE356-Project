<%-- 
    Document   : patient-table
    Created on : 19-Mar-2014, 10:17:46 PM
    Author     : root
--%>

<%@tag description="Generic Table" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="generic" %>
<%
    String defaultQuery = null;
    String staffQuery = null;
    String dataSourceUrl = Database.ServiceConstant.url + Database.ServiceConstant.database;
    if (request.getSession().getAttribute("user") != null) {
        Model.User user = (Model.User) request.getSession().getAttribute("user");
        staffQuery = Database.Query.staffDoctorList(user.getRoleId());
        defaultQuery = Database.Query.doctorList();
    }
%>

<html>
    <c:if test='${user != null}'>
        <style type="text/css">
            .searchbar {
                float:left;
                margin-left: 10px; 
            }
            #doctor-table > tbody[id^="patient-"] :hover {
                background: #DDDDDD;
            }
        </style>
        <sql:setDataSource 
            var="connection" 
            driver="com.mysql.jdbc.Driver"
            url="<%=dataSourceUrl%>"
            user="<%=Database.ServiceConstant.user%>"  
            password="<%=Database.ServiceConstant.pwd%>"/>
        <c:choose>
            <c:when test='${user.getGroupName() == "staff"}'>
                <sql:query dataSource="${connection}" var="doctorList">
                    <%=staffQuery%>
                </sql:query>
            </c:when>
            <c:when test='${user.getGroupName() == "admin"}'>
                <sql:query dataSource="${connection}" var="doctorList">
                    <%=defaultQuery%>
                </sql:query>
            </c:when>
            <c:when test='${user.getGroupName() == "financial"}'>
                <sql:query dataSource="${connection}" var="doctorList">
                    <%=defaultQuery%>
                </sql:query>
            </c:when>
        </c:choose>
        <table id="doctor-table" class="table">
            <thead>
                <tr>
                    <th>doctor id</th>
                    <th>doctor name</th>
                </tr>
            </thead>
            <c:forEach var="row" items="${doctorList.rows}">
                <tbody>
                    <td class="doctor-id">
                        <c:out value="${row.doctor_id}"/>
                    </td>
                    <td class="doctor-name">
                        <c:out value="${row.doctor_name}"/>
                    </td>
                    <c:if test='${user.getGroupName() == "financial"}'>
                        <td>
                            <a href="${pageContext.request.contextPath}/patientRecord.jsp?patientId=0&doctorId=${row.doctor_id}" target="_blank">
                                patient record summary
                            </a>
                        </td>
                    </c:if>
                    <c:if test='${user.getGroupName() == "staff" || user.getGroupName() == "admin"}'>
                        <td>
                            <a href="${pageContext.request.contextPath}/doctorAssign.jsp?doctorId=${row.doctor_id}" target="_blank">
                                assign                            
                            </a>
                        </td>
                    </c:if>
                    <c:if test='${user.getGroupName() == "admin"}'>
                        <td>
                            <a id="edit-doctor-${row.doctor_id}" data-doctor-id="${row.doctor_id}" href="#">
                                what is this?
                            </a>
                        </td>
                    </c:if>
                </tbody>
            </c:forEach>
        </table>
        <script type="text/javascript">
            $(document).ready(function() {
                $('[id^="edit-doctor"]').click(function(e){
                    alert("<!--TODO direct to doctor page-->");
                });
            });
        </script>
    </c:if>
</html>