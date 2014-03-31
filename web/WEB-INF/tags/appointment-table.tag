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
            #appointment-table > tbody > tr[id^="appointment-"]:hover {
                background: #DDDDDD;
                cursor: pointer;
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
        <form id="appointment-searchbar" class="form-inline clearfix" style="padding: 10px">
            <div id="search-option" class="searchbar">
                <select class="form-control">
                    <option value="appointment-id" selected="selected" data-type="int">appointment-id</option>
                    <option value="doctor-name" data-type="string">doctor name</option>
                    <option value="patient-name" data-type="string">default doctor name</option>
                    <option value="start-time" data-type="date">start time</option>
                    <option value="end-time" data-type="date">end time</option>
                </select> 
            </div>
            <div id="search-single" class="searchbar" style="width:200px" hidden>
                <input id="search-input" class="form-control" type="search" placeholder="search"></input>
            </div>
            <div id="search-range" class="form-inline searchbar" style="width:500px">
                <div class="input-group date" style="float:left;padding-right:5px; width:200px">
                    <input id="search-min" class="form-control" type="search" placeholder="min"></input>
                    <span class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                </div>
                <div class="input-group date" style="width:200px">
                    <input id="search-max" class="form-control" type="search" placeholder="max"></input>
                    <span class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                </div>
            </div>
        </form>
        <table id="appointment-table" class="table">
            <thead>
                <tr>
                    <th>appointment id</th>
                    <th>doctor name</th>
                    <th>patient name</th>
                    <th>start time</th>
                    <th>end time</th>
                    <c:if test='${user.getGroupName() == "staff"}'>
                        <th>details</th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="row" items="${appointmentList.rows}">
                <tr id="appointment-${row.appointment_id}">
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
                </tr>
            </c:forEach>
            </tbody>
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