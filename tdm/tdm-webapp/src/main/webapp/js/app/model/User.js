tdm.User = Backbone.AssociatedModel.extend({
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

tdm.Users = Backbone.Collection.extend({
	model:tdm.User,
	url:contexto + "/users/",
    initialize: function (model, options) {	
    }
});