<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Wizard Centralizado</title>



<!-- ========= -->
<!--    CSS    -->
<!-- ========= -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<link rel="stylesheet" href="css/jquery.ui.css" type="text/css" />
<link rel="stylesheet" href="css/ui-lightness/jquery-ui.css" type="text/css" />
<link rel="stylesheet" href="css/style.default.css" type="text/css" />
<link rel="stylesheet" href="css/smart_wizard.css" type="text/css" />
<link rel="stylesheet" href="css/jquery-confirm.min.css" type="text/css" />
<link rel="stylesheet" href="css/jquery.loadmask.css" type="text/css" />
<link rel="stylesheet" href="css/backgrid.css" type="text/css" />
<link rel="stylesheet" href="css/bootstrap.css" type="text/css" />
<!-- <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css" /> -->
<link rel="stylesheet" href="css/datepicker.css" type="text/css" />

<link rel="stylesheet" href="css/backgrid.css" type="text/css" />
<link rel="stylesheet" href="css/backgrid-select-all.css" type="text/css" />
<link rel="stylesheet" href="css/jqx.base.css">

<style type="text/css">
.widget
{
width: 300px;
height: 300px;
}
input[type=search]::-ms-clear { display: none; }
</style>

</head>

<body onload="login()"  style="overflow-x: scroll; min-width: 1200px;">
    
<%  
    String usuario = (String)request.getParameter("userid");  
    session.setAttribute( "user", usuario );
%> 

 <!-- ========= -->
  <!-- HTML -->
  <!-- ========= -->
<div id="mainwrapper" class="mainwrapper">
    
   
    <div class="rightpanel">
        
        <div class="pageheader">
            <!--<div class="pageicon"><span class="iconfa-pencil"></span></div>-->
            <div class="pagetitle">
                <h1>SISTEMA INTEGRAL DE CADENA DE SUMINISTRO / 7-Eleven M&eacute;xico</h1>
            </div>            
        </div><!--pageheader-->
        
        <div class="maincontent">
            <div class="maincontentinner">
                    <!-- START OF TABBED WIZARD -->

                    <form class="stdform" method="post" action="wizards.html" style="min-width: 1036px;">
					<div class="header-pedido pedidoActualClass">
		                Pedido: <span id="pedidoActual">Por seleccionar</span>
		            </div>					
                    <div id="wizard3" class="wizard tabbedwizard">
                   
                        <ul class="tabbedmenu">
                            <li>
                            	<a href="#wiz3step1">
                                	<span class="h2">Paso 1</span>
                                    <span class="label">DEFINICION</span>
                                </a>
                            </li>
                            <li>
                            	<a href="#wiz3step2">
                                	<span class="h2">Paso 2</span>
                                    <span class="label">TIENDAS</span>
                                </a>
                            </li>
                            <li>
                            	<a href="#wiz3step3">
                                	<span class="h2">Paso 3</span>
                                    <span class="label">ARTICULOS</span>
                                </a>
                            </li>                            
							<li>
                            	<a href="#wiz3step4">
                                	<span class="h2">Paso 4</span>
                                    <span class="label">MATRIZ DE PEDIDO</span>
                                </a>
                            </li>
							<li>
                            	<a href="#wiz3step5">
                                	<span class="h2">Paso 5</span>
                                    <span class="label">DIVISION POR ARTICULO</span>
                                </a>
                            </li>
							<li>
                            	<a href="#wiz3step6">
                                	<span class="h2">Resumen</span>
                                    <span class="label">    </span>
                                </a>
                            </li>                            
                        </ul>
                        	
                        <div id="wiz3step1" class="formwiz container-fluid contenido">
                        	<%@include file="jsp/paso1.jsp" %>                           
                        </div><!--#wiz3tep1-->
                        
                        <div id="wiz3step2" class="formwiz contenido">
                        	<%@include file="jsp/paso2.jsp" %>
                        </div><!--#wiz3step2-->

                        <div id="wiz3step3" class="contenido">
                        	<%@include file="jsp/paso3.jsp" %>
                        </div><!--#wiz3step3-->
                        
                        <div id="wiz3step4" class="contenido">
                        	<%@include file="jsp/paso4.jsp" %>
                        </div><!--#wiz3step4-->
                        
                        <div id="wiz3step5" class="contenido">
                        	<%@include file="jsp/paso5.jsp" %>
                        </div><!--#wiz3step5-->
                                               
                        <div id="wiz3step6" class="contenido">
                        	<%@include file="jsp/Resumen.jsp" %>
                        </div><!--#wiz3step6-->                        
                        
                    </div><!--#wizard-->
                    </form>
                                        
                    <!-- END OF TABBED WIZARD -->
                 
            
            </div><!--maincontentinner-->
        </div><!--maincontent-->
        
    </div><!--rightpanel-->
    
</div><!--mainwrapper-->

<div id="accesoDenegado" style="display:none; ">
	<br><br><br><br>
	<center><H1>Acceso Denegado</H1></center>
</div>     
   
  <!-- ========= -->
  <!-- Libraries -->
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
<script type="text/javascript" src="js/custom.js"></script>
<script type="text/javascript" src="js/underscore.js"></script>
<script type="text/javascript" src="js/backbone.js"></script>
<script type="text/javascript" src="js/Backbone.ModelBinder.js"></script>
<script type="text/javascript" src="js/Backbone.CollectionBinder.js"></script>
<script type="text/javascript" src="js/backbone-associations.js"></script>
<script type="text/javascript" src="js/backbone-batch-operations.js"></script>
<script type="text/javascript" src="js/backgrid.js"></script>

<script type="text/javascript" src="js/jquery.integralui.widget.min.js"></script>
<script type="text/javascript" src="js/jquery.ui.widget.min.js"></script>
<script type="text/javascript" src="js/bootstrap-treeview.js"></script>
<!-- <script type="text/javascript" src="js/Backgrid.Grid.js"></script> -->
<!-- <script type="text/javascript" src="js/Backgrid.Extension.SelectRowCell.js"></script> -->
<script type="text/javascript" src="js/backgrid-select-all.js"></script>
<!-- <script type="text/javascript" src="js/Backgrid.Extension.SelectAllHeaderCell.js"></script> -->
<script type="text/javascript" src="js/backgrid-paginator.js"></script>
<script type="text/javascript" src="js/lunr.js"></script>
<script type="text/javascript" src="js/backgrid-filter.js"></script>

<script type="text/javascript" src="js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="js/prettify.js"></script>
<script type="text/javascript">
	if (top.location != location) {
    top.location.href = document.location.href ;
  }
		$(function(){
			// window.prettyPrint && prettyPrint();
			var $j = jQuery.noConflict();
			var dfecAct = new Date();
			var mesfecAct = dfecAct.getMonth() + 1;
			var diafecAct = dfecAct.getDate() + 1;
			var fecAct = diafecAct + '/' + mesfecAct + '/' + dfecAct.getFullYear();
			$j('#divFechaPedido').datepicker('setValue', fecAct);
			$('#inputFechaPedido').val($j('#divFechaPedido').data('date'));
			/*$j('#divFechaPedido').datepicker({setDate: new Date()});
		                update: new Date(),
		                autoclose: true
		            });*/
			$j('#divFechaPedido').datepicker().on('changeDate', function (ev) {
				$j(this).datepicker('hide');
				});
		});
	
</script>


<script type="text/javascript">
function login(){
	var usr = '<%= session.getAttribute("user") %>';
	if(usr == "null"){
		//	$("#mainwrapper").remove();
		//	$("#accesoDenegado").show();
	}
}
</script>




<script type="text/javascript">

var paso1view, paso2view, paso3view, paso4view, paso5view, resumenview, finalizarview;

jQuery(document).ready(function($){
	
	
	$.ajaxSetup({
		cache: false,
	    beforeSend: function (xhr)
	    {
	       xhr.setRequestHeader("Content-Type","application/json;charset=utf-8");	              
	    }
	});
	
	
   $('#scroll').slimScroll({
			size: '10px',
			height: '275px',
			alwaysVisible: true
		});
		
	$.widget("ui.tooltip", $.ui.tooltip, {
	    options: {
	    	
	        content: function () {
	        	var title = $( this ).attr( "title" ) || "";
				// Escape title, since we're going from an attribute to raw HTML
				//return $( "<a>" ).text( title ).html();
	            return $(this).prop('title');
	        },
	        position: { my: "right-25 center", at: "right center", collision: "flipfit" },
			show: true,
			tooltipClass: null,
			track: false,

			// callbacks
			close: null,
			open: null
	    }
	});
	 
    // Smart Wizard 	
    $('#wizard3').smartWizard({
    	selected: 0,
    	labelNext:'Siguiente &raquo;', // label for Next button
        labelPrevious:'&laquo; Anterior', // label for Previous button
        labelFinish:'Terminar',  // label for Finish button  
        onShowStep: onShowStepCallback,
		onLeaveStep: onLeaveStepCallback,
        onFinish: onFinishCallback});
		
    function onFinishCallback(){
             
			if(!finalizarview){
				finalizarview = new merlinwizard.FinalizarView({pedido:paso1view.pedido});
			}else{
				finalizarview.loadFinalizar();
			}
		var ReferenciaPedCent = $('#pedidoActual').text();
		var msgConfirmacion = 'Pedido Centralizado ' + ReferenciaPedCent + ' guardado con exito!'
		setTimeout(function() {
			$jCustom.confirm({
			    title: msgConfirmacion,
			    confirmButtonClass: 'btn-info',
			    confirmButton: 'Aceptar',
			    cancelButton: false,
			    closeIcon: false,
			    animationBounce: 2.5,
			    content: false,
			    confirm: function(){
			    	location.reload();
			    }
			});
			//alert("Pedido Centralizado Finalizado con exito!");
			}, 10);
		//window.close();
              	
    } 

    paso1saved = false, paso2saved = false, paso3saved = false, paso4saved = false, paso5saved = false, paso4next = false;
    pedidoExistente = false, paso1selected=false, paso2selected=false, paso3selected=false;
    function onLeaveStepCallback(obj, ctx){

    	jQuery('#wizard3').smartWizard('hideMessage',"");
    	if(ctx.fromStep > ctx.toStep){
    		if(ctx.toStep == 1){
    			paso1saved = false;
    		}else if(ctx.toStep == 2){
    			paso2saved = false;
    		}else if(ctx.toStep == 3){
    			paso3saved = false;
    		}else if(ctx.toStep == 4){
    			paso4saved = false;
    		}else if(ctx.toStep == 5){
    			paso5saved = false;
    		}
    			
    		return true;
    	}
    	
    	
    	if(ctx.fromStep == 1){
				if(paso1saved){
					return true;
				}else{
					paso1view.onGuardarPedidoClick(null, function(){
						paso1saved = true;
						jQuery('#wizard3').smartWizard('goForward');
						
					});
				}
				return false;
			
    	}else if(ctx.fromStep == 2){
	    	/*if(jQuery('#perfilesTdaCombo').val() == '' && paso2view.editMode == false){
	    		jQuery('#wizard3').smartWizard('showMessage',"Seleccione una tienda para continuar. ");
				return false;
			}else{*/
				if(paso2saved){
					return true;
				}else{
					paso2view.onGuardarTiendaClick(null, function(){
						paso2saved = true;
						jQuery('#wizard3').smartWizard('goForward');
						
					});
				}
				return false;
			//}
		}else if(ctx.fromStep == 3){
	    	/*if( jQuery('#categoriasArtCombo').val() == '' && paso3view.editMode == false){
	    		jQuery('#wizard3').smartWizard('showMessage',"Seleccione un artículo para continuar. ");
				return false;
			}else{*/
				if(paso3saved){
					return true;
				}else{
					paso3view.onGuardarArticuloClick(null, function(){
						paso3saved = true;
						jQuery('#wizard3').smartWizard('goForward');
						
					});
				}
				return false;
			//}
    	}else if(ctx.fromStep == 4){
			if(paso4saved){
					return true;	
				}else{
					paso4view.onGuardarClick(null, function(){
						paso4saved = true;
						jQuery('#wizard3').smartWizard('goForward');
						
					});
				}
				return false;
    	}else if(ctx.fromStep == 5){
			if(paso5saved){
					return true;
				}else{
					paso5view.onGuardarArticuloClick(null, function(){
						paso5saved = true;
						jQuery('#wizard3').smartWizard('goForward');
						//return true;
					});
				}
				return false;
		}
	
    	return true;
		
    }
    function onShowStepCallback(obj, ctx){
        //console.log(ctx);
       
        if(ctx.toStep == 1){
        	
        	if(!paso1view){
        		paso1view = new merlinwizard.Paso1View();
        	} else {
        		paso1view.onBuscarExistenteClick(null);
        	}
        	
        	
        }else if(ctx.toStep == 2){
        	
        	
   			if(!paso2view){
   				paso2view = new merlinwizard.Paso2View({pedido:paso1view.pedido});
   			}else{
   				paso2view.clear();
   				paso2view.loadPerfilesTda();
   			}
   			
       }else if(ctx.toStep == 3){
        	
   			if(!paso3view){
   				paso3view = new merlinwizard.Paso3View({pedido:paso1view.pedido});
   			} else{
   				paso3view.clear();
   				paso3view.loadCategoriasArt();
   			}
        }else if(ctx.toStep == 4){
        	
        
        	if(!paso4view){
				paso4view = new merlinwizard.Paso4View({pedido:paso1view.pedido});
			}else{
				paso4view.loadMatrizExcepciones();
			}
        	
        }else if(ctx.toStep == 5){
        	
        
        			if(!paso5view){
        				paso5view = new merlinwizard.Paso5View({pedido:paso1view.pedido});
        			}else{
        				paso5view.loadArticulos();
        			}
        	
        }else if(ctx.toStep == 6){
        	
            
			if(!resumenview){
				resumenview = new merlinwizard.ResumenView({pedido:paso1view.pedido});
			}else{
			
				resumenview.loadResumen();
			}
	
	
		}

        
        return true;
    } 
			
    //jQuery('select, input:checkbox').uniform();
    
});
</script>


<script type="text/javascript">
console.log(merlinwizard);
var merlinwizard = {};

_.templateSettings = {
	    interpolate: /\<\@\=(.+?)\@\>/gim,
	    evaluate: /\<\@(.+?)\@\>/gim,
	    escape: /\<\@\-(.+?)\@\>/gim
	};



/*
  var keepAliveModel = new merlinwizard.Plazas();
function keepAlive(){
	setTimeout(function(){	
		keepAliveModel.plazas.fetch({ 
			success: function(data){ 
				console.log(data);
				},
				error:function(){
			
				} 
				});	
		keepAlive();
	}, 5000);
}
keepAlive();*/


</script>

<script type="text/javascript" src="js/app/Constantes.js"></script>
<script type="text/javascript" src="js/app/model/Plaza.js"></script>
<script type="text/javascript" src="js/app/model/Pedido.js"></script>
<script type="text/javascript" src="js/app/model/PerfilTda.js"></script>
<script type="text/javascript" src="js/app/model/Tienda.js"></script>
<script type="text/javascript" src="js/app/model/CategoriaArt.js"></script>
<script type="text/javascript" src="js/app/model/Articulo.js"></script>
<script type="text/javascript" src="js/app/model/Resumen.js"></script>
<script type="text/javascript" src="js/app/model/Finalizar.js"></script>
<script type="text/javascript" src="js/app/model/Excepcion.js"></script>
<script type="text/javascript" src="js/app/model/TipoPedido.js"></script>
<script type="text/javascript" src="js/app/model/Estatus.js"></script>
<script type="text/javascript" src="js/app/view/Paso1View.js"></script>

<!-- Plugin TreeView -->
<script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="js/jqxcore.js"></script>
<script type="text/javascript" src="js/jqxbuttons.js"></script>
<script type="text/javascript" src="js/jqxscrollbar.js"></script>
<script type="text/javascript" src="js/jqxpanel.js"></script>
<script type="text/javascript" src="js/jqxtree.js"></script>
<script type="text/javascript" src="js/jquery-confirm.min.js"></script>
<script>var $jCustom = jQuery.noConflict(true);</script>

<script type="text/javascript" src="js/app/view/Paso2View.js"></script>
<script type="text/javascript" src="js/app/view/Paso3View.js"></script>
<script type="text/javascript" src="js/app/view/Paso4View.js"></script>
<script type="text/javascript" src="js/app/view/Paso5View.js"></script>
<script type="text/javascript" src="js/app/view/ResumenView.js"></script>
<script type="text/javascript" src="js/app/view/FinalizarView.js"></script>
<script type="text/javascript" src="js/app/view/ComboPlazasView.js"></script>
<script type="text/javascript" src="js/app/view/ComboPerfilesTdaView.js"></script>
<script type="text/javascript" src="js/app/view/ComboCategoriasArtView.js"></script>

<script type="text/javascript">
//Codigo necesario para mentener la sesion activa
var keepAliveModel = new merlinwizard.Plazas();
function keepAlive(){
	setTimeout(function(){	
		keepAliveModel.fetch({ 
			success: function(){ 
				console.log("Keeping Session Alive");
				keepAlive();
				},
				error:function(){
				keepAlive();
				} 
				});	
		
	}, 1200000);
}
keepAlive();
</script>
   
</body>
</html>