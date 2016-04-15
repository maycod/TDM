<!-- Verificar que la sesion sea valida -->
<%@ page import="java.io.*,java.util.*,javax.servlet.http.HttpSession"%>
<%
	session=request.getSession();  
	String  username = (String)session.getAttribute("username");
	if (username == null){
		response.sendRedirect("../login.jsp");	
	}
	String  profile = (String)session.getAttribute("profile");
	if (!profile.equals("Administrador")){
		response.sendRedirect("../login.jsp");	
	}
	String  idUser = (String)request.getParameter("id");
	
%>
<html lang="en">
<head>

<link rel="import" href="includes.html" >

<script type="text/javascript">

var userAddView;
var tdm = {};

jQuery(document).ready(function($){
	
	
	$.ajaxSetup({
		cache: false,
	    beforeSend: function (xhr)
	    {
	       xhr.setRequestHeader("Content-Type","application/json;charset=utf-8");	              
	    }
	});
	userAddView = new tdm.UserAddView();
	
	var profile = $("#profile")[0].innerHTML;
	if (profile == "Administrador"){
		var tabUsarios = $("#tabUsuarios");
		tabUsarios.css("display", "block");
	}
	
	
});
</script>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>SISS</title>

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
				<img class="navbar-brand-img" src="../images/photos/LogoIndex.png"
					alt="Formacion Social"> <a class="navbar-center navbar-brand"
					href="index.jsp">Sistema Informativo del Servicio Social</a>
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
					<li><a href="alumnos.jsp"><i
							class="fa fa-fw fa-bar-chart-o"></i> Alumnos Destacados </a></li>
					<li><a href="grupos.jsp"><i
							class="fa fa-fw fa-bar-chart-o"></i> Grupos Estudiantiles
							Destacados</a></li>
					<li><a href="proyectos.jsp"><i
							class="fa fa-fw fa-bar-chart-o"></i>Proyectos</a></li>
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
							Usuarios <small>Agregar Usuario</small>
						</h1>
					</div>
				</div>
				<!-- /.row -->
			</div>
			<div>
				<button type="button" class="btn btn-default btn-sm" style="float:right;" onclick="location.href='usuarios.jsp';">
		          <span class="glyphicon glyphicon-circle-arrow-left"></span>Volver
		        </button>
			</div>
			<div class="jumbotron" id="detailInfoDivAdm" style="width:70%;margin: 0 auto;margin-top:30px;padding-top:2px;display:block;">
				<h3 style="text-align:center;">Información Detallada de Usuario</h3>
				<div style="width:70%;margin: 0 auto;">
					<table class="table table-bordered table-striped">
					    <tbody>
					      <tr>
					        <th style="width:20%;">Nombre de Usuario::</th>
					        <td><input type="text" class="form-control" id="usernameAdm"></td>
					      </tr>
					      <tr>
					        <th>Perfil:</th>
					        <td>
					        	<select class="form-control" id="profileDescAdm">
								  <option value="1">Administrador</option>
								  <option value="2">Lider</option>
								  <option value="3">Programador</option>
								</select>
					        </td>
					      </tr>
					    </tbody>
					  </table>
					  <button type="button" class="btn btn-default btn-sm" style="float:right;" id="btnGuardar">
				      	<span class="glyphicon glyphicon-floppy-disk"></span>Guardar
				      </button>
				</div>
			</div>
			<!-- /.container-fluid -->
			
		</div>
		<!-- /#page-wrapper -->

	</div>
	<!-- /#wrapper -->


	<!-- Modelos -->
	<script type="text/javascript" src="../js/app/Constantes.js"></script>
	<script type="text/javascript" src="../js/app/model/User.js"></script>
	<script type="text/javascript" src="../js/app/view/userAddView.js"></script>
	<script type="text/javascript" src="../js/nobackspace.js"></script>


<label id="profile" style="display:none;"><%=profile%></label><br>
</body>
</html>