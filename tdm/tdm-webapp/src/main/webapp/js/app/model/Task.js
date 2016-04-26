tdm.Task = Backbone.AssociatedModel.extend({
	relations: [
	],	
idAttribute:"_id",
url:contexto + "/tasks/",
defaults:{
},	
initialize: function(){
},
validate: function(attribs){
}

});

tdm.Tasks = Backbone.Collection.extend({
	model:tdm.Task,
	url:contexto + "/tasks/",
    initialize: function (model, options) {	
    }
});