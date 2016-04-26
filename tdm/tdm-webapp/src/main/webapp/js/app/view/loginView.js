tdm.LoginView = Backbone.View.extend({
	el : $('#wrapper'),
	initialize : function(options) {
		var self = this;
		self.maskEl = self.$el;
		self.modelBinder = new Backbone.ModelBinder();
		_.bindAll(this, 'onLoginClick');
		$('input').keyup(function(e){
			if(e.keyCode == 13){
				$(this).trigger('enter');
			}
		});

	},
	render : function(event) {
		return this;
	},
	events : {
		"submit" : "onLoginClick",
		"enter #inputUsername": "onLoginClick",
		"enter #inputPassword": "onLoginClick",
	},
	close : function() {
		this.modelBinder.unbind();
		this.collectionBinder.unbind();
		this.off();
		this.undelegateEvents();
		this.remove();
	},

	validate : function(username,password) {
		var usernameRegex = /^[a-zA-Z0-9\._]+$/;
		if (!usernameRegex.test(username)){
			iosOverlay({
				text: "Nombre de Usuario Invalido.",
				duration: 2e3,
				icon: "images/photos/dtchLogo125W.png"
			});
			return false;
		}
		var passwordRegex = /^[^+]{1,20}$/;
		if (!passwordRegex.test(password)){
			iosOverlay({
				text: "Formato de Contrasena Invalido.",
				duration: 2e3,
				icon: "images/photos/dtchLogo125W.png"
			});
			return false;
		}
		return true;
	},
	onLoginClick : function(e,callback) {
		var self = this;
		var username = $("#inputUsername").val();
		var password = $("#inputPassword").val();
		if(!self.validate(username,password)){
			e.preventDefault(); 
		}else{
			iosOverlay({
				text: "Bienvenido!",
				duration: 2e3,
				icon: "images/photos/dtchLogo125W.png"
			});
		}

	},
	clear : function(cname) {
		var self = this;

	},

});