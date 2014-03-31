<%-- 
    Document   : doctor-assign
    Created on : 30-Mar-2014, 10:16:45 PM
    Author     : root
--%>
<%@tag description="Doctor Assign" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="doctor-assign" %>

<%
    int doctorId = 0;
    String assignedStaffQuery = null;
    String assignedPatientQuery = null;
    String grantedStaffQuery = null;
    String dataSourceUrl = Database.ServiceConstant.url + Database.ServiceConstant.database;
    if (request.getParameter("doctorId") != null) {
		doctorId = Integer.parseInt(request.getParameter("doctorId"));
		if (request.getSession().getAttribute("user") != null) {
			Model.User user = (Model.User) request.getSession().getAttribute("user");
			assignedStaffQuery = Database.Query.DoctorAssignedStaff(doctorId);
			assignedPatientQuery = Database.Query.DoctorAssignedPatient(doctorId);
			grantedStaffQuery = Database.Query.DoctorGrantedStaff(doctorId);
		}
    }
%>
<html>
    <c:if test='${user != null}'>
        <sql:setDataSource 
            var="connection" 
            driver="com.mysql.jdbc.Driver"
            url="<%=dataSourceUrl%>"
            user="<%=Database.ServiceConstant.user%>"  
            password="<%=Database.ServiceConstant.pwd%>"/>
        <sql:query dataSource="${connection}" var="assignedStaff">
            <%=assignedStaffQuery%>
        </sql:query>
        <sql:query dataSource="${connection}" var="assignedPatient">
            <%=assignedPatientQuery%>
        </sql:query>
        <sql:query dataSource="${connection}" var="grantedStaff">
            <%=grantedStaffQuery%>
        </sql:query>
        <sql:query dataSource="${connection}" var="doctorInformation">
            SELECT
                *
            FROM
                doctor
            WHERE
                doctor.doctor_id = <%=doctorId%>;
        </sql:query>
        <sql:query dataSource="${connection}" var="doctorList">
            SELECT
                *
            FROM
                doctor
            WHERE
            	doctor.doctor_id != <%=doctorId%>
            ORDER BY
            	doctor.doctor_name;
        </sql:query>
        <sql:query dataSource="${connection}" var="patientList">
            SELECT
                *
            FROM
                patient
            ORDER BY
            	patient.patient_name;
        </sql:query>
        <div class="row">
            <c:forEach var ="row" items="${doctorInformation.rows}">
				Doctor: <c:out value="${row.doctor_name}"/>
            </c:forEach>
        </div>
		<c:if test='${user.getGroupName() == "admin" || user.getGroupName() == "doctor"}'>
			<div class="row">
				<h5>
					grant doctor permission to view patient:
				</h5>
				<select id="selector-Grant-Doctor-Grantee" class="multiselect2">
					<c:forEach items="${doctorList.rows}" var="granteeDoctor">
						<option value="${granteeDoctor.doctor_id}">
							<c:out value="${granteeDoctor.doctor_name}"/>
						</option>
					</c:forEach>
				</select>
				<select id="selector-Grant-Doctor" class="multiselect" multiple="multiple">
					<c:forEach items="${patientList.rows}" var="granteeDoctorPatient">
						<option value="${granteeDoctorPatient.patient_id}">
							<c:out value="${granteeDoctorPatient.patient_name}"/>
						</option>
					</c:forEach>
				</select>
				<button type="submit" data-prefix="Grant" data-suffix="Doctor" class="submit btn btn-default">Submit</button>
			</div>
		</c:if>
		<c:if test='${user.getGroupName() == "admin" || user.getGroupName() == "staff"}'>
			<div class="row">
				<h5>
					assigned patient:
				</h5>
				<select id="selector-Assign-Patient" class="multiselect" multiple="multiple">
					<c:forEach items="${assignedPatient.rows}" var="assignedPatientrow">
						<option value="${assignedPatientrow.patient_id}" ${assignedPatientrow.doctor_id > 0 ? "selected" : ""}>
							<c:out value="${assignedPatientrow.patient_name}"/>
						</option>
					</c:forEach>
				</select>
				<button type="submit" data-prefix="Assign" data-suffix="Patient" class="submit btn btn-default">Submit</button>
			</div>
		</c:if>
		<c:if test='${user.getGroupName() == "admin"}'>
			<div class="row">
				<h5>
					assigned staff:
				</h5>
				<select id="selector-Assign-Staff" class="multiselect" multiple="multiple">
					<c:forEach items="${assignedStaff.rows}" var="assignedStaffRow">
						<option value="${assignedStaffRow.staff_id}" ${assignedStaffRow.doctor_id > 0 ? "selected" : ""}>
							<c:out value="${assignedStaffRow.staff_name}"/>
						</option>
					</c:forEach>
				</select>
				<button type="submit" data-prefix="Assign" data-suffix="Staff" class="submit btn btn-default">Submit</button>
			</div>
		</c:if>
		<c:if test='${user.getGroupName() == "admin" || user.getGroupName() == "doctor"}'>
			<div class="row">
				<h5>
					staff view patient permission:
				</h5>
				<select id="selector-Grant-Staff" class="multiselect" multiple="multiple">
					<c:forEach items="${grantedStaff.rows}" var="grantedStaffRow">
						<option value="${grantedStaffRow.staff_id}" ${grantedStaffRow.view_patient_permission ? "selected" : ""}>
							<c:out value="${grantedStaffRow.staff_name}"/>
						</option>
					</c:forEach>
				</select>
				<button type="submit" data-prefix="Grant" data-suffix="Staff" class="submit btn btn-default">Submit</button>
			</div>
		</c:if>

		<!-- Initialize the plugin: -->
		<script type="text/javascript">
		$(document).ready(function() {
			$('.multiselect').multiselect({
				buttonClass: 'btn btn-default btn-sm',
				buttonWidth: '200px',
				enableFiltering: true
			});

			$('.multiselect2').multiselect({
				buttonClass: 'btn btn-default btn-sm',
				buttonWidth: '200px',
				enableFiltering: true,
				onChange: function(element, checked) {
					granteeDoctorId = element.val();
					$.ajax({
						url:
							'${pageContext.request.contextPath}/GrantDoctorPatient',
						type:
							'POST',
						data: {
							'granterDoctorId': '<%=doctorId%>',
							'granteeDoctorId': granteeDoctorId
						},
						success: function(data) {
							var patientIdArray = data.split(",");
							selected = String($('#selector-Grant-Doctor').val()).split(',');
							for (index = 0; index < selected.length; index++) {
								console.log("asd " + selected[index]);
								if (selected[index] != "null") {
									$('#selector-Grant-Doctor').multiselect('deselect', selected[index]);
								}
							}
							for (index = 0; index < patientIdArray.length; index++) {
								if (patientIdArray[index] != "null") {
									$('#selector-Grant-Doctor').multiselect('select', patientIdArray[index]);
								}
							}
						},
						error: function(req, status, error) {
							alert(status);
						}
					});
				}
			});

			$('button.submit').click(function() {
				prefix = $(this).data("prefix");
				suffix = $(this).data("suffix");
				servletFileName = "" + $(this).data("prefix") + $(this).data("suffix");
				url = '${pageContext.request.contextPath}/' + servletFileName;
				selected = String($('#selector-' + prefix + '-' + suffix).val()).split(',');
				granteeDoctorId = $('#selector-Grant-Doctor-Grantee').val();
				$.ajax({
					url:
						url,
					type:
						'POST',
					dataType: 
						'json',
					data: {
						'doctorId': '<%=doctorId%>',
						'granteeDoctorId': granteeDoctorId,
						selected: selected
					},
					success: function(data) {
						if (data == 1) {
							alert("success");
						} else {
							alert("GG");
						}
						if (prefix == "Assign" && suffix == "Staff") {
							window.location.reload();
						}
					},
					error: function(req, status, error) {
						alert(status);
					}
				});
			});
		});
		</script>
    </c:if>
</html>

