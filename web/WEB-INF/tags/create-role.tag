<%-- 
    Document   : create-role
    Created on : 30-Mar-2014, 12:11:53 PM
    Author     : root
--%>

<%@tag description="Create Role" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="patient-profile" %>

<%@attribute name="createPatient" required="true" %>
<%@attribute name="createStaff" required="true" %>
<%@attribute name="createDoctor" required="true" %>

<html>
	<c:if test='${user != null}'>
		<div id="create-role-form">
			<div class="form-group">
				<label for="select-role">role</label>
				<select id="select-role" class="form-control">
					<c:if test='${createPatient}'>
				    	<option value="patient" selected="selected">patient</option>
					</c:if>
					<c:if test='${createDoctor}'>
						<option value="doctor">doctor</option>
					</c:if>
					<c:if test='${createStaff}'>
					    <option value="staff">staff</option>
					</c:if>
				</select>
			</div>
			<div class="form-group">
				<label for="input-username">username</label>
				<input class="form-control" id="input-username"></input>
			</div>
			<div class="form-group">
				<label for="input-password">password</label>
				<input class="form-control" id="input-password"></input>
			</div>
			<div class="form-group">
				<label for="input-name">name</label>
				<input class="form-control" id="input-name"></input>
			</div>
			<button type="submit" class="btn btn-default">Submit</button>
		</div>
		<script type="text/javascript">
            $(document).ready(function() {
				$('div#create-role-form > button').click(function() {
					group = $('div#create-role-form select#select-role').find(":selected").val().replace(/\s/g, '').toLowerCase();
					username = $('div#create-role-form input#input-username').val().replace(/\s/g, '').toLowerCase();
					password = $('div#create-role-form input#input-password').val().replace(/\s/g, '').toLowerCase();
					name = $('div#create-role-form input#input-name').val().replace(/\s/g, '').toLowerCase();
					// null check
					if (group == "" || username == "" || password == "" || name == "") {
						alert ("cannot have null input");
					} else {
						$.ajax({
							type:
								'POST',
							url:
								'${pageContext.request.contextPath}/CreateRole',
							data:
								'group=' + group +
								'&username=' + username +
								'&password=' + password +
								'&name=' + name,
							success: function(data) {
								if (data == 1) {
									alert("success");
								} else {
									alert("username taken");
								}
							},
							error: function(req, status, error) {
								alert(status);
							}
						});
					}
				});
			});
		</script>
	</c:if>
</html>
