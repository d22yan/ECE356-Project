<%-- 
    Document   : audit-trail-table
    Created on : 30-Mar-2014, 4:12:37 PM
    Author     : root
--%>
<%@tag description="Audit Trail Table" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="audit-trail-table" %>

<%
	String auditTrailTableSuffix = "_history";
	String dataSourceUrl = Database.ServiceConstant.url + Database.ServiceConstant.database;
	String historyTableQuery = Database.Query.HistoryTable(request.getParameter("historyTable") + auditTrailTableSuffix);
	String historyTableColumnQuery = Database.Query.HistoryTableColumn(request.getParameter("historyTable") + auditTrailTableSuffix);
%>

<html>
	<c:if test='${user != null && user.getGroupName() == "admin"}'>
        <sql:setDataSource 
            var="connection" 
            driver="com.mysql.jdbc.Driver"
            url="<%=dataSourceUrl%>"
            user="<%=Database.ServiceConstant.user%>"  
            password="<%=Database.ServiceConstant.pwd%>"/>
        <sql:query dataSource="${connection}" var="historyTable">
        	<%=historyTableQuery%>
        </sql:query>
        <sql:query dataSource="${connection}" var="historyTableColumn">
        	<%=historyTableColumnQuery%>
        </sql:query>
		<table id="audit-trail-table" class="table tablesorter">
        	<thead>
        		<tr>
		            <c:forEach var="historyTableColumnRow" items="${historyTableColumn.rows}">
	                    <th>
	                        <c:out value="${historyTableColumnRow.COLUMN_NAME}"/>
	                    </th>
		            </c:forEach>
        		</tr>
        	</thead>
        	<tbody>
        		<c:forEach var="historyTableRow" items="${historyTable.rows}">
        			<tr>
        				<c:forEach var="asdf" items="${historyTableRow}">
        					<td>
	        					<c:out value="${asdf}"/>
	        				</td>
	        			</c:forEach>
        			</tr>
        		</c:forEach>
        	</tbody>
        </table>
        <script type="text/javascript">
        $(document).ready(function() {
        	$(function(){
        		$("#audit-trail-table").tablesorter();
			});
        	$('#audit-trail-table > tbody > tr > td').each(function() {
        		var asdf = $(this).text().replace(/\s/g, '');
				var regexPattern = /=(.+)/;
				var regexMatch = asdf.match(regexPattern);
				if (regexMatch) {
				    $(this).html(regexMatch[1]);
				}
        	});
        });
        </script>
	</c:if>
</html>