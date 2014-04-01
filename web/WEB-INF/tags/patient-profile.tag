<%-- 
    Document   : patient_profile
    Created on : Mar 28, 2014, 12:36:18 PM
    Author     : sanghoonlee
--%>

<%@tag description="Patient profile" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="patient-profile" %>

<%
    int patientId = 0;
    String patientProfileQuery = null;
    Model.User user = (Model.User) request.getSession().getAttribute("user");
    
    if (request.getParameter("patientId") != null) {
        patientId = Integer.parseInt(request.getParameter("patientId"));
    }
    
    if(user != null) {
        //for Patient editing their own profile
        if(patientId >0 ) {
           patientProfileQuery = "SELECT * FROM patient WHERE patient_id ="+patientId+ ";";
        } 
        //for staffs editing patient's profile
        else {
            patientProfileQuery = "SELECT * FROM patient WHERE patient_id ="+user.getRoleId()+ ";";
        }   
    }
%>

<html> 
    <c:if test='${user != null}'>
        <sql:setDataSource 
            var="connection" 
            driver="com.mysql.jdbc.Driver"
            url="<%=Database.ServiceConstant.dataSourceUrl%>"
            user="<%=Database.ServiceConstant.user%>"  
            password="<%=Database.ServiceConstant.pwd%>"/>
            
        <sql:query dataSource="${connection}" var="patientProfile">
            <%=patientProfileQuery%>
        </sql:query>
        <c:if test="${!empty param.patientId}">
            <sql:query dataSource="${connection}" var="patientUsername">
                SELECT username FROM user_account WHERE role_id = ${param.patientId} AND group_name = "patient";
            </sql:query>
        </c:if>
            
        <div class="container">
        <h3>Patient Information</h3></br>
        <div class="row">     
        <div class="col-md-12">
        <table class="table table-hover" >
            <tr id="roleId">
                <td class="col-md-5" >Role ID</td>
                <td class="col-md-5" >${param.patientId != null ? param.patientId : user.roleId}</td>
                <td class="col-md-2" ></td>
            </tr>
            <tr id="userName">
                <td class="col-md-5" >Username</td>
                <td class="col-md-5" >
                <c:forEach var="row" items="${patientUsername.rows}">
                    <c:out value="${row.username}"></c:out>
                </c:forEach>
                </td>
                <td class="col-md-2" ></td>
            </tr>
            <tr id="editName">
                <td class="col-md-5" >Name</td>
                <td class="col-md-5" >
                     <c:forEach var="row" items="${patientProfile.rows}">
                        <c:out value="${row.patient_name}"></c:out>
                     </c:forEach>
                </td>
                <td class="text-right col-md-2"><p class="text-primary">Edit</p></td>               
            </tr>  
            <tr class="edit-name table-row bg-warning" style="display:none;">
                <td  class="col-md-5" >
                    <form class="form-inline" role="form">
                    <div class="form-group">       
                        <label class="text-primary small" for="first-name">First Name </label> 
                        <input type="text" class="form-control" id="first-name" name="first-name" placeholder="First Name">
                    </div>
                    </form>
                </td>
                <td class="col-md-5">
                    <form class="form-inline" role="form">
                    <div class="form-group">           
                        <label class="text-primary small" for="last-name">Last Name </label>
                        <input type="text" class="form-control" id="last-name" name="last-name" placeholder="Last Name">
                    </div>
                    </form> 
                </td>
                <td class="button-right col-md-2">
                    <button type="button" id="nameButton" class="btn btn-primary btn-sm" onclick="updateName()">Save change</button>
                </td>
            </tr>
            <tr id="editPassword">
                <td>Password:</td>
                <td>********</td>
                <td class="text-right"><p class="text-primary">Edit</p></td>
            </tr>
            <tr class="edit-password table-row bg-warning" style="display:none;">
                <td  class="col-md-5" >
                    <form class="form-inline" role="form">
                    <div class="form-group">       
                        <label class="text-primary small" for="password">New Password </label> 
                        <input type="text" class="form-control" id="password" name="password" placeholder="New Password">
                    </div>
                    </form>
                </td>
                <td class="col-md-5"> 
                </td>
                <td class="button-right col-md-2">
                    <button type="button" id="nameButton" class="btn btn-primary btn-sm" onclick="updatePassword()">Save change</button>
                </td>
            </tr>
            <tr id="editAddress">
                <td>Address:</td>
                <td>
                    <c:forEach var="row" items="${patientProfile.rows}">
                        <c:out value="${row.address}"></c:out>
                    </c:forEach>
                </td>
                <td class="text-right"><p class="text-primary">Edit</p></td>
            </tr>
            <tr class="edit-address table-row bg-warning" style="display:none;">
                <td  class="col-md-5" >
                    <form class="form-inline" role="form">
                    <div class="form-group">       
                        <label class="text-primary small" for="address">New Address </label> 
                        <input type="text" class="form-control " id="address" name="address" placeholder="Unit, City, Prov, Country">
                    </div>
                    </form>
                </td>
                <td class="col-md-5"> 
                </td>
                <td class="button-right col-md-2">
                    <button type="button" id="nameButton" class="btn btn-primary btn-sm" onclick="updateAddress()">Save change</button>
                </td>
            </tr>
            <tr id="editPhoneNumber">
                <td>Phone Number:</td>
                <td>
                    <c:forEach var="row" items="${patientProfile.rows}">
                        <c:out value="${row.phone_number}"></c:out>
                    </c:forEach>
                </td>
                <td class="text-right"><p class="text-primary">Edit</p></td>
            </tr>
            <tr class="edit-phoneNumber table-row bg-warning" style="display:none;">
                <td  class="col-md-5" >
                    <form class="form-inline" role="form">
                    <div class="form-group">       
                        <label class="text-primary small" for="phone_number">New Phone Number </label> 
                        <input type="text" class="form-control" id="phone_number" name="phone_number" placeholder="New Phone Number">
                    </div>
                    </form>
                </td>
                <td class="col-md-5"> 
                </td>
                <td class="button-right col-md-2">
                    <button type="button" id="nameButton" class="btn btn-primary btn-sm" onclick="updatePhone()">Save change</button>
                </td>
            </tr>
            <tr id="editHealthCard">
                <td>Health Card:</td>
                <td>
                    <c:forEach var="row" items="${patientProfile.rows}">
                        <c:out value="${row.health_card}"></c:out>
                    </c:forEach>
                </td>
                <td class="text-right"><p class="text-primary">Edit</p></td>
            </tr>
            <tr class="edit-healthCard table-row bg-warning" style="display:none;">
                <td  class="col-md-5" >
                    <form class="form-inline" role="form">
                    <div class="form-group">       
                        <label class="text-primary small" for="health_card">New Health Card Number </label> 
                        <input type="text" class="form-control" id="health_card" name="health_card" placeholder="New Health Card Number">
                    </div>
                    </form>
                </td>
                <td class="col-md-5"> 
                </td>
                <td class="button-right col-md-2">
                    <button type="button" id="nameButton" class="btn btn-primary btn-sm" onclick="updateHeathCard()">Save change</button>
                </td>
            </tr>
            <tr id="editSINCard">
                <td>Social Insurance Card:</td>
                <td>
                    <c:forEach var="row" items="${patientProfile.rows}">
                        <c:out value="${row.social_insurance_number}"></c:out>
                    </c:forEach>
                </td>
                <td class="text-right"><p class="text-primary">Edit</p></td>
            </tr> 
            <tr class="edit-SIN table-row bg-warning" style="display:none;">
                <td  class="col-md-5" >
                    <form class="form-inline" role="form">
                    <div class="form-group">       
                        <label class="text-primary small" for="SIN">New Social Insurance Card Number </label> 
                        <input type="text" class="form-control" id="SIN" name="SIN" placeholder="New SIN Card Number">
                    </div>
                    </form>
                </td>
                <td class="col-md-5"> 
                </td>
                <td class="button-right col-md-2">
                    <button type="button" id="nameButton" class="btn btn-primary btn-sm" onclick="updateSIN()">Save change</button>
                </td>
            </tr>
            <tr id="editHealthStatus">
                <td>Health Status:</td>
                <td>
                    <c:forEach var="row" items="${patientProfile.rows}">
                        <c:out value="${row.current_health}"></c:out>
                    </c:forEach>
                </td>
                <td class="text-right">
                    <c:if test="${user.groupName != 'patient'}">
                        <p class="text-primary">Edit</p>
                    </c:if>
                </td>
            </tr>
            <c:if test="${user.groupName != 'patient'}">
                 <tr class="edit-Health-status table-row bg-warning" style="display:none;">
                    <td  class="col-md-5" >
                        <form class="form-inline" role="form">
                        <div class="form-group">       
                            <label class="text-primary small" for="health-status">New Health Status</label> 
                            <input type="text" class="form-control" id="health-status" name="health-status" placeholder="New Health Status">
                        </div>
                        </form>
                    </td>
                    <td class="col-md-5"> 
                    </td>
                    <td class="button-right col-md-2">
                        <button type="button" id="nameButton" class="btn btn-primary btn-sm" onclick="updateHealthStatus()">Save change</button>
                    </td>
                </tr>
            </c:if>
        </table>
        </div>
        </div>
        </div>
    </c:if>         
</html>

<script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
<script>
    $(function(){
       $("#editName").click(function(){
                if(!$("#first-name").is(':visible')) {
                    $("#first-name").val('');
                    $("#last-name").val('');                
                }
                    $('.edit-name').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        
        $("#editPassword").click(function(){
            if(!$("#password").is(':visible')) {
                $("#password").val('');               
            }
            $('.edit-password').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        
        $("#editAddress").click(function(){
            if(!$("#address").is(':visible')) {
                $("#address").val('');               
            }
            $('.edit-address').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        
        $("#editPhoneNumber").click(function(){
            if(!$("#phone_number").is(':visible')) {
                $("#phone_number").val('');               
            }
            $('.edit-phoneNumber').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        
        $("#editHealthCard").click(function(){
            if(!$("#health_card").is(':visible')) {
                $("#health_card").val('');               
            }
            $('.edit-healthCard').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        $("#editSINCard").click(function(){
            if(!$("#SIN").is(':visible')) {
                $("#SIN").val('');               
            }
            $('.edit-SIN').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        $("#editHealthStatus").click(function(){
            if(!$("#health-status").is(':visible')) {
                $("#health-status").val('');               
            }
            $('.edit-Health-status').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 

    });
    
    function updateHealthStatus() {
        if($('#health-status').val().length>0){
            $('#health-status').parent().prev().css('color', 'black');
            $('#health-status').css('border-color', '#ccc');
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/UserInfoUpdateServlet",
                data: {type:<%=Database.UpdateQueries.PATIENT_UPDATE_HEALTHSTATUS%>,
                        tableType:"<%=Database.UpdateQueries.PATIENT_TABLE_NAME%>",
                        patientId:"<%=patientId%>",
                        updateValue:$('#health-status').val()},
                success : function(data){
                    location.reload(true);
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert(jqXHR+" - "+textStatus+" - "+errorThrown);
                }  
            });
        } else {
            $('#health-status').parent().prev().css('color', 'red');
            $('#health-status').css('border-color', 'red');
        }  
    }

    function updatePassword() {
        if($('#password').val().length>0){
            $('#password').parent().prev().css('color', 'black');
            $('#password').css('border-color', '#ccc');
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/UserInfoUpdateServlet",
                data: {type:<%=Database.UpdateQueries.USER_ACCOUNT_PASSWORD%>,
                        tableType:"<%=Database.UpdateQueries.USER_ACCOUNT_TABLE_NAME%>",
                        patientId:"<%=patientId%>",
                        updateValue:$('#password').val()},
                success : function(data){
                    location.reload(true);
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert(jqXHR+" - "+textStatus+" - "+errorThrown);
                }  
            });
        } else {
            $('#password').parent().prev().css('color', 'red');
            $('#password').css('border-color', 'red');
        }
    } 
    
    function updateAddress() {
        if($('#address').val().length>0){
            $('#address').parent().prev().css('color', 'black');
            $('#address').css('border-color', '#ccc');
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/UserInfoUpdateServlet",
                data: {type:<%=Database.UpdateQueries.PATIENT_UPDATE_ADDRESS%>,
                        tableType:"<%=Database.UpdateQueries.PATIENT_TABLE_NAME%>",
                        patientId:"<%=patientId%>",
                        updateValue:$('#address').val()},
                success : function(data){
                    location.reload(true);
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert(jqXHR+" - "+textStatus+" - "+errorThrown);
                }  
            });
        } else {
            $('#address').parent().prev().css('color', 'red');
            $('#address').css('border-color', 'red');
        }
    }
    
    function updatePhone() {
        if($('#phone_number').val().length>0){
            $('#phone_number').parent().prev().css('color', 'black');
            $('#phone_number').css('border-color', '#ccc');
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/UserInfoUpdateServlet",
                data: {type:<%=Database.UpdateQueries.PATIENT_UPDATE_PHONENUMB%>,
                        tableType:"<%=Database.UpdateQueries.PATIENT_TABLE_NAME%>",
                        patientId:"<%=patientId%>",
                        updateValue:$('#phone_number').val()},
                success : function(data){
                    location.reload(true);
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert(jqXHR+" - "+textStatus+" - "+errorThrown);
                }  
            });
        } else {
            $('#phone_number').parent().prev().css('color', 'red');
            $('#phone_number').css('border-color', 'red');
        }
    }
    
    function updateHeathCard() {
        if($('#health_card').val().length>0){
            $('#health_card').parent().prev().css('color', 'black');
            $('#health_card').css('border-color', '#ccc');
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/UserInfoUpdateServlet",
                data: {type:<%=Database.UpdateQueries.PATIENT_UPDATE_HEALTHCARD%>,
                        tableType:"<%=Database.UpdateQueries.PATIENT_TABLE_NAME%>",
                        patientId:"<%=patientId%>",
                        updateValue:$('#health_card').val()},
                success : function(data){
                    location.reload(true);
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert(jqXHR+" - "+textStatus+" - "+errorThrown);
                }  
            });
        } else {
            $('#health_card').parent().prev().css('color', 'red');
            $('#health_card').css('border-color', 'red');
        }
    }
    
    function updateSIN() {
        if($('#SIN').val().length>0){
            $('#SIN').parent().prev().css('color', 'black');
            $('#SIN').css('border-color', '#ccc');
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/UserInfoUpdateServlet",
                data: {type:<%=Database.UpdateQueries.PATIENT_UPDATE_SINCARD%>,
                        tableType:"<%=Database.UpdateQueries.PATIENT_TABLE_NAME%>",
                        patientId:"<%=patientId%>",
                        updateValue:$('#SIN').val()},
                success : function(data){
                    location.reload(true);
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert(jqXHR+" - "+textStatus+" - "+errorThrown);
                }  
            });
        } else {
            $('#SIN').parent().prev().css('color', 'red');
            $('#SIN').css('border-color', 'red');
        }
    }

    function updateName() {
        if ($('#first-name').val().length > 0 && $('#last-name').val().length > 0) {           
                $('#first-name').parent().prev().css('color', 'black');
                $('#first-name').css('border-color', '#ccc');
                $('#last-name').parent().prev().css('color', 'black');
                $('#last-name').css('border-color', '#ccc');
                $.ajax({
                    type: "POST",
                    url: "${pageContext.request.contextPath}/UserInfoUpdateServlet",
                    data: {type:<%=Database.UpdateQueries.PATIENT_UPDATE_NAME%>,
                            tableType:"<%=Database.UpdateQueries.PATIENT_TABLE_NAME%>",
                            patientId:"<%=patientId%>",
                            updateValue:$('#first-name').val() +" "+ $('#last-name').val()},
                    success : function(data){
                        location.reload(true);
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                         alert(jqXHR+" - "+textStatus+" - "+errorThrown);
                     }  
                  });

        } else {
                if ($('#first-name').val().length < 1) {
                        $('#first-name').parent().prev().css('color', 'red');
                        $('#first-name').css('border-color', 'red');
                } else {
                        $('#first-name').parent().prev().css('color', 'black');
                        $('#first-name').css('border-color', '#ccc');
                }

                if ($('#last-name').val().length < 1) {
                        $('#last-name').parent().prev().css('color', 'red');
                        $('#last-name').css('border-color', 'red');
                } else {
                        $('#last-name').parent().prev().css('color', 'black');
                        $('#last-name').css('border-color', '#ccc');
                }
        }	
    }
</script>
