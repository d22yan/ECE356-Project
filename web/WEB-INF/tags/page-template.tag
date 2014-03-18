<%-- 
    Document   : page-template
    Created on : Mar 18, 2014, 1:48:02 PM
    Author     : Lewis
--%>

<%@tag description="Generic Page Template" pageEncoding="UTF-8"%>
<%@taglib prefix="generic" tagdir="/WEB-INF/tags" %>
<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="title" required="true"%>

<%-- any content can be specified here e.g.: --%>

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
        
        <!-- Bootstrap core CSS -->
        <link href="${pageContext.request.contextPath}/resources/styles/bootstrap.min.css" rel="stylesheet">
        <!-- Custom styles -->
        <link href="${pageContext.request.contextPath}/resources/styles/custom.css" rel="stylesheet">
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
          <form class="navbar-form navbar-right" role="form" action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div class="form-group">
              <input name="username" type="text" placeholder="username" class="form-control">
            </div>
            <div class="form-group">
              <input name="password" type="password" placeholder="password" class="form-control">
            </div>
            <button type="submit" class="btn btn-success">Sign in</button>
          </form>
        </div><!--/.navbar-collapse -->
      </div>
    </div>

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div class="jumbotron">
      <div class="container">
        <h1>${title}</h1>
        <p>Welcome!</p>
        <p><a class="btn btn-primary btn-lg" role="button">Click Me &raquo;</a></p>
      </div>
    </div>
    
    <div class="container">
    <jsp:doBody/>
    </div> <!-- /container -->

    <div id="footer" class="navbar navbar-fixed-bottom">
        <div class="container">
            <p id="copyright">&copy; asdf</p>
        </div>
    </div>
    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/scripts/bootstrap.min.js"></script>
  </body>
</html>