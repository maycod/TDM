merlinwizard.ChangePasswordView = Backbone.View.extend({	
	el : jQuery('#wrapper'),
	grid : undefined,
	users : undefined,
	initialize : function(options) {
		var self = this;
		self.maskEl = self.$el;

		self.users = new merlinwizard.Users();
		self.modelBinder = new Backbone.ModelBinder();
		_.bindAll(this, 'onCambiarClick');
		
	},
	render : function(event) {
		return this;
	},
	events : {
		"click #btnCambiar" : "onCambiarClick"		
	},
	close : function() {
		this.modelBinder.unbind();
		this.collectionBinder.unbind();
		this.off();
		this.undelegateEvents();
		this.remove();
	},
	onCambiarClick : function(e, callback) {
		var self = this;
		self.maskEl.mask("Guardando...");
		var user = new merlinwizard.User();
		
		var password1 = $("#pwd")[0].value; 
		var password2 = $("#pwd")[0].value;
		var username = $("#username")[0].innerHTML;
		if (password1 == password2){
			self.users.fetch({
				data : {
					'consulta' : 'C3',
					'username':username,
					'password':password1
				},
				success : function(collection, response, options) {
					self.maskEl.unmask();
					window.location="index.jsp";
				},
				error : function() {
					self.maskEl.unmask();
					console.log("Error while loading Users");
				}
			});
		}else{
			alert("Las credenciales no coinciden. Favor de intentar nuevamente.")
		}

		
	},
	clear : function() {
		var self = this;

	},
	
});