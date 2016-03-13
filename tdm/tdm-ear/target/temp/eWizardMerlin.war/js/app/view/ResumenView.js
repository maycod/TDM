merlinwizard.ResumenView = Backbone.View.extend({
el: jQuery('#wiz3step6'),	
pedido:undefined,
grid:undefined,
initialize: function (options) {
	
	var self = this;
	self.maskEl = self.$el;
	
	self.pedido = options.pedido;
	
	self.resumenes = new merlinwizard.Resumenes();
	
	self.loadResumen();

},
loadResumen:function(){
	var self = this;
		self.maskEl.mask("Cargando...");
		var id = self.pedido.get('id');
		
		self.resumenes.fetch({data: {'id': id}, success: function(collection, response, options){  
	         var resumen = collection.models[0];

	         if(resumen){
	     	   	var pedidoBindings = 
		   		{
		   			referencia: '#resumenreferencia', 
		   			descripcion: '#resumendescripcion',
		   			fechaPedido: '#resumenfechapedido',
		   			tiendas: '#resumentiendas',
		   			articulos: '#resumenarticulos'
		   		};
	     	   	pedidoBinder = new Backbone.ModelBinder();
	     	   	pedidoBinder.bind(resumen, self.el, pedidoBindings);
	     	   	var estatusBindings = {descripcion: '#resumenestatus'};
	     	   	estatusBinder = new Backbone.ModelBinder();
	     	   	estatusBinder.bind(resumen.get('estatus'), self.maskEl, estatusBindings);
	     	   	
	     	    var plazaBindings = {descripcion: '#resumenplaza'};
	    	   	plazaBinder = new Backbone.ModelBinder();
	    	   	plazaBinder.bind(resumen.get('plaza'), self.maskEl, plazaBindings);
	    	   	
	    	   	var tipopedidoBindings = {descripcion: '#resumentipopedido'};
	    	   	tipopedidoBinder = new Backbone.ModelBinder();
	    	   	tipopedidoBinder.bind(resumen.get('tipoPedido'), self.maskEl, tipopedidoBindings);
	     	   	
				/*	 var ref = resumen.get('folio');
					 var plaza = resumen.get('plaza');
					 var descripcion = resumen.get('descripcion');
					 var tiendas = resumen.get('tiendas');
					 jQuery('#referencia').html(ref);
					 jQuery('#plaza').html(plaza);
					 jQuery('#descripcion').html(descripcion);
					 jQuery('#tiendas').html(tiendas);
					 jQuery('#referencia').html(ref);
					 jQuery('#referencia').html(ref);
				*/	 
	         }
			 self.maskEl.unmask();
			},
			error:function(){
				self.maskEl.unmask();				
			}
		});
}
});