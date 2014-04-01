<%-- 
    Document   : finance
    Created on : Mar 31, 2014, 10:48:26 AM
    Author     : sanghoonlee
--%>
<%@tag description="Finance page" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="finance" %>

<%
    boolean validToDisplay = false;
    String defaultDoctorSelector = "Select Doctor";
    int patientId = 0;
    String listOfDoctors = "SELECT * FROM doctor;";
         
    
%>

<html> 
    <c:if test='${user != null}'>
        <sql:setDataSource 
            var="connection" 
            driver="com.mysql.jdbc.Driver"
            url="<%=Database.ServiceConstant.dataSourceUrl%>"
            user="<%=Database.ServiceConstant.user%>"  
            password="<%=Database.ServiceConstant.pwd%>"/>
            
        <sql:query dataSource="${connection}" var="doctorList">
            <%=listOfDoctors%>
        </sql:query>
            
            
        <nav class="navbar navbar-default" role="navigation">
            <div class="container-fluid">
            
                <p class="navbar-text">Doctor Name:</p>
                <form class="navbar-form navbar-left">
                    <div class="form-group">
                        <select class="form-control" id="doctor-name">
                            <option selected disabled selected="true"><%=defaultDoctorSelector%></option>
                            <c:forEach var="row" items="${doctorList.rows}">
                                <option value="doctor-${row.patient_id}">${row.doctor_name}</option>
                            </c:forEach>
                         </select>
                    </div> 
                </form>
                
                <div id="patient-record-search-range" class="form-inline">
                    <p class="navbar-text">Start Time:</p>
                    <div class="col-md-3">
                        <div class="input-group date navbar-form">
                            <input id="start-time" class="form-control" type="search"></input>
                            <span class="input-group-addon">
                                <span class="glyphicon glyphicon-calendar"></span>
                            </span>
                        </div>
                    </div>                            

                    <p class="navbar-text">End Time:</p>
                    <div class="col-md-3">
                        <div class="input-group date navbar-form">
                            <input id="end-time" class="form-control" type="search"></input>
                            <span class="input-group-addon">
                                <span class="glyphicon glyphicon-calendar"></span>
                            </span>
                        </div>
                    </div> 
                </div>
            </div>
                <c:if test='${validToDisplay == true}'>
                    PATIENT TABLE goes here
                </c:if>
        </nav>  
</c:if>
</html>

<script>
    $(document).ready(function() {
        $('#patient-record-search-range .input-group').datetimepicker({});
    });

    
    $('#patient-record-search-range .date').on('dp.change', function(e) {
        patientFilter();
    });
    
    $('#doctor-name').on('change', function(e) {
        patientFilter();
    });
    
    function patientFilter() {
       if(validateTime() && validateDoctor()) {
           alert("sdasd");
       }
    }
    
    function validateTime() {
        return (moment($('#start-time').val()).isValid() && moment($('#end-time').val()).isValid()) ? true : false;   
    }
    
    function validateDoctor() {
        var e = document.getElementById("doctor-name");
        var strUser = e.options[e.selectedIndex].text; 
        return (strUser!=="<%=defaultDoctorSelector%>")? true:false;
    }
    
</script>
