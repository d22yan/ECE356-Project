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
        <form class="form-inline" style="margin-bottom: 50px">
            <div id="search-option" class="searchbar">
                <select class="form-control">
                    <option value="patient-name" selected="selected" data-type="text">patient name</option>
                    <option value="patient-id" data-type="number">patient id</option>
                    <option value="default-doctor-name" data-type="text">default doctor name</option>
                    <option value="last-visit-date" data-type="date">last visit date</option>
                </select> 
            </div>
            <div id="search-single" class="searchbar" style="width:200px">
                <input id="search-input" class="form-control" type="search" placeholder="search"></input>
            </div>
            <div id="search-range" class="form-inline searchbar" style="width:500px" hidden>
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

            <c:if test='${user.getGroupName() == "doctor" || user.getGroupName() == "staff"}'>
                <a id="view-all" class="btn btn-default searchbar pull-right" href="#" role="button">
                    all patient
                </a>
                <a id="view-current" class="btn btn-default searchbar pull-right" href="#" role="button">
                    current patient
                </a>
            </c:if>
        </form>
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
                    <td class="last-visit-date">
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
        <script type="text/javascript">
            var isCurrentPatient = false;
            $(document).ready(function() {
                $('#search-range .input-group').datetimepicker({ pickTime: false });
                $('[id^="edit"]').click(function(e){
                    e.stopPropagation();
                    alert("<!--TODO direct to patient page-->");
                });
                $('#patient-table > tbody[id^="patient-"]').click(function(e){
                    alert("<!--TODO direct to visit record page-->");
                });
                $('#search-option').change(function() {
                    if ($(this).find(':selected').data('type') == 'text') {
                        $('#search-single').show();
                        $('#search-range').hide();
                        $('#search-single .form-control').val('');
                        searchFilter();
                    } else {
                        $('#search-single').hide();
                        $('#search-range').show();
                        $('#search-range .form-control').val('');
                        searchRangeFilter();
                    }
                });
                $('#search-input').on('input', function(e) {
                    searchFilter();
                });
                $('#view-all').click(function() {
                    isCurrentPatient = false;
                    toggleCurrentPatient(true);
                    $('#patient-table').children('tbody').show();
                    searchFilter();
                });
                $('#view-current').click(function() {
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
                function searchRangeFilter() {
                    
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