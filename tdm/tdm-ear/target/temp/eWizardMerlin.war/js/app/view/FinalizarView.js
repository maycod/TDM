merlinwizard.FinalizarView = Backbone.View.extend({
el: jQuery('#wiz3resumen'),
pedido:undefined,
initialize: function (options) {

	var self = this;
	self.maskEl = self.$el;
	
	self.pedido = options.pedido;
	self.finalizar = new merlinwizard.Finalizar();
	  
    self.loadFinalizar();     
},
render: function( event ){	
},
close: function(){ 
     this.modelBinder.unbind();
     this.collectionBinder.unbind();
     this.off();
     this.undelegateEvents();
     this.remove();
},
loadFinalizar:function(){
	var self = this;
	self.maskEl.mask("Grabando...");
	self.finalizar.set('id', self.pedido.get('id'));
	//self.finalizar.save({data: {'id': self.pedido.get('id')}});
	self.finalizar.save(self.finalizar.attributes);
	
	self.maskEl.unmask();
}
});