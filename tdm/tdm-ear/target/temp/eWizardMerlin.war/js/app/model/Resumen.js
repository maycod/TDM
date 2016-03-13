merlinwizard.Resumen = Backbone.AssociatedModel.extend({	
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
url:contexto + "/resumenes/", 	
defaults:{
},
initialize: function(){
}
});


merlinwizard.Resumenes = Backbone.BatchCollection.extend({
	model:merlinwizard.Resumen,
	url:contexto + "/resumenes/",
    initialize: function (model, options) {	
    }
});