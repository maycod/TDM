merlinwizard.Mercado = Backbone.AssociatedModel.extend({
relations: [
            {
                type: Backbone.One,
                key: 'plaza',
                relatedModel: 'merlinwizard.Plaza' 
            }
        ],
url:contexto + "/mercados/",
defaults:{
},	
initialize: function(){
},
validate: function(attribs){
}
});


merlinwizard.Mercados = Backbone.BatchCollection.extend({
	model:merlinwizard.Mercado,
	url:contexto + "/mercados/",
    initialize: function (model, options) {	
    }
});