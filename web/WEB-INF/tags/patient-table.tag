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
    String patientQuery = null;
    String dataSourceUrl = Database.ServiceConstant.url + Database.ServiceConstant.database;
    if (request.getSession().getAttribute("user") != null) {
        Model.User user = (Model.User) request.getSession().getAttribute("user");
        if (user.getGroupName().equals("doctor")) {
            patientQuery = Database.Query.DoctorPatientList(user.getRoleId());
        } else if (user.getGroupName().equals("staff")) {
            patientQuery = Database.Query.StaffPatientList(user.getRoleId());
        } else {
            patientQuery = Database.Query.DefaultPatientList();
        }
    }
%>

<html>
    <c:if test='${user != null}'>
        <style type="text/css">
            #patient-table > tbody > tr[id^="patient-"]:hover {
                cursor: pointer;
            }
        </style>
        <sql:setDataSource 
            var="connection" 
            driver="com.mysql.jdbc.Driver"
            url="<%=dataSourceUrl%>"
            user="<%=Database.ServiceConstant.user%>"  
            password="<%=Database.ServiceConstant.pwd%>"/>
        <sql:query dataSource="${connection}" var="patientList">
            <%=patientQuery%>
        </sql:query>
        <form id="patient-searchbar" class="form-inline clearfix" style="padding: 10px">
            <div id="search-option" class="searchbar">
                <select class="form-control">
                    <option value="patient-name" selected="selected" data-type="string">patient name</option>
                    <option value="patient-id" data-type="int">patient id</option>
                    <option value="default-doctor-name" data-type="string">default doctor name</option>
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
        <div class="table-responsive">
        <table id="patient-table" class="table table-hover table-condensed">
            <thead>
                <tr>
                    <th>patient name</th>
                    <th>patient id</th>
                    <th>default doctor</th>
                    <th>last visit date</th>
                    <c:if test='${user.getGroupName() == "staff"}'>
                        <th>edit</th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="row" items="${patientList.rows}">
                <tr 
                    id="patient-${row.patient_id}" 
                    data-patient-id="${row.patient_id}" 
                    data-is-current-patient="${(user.getGroupName() == "doctor" && row.doctor_id == user.getRoleId()) || (user.getGroupName() == "staff" && row.staff_id == user.getRoleId()) ? true : false}">
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
                            <button type="button" id="edit-patient-${row.patient_id}" class="btn btn-primary btn-xs" data-patient-id="${row.patient_id}">
                                edit
                            </button>
                        </td>
                    </c:if>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        </div>
        <script type="text/javascript">
            var isCurrentPatient = false;
            
            $(document).ready(function() {
                $(function(){
                    $("#patient-table").tablesorter();
                });
                clearSearchFilter();
                toggleCurrentPatient(true);

                $('#patient-searchbar #search-range .input-group').datetimepicker();
                
                $('[id^="edit-patient"]').click(function(e){
                    e.stopPropagation();
                    var win = window.open('${pageContext.request.contextPath}/updatePatient.jsp?patientId=' + $(this).data('patient-id'), '_blank');
                });

                $('#patient-table > tbody > tr[id^="patient-"]').click(function(e){
                    var win = window.open('${pageContext.request.contextPath}/patientRecord.jsp?patientId=' + $(this).data('patient-id'), '_blank');
                });

                $('#patient-searchbar #search-option').change(function() {
                    if ($(this).find(':selected').data('type') == 'string') {
                        $('#patient-searchbar #search-single').show();
                        $('#patient-searchbar #search-range').hide();
                        $('#patient-searchbar #search-single .form-control').val('');
                        searchFilter();
                    } else {
                        $('#patient-searchbar #search-single').hide();
                        $('#patient-searchbar #search-range').show();
                        $('#patient-searchbar #search-range .form-control').val('');
                        searchRangeFilter();
                    }
                });

                $('#patient-searchbar #search-input').on('input', function(e) {
                    searchFilter();
                });

                $('#patient-searchbar #search-range .form-control').on('input', function(e) {
                    searchRangeFilter();
                });

                $('#patient-searchbar #search-range .date').on('dp.change', function(e) {
                    searchRangeFilter();
                });

                $('#patient-searchbar #view-all').click(function() {
                    isCurrentPatient = false;
                    toggleCurrentPatient(true);
                    $('#patient-table tbody tr').show();
                    
                    if ($('#patient-searchbar #search-option').find(':selected').data('type') == 'string') {
                        searchFilter();
                    } else {
                        searchRangeFilter();
                    }
                });

                $('#patient-searchbar #view-current').click(function() {
                    isCurrentPatient = true;
                    toggleCurrentPatient(false);
                    $('#patient-table tbody tr').each(function() {
                        if (!$(this).data('isCurrentPatient')) {
                            $(this).hide();
                        }
                    });
                    
                    if ($('#patient-searchbar #search-option').find(':selected').data('type') == 'string') {
                        searchFilter();
                    } else {
                        searchRangeFilter();
                    }
                });

                function clearSearchFilter() {
                    $('#patient-searchbar #search-input').val('');
                    $('#patient-searchbar #search-range #search-min, #patient-searchbar #search-range #search-max').val('');
                }

                function searchFilter() {
                    var searchInput = $('#patient-searchbar #search-input').val().toLowerCase().replace(/\s/g, '');
                    var option = $('#patient-searchbar #search-option').find(':selected').val();
                    $('#patient-table tbody tr').each(function() {
                        if ($(this).find('[class^="' + option + '"]').text().toLowerCase().replace(/\s/g, '').indexOf(searchInput) == -1 || (!$(this).data('isCurrentPatient') && isCurrentPatient)) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                }
                
                function searchRangeFilter() {
                    var valueType = $('#patient-searchbar #search-option').find(':selected').data('type');
                    var option = $('#patient-searchbar #search-option').find(':selected').val();
                    
                    var searchMin, searchMax, parseValue;
                    switch (valueType) {
                        case "int": 
                            searchMin = parseInt($.trim($('#patient-searchbar #search-min').val()));
                            searchMax = parseInt($.trim($('#patient-searchbar #search-max').val()));
                            parseValue = function(value) { 
                                return !isNaN(parseInt(value)) ? parseInt(value) : null; 
                            };
                            break;
                        case "date":
                            searchMin = moment($.trim($('#patient-searchbar #search-min').val()));
                            searchMax = moment($.trim($('#patient-searchbar #search-max').val()));
                            parseValue = function(value) {
                                return moment(value).isValid() ? moment(value) : null;
                            };
                            break;
                    }
                        
                    $('#patient-table tbody tr').each(function() {
                        var testValue = parseValue($.trim($(this).find('[class^="' + option + '"]').text()));
                        if (testValue == null || testValue < searchMin || testValue > searchMax || (!$(this).data('isCurrentPatient') && isCurrentPatient)) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                }
                function toggleCurrentPatient(showCurrentButton) {
                    if (showCurrentButton) {
                        $('#patient-searchbar #view-all').hide();
                        $('#patient-searchbar #view-current').show();
                    } else {
                        $('#patient-searchbar #view-all').show();
                        $('#patient-searchbar #view-current').hide();
                    }
                }
            });
        </script>
    </c:if>
</html>