tdm.UserAddView = Backbone.View.extend({	
	el : jQuery('#usersDiv'),
	grid : undefined,
	users : undefined,
	initialize : function(options) {
		var self = this;
		self.users = new tdm.Users();

		self.modelBinder = new Backbone.ModelBinder();
		_.bindAll(this, 'onGuardarClick', 'onEditarClick');
		
	},
	render : function(event) {
		return this;
	},
	events : {
		"click #btnGuardar" : "onGuardarClick"		
	},
	close : function() {
		this.modelBinder.unbind();
		this.collectionBinder.unbind();
		this.off();
		this.undelegateEvents();
		this.remove();
	},
	validate: function(username,userDesc, codename){
		var self = this;
		
		var usernameRegex = /^[a-zA-Z0-9\._]+$/;
		if (!usernameRegex.test(username)){
			iosOverlay({
				text: " Formato de Clave de Usuario Inv&aacute;lido.",
				duration: 2e3,
				icon: "../images/photos/dtchLogo125W.png"
			});
			return false;
		}
		
		var userDescRegex = /^[^+]{1,100}$/;
		if (!userDescRegex.test(userDesc)){
			iosOverlay({
				text: "Formato de Nombre de Usuario Inv&aacute;lido.",
				duration: 2e3,
				icon: "../images/photos/dtchLogo125W.png"
			});
			return false;
		}
		var codenameRegex = /^[^+]{1,10}$/;
		if (!codenameRegex.test(codename)){
			iosOverlay({
				text: "Formato de C&oacute;digo de Usuario Inv&aacute;lido.",
				duration: 2e3,
				icon: "../images/photos/dtchLogo125W.png"
			});
			return false;
		}
		return true;
	},
	onGuardarClick : function(e, callback) {
		var self = this;
		var idUserAdm =0; 
		var usernameAdm = $("#usernameAdm")[0].value; 
		var profileIdAdm = $("#profileDescAdm").val(); 
		var userDescAdm = $("#userDescAdm")[0].value; 
		var codenameAdm = $("#codenameAdm")[0].value; 
		var activeAdm = $("#activeAdm")[0]; 
		if (self.validate(usernameAdm,userDescAdm, codenameAdm )){
			var mask=self.createMask("Guardando...");
			var user = new tdm.User();
			
			user.set('id', idUserAdm); 
			user.set('username', usernameAdm); 
			user.set('profileId', profileIdAdm);
			user.set('codename', codenameAdm); 
			user.set('userDesc', userDescAdm);
			user.set('active', activeAdm.checked);
			
			
			user.save(user.attributes,{
				 success:function(model, response, options){ 			
					 	mask.hide();
					 	iosOverlay({
							text: "Cambios Guardados.",
							duration: 2e3,
							icon: "../images/photos/dtchLogo125W.png"
						});
					 	window.location="usuarios.jsp";
				 	}, error : function(model, response, options) {
				 		mask.hide();
						iosOverlay({
							text: "Error en operaci&oacute;n.",
							duration: 2e3,
							icon: "../images/photos/dtchLogo125W.png"
						});
				 	}
				});
		}
		
	},
	onEditarClick : function(e, callback) {
		var self = this;
		var mask = self.createMask("Cargando...");
		var normalView = $("#detailInfoDivUsr");
		var editarView = $("#detailInfoDivAdm");
		
		normalView.css("display", "none");
		editarView.css("display", "block");
		mask.hide();
	},
	loadUsersById : function() {
		var self = this;
		var mask = self.createMask("Cargando...");
		var idUserLbl = $("#idUser");
		var idUserStr = idUserLbl[0].innerHTML;
		var idUserInt = parseInt(idUserStr);
		self.users.fetch({
			data : {
				'consulta' : 'C1',
				'id':idUserInt
			},
			success : function(collection, response, options) {
				//Usr
				var data = collection.models[0].attributes;
				var userNumberUsr = $("#userNumberUsr")[0];
				userNumberUsr.innerHTML = data.userNumber;
				var lastNameUsr = $("#lastNameUsr")[0];
				lastNameUsr.innerHTML = data.lastName;
				var firstNameUsr = $("#firstNameUsr")[0];
				firstNameUsr.innerHTML = data.firstName;
				var bachelorUsr = $("#bachelorUsr")[0];
				bachelorUsr.innerHTML = data.bachelor;
				var emailUsr = $("#emailUsr")[0];
				emailUsr.innerHTML = data.email;
				var phoneNumberUsr = $("#phoneNumberUsr")[0];
				phoneNumberUsr.innerHTML = data.phoneNumber;
				var commentsUsr = $("#commentsUsr")[0];
				commentsUsr.innerHTML = data.comments;
				//Adm
				var data = collection.models[0].attributes;
				var userNumberAdm = $("#userNumberAdm")[0];
				userNumberAdm.value = data.userNumber;
				var lastNameAdm = $("#lastNameAdm")[0];
				lastNameAdm.value = data.lastName;
				var firstNameAdm = $("#firstNameAdm")[0];
				firstNameAdm.value = data.firstName;
				var bachelorAdm = $("#bachelorAdm")[0];
				bachelorAdm.value = data.bachelor;
				var emailAdm = $("#emailAdm")[0];
				emailAdm.value = data.email;
				var phoneNumberAdm = $("#phoneNumberAdm")[0];
				phoneNumberAdm.value = data.phoneNumber;
				var commentsAdm = $("#commentsAdm")[0];
				commentsAdm.innerHTML = data.comments;
				self.render();
				mask.hide();
				
			},
			error : function() {
				mask.hide();
				console.log("Error while loading Users");
			}
		});
		
		
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
	clear : function() {
		var self = this;

	},
	
});