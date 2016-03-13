merlinwizard.Articulo = Backbone.AssociatedModel.extend({
//merlinwizard.Articulo = Backbone.PageableCollection.extend({
relations: [
            {
                type: Backbone.One, 
                key: 'categoriaArt', 
                relatedModel: 'merlinwizard.CategoriaArt' 
            },
            {
                type: Backbone.One,
                key: 'plaza',
                relatedModel: 'merlinwizard.Plaza' 
            }

        ],
url:contexto + "/articulos/",
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


merlinwizard.Articulos = Backbone.BatchCollection.extend({
	model:merlinwizard.Articulo,
	url:contexto + "/articulos/",
	state: {
	    pageSize: 15
	  },
    initialize: function (model, options) {	
    }
});