merlinwizard.Paso3View = Backbone.View.extend({
el: jQuery('#wiz3step3'),
pedido:undefined,
grid:undefined,
gridAsig:undefined,
editMode:false,
categoriaArt:undefined,
initialize: function (options) {

	var self = this;
	self.maskEl = self.$el;
	
	
	merlinwizard.categoriasArt = new merlinwizard.CategoriasArt();
	self.articulo = new merlinwizard.Articulo();
	self.articulosDisp = new merlinwizard.Articulos();
	self.articulosAsig = new merlinwizard.Articulos();
	
	self.categoriasArtCombo = self.$('#categoriasArtCombo');
	
	//self.plaza = options.plaza;
	self.pedido = options.pedido;
	
		
	self.articulosDisp.on('beforerequest', function(data){		
		var arrayLength = data.length;
		for (var i = 0; i < arrayLength; i++) {
			data[i].plaza.id=self.pedido.get('plaza.id');
		}		
	});
	self.articulosAsig.on('beforerequest', function(data){		
		var arrayLength = data.length;
		for (var i = 0; i < arrayLength; i++) {
			data[i].plaza.id=self.pedido.get('plaza.id');
		}		
	});
	
	self.articulosDisp.on('sync', function(models){		
		self.maskEl.unmask();		 	
	});
	self.articulosAsig.on('sync', function(models){		
		self.maskEl.unmask();		 	
	});
	
		
	
	//self.enable("#gruposCfgCombo");
	self.enable("#detalleArticulo *");

	
	self.loadCategoriasArt();

		
	 merlinwizard.categoriasArt.on('add', this.addCategoriasArt, this);
	 merlinwizard.categoriasArt.on('reset', this.resetCategoriasArt, self);
     self.modelBinder = new Backbone.ModelBinder();
     
 	var columns = [ {
 	    name: "",
 		headerCell: Backgrid.Extension.SelectAllHeaderCell,
 		cell: Backgrid.Extension.SelectRowCell
 	  },{
 	 	name: "id",
 	 	label: "Id",
 	 	cell: "string",
 	 	editable: false,
 	 	renderable: false
 	  },
 	  {
	    name: "codigoBarras",
	    label: "Codigo Barras",
	    cell: "string",
	    editable: false
	  }, {
	    name: "descripcion",
	    label: "Descripcion",
	    cell: "string" ,
	    editable: false
	  },
	  {
		name: "cantidad",
		label: "Cantidad",
		cell: "integer",
		editable: false,
		renderable: false
		
	  }, 
	  {
		name: "cantidadCompra",
		label: "Cant. Compra",
		cell: "integer" ,
		renderable: false
	  }];
 	
 	var columnsAsig = [ {
 	    name: "",
 		headerCell: Backgrid.Extension.SelectAllHeaderCell,
 		cell: Backgrid.Extension.SelectRowCell
 	  },{
 		name: "id",
 		label: "Id",
 		cell: "string",
 		editable: false,
 		renderable: false
 	   },
 	   {
	    name: "codigoBarras",
	    label: "Codigo Barras",
	    cell: "string",
	    editable: false
	  }, {
	    name: "descripcion",
	    label: "Descripcion",
	    cell: "string" ,
	    editable: false
	  }, {
		 name: "cantidad",
		 label: "Cantidad",
		 cell: "integer" 
		  }, {
		 name: "cantidadCompra",
		 label: "Unidad Compra",
		 cell: "integer" ,
		 editable: false
	  }];
 	
 	var FocusableRow = Backgrid.Row.extend({
 		  highlightColor: "lightYellow",
 		  events: {
 		    focusin: "rowFocused",
 		    focusout: "rowLostFocus"
 		  },
 		  rowFocused: function() {
 		    this.el.style.backgroundColor = this.highlightColor;
 		  },
 		  rowLostFocus: function() {
 		    delete this.el.style.backgroundColor;
 		  }
 		});
 	
	self.grid = new Backgrid.Grid({
		  row: FocusableRow,
		  columns: columns,
		  collection: self.articulosDisp
		});
	
	self.gridAsig = new Backgrid.Grid({
		row: FocusableRow,
		  columns: columnsAsig,
		  collection: self.articulosAsig
		});
	
	 self.articulosAsig.on('backgrid:editing', function(a,b,c){
			 
			var cantidad = jQuery(".cantidad").children(":text");
			cantidad.attr("maxlength", 5);
			cantidad.filter_input({regex:'[0-9]'});
			
	});
 	
	var clientSideFilter = new Backgrid.Extension.LunrFilter({
		  collection:self.articulosDisp,
		  id: "frmBuscarArtPaso3",
		  name: "inputBuscarArtPaso3",
		  placeholder: "Buscar por descripcion",
		  // Campos en los cuales se realizara la busqueda y su vallor boost
		  fields: {
			    descripcion: 10
			  },
		  // lunr.js document key for indexing
		  ref: 'id',
		  wait: 150
		});

		$("#contenedorFiltrosPaso3").prepend(clientSideFilter.render().el);
	
         
},
render: function( event ){
	var self = this;
	
		
	self.$("#tablaArticulosDisp").append(self.grid.render().el);
	
	self.$("#tablaArticulosAsig").append(self.gridAsig.render().el);
	 $("#frmBuscarArtPaso3 :input").attr("maxlength",30);
	 //$("#frmBuscarArtPaso3 :input").filter_input({regex:'[a-zA-Z\\s0-9]'});
	 
//	// Initialize the paginator
//	var paginator = new Backgrid.Extension.Paginator({
//	  collection: self.articulosDisp
//	});
//
//	// Render the paginator
//	self.$("#tablaArticulosDisp").after(paginator.render().el);
	
	
	return this;
},
events: {
"change #categoriasArtCombo" :"onCategoriasArtComboChange",
"click #articuloadd" :"onArticuloAddClick",
"click #articulodel" :"onArticuloDelClick",
},
 close: function(){ 
     this.modelBinder.unbind();
     this.collectionBinder.unbind();
     this.off();
     this.undelegateEvents();
     this.remove();
 },
 
 addCategoriasArt: function(categoriaArt){
	  var view = new merlinwizard.ComboCategoriasArtView({model: categoriaArt});
	  this.categoriasArtCombo.append(view.render().el);
},
resetCategoriasArt: function(categoriasArt){
	
	this.categoriasArtCombo.html('');
	
},
onArticuloDelClick:function(e){
	var self = this;
	//var plazaId = self.pedido.get('plaza.id');		 
		 
	var selectedModels = self.gridAsig.getSelectedModels();	

	//var articulo = new merlinwizard.Articulo();
	 
		_.each(selectedModels, function (model) {
	        model.trigger("backgrid:select", model, false);
	        //model.set('id',model.get('id'));
	        
	        var CB = model.get('codigoBarras');
	        var Des = model.get('descripcion');
	        var idArt = model.get('id');
	        var cantCompra = model.get('cantidadCompra');
			var cant = model.get('cantidad');

	        self.grid.insertRow([ {
		         id:idArt,	 
 		         codigoBarras: CB,
 		         descripcion: Des,
 		         cantidad: cant,
		         cantidadCompra: cantCompra
 		         
			}]);
			
			var rowSelected = self.gridAsig.collection.where({ id: idArt });
			self.gridAsig.removeRow(rowSelected);
	        
//			 articulo.get('plaza').set('id', plazaId);
	         //articulo.set('idPlaza', plazaId);
			 //articulo.set('id', idArt);
			 //articulo.set('codigoBarras',model.get('codigoBarras'));
			 //articulo.set('descripcion',model.get('descripcion'));
			 //articulo.set('cantidad',cant);
			 //articulo.set('cantidadCompra', cantCompra);
			 
			 //model.destroy();
			 
			    $("#contadorAsig").empty();
				$("#contadorAsig").append("("+self.articulosAsig.length+")");
				$("#contadorDisp").empty();
				$("#contadorDisp").append("("+self.articulosDisp.length+")");

	     });
	
	 },
onArticuloAddClick:function(e){
	var self = this;
	//var plazaId = self.pedido.get('plaza.id');
		 
	var selectedModels = self.grid.getSelectedModels();
	
	//var articulo = new merlinwizard.Articulo();
	
	var CB;
	var Des;
	var idArt;
	var cantCompra;
	var cant;
	
	_.each(selectedModels, function (model) {
  
		CB = model.get('codigoBarras');
		Des = model.get('descripcion');
		idArt = model.get('id');
		cantCompra = model.get('cantidadCompra');
		cant = model.get('cantidad');
  
//	 articulo.get('plaza').set('id', plazaId);
		//articulo.set('idPlaza', plazaId);
		//articulo.set('id', idArt);
		//articulo.set('codigoBarras',model.get('codigoBarras'));
		//articulo.set('descripcion',model.get('descripcion'));
		//articulo.set('cantidad',cant);
		//articulo.set('cantidadCompra', cantCompra);
//	 alert("("+articulo.get('id')+"-"+articulo.get('descripcion')+"-"+articulo.get('codigoBarras')+"-"+articulo.get('idPlaza'));
  
	    self.gridAsig.insertRow([
		         		         {
		         		         id:idArt,	 
		         		         codigoBarras: CB,
		         		         descripcion: Des,
		         		         cantidad: cant,
		         		         cantidadCompra: cantCompra
		         		         }
		         		    ]);

		var rowSelected = self.grid.collection.where({ id: idArt });
		self.grid.removeRow(rowSelected);	    
	    
	    //model.destroy();
	    
	    $("#contadorAsig").empty();
		$("#contadorAsig").append("("+self.articulosAsig.length+")");
		$("#contadorDisp").empty();
		$("#contadorDisp").append("("+self.articulosDisp.length+")");
    
	});
		 		 
	 },

disable: function(id){
	this.$(id).prop('disabled',true);

},
enable: function(id){
	this.$(id).prop('disabled',false);

},
performFiltering : function(e){
	var self = this;
	var val = jQuery(e.target).val();
	  self.editMode = false;
	  if(val !== ''){
		  var tmpmodel = merlinwizard.categoriasArt.get(val); 
		  
		  var tmpcategoriasArt = new merlinwizard.CategoriasArt();
		  
		  var categoriaArt = new merlinwizard.CategoriaArt();
		  categoriaArt.set('id',tmpmodel.get('id'));
		  	  
		  self.maskEl.mask("Cargando Art&iacute;culos...");
		  
		  
		  self.articulosDisp.fetch({data: {'idPedido':self.pedido.get('id'), 'plaza.id':self.pedido.get('plaza.id'), 'categoriaArt.id': categoriaArt.get('id')}, 
							success:function(collection, response, options){
								$("#contadorDisp").empty();
								$("#contadorDisp").append("("+self.articulosDisp.length+")");
								
							},
							error:function(){
								self.maskEl.unmask();				
							}
						});	
		  $("#detalleArticulo").css("display", "block");
		  paso3selected =true;
	  }
},
 onCategoriasArtComboChange:function(e){
  
  var self = this;
  if (self.grid.getSelectedModels().length > 0 /*|| self.grid.getSelectedModels().length > 0*/ ){
		$jCustom.confirm({
			icon: 'fa fa-warning',
		    title: 'Confirmaci&oacute;n',
		    confirmButton: 'SI',
		    cancelButton: 'NO',
		    content: 'Existen Art&iacute;culos seleccionados. ¿Seguro que desea continuar?',
		    confirm: function(){
		    	self.performFiltering(e);
		    }
		});
	}else{
		self.performFiltering(e);
	}
  
  
  
 },
 onGuardarArticuloClick:function(e, callback){
 	var self = this;
 		 
	if (self.articulosAsig.length<=0){
		jQuery('#wizard3').smartWizard('showMessage','Agregue por lo menos un articulo..');
	
	}else {
		var articulo = new merlinwizard.Articulo();
		var tmp = new merlinwizard.Articulo();
 		var plazaId = self.pedido.get('plaza.id');
 		
		self.maskEl.mask("Grabando...");
		tmp.set('idPedido', self.pedido.get('id'));
		tmp.set('consulta', 'CLEAN_ARTICULOS');
		
		tmp.save(tmp.attributes, {
			success : function(model, response, options) {
				var errores = 0;

				self.gridAsig.collection.each(function (model, i) {
		 	        model.trigger("backgrid:select", model, true);
			    });
		 	   	var selectedModels = self.gridAsig.getSelectedModels();
		 	       _.each(selectedModels, function (model) {
		 	        //model.set('id',model.get('id'));
		 	        
		 	        CB = model.get('codigoBarras');
		 	        Des = model.get('descripcion');
		 	        idArt = model.get('id');
		 	        cantCompra = model.get('cantidadCompra');
		 	        cant = model.get('cantidad');
		 	        
		 	        articulo.set('idPedido', self.pedido.get('id'));
		 	        articulo.set('plaza', self.pedido.get('plaza'));
		 	        articulo.set('idPlaza', plazaId);
		 			articulo.set('id', idArt);
		 			articulo.set('codigoBarras', model.get('codigoBarras'));
		 			articulo.set('descripcion', model.get('descripcion'));
		 			articulo.set('cantidad', cant);
		 			articulo.set('cantidadCompra', cantCompra); 			 
		 	        
		 			articulo.save(articulo.attributes,{
		 				 success:function(model, response, options){ },
		 			 	 error:function(model, response, options){
		 			 		errores = errores + 1;
		 			 	}
		 			 }); 
			    });
			
				if (errores > 0){
					self.maskEl.unmask();
					jQuery('#wizard3').smartWizard('showMessage',
					'Hubo un error al momento de guardar los cambios, intente de nuevo.');
				}
				else{				
					var tmpFin = new merlinwizard.Articulo();

					tmpFin.set('idPedido', self.pedido.get('id'));
					tmpFin.set('consulta', 'POST_ARTICULOS');
					
					tmpFin.save(tmpFin.attributes, {success : function(model, response, options) {
						self.maskEl.unmask();
						jQuery('#wizard3').smartWizard('showMessage',
						'Los articulos fueron grabados con exito.');
						if (callback) {
							callback();
						}
					}, error : function(model, response, options) {
						self.maskEl.unmask();
						jQuery('#wizard3').smartWizard('showMessage',
						'Hubo un error al momento de guardar los cambios, intente de nuevo.');
					}
					});
				}
			},
			error : function(model, response, options) {
				self.maskEl.unmask();
				jQuery('#wizard3').smartWizard('showMessage',
				'Hubo un error al momento de guardar los cambios, intente de nuevo.');
			}
		});
	} 	     
 },

loadCategoriasArt:function(){
	if (!pedidoExistente && !paso3selected){
		$("#detalleArticulo").css("display", "none");
	}else{
		$("#detalleArticulo").css("display", "block");
	}
	var self = this;
		
//	merlinwizard.categoriasArt.reset();
	self.maskEl.mask("Cargando Categor&iacute;as...");
	merlinwizard.categoriasArt.fetch({
		success: function(){ 
			self.maskEl.unmask();
			self.maskEl.mask("Cargando Art&iacute;culos...");
			self.articulosAsig.fetch({
				data: {'idPedido': self.pedido.get('id'),'consulta':'A1'}, 
				success:function(collection, response, options){
					self.maskEl.unmask();
					$("#contadorAsig").empty();
					$("#contadorAsig").append("("+self.articulosAsig.length+")");
					self.render() ;
				},
				error:function(){
					self.maskEl.unmask();				
				}
			});
		} 
	});
},
clear:function(){
	var self = this;
//	self.categoriasArt.clear();
	merlinwizard.categoriasArt.reset();
	self.articulosDisp.reset();
	$("#contadorDisp").empty();
	$("#contadorDisp").append("("+self.articulosDisp.length+")");
	self.gridAsig.clearSelectedModels();
	self.render() ;
}
	  
});