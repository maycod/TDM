merlinwizard.Plaza = Backbone.AssociatedModel.extend({
	relations: [
	],	
	idAttribute:"id",
url:contexto + "/plazas/",
defaults:{
},	
initialize: function(){
},
validate: function(attribs){
}

});

merlinwizard.Plazas = Backbone.Collection.extend({
	model:merlinwizard.Plaza,
	url:contexto + "/plazas/",
    initialize: function (model, options) {	
    }
});