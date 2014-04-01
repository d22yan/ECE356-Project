<%-- 
    Document   : patient-table
    Created on : 19-Mar-2014, 10:17:46 PM
    Author     : root
--%>

<%@tag description="Generic Table" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="generic" %>
<%
    String defaultQuery = null;
    String doctorQuery = null;
    String staffQuery = null;
    String dataSourceUrl = Database.ServiceConstant.url + Database.ServiceConstant.database;
    if (request.getSession().getAttribute("user") != null) {
        Model.User user = (Model.User) request.getSession().getAttribute("user");
        doctorQuery = Database.Query.doctorAppointmentList(user.getRoleId());
        staffQuery = Database.Query.staffAppointmentList(user.getRoleId());
//        defaultQuery = Database.Query.staffappointmentList(user.getRoleId());
    }
%>

<html>
    <c:if test='${user != null}'>
        <style type="text/css">
            #appointment-table > tbody > tr[id^="appointment-"]:hover {
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
            <c:when test='${user.getGroupName() == "staff"}'>
                <sql:query dataSource="${connection}" var="appointmentList">
                    <%=staffQuery%>
                </sql:query>
            </c:when>
            <c:when test='${user.getGroupName() == "doctor"}'>
                <sql:query dataSource="${connection}" var="appointmentList">
                    <%=doctorQuery%>
                </sql:query>
            </c:when>
        </c:choose>
        <form id="appointment-searchbar" class="form-inline clearfix" style="padding: 10px">
            <div id="search-option" class="searchbar">
                <select class="form-control">
                    <option value="appointment-id" selected="selected" data-type="int">appointment id</option>
                    <option value="doctor-name" data-type="string">doctor name</option>
                    <option value="patient-name" data-type="string">patient name</option>
                    <option value="start-time" data-type="date">start time</option>
                    <option value="end-time" data-type="date">end time</option>
                </select> 
            </div>
            <div id="search-single" class="searchbar" style="width:200px" hidden>
                <input id="search-input" class="form-control" type="search" placeholder="search"></input>
            </div>
            <div id="search-range" class="form-inline searchbar" style="width:500px">
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
            <div>
            <c:if test="${user.groupName == 'staff'}">
            <a href="${pageContext.request.contextPath}/createAppointment.jsp" class="btn btn-primary" role="button" class="btn btn-primary">
                Create Appointment
            </a>
            </c:if>    

            </div>
        </form>
        <div class="table-responsive">
        <table id="appointment-table" class="table table-hover table-condensed">
            <thead>
                <tr>
                    <th>appointment id</th>
                    <th>doctor name</th>
                    <th>patient name</th>
                    <th>start time</th>
                    <th>end time</th>
                    <c:if test="${user.groupName == 'staff'}">
                    <th>delete</th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="row" items="${appointmentList.rows}">
                    <tr id="appointment-${row.appointment_id}" 
                        data-appointment-id = "${row.appointment_id}" 
                        data-doctor-id = "${row.doctor_id}" 
                        data-patient-id = "${row.patient_id}"
                        data-start-time = "${row.appointment_start_time}"
                        data-end-time="${row.appointment_end_time}">
                        <td class="appointment-id">
                            <c:out value="${row.appointment_id}"/>
                        </td>
                    <td class="doctor-name">
                            <c:out value="${row.doctor_name}"/>
                        </td>
                    <td class="patient-name">
                            <c:out value="${row.patient_name}"/>
                        </td>
                        <td class="start-time">
                            <c:out value="${row.appointment_start_time}"/>
                        </td>
                        <td class="end-time">
                            <c:out value="${row.appointment_end_time}"/>
                        </td>
                        <c:if test="${user.groupName == 'staff'}">
                            <td>
                            <button id="delete-appointment-${row.appointment_id}" class="btn btn-danger btn-xs" data-appointment-id="${row.appointment_id}" href="#">
                                delete
                            </button>
                            </td>
                        </c:if>
                </tr>
                </c:forEach>
            </tbody>
        </table>
        </div>
        <script type="text/javascript">
            $(document).ready(function() {
                $('#appointment-table > tbody > tr[id^="appointment-"]').click(function(e){
                    if ( ${user.getGroupName() == "staff"} )
                    {
                        window.open('${pageContext.request.contextPath}/editAppointment.jsp?appointmentId=' + $(this).data('appointment-id') + '&' +
                                                                                                'doctorId=' + $(this).data('doctor-id') + '&' +
                                
                                                                                                'patientId=' + $(this).data('patient-id') + '&' +
                                                                                                'startTime=' + $(this).data('start-time') + '&' +
                                                                                                 'endTime=' + $(this).data('end-time'), '_blank');
                    }
                });
               
                
                $('[id^="delete-appointment"]').click(function(){
                    if ( ${user.getGroupName() == "staff"} ) {
                        $.ajax({
                            type: "POST",
                            url: "${pageContext.request.contextPath}/deleteAppointment",
                            data: {appointmentid:$(this).data('appointment-id')},
                            success : function(data){
                                location.reload(true);
                            },
                            error: function(jqXHR, textStatus, errorThrown) {
                                alert(jqXHR+" - "+textStatus+" - "+errorThrown);
                            }  
                        });
                    }                        

                });
                
                $(function(){
                    $('#appointment-table').tablesorter();
                });
                
                clearSearchFilter();

                $('#appointment-searchbar #search-range .input-group').datetimepicker({});

                $('#appointment-searchbar #search-option').change(function() {
                    if ($(this).find(':selected').data('type') == 'string') {
                        $('#appointment-searchbar #search-single').show();
                        $('#appointment-searchbar #search-range').hide();
                        $('#appointment-searchbar #search-single .form-control').val('');
                        searchFilter();
                    } else {
                        $('#appointment-searchbar #search-single').hide();
                        $('#appointment-searchbar #search-range').show();
                        $('#appointment-searchbar #search-range .form-control').val('');
                        searchRangeFilter();
                    }
                });

                $('#appointment-searchbar #search-input').on('input', function(e) {
                    searchFilter();
                });

                $('#appointment-searchbar #search-range .form-control').on('input', function(e) {
                    searchRangeFilter();
                });

                $('#appointment-searchbar #search-range .date').on('dp.change', function(e) {
                    searchRangeFilter();
                });

                function clearSearchFilter() {
                    $('#appointment-searchbar #search-input').val('');
                    $('#appointment-searchbar #search-range #search-min, #appointment-searchbar #search-range #search-max').val('');
                }

                function searchFilter() {
                    var searchInput = $.trim($('#appointment-searchbar #search-input').val().toLowerCase());
                    var option = $('#appointment-searchbar #search-option').find(':selected').val();
                    $('#appointment-table tbody tr').each(function() {
                        if ($.trim($(this).find('[class^="' + option + '"]').text().toLowerCase()).indexOf(searchInput) == -1) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                }
                
                function searchRangeFilter() {
                    var valueType = $('#appointment-searchbar #search-option').find(':selected').data('type');
                    var option = $('#appointment-searchbar #search-option').find(':selected').val();
                    
                    var searchMin, searchMax, parseValue;
                    switch (valueType) {
                        case "int": 
                            searchMin = parseInt($.trim($('#appointment-searchbar #search-min').val()));
                            searchMax = parseInt($.trim($('#appointment-searchbar #search-max').val()));
                            parseValue = function(value) { 
                                return !isNaN(parseInt(value)) ? parseInt(value) : null; 
                            };
                            break;
                        case "date":
                            searchMin = moment($.trim($('#appointment-searchbar #search-min').val()));
                            searchMax = moment($.trim($('#appointment-searchbar #search-max').val()));
                            parseValue = function(value) {
                                return moment(value).isValid() ? moment(value) : null;
                            };
                            break;
                    }
                        
                    $('#appointment-table tbody tr').each(function() {
                        var testValue = parseValue($.trim($(this).find('[class^="' + option + '"]').text()));
                        if (testValue == null || testValue < searchMin || testValue > searchMax) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                }
            });
        </script>
    </c:if>
</html>