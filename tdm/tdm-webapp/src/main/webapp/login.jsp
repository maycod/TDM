<%@ page import="java.io.*,java.util.*,javax.servlet.http.HttpSession" %>
<html lang="en">
<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>TDM - Iniciar Sesión</title>
<!-- Bootstrap Core CSS -->
<link href="css/bootstrap.min.css" rel="stylesheet">
<!-- Custom CSS -->
<link href="css/login.css" rel="stylesheet">
<!-- Custom Fonts -->
<link href="font-awesome/css/font-awesome.min.css" rel="stylesheet"
	type="text/css">
<!-- jQuery -->
<script src="js/jquery.js"></script>

<script type="text/javascript">
$( document ).ready( function(){
	  $( '#loginWindow' ).animate({ 'width': '100%' }, 500)
	    .delay(30)
	    .animate({ 'height': '300px' }, 500);
	  $( '.page-header, .input-group, .btn' )
	    .delay(850)
	    .animate({ 'opacity': '100' }, 7000);
	});

</script>

<%
	session=request.getSession();  
	String  mensajeError = (String)session.getAttribute("mensajeError");
	if (mensajeError == null){
		mensajeError = "";
	}

%>
</head>
<body style="margin-top:0px;">
	 <!-- jQuery/Bootstrap login window -->
    <div id="wrapper">
      <img src="images/photos/dtchLogo500W.png" class="img-responsive" alt="Logo" width="1000" height="500">
      <br>
      <div id="loginWindow">
        <div class="page-header">
          <h1>Login</h1>
        </div>
        <form class="form-signin" action="LoginServlet" method="post">
	        <div class="input-group">
	          <span class="input-group-addon" id="basic-addon1">Username</span>
	          <input type="text" class="form-control" placeholder="Username" aria-describedby="basic-addon1"  name="inputUsername">
	        </div>
	        <div class="input-group">
	          <span class="input-group-addon" id="basic-addon2">Password</span>
	          <input type="password" class="form-control" placeholder="Password" aria-describedby="basic-addon2"  name="inputPassword">
	        </div>
	        <button class="btn btn-lg btn-danger" type="submit">Submit</button>
	        <label id= "labelError" style="text-align:center; color:rgb(204, 0, 0);"><%=mensajeError%></label>
	        
        </form>
      </div>
    </div>
</body>
</html>