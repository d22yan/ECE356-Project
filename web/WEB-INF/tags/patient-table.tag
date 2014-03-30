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
            .searchbar {
                float:left;
                margin-left: 10px; 
            }
            
            #patient-table > tbody > tr[id^="patient-"]:hover {
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
        <sql:query dataSource="${connection}" var="patientList">
            <%=patientQuery%>
        </sql:query>
        <form class="form-inline clearfix" style="padding: 10px">
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
        <table id="patient-table" class="table">
            <thead>
                <tr>
                    <th>patient</th>
                    <th>patient #</th>
                    <th>default doctor</th>
                    <th>last visit date</th>
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
                            <a id="edit-patient-${row.patient_id}" data-patient-id="${row.patient_id}" href="#">
                                edit
                            </a>
                        </td>
                    </c:if>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <script type="text/javascript">
            var isCurrentPatient = false;

            $(document).ready(function() {
                clearSearchFilter();
                toggleCurrentPatient(true);
                $('#search-option option[value="patient-record-id"]').prop('selected', true);

                $('#search-range .input-group').datetimepicker({ pickTime: false });
                
                $('[id^="edit-patient"]').click(function(e){
                    e.stopPropagation();
                    alert("<!--TODO direct to patient page-->");
                });

                $('#patient-table > tbody > tr[id^="patient-"]').click(function(e){
                    var win = window.open('${pageContext.request.contextPath}/patientRecord.jsp?patientId=' + $(this).data('patient-id'), '_blank');
                });

                $('#search-option').change(function() {
                    if ($(this).find(':selected').data('type') == 'string') {
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

                $('#search-range .form-control').on('input', function(e) {
                    searchRangeFilter();
                });

                $('#search-range .date').on('dp.change', function(e) {
                    searchRangeFilter();
                });

                $('#view-all').click(function() {
                    isCurrentPatient = false;
                    toggleCurrentPatient(true);
                    $('#patient-table tbody tr').show();
                    
                    if ($('#search-option').find(':selected').data('type') == 'string') {
                        searchFilter();
                    } else {
                        searchRangeFilter();
                    }
                });

                $('#view-current').click(function() {
                    isCurrentPatient = true;
                    toggleCurrentPatient(false);
                    $('#patient-table tbody tr').each(function() {
                        if (!$(this).data('isCurrentPatient')) {
                            $(this).hide();
                        }
                    });
                    
                    if ($('#search-option').find(':selected').data('type') == 'string') {
                        searchFilter();
                    } else {
                        searchRangeFilter();
                    }
                });

                function clearSearchFilter() {
                    $('#search-input').val('');
                    $('#search-range #searchMin, #search-range #searchMax').val('');
                }

                function searchFilter() {
                    var searchInput = $('#search-input').val().toLowerCase().replace(/\s/g, '');
                    var option = $('#search-option').find(':selected').val();
                    $('#patient-table tbody tr').each(function() {
                        if ($(this).find('[class^="' + option + '"]').text().toLowerCase().replace(/\s/g, '').indexOf(searchInput) == -1 || (!$(this).data('isCurrentPatient') && isCurrentPatient)) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                }
                
                function searchRangeFilter() {
                    var valueType = $('#search-option').find(':selected').data('type');
                    var option = $('#search-option').find(':selected').val();
                    
                    var searchMin, searchMax, parseValue;
                    switch (valueType) {
                        case "int": 
                            searchMin = parseInt($('#search-min').val().replace(/\s/g, ''));
                            searchMax = parseInt($('#search-max').val().replace(/\s/g, ''));
                            parseValue = function(value) { 
                                return !isNaN(parseInt(value)) ? parseInt(value) : null; 
                            };
                            break;
                        case "date":
                            searchMin = moment($('#search-min').val().replace(/\s/g, ''));
                            searchMax = moment($('#search-max').val().replace(/\s/g, ''));
                            parseValue = function(value) {
                                return moment(value).isValid() ? moment(value) : null;
                            };
                            break;
                    }
                        
                    $('#patient-table tbody tr').each(function() {
                        var testValue = parseValue($(this).find('[class^="' + option + '"]').text().replace(/\s/g, ''));
                        if (testValue == null || testValue < searchMin || testValue > searchMax || (!$(this).data('isCurrentPatient') && isCurrentPatient)) {
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
            });
        </script>
    </c:if>
</html>