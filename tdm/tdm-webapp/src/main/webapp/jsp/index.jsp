<%@ page import="java.io.*,java.util.*,javax.servlet.http.HttpSession"%>
<%
	/*session=request.getSession();  
	String  username = (String)session.getAttribute("username");
	if (username == null){
		response.sendRedirect("../login.jsp");	
	}
	String  profile = (String)session.getAttribute("profile");*/

%>
<html lang="en">
<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>TDM</title>
<!-- jQuery -->
<script src="../js/jquery.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="../js/bootstrap.min.js"></script>
<script src="../js/csi.min.js"></script>
<!-- Bootstrap Core CSS -->
<link href="../css/bootstrap.min.css" rel="stylesheet">

<!-- Custom CSS -->
<link href="../css/sb-admin.css" rel="stylesheet">

<!-- Morris Charts CSS -->
<link href="../css/plugins/morris.css" rel="stylesheet">

<!-- Custom Fonts -->
<link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet"
	type="text/css">




</head>
<style>
.navbar-center {
	position: absolute;
	width: 100%;
	left: 0;
	top: 0;
	text-align: center;
	margin: auto;
	height: 100%;
}

.navbar-brand-img {
	float: left;
	height: 50px;
	padding: 5px 5px;
	font-size: 23px;
	line-height: 20px
}
</style>

<script type="text/javascript">
$(document).ready(function($){
	var profile = $("#profile")[0].innerHTML;
	if (profile == "Administrador"){
		var tabUsarios = $("#tabUsuarios");
		tabUsarios.css("display", "block");
	}
	
});


</script>
<body>

	<div id="wrapper">

		<!-- Navigation -->
		<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-ex1-collapse">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<img class="navbar-brand-img" src="../images/photos/LogoIndex.png"
					alt="Formacion Social"> <a class="navbar-center navbar-brand"
					href="index.jsp">ToDo Manager</a>
			</div>
			<!-- Top Menu Items -->
			<ul class="nav navbar-right top-nav">
				<li class="dropdown"><a class="dropdown-toggle"
					data-toggle="dropdown"><i class="fa fa-user"></i> 
						<b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="cambiarClave.jsp"><i
								class="fa fa-fw fa-gear"></i> Cambiar contraseña</a></li>
						<li class="divider"></li>
						<li><a href="../LogoutServlet"><i
								class="fa fa-fw fa-power-off"></i> Salir</a></li>
					</ul></li>
			</ul>
			<!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
			<div class="collapse navbar-collapse navbar-ex1-collapse">
				<ul class="nav navbar-nav side-nav">
					
					<li style="display: block;" id="tabUsuarios"><a
						href="usuarios.jsp"><i class="fa fa-fw fa-bar-chart-o"></i>Usuarios</a>
					</li>
				</ul>
			</div>
			<!-- /.navbar-collapse -->
		</nav>

		<div id="page-wrapper">

			<div class="container-fluid">

				<!-- Page Heading -->
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">
							!Bienvenido! <small></small>
						</h1>
						<ol class="breadcrumb">
							<li class="active">Lorem ipsum</li>
						</ol>
					</div>
				</div>
				<!-- /.row -->
			</div>
			<!-- /.container-fluid -->
				<div class="container">
					<br>
					
				</div>
			</div>
		<!-- /#page-wrapper -->

	</div>
	<!-- /#wrapper -->


	<label id="profile" style="display: none;"></label>
	<br>
	
</body>
</html>