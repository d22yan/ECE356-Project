<%-- 
    Document   : patient-record
    Created on : 25-Mar-2014, 12:58:41 AM
    Author     : root
--%>

<%@tag description="Patient Record Table" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="patient-table" %>
<%
    int doctorId = 0;
    int staffId = 0;
    int patientId = 0;
    String patientRecordQuery = null;
    String dataSourceUrl = Database.ServiceConstant.url + Database.ServiceConstant.database;
    Model.User user = null;
    if (request.getParameter("patientId") != null) {
        patientId = Integer.parseInt(request.getParameter("patientId"));
    }
    if (request.getSession().getAttribute("user") != null) {
        user = (Model.User) request.getSession().getAttribute("user");
        if (user.getGroupName().equals("doctor")) {
            doctorId = user.getRoleId();
            patientRecordQuery = Database.Query.DoctorPatientRecord(doctorId, patientId);
        } else if (user.getGroupName().equals("staff")) {
            staffId = user.getRoleId();
            patientRecordQuery = Database.Query.StaffPatientRecord(staffId, patientId);
        } else if (user.getGroupName().equals("patient")) {
            patientId = user.getRoleId();
            patientRecordQuery = Database.Query.PatientRecord(patientId);
        }
        else {
            patientRecordQuery = Database.Query.StaffPatientRecord(0, patientId);
        }
    } else {
        patientRecordQuery = Database.Query.StaffPatientRecord(0, patientId);
    }
%>
<html>
    <c:if test='${user != null}'>
        <style type="text/css">
            #patient-record-table > tbody > tr[id^="patient-record"]:hover,
            #patient-record-table > tbody > tr[id="add-patient-record"]:hover {
                cursor: pointer;
            }
        </style>
        <sql:setDataSource 
            var="connection" 
            driver="com.mysql.jdbc.Driver"
            url="<%=dataSourceUrl%>"
            user="<%=Database.ServiceConstant.user%>"  
            password="<%=Database.ServiceConstant.pwd%>"/>
        <sql:query dataSource="${connection}" var="patientRecordList">
            <%=patientRecordQuery%>
        </sql:query>
        <sql:query dataSource="${connection}" var="patientInformation">
            SELECT
                *
            FROM
                patient
            WHERE
                patient.patient_id = <%=patientId%>;
        </sql:query>
        <sql:query dataSource="${connection}" var="doctorInformation">
            SELECT
                *
            FROM
                doctor
            WHERE
                doctor.doctor_id = <%=doctorId%>;
        </sql:query>
        <div class="row">
            <c:forEach var ="row" items="${patientInformation.rows}">
                <div class="col-md-4">
                    <h2>
                       <c:out value="${row.patient_name}"/>
                    </h2>
                </div>
            </c:forEach>
        </div>
        <div class="row" style="display: none">
            <c:forEach var ="row" items="${doctorInformation.rows}">
                <div class="col-md-4">
                    <h2 id="user-doctor-name">
                       <c:out value="${row.doctor_name}"/>
                    </h2>
                </div>
            </c:forEach>
        </div>
        <div id="patient-record-search-bar" style="margin-bottom: 50px">
            <div id="patient-record-search-option" class="searchbar">
                <select class="form-control">
                    <option data-type="int" value="patient-record-id">patient record id</option>
                    <option data-type="string" value="doctor-name">doctor name</option>
                    <option data-type="date" value="date">date</option>
                    <option data-type="string" value="diagnosis">diagnosis</option>
                    <option data-type="string" value="prescription">prescription</option>
                    <option data-type="string" value="treatment-schedule">treatment-schedule</option>
                    <option data-type="string" value="freeform">freeform</option>
                </select> 
            </div>
            <div id="patient-record-search-single" class="searchbar" style="width:200px" hidden>
                <input id="patient-record-search-input" class="form-control" type="search" placeholder="search"></input>
            </div>
            <div id="patient-record-search-range" class="form-inline searchbar" style="width:500px">
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
        </div>
        <div class="table-responsive">
        <table id="patient-record-table" class="table table-hover table-condensed">
            <thead>
                <tr>
                    <th>record id</th>
                    <th>date</th>
                    <th>written by</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="row" items="${patientRecordList.rows}">
                    <tr id="patient-record-${row.patient_record_id}"
                           patientRecordId="${row.patient_record_id}">
                        <td class="patient-record-id">
                            <c:out value="${row.patient_record_id}"/>
                        </td>
                        <td class="date">
                            <c:out value="${row.patient_record_date}"/>
                        </td>
                        <td class="doctor-name">
                            <c:out value="${row.doctor_name}"/>
                        </td>
                        <td class="diagnosis" hidden>
                            <c:out value="${row.diagnosis}"/>
                        </td>
                        <td class="treatment-schedule" hidden>
                            <c:out value="${row.treatment_schedule}"/>
                        </td>
                        <td class="prescription" hidden>
                            <c:out value="${row.prescription}"/>
                        </td>
                        <td class="freeform" hidden>
                            <c:out value="${row.freeform}"/>
                        </td>
                    </tr>
                    <tr id="data-patient-record-${row.patient_record_id}" style="display: none;">
                        <td colspan="3">
                            <div class="row">
                                <div class="col-md-3">
                                    <label>visit start time</label>
                                    <input class="form-control" value="${row.visit_start_time}" disabled></input>
                                </div>
                                <div class="col-md-3">
                                    <label>visit end time</label>
                                    <input class="form-control" value="${row.visit_end_time}" disabled></input>
                                </div>
                                <div class="col-md-6">
                                    <label>diagnosis</label>
                                    <input class="form-control" value="${row.diagnosis}" disabled></input>
                                </div>
                                <div class="col-md-6">
                                    <label>treatment schedule</label>
                                    <input class="form-control" value="${row.treatment_schedule}" disabled></input>
                                </div>
                                <div class="col-md-6">
                                    <label>prescription</label>
                                    <input class="form-control" value="${row.prescription}" disabled></input>
                                </div>
                                <div class="col-md-12">
                                    <label>freeform</label>
                                    <input class="form-control" value="${row.freeform}" disabled></input>
                                </div>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test='${user.getGroupName() == "doctor"}'> 
                    <tr id="add-patient-record">
                        <td colspan="3">
                            add new record
                        </td>
                    </tr>
                    <tr id="data-add-patient-record" style="display: none;">
                        <td colspan="3">
                            <div class="row">
                                <div class="col-md-3">
                                    <label>visit start time</label>
                                    <div class="input-group date datePicker">
                                        <input id="data-input-visit-start-time" class="form-control" type="search"></input>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label>visit end time</label>
                                    <div class="input-group date datePicker">
                                        <input id="data-input-visit-end-time" class="form-control" type="search"></input>
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label>diagnosis</label>
                                    <input id="data-input-diagnosis" class="form-control"></input>
                                </div>
                                <div class="col-md-6">
                                    <label>treatment schedule</label>
                                    <input id="data-input-treatment-schedule" class="form-control"></input>
                                </div>
                                <div class="col-md-6">
                                    <label>prescription</label>
                                    <input id="data-input-prescription" class="form-control"></input>
                                </div>
                                <div class="col-md-12">
                                    <label>freeform</label>
                                    <input id="data-input-freeform" class="form-control"></input>
                                </div>
                                <div class="col-md-12" style="margin-top: 5px;">
                                    <button id="data-input-submit" type="submit" class="btn btn-default">Submit</button>
                                </div>
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
        </div>
        <script type="text/javascript">
            if (<%=patientId%> == 0) {
                document.getElementById("patient-record-search-bar").style.display = "none";
                document.getElementById("patient-record-table").style.display = "none";
            }    
            $(document).ready(function() {
                clearPatientRecordSearchFilter();
                $('#patient-record-search-option option[value="patient-record-id"]').prop('selected', true);

                $('.datePicker').datetimepicker({});

                $('#patient-record-search-range .input-group').datetimepicker({ 
                    pickTime: false
                });

                $(document).on('click', '#patient-record-table > tbody > tr[id^="patient-record"]', function() {
                    $('#patient-record-table > tbody > tr#data-patient-record-' + $(this).attr('patientRecordId')).toggle();
                });

                $('#patient-record-table > tbody > tr#add-patient-record').click(function() {
                    $('#patient-record-table > tbody > tr#data-add-patient-record').toggle();
                });

                $('#patient-record-table #data-input-submit').click(function() {
                    visitStartTime = $('#patient-record-table #data-add-patient-record #data-input-visit-start-time').val();
                    visitEndTime = $('#patient-record-table #data-add-patient-record #data-input-visit-end-time').val();
                    diagnosis = $('#patient-record-table #data-add-patient-record #data-input-diagnosis').val();
                    prescription = $('#patient-record-table #data-add-patient-record #data-input-prescription').val();
                    treatmentSchedule = $('#patient-record-table #data-add-patient-record #data-input-treatment-schedule').val();
                    freeform = $('#patient-record-table #data-add-patient-record #data-input-freeform').val();
                    if (validateVisitTimes(visitStartTime, visitEndTime)) {
                        $.ajax({
                            type: 
                                'POST',
                            url: 
                                '${pageContext.request.contextPath}/AddPatientRecord',
                            data: 
                                'doctorId=<%=doctorId%>' + 
                                '&patientId=<%=patientId%>' + 
                                '&visitStartTime=' + convertDateTimeToSqlFormat(visitStartTime) +
                                '&visitEndTime=' + convertDateTimeToSqlFormat(visitEndTime) +
                                '&diagnosis=' + diagnosis +
                                '&prescription=' + prescription +
                                '&treatmentSchedule=' + treatmentSchedule +
                                '&freeform=' + freeform,
                            success: function(data) { 
                                $('#patient-record-table > tbody > tr#data-add-patient-record').hide();
                                patientRecordId = parseInt(data);
                                patientRecordDate = moment(visitStartTime).format('MM/DD/YYYY');
                                patientDoctorName = $("#user-doctor-name").text();
                                $(
                                    '<tr id="patient-record-' + patientRecordId + '"' +
                                           'patientRecordId="' + patientRecordId + '">' +
                                        '<td class="patient-record-id">' +
                                            patientRecordId +
                                        '</td>' +
                                        '<td class="date">' +
                                            patientRecordDate +
                                        '</td>' +
                                        '<td class="doctor-name">' +
                                            patientDoctorName +
                                        '</td>' +
                                    '</tr>' +
                                    '<tr id="data-patient-record-' + patientRecordId + '" style="display: none;">' +
                                        '<td colspan="3">' +
                                            '<div class="row">' +
                                                '<div class="col-md-3">' +
                                                    '<label>visit start time</label>' +
                                                    '<input class="form-control" value="' + visitStartTime + '" disabled></input>' +
                                                '</div>' +
                                                '<div class="col-md-3">' +
                                                    '<label>visit end time</label>' +
                                                    '<input class="form-control" value="' + visitEndTime + '" disabled></input>' +
                                                '</div>' +
                                                '<div class="col-md-6">' +
                                                    '<label>diagnosis</label>' +
                                                    '<input class="form-control" value="' + diagnosis + '" disabled></input>' +
                                                '</div>' +
                                                '<div class="col-md-6">' +
                                                    '<label>treatment schedule</label>' +
                                                    '<input class="form-control" value="' + prescription + '" disabled></input>' +
                                                '</div>' +
                                                '<div class="col-md-6">' +
                                                    '<label>prescription</label>' +
                                                    '<input class="form-control" value="' + treatmentSchedule + '" disabled></input>' +
                                                '</div>' +
                                                '<div class="col-md-12">' +
                                                    '<label>freeform</label>' +
                                                    '<input class="form-control" value="' + freeform + '" disabled></input>' +
                                                '</div>' +
                                            '</div>' +
                                        '</td>' +
                                    '</tr>'
                                ).insertBefore('#patient-record-table > tbody > #add-patient-record');
                                patientRecordSearchRangeFilter();
                            },
                            error: function(req, status, error) {
                               alert(status);
                            }
                        });
                    } else {
                        alert("incorrect visit date input");
                    }
                });

                $('#patient-record-search-option').change(function() {
                    if ($(this).find(':selected').data('type') == 'string') {
                        $('#patient-record-search-single').show();
                        $('#patient-record-search-range').hide();
                        $('#patient-record-search-single .form-control').val('');
                        searchFilter();
                    } else {
                        $('#patient-record-search-single').hide();
                        $('#patient-record-search-range').show();
                        $('#patient-record-search-range .form-control').val('');
                        searchRangeFilter();
                    }
                });

                $('#patient-record-search-input').keyup(function(e) {
                    patientRecordSearchFilter();
                });


                $('#patient-record-search-range .form-control').on('input', function(e) {
                    patientRecordSearchRangeFilter();
                });

                $('#patient-record-search-range .date').on('dp.change', function(e) {
                    patientRecordSearchRangeFilter();
                });

                function clearPatientRecordSearchFilter() {
                    $('#patient-record-search-input').val('');
                    $('#patient-record-search-range #searchMin, #patient-record-search-range #searchMax').val('');
                }

                function convertDateTimeToSqlFormat(dateTime) {
                    return moment(dateTime).format('YYYY-MM-DD HH:MM:SSS');
                }

                function patientRecordSearchFilter() {
                    $('#patient-record-table tr[id^="data-patient-record"]').each(function() {
                        $(this).hide();
                    });
                    var searchInput = $('#patient-record-search-input').val().toLowerCase().replace(/\s/g, '');
                    var option = $('#patient-record-search-option').find(':selected').val();
                    $('#patient-record-table > tbody > tr[id^="patient-record"]').each(function() {
                        if ($(this).find('[class^="' + option + '"]').text().toLowerCase().replace(/\s/g, '').indexOf(searchInput) == -1 || ($(this).attr('isCurrentPatient') == 0 && isCurrentPatient)) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                }

                function patientRecordSearchRangeFilter() {
                    $('#patient-record-table tr[id^="data-patient-record"]').each(function() {
                        $(this).hide();
                    });

                    var valueType = $('#patient-record-search-option').find(':selected').data('type');
                    var option = $('#patient-record-search-option').find(':selected').val();
                    
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
                        
                    $('#patient-record-table tbody tr[id^="patient-record"]').each(function() {
                        var testValue = parseValue($(this).find('[class^="' + option + '"]').text().replace(/\s/g, ''));
                        if (testValue == null || testValue < searchMin || testValue > searchMax) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                }

                function validateVisitTimes(startTime, endTime) {
                    return moment(startTime) <= moment(endTime);
                }
            });
        </script>
    </c:if>
</html>