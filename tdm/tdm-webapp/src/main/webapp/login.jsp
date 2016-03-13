<%@ page import="java.io.*,java.util.*,javax.servlet.http.HttpSession" %>
<html lang="en">
<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>SISS - Iniciar Sesión</title>
<!-- Bootstrap Core CSS -->
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/signin.css" rel="stylesheet">
<!-- Custom CSS -->
<link href="css/sb-admin.css" rel="stylesheet">
<!-- Custom Fonts -->
<link href="font-awesome/css/font-awesome.min.css" rel="stylesheet"
	type="text/css">
	
<%
	session=request.getSession();  
	String  mensajeError = (String)session.getAttribute("mensajeError");
	if (mensajeError == null){
		mensajeError = "";
	}

%>
</head>
<body style="background-color:#FFFFFF;margin-top:0px;">
	<div class="container">
		<form class="form-signin" action="LoginServlet" method="post">
			<h2 class="form-signin-heading" style="text-align:center; color:rgb(0, 0, 153);">Sistema Informativo del Servicio Social</h2>
			<div style="text-align:center;"><img src="images/photos/loginLogo.jpg" alt="Formacion Social"></div>
			<p><br></br></p>
			<input type="text" name="inputUsername" class="form-control"
				placeholder="Nombre de Usuario" required autofocus> 
			<input type="password" name="inputPassword" class="form-control"
				placeholder="Password" required>
			<button class="btn btn-lg btn-primary btn-block" type="submit">Ingresar</button>
			<label id= "labelError" style="text-align:center; color:rgb(204, 0, 0);"><%=mensajeError%></label>
		</form>
	</div><!-- /container -->
</body>
</html>