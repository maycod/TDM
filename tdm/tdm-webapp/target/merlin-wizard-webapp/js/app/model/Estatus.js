merlinwizard.Estatus = Backbone.AssociatedModel.extend({	
idAttribute:"id",
url:contexto + "/estatus/",	
defaults:{
},
initialize: function(){
}
});


merlinwizard.TiposPedido = Backbone.Collection.extend({
	model:merlinwizard.Estatus,
	url:contexto + "/estatus/",
    initialize: function (model, options) {	
    }
});