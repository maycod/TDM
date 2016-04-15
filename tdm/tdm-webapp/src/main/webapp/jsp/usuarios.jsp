<!-- Verificar que la sesion sea valida -->
<%@ page import="java.io.*,java.util.*,javax.servlet.http.HttpSession"%>
<%
	session=request.getSession();  
	String  username = (String)session.getAttribute("username");
	if (username == null){
		response.sendRedirect("../login.jsp");	
	}
	String  profile = (String)session.getAttribute("profile");

%>
<html lang="en">
<head>

<link rel="import" href="includes.html" >

<script type="text/javascript">

var usersView;
var tdm = {};

jQuery(document).ready(function($){
	
	
	$.ajaxSetup({
		cache: false,
	    beforeSend: function (xhr)
	    {
	       xhr.setRequestHeader("Content-Type","application/json;charset=utf-8");	              
	    }
	});
	usersView = new tdm.UsersView();
	
	var profile = $("#profile")[0].innerHTML;
	if (profile == "Administrador"){
		var tabUsarios = $("#tabUsuarios");
		tabUsarios.css("display", "block");
		var btnAgregar = $("#btnAgregar");
		btnAgregar.css("display", "block");
		var btnEliminar = $("#btnEliminar");
		btnEliminar.css("display", "block");
	}
	
	
	
});
</script>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>ToDoManager - Usuarios</title>

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
				<img class="navbar-brand-img" src="../images/photos/dtchLogo500W.png"
					alt="Formacion Social"> <a class="navbar-center navbar-brand"
					href="tareas.jsp">To Do Manager</a>
			</div>
			<!-- Top Menu Items -->
			<ul class="nav navbar-right top-nav">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown"><i class="fa fa-user"></i> <%=username%>
						<b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="cambiarClave.jsp"><i class="fa fa-fw fa-gear"></i> Cambiar
								contraseña</a></li>
						<li class="divider"></li>
						<li><a href="../LogoutServlet"><i
								class="fa fa-fw fa-power-off"></i> Salir</a></li>
					</ul></li>
			</ul>
			<!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
			<div class="collapse navbar-collapse navbar-ex1-collapse">
				<ul class="nav navbar-nav side-nav">
					<li><a href="tareas.jsp"><i
							class="fa fa-fw fa-bar-chart-o"></i>Tareas</a></li>
					<li class="active" style="display:none;" id="tabUsuarios"><a href="usuarios.jsp"><i
							class="fa fa-fw fa-bar-chart-o"></i>Usuarios</a></li>
				</ul>
			</div>
			<!-- /.navbar-collapse -->
		</nav>
		<div id="usersDiv">

			<div class="container-fluid">

				<!-- Page Heading -->
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">
							Usuarios <small></small>
						</h1>
					</div>
				</div>
				<!-- /.row -->
			</div>
			<div>
				 <button type="button" class="btn btn-default btn-sm" style="float:right;display:none;" id="btnEliminar">
		          <span class="glyphicon glyphicon-trash"></span>Eliminar
		        </button>
				<button type="button" class="btn btn-default btn-sm" style="float:right;display:none;" onclick="location.href='usuarioAgregar.jsp';" id="btnAgregar">
		          <span class="glyphicon glyphicon-plus"></span>Agregar
		        </button>
			</div>
			<!-- /.container-fluid -->
			<div class ="row" id="filtersContainer">
			<table style="width:80%">
			  <tr>
			    <td style="width:25%"><div id="filter1"></div></td>
			    <td style="width:25%"><div id="filter2"></div></td> 
			    <td style="width:25%"><div id="filter3"></div></td>
			  </tr>
			</table>
			</div>
			<div class="backgrid-container" id="usersTable"></div>
		</div>
		<!-- /#page-wrapper -->

	</div>
	<!-- /#wrapper -->

	<!-- Modelos -->
	<script type="text/javascript" src="../js/app/Constantes.js"></script>
	<script type="text/javascript" src="../js/app/model/User.js"></script>
	<script type="text/javascript" src="../js/app/view/usersView.js"></script>
	<script type="text/javascript" src="../js/nobackspace.js"></script>


<label id="profile" style="display:none;"><%=profile%></label><br>
</body>
</html>