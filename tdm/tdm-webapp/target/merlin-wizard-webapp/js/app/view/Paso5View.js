merlinwizard.Paso5View = Backbone.View.extend({
el: jQuery('#wiz3step5'),
pedido:undefined,
articulo:undefined,
grid:undefined,
editMode:false,
initialize: function (options) {

	var self = this;
	self.maskEl = self.$el;
	
	self.pedido = options.pedido;
	self.articulo = options.articulo;
	self.articulos = new merlinwizard.Articulos();
	
	self.articulos.on('beforerequest', function(data){		
		var arrayLength = data.length;
		for (var i = 0; i < arrayLength; i++) {
			data[i].plaza.id=self.pedido.get('plaza.id');
		}		
	});
	
	self.articulos.on('sync', function(models){		
		self.maskEl.unmask();		 	
	});
	
	self.enable("#detalleArticulo *");
	
	self.maskEl.mask("Cargando...");
	
	self.loadArticulos();
	
	self.modelBinder = new Backbone.ModelBinder();
    
 	var columns = [ {
	    name: "codigoBarras",
	    label: "Codigo Barras",
	    cell: "string",
	    editable: false
	  }, {
		name: "id",
		label: "Articulo",
		cell: "string" ,
		editable: false
	  }, {
	    name: "descripcion",
	    label: "Descripcion",
	    cell: "string" ,
	    editable: false
	  }, {
		name: "cantidad",
		label: "Cantidad Default",
		cell: "integer" ,
		editable: false
	  }, {
		name: "cantidadCompra",
		label: "Unidad de Compra",
		cell: "integer" ,
		editable: false
	  }, {
		name: "cantidadTotal",
		label: "Piezas Totales",
		cell: "integer" ,
		editable: false
	  }, {
		name: "cantidadTope",
		label: "Piezas por Pedido",
		cell: "integer",
		editable: true,
		maxlength: 10
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
		  collection: self.articulos
		  
	});
 		 self.articulos.on('backgrid:editing', function(a,b,c){
 			var articulo = jQuery(".cantidadTope").children(":text");
			articulo.attr("maxlength", 5);
			articulo.filter_input({regex:'[0-9]'});	  
 		}
	);
},
render: function( event ){
	var self = this;
	
	self.$("#tablaArticulos").append(self.grid.render().el);
	
	return this;
},
close: function(){ 
    this.modelBinder.unbind();
    this.collectionBinder.unbind();
    this.off();
    this.undelegateEvents();
    this.remove();
},
disable: function(id){
	this.$(id).prop('disabled',true);
},
enable: function(id){
	this.$(id).prop('disabled',false);
},
loadArticulos:function(){
	 var self = this;

	 //self.maskEl.unmask();
	 self.maskEl.mask("Cargando...");

		self.articulos.fetch({
			data: {'idPedido': self.pedido.get('id'),'consulta':'SP_GET_ARTICULOS_TOPE'}, 
			success:function(collection, response, options){
				self.render(); 
				self.maskEl.unmask();	
			},
			error:function(){
				self.maskEl.unmask();				
			}
		});
},
onGuardarArticuloClick:function(e, callback){
 	var self = this;
 	var cont = 0;
 	var nomultiplo=0;
	    self.grid.collection.each(function (model, i) {
 	        model.trigger("backgrid:select", model, true);
 	        model.set('consulta', 'SP_GUARDAR_PED_CENT_ARTIC_TOPE');
 	        
 	        if (model.get('cantidadTope')>(parseInt(model.get('cantidad'))*parseInt(model.get('cantidadCompra')))){
 	        	cont=cont+1; 	        	
 	        }
 	        	
 	        var resultado= (parseInt(model.get('cantidadTope'))%parseInt(model.get('cantidadCompra')));
 	          if (resultado!=0){
 	    	      nomultiplo =1;  
	         }
	       
	    });
	    
	    if (cont>0 ||nomultiplo==1 ){
	    	if (cont>0){
	    		jQuery('#wizard3').smartWizard('showMessage','Las Piezas por Pedido no pueden ser mayor que la Cantidad Default.');
	    	}else 
	    		if(nomultiplo==1){
	    			jQuery('#wizard3').smartWizard('showMessage','Las Piezas por Pedido deben ser multiplo de la Cantidad Default.'); 
	    		}
	    }
	    else{
	    
	    self.maskEl.mask("Grabando...");
	    
	    var errores = 0;
	    self.articulos.save({
				success:function(model, response, options){		
			 	},
			 	error:function(model, response, options){
			 		errores = errores + 1;
			 	}
			 });
	    	self.maskEl.unmask();
	    	if (errores > 0){
	    		jQuery('#wizard3').smartWizard('showMessage','Hubo un error al momento de guardar los cambios, intente de nuevo.');
	    	}else{
	    		jQuery('#wizard3').smartWizard('showMessage','Las cantidades pedidas fueron grabadas con �xito.');
	    		if(callback){
	    			callback();
	    		}
	    	}
	    }
 }
});
