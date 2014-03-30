<%-- 
    Document   : tab
    Created on : Mar 29, 2014, 7:46:19 PM
    Author     : Lewis
--%>

<%@tag description="Generic tabs component" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib tagdir="/WEB-INF/tags" prefix="generic" %>

<%@attribute name="id" required="true"%>
<%@attribute name="label" required="true"%>
<%@attribute name="isActive"%>

<div class="tab-pane${isActive ? " active" : ""}" id="${id}">
    <jsp:doBody/>
</div>

<script type="text/javascript">
    $(document).ready(function() {
        $('ul.nav.nav-tabs').append('<li${isActive ? ' class="active"' : ""}><a href="#${id}" data-toggle="tab">${label}</a></li>');
    });
</script>
