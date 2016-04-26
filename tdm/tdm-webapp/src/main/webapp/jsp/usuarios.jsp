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

$(document).ready(function($){
	
	$('#template').load('template.html');
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
<label id="username" style="display:none;"><%=username%></label><br>
</body>
</html>