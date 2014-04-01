<%-- 
    Document   : user-information
    Created on : Mar 31, 2014, 3:40:58 PM
    Author     : sanghoonlee
--%>

<%@tag description="User information" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="user-information" %>

<%
    
    String userProfileQuery = null;
    Model.User user = (Model.User) request.getSession().getAttribute("user");

    if(user != null) {
        //for user name
        userProfileQuery = "SELECT * FROM "+user.getGroupName()+" WHERE "+user.getGroupName()+"_id ="+user.getRoleId()+ ";";  
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
            
        <sql:query dataSource="${connection}" var="userProfile">
            <%=userProfileQuery%>
        </sql:query>
            
        <div class="container">
        <h3>Patient Information</h3></br>
        <div class="row">     
        <div class="col-md-12">
        <table class="table table-hover" >
            <tr id="editName">
                <td class="col-md-5" >Name</td>
                <td class="col-md-5" >
                     <c:forEach var="row" items="${userProfile.rows}">
                         <c:choose>
                            <c:when test="${user.groupName == 'doctor'}">
                               <c:out value="${row.doctor_name}"></c:out>
                            </c:when>
                            <c:when test="${user.groupName == 'staff'}">
                                <c:out value="${row.staff_name}"></c:out>
                            </c:when>
                        </c:choose>
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
        </table>
        </div>
        </div>
        </div>
    </c:if>         
</html>

<script>
    $(document).ready(function() {
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
                        patientId:"<%=user.getRoleId()%>",
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
                            tableType:"<%=user.getGroupName()%>",
                            patientId:"<%=user.getRoleId()%>",
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
