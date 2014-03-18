<%-- 
    Document   : doctors
    Created on : Mar 17, 2014, 6:26:07 PM
    Author     : Lewis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Doctors</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
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
          <a class="navbar-brand" href="#">ECE356 Project</a>
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
        <h1>Doctors</h1>
        <p>Welcome Doctor!</p>
        <p><a class="btn btn-primary btn-lg" role="button">Click Me &raquo;</a></p>
      </div>
    </div>
    
    <table class="table">
        <thead>
            <tr>
                <th>Patient #</th>
                <th>Last Name</th>
                <th>First Name</th>
                <th>Phone Number</th>
            </tr>
        </thead>
        <tbody>
            
        </tbody>
    </table>


    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>
