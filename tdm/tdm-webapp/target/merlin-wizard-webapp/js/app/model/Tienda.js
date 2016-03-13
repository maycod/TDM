merlinwizard.Tienda = Backbone.AssociatedModel.extend({
relations: [
            {
                type: Backbone.One,
                key: 'plaza',
                relatedModel: 'merlinwizard.Plaza' 
            }
        ],
url:contexto + "/tiendas/",
defaults:{
},	
initialize: function(){
},
state: {
    pageSize: 15
},
validate: function(attribs){
}

});


merlinwizard.Tiendas = Backbone.BatchCollection.extend({
	model:merlinwizard.Tienda,
	url:contexto + "/tiendas/",
	state: {
	    pageSize: 15
	  },
    initialize: function (model, options) {	
    }
});