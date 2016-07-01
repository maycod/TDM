<!-- Verificar que la sesion sea valida -->
<%@ page import="java.io.*,java.util.*,javax.servlet.http.HttpSession"%>
<%
	session = request.getSession();
	String username = (String) session.getAttribute("username");
	if (username == null) {
		response.sendRedirect("../login.jsp");
	}
	String profile = (String) session.getAttribute("profile");
	Integer profileId = (Integer) session.getAttribute("profileId");
	Integer userId = (Integer) session.getAttribute("userId");
%>
<html lang="en">
<head>

<link rel="import" href="includes.html">

<script type="text/javascript">
	var tasksView;
	var tdm = {};

	$(document).ready(
			function($) {

				$('#template').load('template.html');
				$('#asignarModal').load('tareaAsignar.html');
				$.ajaxSetup({
					cache : false,
					beforeSend : function(xhr) {
						xhr.setRequestHeader("Content-Type",
								"application/json;charset=utf-8");
					}
				});
				tasks = new tdm.TasksView();
				setTimeout(function() {
					var username = $("#username").text();
					$("#usernameNavBar").append(username);
					var profile = jQuery("#profile").text();
					if (profile == "Administrador") {
						var tabUsarios = $("#tabUsuarios");
						tabUsarios.css("display", "block");
						var btnAgregar = $("#btnAgregar");
						btnAgregar.css("display", "block");
						var btnEliminar = $("#btnEliminar");
						btnEliminar.css("display", "block");
					}
					$("#tabTareas").toggleClass("active");
				}, 500);

			});
</script>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>ToDoManager - Tareas</title>

</head>

<body>

	<div id="wrapper">
		<!-- Import de template.html -->
		<div id="template"></div>
		
		<!-- #tasksDiv -->
		<div id="tasksDiv" style="position: relative;left: 3%;">
			<div class="container-fluid">
				<!-- Page Heading -->
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">
							Tareas <small></small>
						</h1>
					</div>
				</div>
				<!-- /.row -->
			</div>

			<!-- /.container-fluid -->
			<div class="row" style="width: 100%;">
				<!-- #taskTreeContainer -->
				<div id="taskTreeContainer" class="col-sm-4 jumbotron"
					style="width: 30%; padding-top: 10px">
					<div style="padding-right: 4%;">
						<button type="button" class="btn btn-default btn-sm"
							style="float: left;" id="btnAsignar">
							<span class="glyphicon glyphicon-share"></span>Asignar
						</button>
						<button type="button" class="btn btn-default btn-sm"
							style="float: right; display: none;" id="btnEliminar">
							<span class="glyphicon glyphicon-trash"></span>Eliminar
						</button>
						<button type="button" class="btn btn-default btn-sm"
							style="float: right; display: none;"
							id="btnAgregar">
							<span class="glyphicon glyphicon-plus"></span>Agregar
						</button>
					</div>
					<div style="min-height:35px;"></div>
					<div id="jqxTree"
						style="overflow-y: scroll !important; padding-top: 10px !important;"></div>
				</div>
				<!-- /#taskTreeContainer -->
				<div class="col-sm-1" style="width: 6%;"></div>
				<label id="taskId" style="display: none;"></label>
				<label id="parentTaskId" style="display: none;"></label>
				<!-- #taskDetailAdm -->
				<div id="taskDetailAdm" class="col-sm-5 jumbotron"
					style="width: 60%; display:none;">
					<h3 style="text-align: center;">Información Detallada de Tarea</h3>
					<div style="width: 70%; margin: 0 auto;">
						<table class="table table-bordered table-striped">
							<tbody>
								<tr>
									<th style="width: 20%;">Clave:</th>
									<td> <input
										type="text" class="form-control" id="taskNameAdm" required></td>
								</tr>
								<tr>
									<th style="width: 20%;">Nombre:</th>
									<td><input type="text" class="form-control"
										id="taskDescAdm" required></td>
								</tr>
								<tr>
									<th style="width: 20%;">Observaciones:</th>
									<td><input type="text" class="form-control"
										id="observationsAdm"></td>
								</tr>
								<tr>
									<th style="width: 20%;">Horas Presupuestadas:</th>
									<td><input type="text" class="form-control"
										id="timeBudgetAdm"></td>
								</tr>
								<tr>
									<th style="width: 20%;">Activo:</th>
									<td><input type="checkbox" value="" id="activeAdm">
									</td>
								</tr>
							</tbody>
						</table>
						<button type="button" class="btn btn-default btn-sm"
							style="float: right;" id="btnGuardar">
							<span class="glyphicon glyphicon-floppy-disk"></span>Guardar
						</button>
					</div>
				</div>
				<!-- /#taskDetailAdm -->
				<!-- #taskDetailUsr -->
				<div id="taskDetailUsr" class="col-sm-5 jumbotron"
					style="width: 60%;display:none;">
					<button type="button" class="btn btn-default btn-sm" style="float:right;" id="btnEditar">
			          <span class="glyphicon glyphicon-edit"></span>Editar
			        </button>
					<h3 style="text-align: center;">Información Detallada de Tarea</h3>
					<div style="width: 70%; margin: 0 auto;">
						<table class="table table-bordered table-striped">
							<tbody>
								<tr>
									<th style="width: 20%;">Clave:</th>
									<td>
									<label id="taskNameUsr"></label>
									 </td>
								</tr>
								<tr>
									<th style="width: 20%;">Nombre:</th>
									<td><label id="taskDescUsr"></label></td>
								</tr>
								<tr>
									<th style="width: 20%;">Observaciones:</th>
									<td><label id="observationsUsr"></label></td>
								</tr>
								<tr>
									<th style="width: 20%;">Responsable:</th>
									<td><label id="responsibleNameUsr"></label></td>
								</tr>
								<tr>
									<th style="width: 20%;">Horas Presupuestadas:</th>
									<td><label id="timeBudgetUsr"></label></td>
								</tr>
								<tr>
									<th style="width: 20%;">Activo:</th>
									<td><input type="checkbox" value="" id="activeUsr" disabled>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- /#taskDetailUsr -->
			</div>
		</div>
		<!-- /#tasksDiv -->
	</div>
	<!-- /#wrapper -->
	<!-- #asignarModal -->
	<div class="modal fade" id="asignarModal" tabindex="-1" role="dialog" 
     aria-labelledby="myModalLabel" aria-hidden="true"></div>
     <!-- /#asignarModal -->
	<!-- Modelos -->
	<script type="text/javascript" src="../js/app/Constantes.js"></script>
	<script type="text/javascript" src="../js/app/model/Task.js"></script>
	<script type="text/javascript" src="../js/app/model/User.js"></script>
	<script type="text/javascript" src="../js/app/view/tasksView.js"></script>
	<script type="text/javascript" src="../js/nobackspace.js"></script>


	<label id="profile" style="display: none;"><%=profile%></label>
	<label id="profileId" style="display: none;"><%=profileId%></label>
	<label id="username" style="display: none;"><%=username%></label>
	<label id="userId" style="display: none;"><%=userId%></label>
	<div style="display:none;"><img src="../images/photos/dtchLogo125W.png"></img></div>
	</body>
</html>