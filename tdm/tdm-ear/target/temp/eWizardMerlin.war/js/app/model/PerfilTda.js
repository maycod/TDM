merlinwizard.PerfilTda = Backbone.AssociatedModel.extend({	
idAttribute:"id",
url:contexto + "/perfilesTda/", 
relations: [
{
}],	
defaults:{	
},
initialize: function(){
}
});


merlinwizard.PerfilesTda = Backbone.Collection.extend({
	model:merlinwizard.PerfilTda,
	url:contexto + "/perfilesTda/",
    initialize: function (model, options) {	
    }
});