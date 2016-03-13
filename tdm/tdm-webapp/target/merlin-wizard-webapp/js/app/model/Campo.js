merlinwizard.Campo = Backbone.AssociatedModel.extend({
relations: [
            {
                type: Backbone.One,
                key: 'mercado',
                relatedModel: 'merlinwizard.Mercado' 
            }
        ],
url:contexto + "/campos/",
defaults:{
},	
initialize: function(){
},
validate: function(attribs){
}

});


merlinwizard.Campos = Backbone.BatchCollection.extend({
	model:merlinwizard.Campo,
	url:contexto + "/campos/",
    initialize: function (model, options) {	
    }
});