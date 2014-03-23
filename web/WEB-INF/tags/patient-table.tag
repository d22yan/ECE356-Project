<%-- 
    Document   : patient-table
    Created on : 19-Mar-2014, 10:17:46 PM
    Author     : root
--%>

<%@tag description="Patient Table" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="patient-table" %>
<%
    String defaultQuery = null;
    String doctorQuery = null;
    String staffQuery = null;
    String dataSourceUrl = Database.ServiceConstant.url + Database.ServiceConstant.database;
    if (request.getSession().getAttribute("user") != null) {
        Model.User user = (Model.User) request.getSession().getAttribute("user");
        doctorQuery = Database.Query.DoctorPatientList(user.getRoleId());
        staffQuery = Database.Query.StaffPatientList(user.getRoleId());
        defaultQuery = Database.Query.DefaultPatientList();
    }
%>

<html>
    <c:if test='${user != null}'>
        <style type="text/css">
            .searchbar {
                float:left;
                margin-left: 10px; 
            }
            #patient-table > tbody[id^="patient-"] :hover {
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
            <c:when test='${user.getGroupName() == "doctor"}'>
                <sql:query dataSource="${connection}" var="patientList">
                    <%=doctorQuery%>
                </sql:query>
            </c:when>
            <c:when test='${user.getGroupName() == "staff"}'>
                <sql:query dataSource="${connection}" var="patientList">
                    <%=staffQuery%>
                </sql:query>
            </c:when>
            <c:otherwise>
                <sql:query dataSource="${connection}" var="patientList">
                    <%=defaultQuery%>
                </sql:query>
            </c:otherwise>
        </c:choose>
        <div style="margin-bottom: 50px">
            <div class="searchbar" style="width:200px">
                <input id="search-input" class="form-control" type="search" placeholder="search"></input>
            </div>
            <div id="search-option" class="searchbar">
                <select>
                    <option value="patient-id">patient id</option>
                    <option value="patient-name" selected="selected">patient name</option>
                    <option value="default-doctor-name">default doctor name</option>
                    <option value="last-visit-date">last visit date</option>
                </select> 
            </div>
            <c:if test='${user.getGroupName() == "doctor" || user.getGroupName() == "staff"}'>
                <a id="view-all" class="btn btn-default searchbar" href="#" role="button">
                    all patient
                </a>
                <a id="view-current" class="btn btn-default searchbar" href="#" role="button">
                    current patient
                </a>
            </c:if>
        </div>
        <table id="patient-table" class="table">
            <thead>
                <tr>
                    <th>patient</th>
                    <th>patient #</th>
                    <th>default doctor</th>
                    <th>last visit date</th>
                </tr>
            </thead>
            <c:forEach var="row" items="${patientList.rows}">
                <tbody 
                    id="patient-${row.patient_id}" 
                    patientId="${row.patient_id}" 
                    isCurrentPatient="${(user.getGroupName() == "doctor" && row.doctor_id == user.getRoleId()) || (user.getGroupName() == "staff" && row.staff_id == user.getRoleId()) ? 1 : 0}">
                    <td class="patient-name">
                        <c:out value="${row.patient_name}"/>
                    </td>
                    <td class="patient-id">
                        <c:out value="${row.patient_id}"/>
                    </td>
                    <td class="default-doctor-name">
                        <c:out value="${row.doctor_name}"/>
                    </td>
                    <td class="default-doctor-name">
                        <c:out value="${row.last_visit_date}"/>
                    </td>
                    <c:if test='${user.getGroupName() == "staff"}'>
                        <td>
                            <a id="edit-${row.patient_id}" patientId="${row.patient_id}" href="#">
                                edit
                            </a>
                        </td>
                    </c:if>
                </tbody>
            </c:forEach>
        </table>
        <script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
        <script>
            var isCurrentPatient = false;
            $(document).ready(function() {
                $('[id^="edit"]').on('click', function(e){
                    e.stopPropagation();
                    alert("<!--TODO direct to patient page-->");
                });
                $('#patient-table > tbody[id^="patient-"]').on('click', function(e){
                    alert("<!--TODO direct to visit record page-->");
                });
                $('#search-option').change(function() {
                    searchFilter();
                });
                $('#search-input').keyup(function(e) {
                    searchFilter();
                });
                $('#view-all').on('click', function() {
                    isCurrentPatient = false;
                    toggleCurrentPatient(true);
                    $("#patient-table").children("tbody").show();
                    searchFilter();
                });
                $('#view-current').on('click', function() {
                    isCurrentPatient = true;
                    toggleCurrentPatient(false);
                    $('#patient-table > tbody').each(function() {
                        if ($(this).attr('isCurrentPatient') == 0) {
                            $(this).hide();
                        }
                    });
                    searchFilter();
                });
                function clearSearchFilter() {
                    $('#search-input').val('');
                }
                function searchFilter() {
                    var searchInput = $('#search-input').val().replace(/\s/g, '');
                    var option = $('#search-option').find(':selected').val();
                    $('#patient-table > tbody').each(function() {
                        if ($(this).find('[class^="' + option + '"]').text().replace(/\s/g, '').indexOf(searchInput) == -1 || ($(this).attr('isCurrentPatient') == 0 && isCurrentPatient)) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                }
                function toggleCurrentPatient(showCurrentButton) {
                    if (showCurrentButton) {
                        $('#view-all').hide();
                        $('#view-current').show();
                    } else {
                        $('#view-all').show();
                        $('#view-current').hide();
                    }
                }
                clearSearchFilter();
                toggleCurrentPatient(true);
            });
        </script>
    </c:if>
</html>