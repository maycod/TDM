tdm.UsersDetailView = Backbone.View.extend({	
	el : jQuery('#usersDiv'),
	grid : undefined,
	users : undefined,
	initialize : function(options) {
		var self = this;
		self.maskEl = self.$el;
		self.users = new tdm.Users();

		self.modelBinder = new Backbone.ModelBinder();
		_.bindAll(this, 'onGuardarClick', 'onEditarClick','createMask');
		self.loadUsersById();
		
	},
	render : function(event) {
		return this;
	},
	events : {
		"click #btnGuardar" : "onGuardarClick",
		"click #btnEditar" : "onEditarClick",
		
	},
	close : function() {
		this.modelBinder.unbind();
		this.collectionBinder.unbind();
		this.off();
		this.undelegateEvents();
		this.remove();
	},
	validateFields: function(){
		var self = this;
		
		var usernameAdm = $("#usernameAdm")[0].value;
		var usernameRegex = /^[a-zA-Z0-9\._]+$/;
		if (!usernameRegex.test(usernameAdm)){
			iosOverlay({
				text: "Nombre de Usuario Inv&aacute;lido.",
				duration: 2e3,
				icon: "../images/photos/dtchLogo125W.png"
			});
			return false;
		}
		return true;
	},
	onGuardarClick : function(e, callback) {
		var self = this;
		if (self.validateFields()){
			var mask = self.createMask("Guardando...");
			var user = new tdm.User();
			
			var idUserAdm = $("#idUser")[0].innerHTML; 
			var usernameAdm = $("#usernameAdm")[0].value; 
			var profileIdAdm = $("#profileDescAdm").val(); 
			var userDescAdm = $("#userDescAdm")[0].value; 
			var codenameAdm = $("#codenameAdm")[0].value; 
			var activeAdm = $("#activeAdm")[0]; 

			user.set('id', idUserAdm); 
			user.set('username', usernameAdm); 
			user.set('profileId', profileIdAdm);
			user.set('codename', codenameAdm); 
			user.set('userDesc', userDescAdm);
			user.set('active', activeAdm.checked);
			
			user.save(user.attributes,{
				 success:function(model, response, options){ 		
					 	iosOverlay({
							text: "Cambios Guardados.",
							duration: 2e3,
							icon: "../images/photos/dtchLogo125W.png"
						});
					 	mask.hide();
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
				var usernameUsr = $("#usernameUsr")[0];
				usernameUsr.innerHTML = data.username;
				var codenameUsr = $("#codenameUsr")[0];
				codenameUsr.innerHTML = data.codename;
				var userDescUsr = $("#userDescUsr")[0];
				userDescUsr.innerHTML = data.userDesc;
				var activeUsr = $("#activeUsr")[0];
				activeUsr.checked = data.active;
				var profileDescUsr = $("#profileDescUsr")[0];
				profileDescUsr.innerHTML = data.profileDesc;
				var creationDateUsr = $("#creationDateUsr")[0];
				creationDateUsr.innerHTML = data.creationDate;
				//Adm
				var data = collection.models[0].attributes;
				var usernameAdm = $("#usernameAdm")[0];
				usernameAdm.value = data.username;
				var codenameUsr = $("#codenameAdm")[0];
				codenameUsr.value = data.codename;
				var userDescUsr = $("#userDescAdm")[0];
				userDescUsr.value = data.userDesc;
				var activeUsr = $("#activeAdm")[0];
				activeUsr.checked = data.active;
				var profileDescAdm = $("#profileDescAdm");
				profileDescAdm.val(data.profileId);
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