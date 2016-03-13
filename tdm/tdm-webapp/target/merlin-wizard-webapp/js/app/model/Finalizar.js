merlinwizard.Finalizar = Backbone.AssociatedModel.extend({	
idAttribute:"id",
url:contexto + "/finalizar/",	
defaults:{
},
initialize: function(){
}
});


merlinwizard.Finalizars = Backbone.BatchCollection.extend({
	model:merlinwizard.Finalizar,
	url:contexto + "/finalizar/",
    initialize: function (model, options) {	
    }
});