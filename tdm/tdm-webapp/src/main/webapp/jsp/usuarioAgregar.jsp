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
	Integer profileId = (Integer) session.getAttribute("profileId");
	Integer userId = (Integer) session.getAttribute("userId");
	
%>
<html lang="en">
<head>

<link rel="import" href="includes.html" >

<script type="text/javascript">

var userAddView;
var tdm = {};

$(document).ready(function($){
	
	$('#template').load('template.html');
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
	setTimeout(function () {
		var username = $("#username").text();
		$("#usernameNavBar").append(username);
        console.log("test");
        var profile = jQuery("#profile").text();
    	if (profile == "Administrador"){
    		var tabUsarios = $("#tabUsuarios");
    		tabUsarios.css("display", "block");
    		var btnAgregar = $("#btnAgregar");
    		btnAgregar.css("display", "block");
    		var btnEliminar = $("#btnEliminar");
    		btnEliminar.css("display", "block");
    	}
    	$("#tabUsuarios").toggleClass("active");
    }, 500);	
});

</script>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>ToDoManager - Usuarios</title>

</head>

<body>

	<div id="wrapper">
		<!-- Import de template.html -->
		<div id="template"></div>
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
			<div class="jumbotron" id="detailInfoDivAdm" style="width:70%;margin: 0 auto;margin-top:30px;padding-top:2px;">
				<h3 style="text-align:center;">Información Detallada de Usuario</h3>
				<div style="width:70%;margin: 0 auto;">
					<table class="table table-bordered table-striped">
					    <tbody>
					      <tr>
					        <th style="width:20%;">Nombre de Usuario:</th>
					        <td><input type="text" class="form-control" id="userDescAdm"></td>
					      </tr>
					      <tr>
					        <th>Codigo de Usuario:</th>
					        <td><input type="text" class="form-control" id="codenameAdm"></td>
					      </tr>
					      <tr>
					        <th>Clave de Usuario:</th>
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
					      <tr>
					        <th>Activo:</th>
					        <td>
								  <label class="checkbox-inline"><input type="checkbox" id="activeAdm" value=""></label>
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


<label id="profile" style="display:none;"><%=profile%></label>
<label id="profileId" style="display: none;"><%=profileId%></label>
<label id="username" style="display:none;"><%=username%></label>
<label id="userId" style="display: none;"><%=userId%></label>
<div style="display:none;"><img src="../images/photos/dtchLogo125W.png"></img></div>
</body>
</html>