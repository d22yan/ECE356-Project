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
    String staffQuery = null;
    String dataSourceUrl = Database.ServiceConstant.url + Database.ServiceConstant.database;
    if (request.getSession().getAttribute("user") != null) {
        Model.User user = (Model.User) request.getSession().getAttribute("user");
        staffQuery = Database.Query.staffDoctorList(user.getRoleId());
        defaultQuery = Database.Query.doctorList();
    }
%>

<html>
    <c:if test='${user != null}'>
        <style type="text/css">
            #doctor-table tbody tr[id^="doctor-"] :hover {
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
                <sql:query dataSource="${connection}" var="doctorList">
                    <%=staffQuery%>
                </sql:query>
            </c:when>
            <c:when test='${user.getGroupName() == "admin"}'>
                <sql:query dataSource="${connection}" var="doctorList">
                    <%=defaultQuery%>
                </sql:query>
            </c:when>
            <c:when test='${user.getGroupName() == "financial"}'>
                <sql:query dataSource="${connection}" var="doctorList">
                    <%=defaultQuery%>
                </sql:query>
            </c:when>
        </c:choose>
        
        <form id="doctor-searchbar" class="form-inline clearfix" style="padding: 10px">
            <div id="search-option" class="searchbar">
                <select class="form-control">
                    <option value="doctor-id" selected="selected" data-type="int">doctor id</option>
                    <option value="doctor-name" data-type="string">doctor name</option>
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
        </form>
        <div class="table-responsive">
        <table id="doctor-table" class="table table-hover table-condensed">
            <thead>
                <tr>
                    <th>doctor id</th>
                    <th>doctor name</th>
                    <c:if test='${user.getGroupName() == "financial"}'>
                        <th>
                            patient record summary
                        </th>
                    </c:if>
                    <c:if test='${user.getGroupName() == "staff" || user.getGroupName() == "admin"}'>
                        <th>
                            assignment                           
                        </th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="row" items="${doctorList.rows}">
                <tr>
                    <td class="doctor-id">
                        <c:out value="${row.doctor_id}"/>
                    </td>
                    <td class="doctor-name">
                        <c:out value="${row.doctor_name}"/>
                    </td>
                    <c:if test='${user.getGroupName() == "financial"}'>
                        <td>
                            <a href="${pageContext.request.contextPath}/patientRecord.jsp?patientId=0&doctorId=${row.doctor_id}" target="_blank" class="btn btn-xs btn-primary">
                                patient record summary
                            </a>
                        </td>
                    </c:if>
                    <c:if test='${user.getGroupName() == "staff" || user.getGroupName() == "admin"}'>
                        <td>
                            <a href="${pageContext.request.contextPath}/doctorAssign.jsp?doctorId=${row.doctor_id}" target="_blank" class="btn btn-xs btn-primary">
                                assign                            
                            </a>
                        </td>
                    </c:if>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        </div>
        <script type="text/javascript">
            $(document).ready(function() {
                $(function(){
                    $('#doctor-table').tablesorter();
                });
                
                clearSearchFilter();

                $('#doctor-searchbar #search-range .input-group').datetimepicker();

                $('#doctor-searchbar #search-option').change(function() {
                    if ($(this).find(':selected').data('type') == 'string') {
                        $('#doctor-searchbar #search-single').show();
                        $('#doctor-searchbar #search-range').hide();
                        $('#doctor-searchbar #search-single .form-control').val('');
                        searchFilter();
                    } else {
                        $('#doctor-searchbar #search-single').hide();
                        $('#doctor-searchbar #search-range').show();
                        $('#doctor-searchbar #search-range .form-control').val('');
                        searchRangeFilter();
                    }
                });

                $('#doctor-searchbar #search-input').on('input', function(e) {
                    searchFilter();
                });

                $('#doctor-searchbar #search-range .form-control').on('input', function(e) {
                    searchRangeFilter();
                });

                $('#doctor-searchbar #search-range .date').on('dp.change', function(e) {
                    searchRangeFilter();
                });

                function clearSearchFilter() {
                    $('#doctor-searchbar #search-input').val('');
                    $('#doctor-searchbar #search-range #search-min, #doctor-searchbar #search-range #search-max').val('');
                }

                function searchFilter() {
                    var searchInput = $.trim($('#doctor-searchbar #search-input').val().toLowerCase());
                    var option = $('#doctor-searchbar #search-option').find(':selected').val();
                    $('#doctor-table tbody tr').each(function() {
                        if ($.trim($(this).find('[class^="' + option + '"]').text().toLowerCase()).indexOf(searchInput) == -1) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                }
                
                function searchRangeFilter() {
                    var valueType = $('#doctor-searchbar #search-option').find(':selected').data('type');
                    var option = $('#doctor-searchbar #search-option').find(':selected').val();
                    
                    var searchMin, searchMax, parseValue;
                    switch (valueType) {
                        case "int": 
                            searchMin = parseInt($.trim($('#doctor-searchbar #search-min').val()));
                            searchMax = parseInt($.trim($('#doctor-searchbar #search-max').val()));
                            parseValue = function(value) { 
                                return !isNaN(parseInt(value)) ? parseInt(value) : null; 
                            };
                            break;
                        case "date":
                            searchMin = moment($.trim($('#doctor-searchbar #search-min').val()));
                            searchMax = moment($.trim($('#doctor-searchbar #search-max').val()));
                            parseValue = function(value) {
                                return moment(value).isValid() ? moment(value) : null;
                            };
                            break;
                    }
                        
                    $('#doctor-table tbody tr').each(function() {
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