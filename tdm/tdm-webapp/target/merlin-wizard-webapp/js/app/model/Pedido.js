merlinwizard.Pedido = Backbone.AssociatedModel.extend({
	relations: [
	            {
	                type: Backbone.One, 
	                key: 'estatus', 
	                relatedModel: 'merlinwizard.Estatus' 
	            },
	            {
	                type: Backbone.One, 
	                key: 'plaza', 
	                relatedModel: 'merlinwizard.Plaza' 
	            },
	            {
	                type: Backbone.One, 
	                key: 'tipoPedido', 
	                relatedModel: 'merlinwizard.TipoPedido' 
	            }
	        ],
	idAttribute:"id",
url:contexto + "/pedidos/",
defaults:{
},	
initialize: function(){
},
validate: function(attribs){

		var inputRefVal = $("#inputReferencia").val()
		if (inputRefVal === ""){
			return {field:"inputReferencia", msg:"Seleccione un pedido Nuevo o introduzca uno Existente."};
			//return null;
		}
		if(attribs.descripcion === undefined || attribs.descripcion === "" ){
			return {field:"descripcion", msg:"Capture una descripci&oacute;n"};
		}
		else
			if(attribs.fechaPedido === undefined || attribs.fechaPedido === ""){
				return {field:"fechaPedido", msg:"Capture la fecha del pedido"};
			}
			else{
				var fec = attribs.fechaPedido.split("/");
				var dfec = new Date(fec[2], fec[1]-1, fec[0]);
				var dfecNow = new Date();
				if(dfec < dfecNow){
					return {field:"fechaPedido", msg:"La fecha del pedido debe ser mayor a la fecha actual"};
				}
				else
					if(attribs.plaza === undefined || attribs.plaza.id === ""){
						return {field:"plaza", msg:"Capture la plaza"};
					}
			}
	}
});

merlinwizard.Pedidos = Backbone.Collection.extend({
	model:merlinwizard.Pedido,
	url:contexto + "/pedidos/",
    initialize: function (model, options) {	
    }
});