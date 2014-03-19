<%-- 
    Document   : page-template
    Created on : Mar 18, 2014, 1:48:02 PM
    Author     : Lewis
--%>

<%@tag description="Generic Page Template" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="generic" tagdir="/WEB-INF/tags"%>

<%@attribute name="title" required="true"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>ECE356 Project</title>
        
        <link href="${pageContext.request.contextPath}/resources/styles/bootstrap.min.css" rel="stylesheet">
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/resources/scripts/bootstrap.min.js"></script>
        
        <!-- Custom resources -->
        <link href="${pageContext.request.contextPath}/resources/styles/custom.css" rel="stylesheet">
        <script src="${pageContext.request.contextPath}/resources/scripts/custom.js"></script>
    </head>
  <body>

    <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">ECE356 Project</a>
        </div>
        <div class="navbar-collapse collapse">
          <form class="navbar-form navbar-right" role="form" action="${pageContext.request.contextPath}/${user != null ? "LogoutServlet": "LoginServlet"}" method="post">
              <c:if test="${user == null}">
                <div class="form-group">
                  <input id="username" name="username" type="text" placeholder="username" class="form-control">
                </div>
                <div class="form-group">
                  <input id="password" name="password" type="password" placeholder="password" class="form-control">
                </div>
              </c:if>
              <button type="submit" class="btn btn-success">${user != null ? "Sign out" : "Sign in"}</button>
          </form>
        </div><!--/.navbar-collapse -->
      </div>
    </div>

    <div class="jumbotron">
      <div class="container">
        <h1>${title}</h1>
        <c:choose>
            <c:when test="${user != null}">
                <p>Welcome ${user.getUserName()}!</p>
            </c:when>
            <c:otherwise>
                <p>Welcome!</p>
            </c:otherwise>
        </c:choose>
        
        <c:choose>
            <c:when test="${user == null}">
                <label for="username"><p><a class="btn btn-primary btn-lg" role="button">
                    Sign in &raquo;
                </a></p></label>
            </c:when>
            <c:when test="${title == 'Home' && user != null}">
                <p><a href="${pageContext.request.contextPath}/${user.getGroupName()}" class="btn btn-primary btn-lg" role="button">
                    Return to <span class="capitalize">${user.getGroupName()}</span> &raquo;
                </a></p>
            </c:when>
            <c:when test="${title != 'Home'}">
                <p><a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg" role="button">
                    Return to Home &raquo;
                </a></p>
            </c:when>
        </c:choose>
      </div>
    </div>
    
    <div class="container">
        <c:choose>
            <c:when test="${title == 'Home' || user.getGroupName() == title.toLowerCase()}">
                <jsp:doBody/>
            </c:when>
            <c:otherwise>
                <div class="alert alert-danger fade in">
                    <h4>You do not have access to this page</h4>
                    <p>Please sign in as a user from the ${title} Department.</p>
                </div>
            </c:otherwise>
        </c:choose>
    
    </div> <!-- /container -->

    <div id="footer" class="navbar navbar-fixed-bottom">
        <div class="container">
            <div class="navbar-header">
                <p id="credits">Development Team: 
                    <a class="dev-name" href="#" data-toggle="tooltip" title="d22yan">Danny Yan</a>,
                    <a class="dev-name" href="#" data-toggle="tooltip" title="jkfu">Tony Fu</a>,
                    <a class="dev-name" href="#" data-toggle="tooltip" title="sh42lee">SangHoon Lee</a>,
                    <a class="dev-name" href="#" data-toggle="tooltip" title="q35liu">Lewis (Qi) Liu</a>
                </p>
            </div>
            
            <div class="navbar-collapse collapse">
                <div class="navbar-right">
                    <!-- DEBUG PANEL -->
                    
                </div>
            </div>
        </div>
    </div>
  </body>
</html>