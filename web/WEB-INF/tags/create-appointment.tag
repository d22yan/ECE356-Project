<%-- 
    Document   : patient-record
    Created on : 25-Mar-2014, 12:58:41 AM
    Author     : root
--%>

<%@tag description="Appointment Edit" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="create-appointment" %>
<%
    int staffId = 0;
    String dataSourceUrl = Database.ServiceConstant.url + Database.ServiceConstant.database;
    Model.User user = null;
    if (request.getSession().getAttribute("user") != null) {
        user = (Model.User) request.getSession().getAttribute("user");
        if (user.getGroupName().equals("staff")) {
            staffId = user.getRoleId();
        }
    } else {
    }
%>
<html>
    <c:if test='${user != null}'>
        <style type="text/css">
            .searchbar {
                float:left;
                margin-left: 10px; 
            }
        </style>
        <sql:setDataSource 
            var="connection" 
            driver="com.mysql.jdbc.Driver"
            url="<%=dataSourceUrl%>"
            user="<%=Database.ServiceConstant.user%>"  
            password="<%=Database.ServiceConstant.pwd%>"/>
        <sql:query dataSource="${connection}" var="patientInformation">
            SELECT
                *
            FROM
                patient;
        </sql:query>
        <sql:query dataSource="${connection}" var="doctorInformation">
            SELECT 
                doctor.doctor_id, 
                doctor.doctor_name 
            FROM 
                doctor 
            RIGHT JOIN 
                (SELECT 
                    * 
                FROM 
                    assigned_staff 
                WHERE 
                    assigned_staff.staff_id = <%=staffId%> ) 
            AS 
                test 
            ON 
                doctor.doctor_id = test.doctor_id;
        </sql:query>
        <c:if test='${user.getGroupName() == "staff"}'> 
            <form role="form" action="${pageContext.request.contextPath}/CreateAppointmentServlet" method="post" class="form-standalone">
                <p>Doctor</p>
                <select name="doctor" class="form-control">
                    <c:forEach var="row" items="${doctorInformation.rows}">
                        <option value="${row.doctor_id}">
                            <c:out value="${row.doctor_name}"/>
                        </option>
                    </c:forEach>
                </select>
                <p>Patient:</p>
                <select name="patient" class="form-control">
                    <c:forEach var="row" items="${patientInformation.rows}">
                            <option value="${row.patient_id}">
                                <c:out value="${row.patient_name}"/>
                            </option>
                    </c:forEach>
                </select>
                <p>Start Time:</p>
                <div id="start-time" class="input-group date">
                    <input id="start-time-value" name = "startTime" class="form-control" type="search" ></input>
                    <span class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                </div>
                <p>End Time:</p>
                <div id="end-time" class="input-group date">
                    <input id="end-time-value" name = "endTime" class="form-control" type="search" ></input>
                    <span class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                </div>
           
                <button type="submit" class="btn btn-success">Submit</button>
            </form>
        </c:if>
        <script type="text/javascript">
                $(document).ready(function() {
                    $('#start-time').datetimepicker({
                        defaultDate: moment("${param.startTime}")
                    });
                });
                
                $(document).ready(function() {
                    $('#end-time').datetimepicker({
                        defaultDate: moment("${param.endTime}")
                    });
                });
        </script>
    </c:if>
</html>