merlinwizard.ComboCategoriasArtView = Backbone.View.extend({
tagName: 'option',
render: function(){
	 jQuery(this.el).attr('value',     this.model.get('id')).html(this.model.get('descripcion'));
		      
  return this; 
}
});