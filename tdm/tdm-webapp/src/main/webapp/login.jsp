<%@ page import="java.io.*,java.util.*,javax.servlet.http.HttpSession" %>
<html lang="en">
<head>
<!-- ========= -->
<!-- Backbone & jQuery (JS) -->
<!-- =========-->

<script type="text/javascript" src="js/jquery-2.0.0.min.js"></script>
<script type="text/javascript" src="js/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.10.3.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.maskedinput.js"></script>
<script type="text/javascript" src="js/jquery.filter_input.js"></script>
<script type="text/javascript" src="js/jquery.cookie.js"></script>
<script type="text/javascript" src="js/modernizr.min.js"></script>
<script type="text/javascript" src="js/jquery.smartWizard.js"></script>
<script type="text/javascript" src="js/jquery.slimscroll.js"></script>
<script type="text/javascript" src="js/jquery.loadmask.js"></script>
<script type="text/javascript" src="js/underscore.js"></script>
<script type="text/javascript" src="js/backbone.js"></script>
<script type="text/javascript" src="js/Backbone.ModelBinder.js"></script>
<script type="text/javascript" src="js/Backbone.CollectionBinder.js"></script>
<script type="text/javascript" src="js/backbone-associations.js"></script>
<script type="text/javascript" src="js/backbone-batch-operations.js"></script>
<script type="text/javascript" src="js/backgrid.js"></script>
<script type="text/javascript" src="js/jquery.integralui.widget.min.js"></script>
<script type="text/javascript" src="js/jquery.ui.widget.min.js"></script>
<script type="text/javascript" src="js/backgrid-select-all.js"></script>
<script type="text/javascript" src="js/backgrid-paginator.js"></script>
<script type="text/javascript" src="js/lunr.js"></script>
<script type="text/javascript" src="js/backgrid-filter.js"></script>
<script type="text/javascript" src="js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="js/iosoverlay.min.js"></script>
<script type="text/javascript" src="js/spin.min.js"></script>
<script type="text/javascript" src="js/prettify.js"></script>
<script type="text/javascript" src="js/jqxcore.js"></script>
<script type="text/javascript" src="js/jqxtree.js"></script>

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
<!-- iosOverlay Fonts -->
<link href="css/iosoverlay.min.css" rel="stylesheet">


<script type="text/javascript">
var loginView;
var tdm = {};
$( document ).ready( function(){
	  $( '#loginWindow' ).animate({ 'width': '70%' }, 500)
	    .delay(30)
	    .animate({ 'height': '320px' }, 500);
	  $( '.page-header, .input-group, .btn' )
	    .delay(850)
	    .animate({ 'opacity': '100' }, 7000);
		
		loginView = new tdm.LoginView();
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
      <img src="images/photos/dtchLogo500W.png" class="img-responsive" style="margin-left: 14%; max-width: 70%;" alt="Logo" width="1000" height="500">
      <br>
      <div id="loginWindow">
        <div class="page-header">
          <h1>Login</h1>
        </div>
        <form id="logInForm" class="form-signin" action="LoginServlet" method="post">
	        <div class="input-group">
	          <span class="input-group-addon" id="basic-addon1">Username</span>
	          <input type="text" class="form-control" placeholder="Username" aria-describedby="basic-addon1"  id="inputUsername" name="inputUsername">
	        </div>
	        <div class="input-group">
	          <span class="input-group-addon" id="basic-addon2">Password</span>
	          <input type="password" class="form-control" placeholder="Password" aria-describedby="basic-addon2" id="inputPassword" name="inputPassword">
	        </div>
	        <button class="btn btn-lg btn-danger" type="submit">Submit</button>
	        <label id= "labelError" style="text-align:center; color:rgb(204, 0, 0);"><%=mensajeError%></label>
	        
        </form>
      </div>
    </div>
    
    <!-- Modelos -->
	<script type="text/javascript" src="js/app/Constantes.js"></script>
	<script type="text/javascript" src="js/app/view/loginView.js"></script>
	<script type="text/javascript" src="js/nobackspace.js"></script>
    
    <div style="display:none;"><img src="images/photos/dtchLogo125W.png"></img></div>
</body>
</html>