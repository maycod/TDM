merlinwizard.User = Backbone.AssociatedModel.extend({
	relations: [
	],	
idAttribute:"_id",
url:contexto + "/users/",
defaults:{
},	
initialize: function(){
},
validate: function(attribs){
}

});

merlinwizard.Users = Backbone.Collection.extend({
	model:merlinwizard.User,
	url:contexto + "/users/",
    initialize: function (model, options) {	
    }
});