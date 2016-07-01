tdm.LoginView = Backbone.View.extend({
	el : $('#wrapper'),
	initialize : function(options) {
		var self = this;
		self.maskEl = self.$el;
		self.modelBinder = new Backbone.ModelBinder();
		_.bindAll(this, 'onLoginClick','onErrorMsg');
		$('input').keyup(function(e){
			if(e.keyCode == 13){
				$(this).trigger('enter');
			}
		});
		self.onErrorMsg();

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
	onErrorMsg : function() {
		var self = this;
		var errorMsgLbl = $("#errorMsgLbl")[0];
		var errorMsg = errorMsgLbl.innerHTML;
		if (errorMsg != null){
			if (errorMsg != ""){
				setTimeout(function() {
					iosOverlay({
						text: errorMsg,
						duration: 3e3,
						icon: "images/photos/dtchLogo125W.png"
					});
				}, 1500);
			}
			

		}
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
			var mask = self.createMask("Cargando...");
		}

	},
	createMask : function(message){
		self = this;
		var opts = {
			lines: 13, // The number of lines to draw
			length: 11, // The length of each line
			width: 5, // The line thickness
			radius: 17, // The radius of the inner circle
			corners: 1, // Corner roundness (0..1)
			rotate: 0, // The rotation offset
			color: '#FFF', // #rgb or #rrggbb
			speed: 1, // Rounds per second
			trail: 60, // Afterglow percentage
			shadow: false, // Whether to render a shadow
			hwaccel: false, // Whether to use hardware acceleration
			className: 'spinner', // The CSS class to assign to the spinner
			zIndex: 2e9, // The z-index (defaults to 2000000000)
			top: 'auto', // Top position relative to parent in px
			left: 'auto' // Left position relative to parent in px
		};
		var target = document.createElement("div");
		document.body.appendChild(target);
		var spinner = new Spinner(opts).spin(target);
		var mask=iosOverlay({
			text: message,
			spinner: spinner
		});
		return mask;
	},
	clear : function(cname) {
		var self = this;

	},

});