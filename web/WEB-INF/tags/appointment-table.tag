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
    String doctorQuery = null;
    String staffQuery = null;
    String dataSourceUrl = Database.ServiceConstant.url + Database.ServiceConstant.database;
    if (request.getSession().getAttribute("user") != null) {
        Model.User user = (Model.User) request.getSession().getAttribute("user");
        doctorQuery = Database.Query.doctorAppointmentList(user.getRoleId());
        staffQuery = Database.Query.staffAppointmentList(user.getRoleId());
//        defaultQuery = Database.Query.staffappointmentList(user.getRoleId());
    }
%>

<html>
    <c:if test='${user != null}'>
        <style type="text/css">
            .searchbar {
                float:left;
                margin-left: 10px; 
            }
            #appointment-table > tbody[id^="patient-"] :hover {
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
                <sql:query dataSource="${connection}" var="appointmentList">
                    <%=staffQuery%>
                </sql:query>
            </c:when>
            <c:when test='${user.getGroupName() == "doctor"}'>
                <sql:query dataSource="${connection}" var="appointmentList">
                    <%=doctorQuery%>
                </sql:query>
            </c:when>
        </c:choose>
        <table id="appointment-table" class="table">
            <thead>
                <tr>
                    <th>appointment id</th>
                    <th>doctor name</th>
                    <th>patient name</th>
                    <th>start time</th>
                    <th>end time</th>
                </tr>
            </thead>
            <c:forEach var="row" items="${appointmentList.rows}">
                <tbody>
                    <td class="appointment-id">
                        <c:out value="${row.appointment_id}"/>
                    </td>
                    <td class="doctor-id">
                        <c:out value="${row.doctor_name}"/>
                    </td>
                    <td class="patient-id">
                        <c:out value="${row.patient_name}"/>
                    </td>
                    <td class="start-time">
                        <c:out value="${row.appointment_start_time}"/>
                    </td>
                    <td class="end-time">
                        <c:out value="${row.appointment_end_time}"/>
                    </td>
                    <c:if test='${user.getGroupName() == "staff"}'>
                        <td>
                            <a id="edit-appointment-${row.appointment_id}" data-appointment-id="${row.appointment_id}" href="#">
                                what is this?
                            </a>
                        </td>
                    </c:if>
                </tbody>
            </c:forEach>
        </table>
        <script type="text/javascript">
            $(document).ready(function() {
                $('[id^="edit-appointment"]').click(function(e){
                    alert("<!--TODO direct to appointment page-->");
                });
            });
        </script>
    </c:if>
</html>