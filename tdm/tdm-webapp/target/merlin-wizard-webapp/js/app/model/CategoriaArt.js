merlinwizard.CategoriaArt = Backbone.AssociatedModel.extend({	
idAttribute:"id",
url:contexto + "/categoriasArt/", 
relations: [
{
}],	
defaults:{
},
initialize: function(){
}

});


merlinwizard.CategoriasArt = Backbone.Collection.extend({
	model:merlinwizard.CategoriaArt,
	url:contexto + "/categoriasArt/",
    initialize: function (model, options) {	
    }
});