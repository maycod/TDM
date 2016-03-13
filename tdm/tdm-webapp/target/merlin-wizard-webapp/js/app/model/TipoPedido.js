merlinwizard.TipoPedido = Backbone.AssociatedModel.extend({	
idAttribute:"id",
url:contexto + "/tipoPedido/",	
defaults:{
},
initialize: function(){
}
});


merlinwizard.TiposPedido = Backbone.Collection.extend({
	model:merlinwizard.TipoPedido,
	url:contexto + "/tipoPedido/",
    initialize: function (model, options) {	
    }
});