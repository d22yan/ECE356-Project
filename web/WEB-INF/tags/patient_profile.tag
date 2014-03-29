<%-- 
    Document   : patient_profile
    Created on : Mar 28, 2014, 12:36:18 PM
    Author     : sanghoonlee
--%>

<%@tag description="Patient profile" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="patient_profile" %>

<%
    String patientProfileQuery = null;
    Model.User user = (Model.User) request.getSession().getAttribute("user");
    if(user != null) {
         patientProfileQuery = "SELECT * FROM patient WHERE patient_id ="+user.getRoleId()+ ";";
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
            
        <div class="container">
        <h3>Patient Information</h3></br>
        <div class="row">     
        <div class="col-md-12">
        <table class="table table-hover" >
            <tr id="editName">
                <td class="col-md-5" >Name</td>
                <td class="col-md-5" >
                     <c:forEach var="row" items="${patientProfile.rows}">
                        <c:out value="${row.patient_name}"></c:out>
                     </c:forEach>
                </td>
                <td class="text-right col-md-2"><p class="text-primary">Edit</p></td>               
            </tr>  
            <tr class="edit_name table-row bg-warning" style="display:none;">
                <td  class="col-md-5" >
                    <form class="form-inline" role="form">
                    <div class="form-group">       
                        <label class="text-primary small" for="first_name">First Name </label> 
                        <input type="text" class="form-control" id="first_name" name="first_name" placeholder="First Name">
                    </div>
                    </form>
                </td>
                <td class="col-md-5">
                    <form class="form-inline" role="form">
                    <div class="form-group">           
                        <label class="text-primary small" for="last_name">Last Name </label>
                        <input type="text" class="form-control" id="last_name" name="last_name" placeholder="Last Name">
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
            <tr class="edit_password table-row bg-warning" style="display:none;">
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
            <tr class="edit_address table-row bg-warning" style="display:none;">
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
            <tr class="edit_phoneNumber table-row bg-warning" style="display:none;">
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
            <tr class="edit_healthCard table-row bg-warning" style="display:none;">
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
            <tr class="edit_SIN table-row bg-warning" style="display:none;">
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
            <tr>
                <td>Health Status:</td>
                <td>
                    <c:forEach var="row" items="${patientProfile.rows}">
                        <c:out value="${row.current_health}"></c:out>
                    </c:forEach>
                </td>
                <td></td>
            </tr> 
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
                if(!$("#first_name").is(':visible')) {
                    $("#first_name").val('');
                    $("#last_name").val('');                
                }
                    $('.edit_name').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        
        $("#editPassword").click(function(){
            if(!$("#password").is(':visible')) {
                $("#password").val('');               
            }
            $('.edit_password').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        
        $("#editAddress").click(function(){
            if(!$("#address").is(':visible')) {
                $("#address").val('');               
            }
            $('.edit_address').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        
        $("#editPhoneNumber").click(function(){
            if(!$("#phone_number").is(':visible')) {
                $("#phone_number").val('');               
            }
            $('.edit_phoneNumber').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        
        $("#editHealthCard").click(function(){
            if(!$("#health_card").is(':visible')) {
                $("#health_card").val('');               
            }
            $('.edit_healthCard').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 
        $("#editSINCard").click(function(){
            if(!$("#SIN").is(':visible')) {
                $("#SIN").val('');               
            }
            $('.edit_SIN').animate({height: "toggle", opacity:"toggle" }, 'medium');
        }); 

    });

    function updatePassword() {
        if($('#password').val().length>0){
            $('#password').parent().prev().css('color', 'black');
            $('#password').css('border-color', '#ccc');
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/UserInfoUpdateServlet",
                data: {type:<%=Database.UpdateQueries.USER_ACCOUNT_PASSWORD%>,
                        tableType:"<%=Database.UpdateQueries.USER_ACCOUNT_TABLE_NAME%>",
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
        if ($('#first_name').val().length > 0 && $('#last_name').val().length > 0) {           
                $('#first_name').parent().prev().css('color', 'black');
                $('#first_name').css('border-color', '#ccc');
                $('#last_name').parent().prev().css('color', 'black');
                $('#last_name').css('border-color', '#ccc');
                $.ajax({
                    type: "POST",
                    url: "${pageContext.request.contextPath}/UserInfoUpdateServlet",
                    data: {type:<%=Database.UpdateQueries.PATIENT_UPDATE_NAME%>,
                            tableType:"<%=Database.UpdateQueries.PATIENT_TABLE_NAME%>",
                            updateValue:$('#first_name').val() +" "+ $('#last_name').val()},
                    success : function(data){
                        location.reload(true);
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                         alert(jqXHR+" - "+textStatus+" - "+errorThrown);
                     }  
                  });

        } else {
                if ($('#first_name').val().length < 1) {
                        $('#first_name').parent().prev().css('color', 'red');
                        $('#first_name').css('border-color', 'red');
                } else {
                        $('#first_name').parent().prev().css('color', 'black');
                        $('#first_name').css('border-color', '#ccc');
                }

                if ($('#last_name').val().length < 1) {
                        $('#last_name').parent().prev().css('color', 'red');
                        $('#last_name').css('border-color', 'red');
                } else {
                        $('#last_name').parent().prev().css('color', 'black');
                        $('#last_name').css('border-color', '#ccc');
                }
        }	
    }
</script>