merlinwizard.Excepcion = Backbone.AssociatedModel.extend({	
idAttribute:"id",
url:contexto + "/excepcion/", 	
defaults:{
},
initialize: function(){
}

});

merlinwizard.Excepcions = Backbone.BatchCollection.extend({
	model:merlinwizard.Excepcion,
	url:contexto + "/excepcion/",
    initialize: function (model, options) {	
    }
});