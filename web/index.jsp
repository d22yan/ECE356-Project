<%-- 
    Document   : index
    Created on : 10-Mar-2014, 9:28:16 PM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html ng-app="app">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="../../assets/ico/favicon.ico">
    <title>ECE356 Database Application</title>
    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="styles/bootstrap/bootstrap.min.css">
    <!-- Custom styles for this template -->
    <!-- <link rel="stylesheet" href="styles/custom.css" > -->
    <script src="scripts/libraries/angularjs/angular.min.js"></script>
    <script src="scripts/libraries/angularjs/ui-bootstrap-tpls-0.10.0.min.js"></script>
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
          <a class="navbar-brand" href="#">ECE356 Database Application</a>
        </div>
        <div class="navbar-collapse collapse">
          <form class="navbar-form navbar-right" role="form" action="LoginServlet" method="post">
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
        <h1>header</h1>
        <p>description</p>
        <p><a class="btn btn-primary btn-lg" role="button">button &raquo;</a></p>
      </div>
    </div>

    <div class="container">
      <!-- Example row of columns -->
      <div class="row">
        <div class="col-md-4" ng-repeat="heading in [1,2,3]">
          <h2>Heading {{heading}}</h2>
          <p>description {{heading}}</p>
          <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
        </div>
      </div>

      <hr>

      <footer ng-controller="DevelopersController">
        <p>&copy;
          <span ng-repeat="developer in developers">
            <a href="#" tooltip="{{developer.id}}">{{developer.name}}</a>{{$last ? '' : ', '}}
          </span>
        </p>
      </footer>
    </div> <!-- /container -->
    <script src="scripts/app.js"></script>
    <script src="scripts/controllers.js"></script>
  </body>
</html>