merlinwizard.Paso1View = Backbone.View.extend({
el: jQuery('#wiz3step1'),
plaza:undefined,
pedido:undefined,
editMode:false,
initialize: function () {
	var self = this;
	self.maskEl = self.$el;
		
	self.pedido = new merlinwizard.Pedido();
	//self.plaza = new merlinwizard.Plaza();
	//self.tipospedido = new merlinwizard.TiposPedido();

	//self.$('#inputActivoPedido').filter_input({regex:'[0-9]'});
	
	self.pedido.on("invalid", function(model, error) {
		jQuery('#wizard3').smartWizard('showMessage',error.msg);
		  var rs = jQuery("input[name='"+error.field+"']");		  
		  rs.focus();
		});
	
	$("#detallePedido").css("display", "none");
	$( ".buttonNext" ).toggleClass('buttonNext buttonNext buttonDisabled');
		
	
	
	//$( ".buttonNext" ).button("disable");
    //self.inputRerefenciaExiste = self.$('#inputReferenciaExiste');
    self.inputReferencia = self.$('#inputReferencia');
	self.plazasCombo = self.$('#plazasCombo');
	self.tiposPedidoCombo = self.$('#tiposPedidoCombo');	
	self.disable("#detallePedido *");
	//self.enable("#inputReferenciaExiste");
	
	merlinwizard.plazas = new merlinwizard.Plazas();
	merlinwizard.tipospedido = new merlinwizard.TiposPedido();
	merlinwizard.estatus = new merlinwizard.Estatus();
	
	self.maskEl.mask("Cargando...");
	
	merlinwizard.plazas.fetch({ 
		success: function(){ 
			//self.render(); 
			self.maskEl.unmask(); 
			},
			error:function(){
				self.maskEl.unmask();				
			} 
			});	
	
	 merlinwizard.plazas.on('add', self.addPlaza, self);
	 merlinwizard.plazas.on('reset', self.resetPlazas, self);
	 merlinwizard.tipospedido.on('add', self.addTipoPedido, self);
	 merlinwizard.tipospedido.on('reset', self.resetTiposPedido, self);
	 
	 self.$('#referenexiste').filter_input({regex:'[0-9]'});
	 //faltan caracteres especiales: ~ ^
	 self.$('#inputDescPedido').filter_input({regex:'[^\$\*\[\\]\{\}\'\#\+\|\°\\\^]'});
	 
	// self.$('#inputDescPedido').filter_input({regex:'[^\w\s]/gi]'});
     //self.modelBinder = new Backbone.ModelBinder();
	
},/*
render: function( event ){
	var self = this;
	
	
	
},
/*
	var bindings = {*/
             /*'plaza': [
                 { 'selector': '#plazasCombo', converter: new Backbone.ModelBinder.CollectionConverter(merlinwizard.plazas).convert }
             ],*/
             //'id': '[name=id]',
             /*'referencia': '[name=referencia]',*/
             //'descripcion': '[name=descripcion]'//,
             /*'activo': '[name=activo]',
             'tipoPedido': [
                       { 'selector': '#tiposPedidoCombo', converter: new Backbone.ModelBinder.CollectionConverter(self.tipospedido).convert }
                   ],
             'estatus' : '[name=estatus]',
             'fechaPedido': '[name=fechapedido]'*/
/*         };
	
	self.modelBinder.bind(self.pedido, self.el, bindings);
	//self.modelBinder.bind(self.pedido, self.el);
	return self;
},*/
events: {
"click #agregarNuevo":"onAgregarNuevoClick",
//"click #guardarPedido":"onGuardarPedidoClick",
"click #buscarExistente":"onBuscarExistenteClick",
},
close: function(){ 
    this.modelBinder.unbind();
    this.collectionBinder.unbind();
    this.off();
    this.undelegateEvents();
    this.remove();
},
addPlaza: function(plaza){
	var view = new merlinwizard.ComboPlazasView({model: plaza});
	this.plazasCombo.append(view.render().el);
},
resetPlazas: function(plaza){
	this.plazasCombo.html('<option value="">--Seleccione plaza--</option>');
},
addTipoPedido: function(tipopedido){
	var view = new merlinwizard.ComboTiposPedidoView({model: tipopedido});
	this.tiposPedidoCombo.append(view.render().el);
},
resetTiposPedido: function(tipopedido){
	this.tiposPedidoCombo.html('<option value="1">PEDIDO CENTRALIZADO</option>');
},
disable: function(id){
	this.$(id).prop('disabled',true);
},
enable: function(id){
	this.$(id).prop('disabled',false);
},
clearAll:function(){
	
	paso1saved = false,
	paso2saved = false,
	paso3saved = false, 
	paso4saved = false, 
	paso5saved = false; 
	
	if(paso2view){
		paso2view.clear();
	}
	if(paso3view){
		paso3view.clear();
	}
	if(paso4view){
		paso4view.clear();
	}
	if(paso5view){
		paso5view.clear();
	}
},
onAgregarNuevoClick:function(e){
		pedidoExistente = false;
		paso2selected = false;
		paso3selected = false;
		
		var self = this;
		//self.clearAll();
		self.editMode = true;
		jQuery('#wizard3').smartWizard('hideMessage',"");
		jQuery('#wizard3').smartWizard('disableStep','2');
		jQuery('#wizard3').smartWizard('disableStep','3');
		jQuery('#wizard3').smartWizard('disableStep','4');
		jQuery('#wizard3').smartWizard('disableStep','5');
		jQuery('#wizard3').smartWizard('disableStep','6');
		//jQuery('#wizard3').smartWizard('disableStep','7');
		//jQuery('#wizard3').smartWizard('disableStep','8');
		jQuery('#wizard3').smartWizard('disableFinish','disabled');
		
		$("#detallePedido").css("display", "block");
		if (!paso1selected){
			$( ".buttonNext" ).toggleClass('buttonNext buttonDisabled buttonNext');
			paso1selected = true;
		}
		
		 self.enable("#detallePedido *");
		 self.disable("#tiposPedidoCombo");
		 self.disable("#inputEstatus");
		 self.disable("#inputReferencia");
		 $('#referenexiste').val('');
		 $('#inputReferencia').val('');
		 $('#inputDescPedido').val('');
		 document.getElementById("inputActivoPedido").checked = true;
		 self.plazasCombo.val('');
		 var $j = jQuery.noConflict();
		 var dfecAct = new Date();
		 var mesfecAct = dfecAct.getMonth() + 1;
		 var diafecAct = dfecAct.getDate() + 1;
		 var fecAct = diafecAct + '/' + mesfecAct + '/' + dfecAct.getFullYear();
		 $j('#divFechaPedido').datepicker('setValue', fecAct);
		 $('#inputFechaPedido').val($j('#divFechaPedido').data('date'));
		 	 
		 self.maskEl.mask("Cargando...");

		 self.tmppedidos = new merlinwizard.Pedidos();
		 self.tmppedidos.fetch({success: function(collection, response, options){  
				 var model = collection.models[0];
			  	//self.pedido.set(_.clone(model.attributes));

				 if(model){
	            	   	var pedidoBindings = 
            	   		{
            	   			id: '[name=id]',
            	   			referencia: '[name=referencia]'
            	   		};
	            	   	pedidoBinder = new Backbone.ModelBinder();
	            	   	pedidoBinder.bind(model, self.el, pedidoBindings);
            	   	
	            	   	var estatusBindings = {descripcion: '#inputEstatus', clave: '#inputEstatusClav'};
	            	   	estatusBinder = new Backbone.ModelBinder();
	            	   	estatusBinder.bind(model.get('estatus'), self.maskEl, estatusBindings);
            	   	
	            	   	/*var ref = model.get('referencia');
	            	   	$('#inputReferencia').val(ref);
	            	   	var id = model.get('id');
	            	   	$('#inputID').val(id);
	            	   	tmpest = new merlinwizard.Estatus();
	            	   	tmpest = model.get('estatus');
	            	   	$('#inputEstatus').val('NUEVO');
	            	   	$('#inputEstatusClav').val('CENT_NUEVO');*/
				 }
				 else
				 {
					 jQuery('#referencia').html('NO FUNCIONA');
				 }
				 //self.render();
				 self.maskEl.unmask();
				 merlinwizard.tipospedido.reset();
		 		}
			});
 },
onGuardarPedidoClick:function(e, callback){
	 	var self = this;
		//console.log(self);
		var id = $('#inputID').val();
		var activo=$("input[name='activo']").is(":checked");
		var ref = $('#inputReferencia').val();
		var desPlaza =self.plazasCombo.val();
		var descripcion = $('#inputDescPedido').val();
		var tipoPedido = self.tiposPedidoCombo.val();
		var estatus = $('#inputEstatusClav').val();
		var fechaPedido = $('#inputFechaPedido').val();
			 
		tmpplaza = new merlinwizard.Plaza();
		tmptipopedido = new merlinwizard.TipoPedido();
		tmpestatus = new merlinwizard.Estatus();
			 
		tmpplaza.set('id', desPlaza);
		tmptipopedido.set('id', tipoPedido);
		tmpestatus.set('clave', estatus);
		self.pedido.set('id', id);
			 
		self.pedido.set('referencia', ref);
		self.pedido.set('plaza', tmpplaza);
		self.pedido.set('descripcion',descripcion);
		self.pedido.set('tipoPedido', tmptipopedido);
		self.pedido.set('estatus', tmpestatus);
		self.pedido.set('activo', activo);
		self.pedido.set('fechaPedido', fechaPedido);
			 
		if(self.pedido.isValid()){
				 
			 self.maskEl.mask("Grabando...");
			 self.pedido.save(self.pedido.attributes,{
				 success:function(model, response, options){					 
					 self.editMode = false;
					 
					jQuery('#wizard3').smartWizard('showMessage','El pedido centralizado fue grabado con éxito.');
					 					  					
					jQuery('#pedidoActual').html(self.pedido.get('referencia'));
					if(callback){
						callback();
					}	
			 	},
			 	error:function(model, response, options){
				 self.maskEl.unmask();
				 jQuery('#wizard3').smartWizard('showMessage',response.statusText);
			 	}
			 });
			
		 }
   },
onBuscarExistenteClick:function(e){
		paso2selected = false;
		paso3selected =false;
		//var val = jQuery(e.target).val();
		var self = this;
		//self.clearAll();
		self.editMode = true;
		jQuery('#wizard3').smartWizard('hideMessage',"");
		self.enable("#detallePedido *");
		self.disable("#tiposPedidoCombo");
		self.disable("#inputEstatus");
		self.disable("#plazasCombo");
		self.disable("#inputReferencia");
		$('#inputReferencia').val('');
		
		self.maskEl.mask("Cargando...");
		 
		var referencia = self.pedido.get('referencia');
		if (!referencia)
		{
			referencia = $('#referenexiste').val();
		}
		$('#referenexiste').val('');
		
		var tmppedidos = new merlinwizard.Pedidos();
		tmppedidos.fetch({data: {'referencia': referencia, 'consulta':'GET_PED_CEN'}, success: function(collection, response, options)
			{  
	               var model = collection.models[0];
	               //var tmppedido = new merlinwizard.Pedido();
	               //tmppedido.set(_.clone(model.attributes));
	               
	               if(model){
	            	   pedidoExistente = true;
	            	   $("#detallePedido").css("display", "block");
	            	   if (!paso1selected){
	           				$( ".buttonNext" ).toggleClass('buttonNext buttonDisabled buttonNext');
	           				paso1selected = true;
	           			}
	            	   	var pedidoBindings = 
	            	   		{
	            	   			id: '[name=id]',
	            	   			referencia: '[name=referencia]', 
	            	   			descripcion: '[name=descripcion]',
	            	   			fechaPedido: '[name=fechapedido]',
	            	   			activo: '[name=activo]',
	            	   			plaza: [{'selector': '#plazasCombo', converter: new Backbone.ModelBinder.CollectionConverter(merlinwizard.plazas).convert }],
	            	   			tipoPedido: [{'selector': '#tiposPedidoCombo', converter: new Backbone.ModelBinder.CollectionConverter(merlinwizard.TiposPedido).convert }]
	            	   		};
	            	   	pedidoBinder = new Backbone.ModelBinder();
	            	   	pedidoBinder.bind(model, self.el, pedidoBindings);
	            	   	
	            	   	var estatusBindings = {descripcion: '#inputEstatus', clave: '#inputEstatusClav'};
	            	   	estatusBinder = new Backbone.ModelBinder();
	            	   	estatusBinder.bind(model.get('estatus'), self.maskEl, estatusBindings);
	            	   	
	            	   	//alert(model.get('estatus.clave'));
	            	   	//alert(model.get('plaza.id'));
	            	   	//alert(model.get('tipoPedido.id'));

						 /*				
						 if(model.get('activo')==true){
							 $("input[name='activo']").prop("checked", "checked"); 
						 }
						 else {
							 	$("input[name='activo']").prop("checked", ""); 
						 }*/
	               }
	               else
	               {
						 self.maskEl.unmask();
						 jQuery('#wizard3').smartWizard('showMessage','No existe el pedido capturado');
						 return;
	               }
	               //self.render();
	               self.maskEl.unmask();
	               merlinwizard.tipospedido.reset();
			}
		});
       }
   });

 
