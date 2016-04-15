tdm.UserAddView = Backbone.View.extend({	
	el : jQuery('#usersDiv'),
	grid : undefined,
	users : undefined,
	initialize : function(options) {
		var self = this;
		self.maskEl = self.$el;
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
	validateFields: function(){
		var self = this;
		
		var usernameAdm = $("#usernameAdm")[0].value;
		var usernameRegex = /^[a-zA-Z0-9\._]+$/;
		if (!usernameRegex.test(usernameAdm)){
			iosOverlay({
				text: "Nombre de Usuario Inv&aacute;lido.",
				duration: 2e3,
				icon: "../images/photos/logo43.png"
			});
			return false;
		}
		return true;
	},
	onGuardarClick : function(e, callback) {
		var self = this;
		if (self.validateFields()){
			self.maskEl.mask("Guardando...");
			var user = new tdm.User();
			
			var idUserAdm =0; 
			var usernameAdm = $("#usernameAdm")[0].value; 
			var profileIdAdm = $("#profileDescAdm").val(); 
			
			user.set('id', idUserAdm); 
			user.set('username', usernameAdm); 
			user.set('profileId', profileIdAdm); 
			
			user.save(user.attributes,{
				 success:function(model, response, options){ 			
					 	self.maskEl.unmask();
					 	iosOverlay({
							text: "Cambios Guardados.",
							duration: 2e3,
							icon: "../images/photos/logo43.png"
						});
					 	window.location="usuarios.jsp";
				 	}, error : function(model, response, options) {
						self.maskEl.unmask();
						iosOverlay({
							text: "Error en operaci&oacute;n.",
							duration: 2e3,
							icon: "../images/photos/logo43.png"
						});
				 	}
				});
		}
		
	},
	onEditarClick : function(e, callback) {
		var self = this;
		self.maskEl.mask("Cargando...");
		self.maskEl.unmask();
		var normalView = $("#detailInfoDivUsr");
		var editarView = $("#detailInfoDivAdm");
		
		normalView.css("display", "none");
		editarView.css("display", "block");
	},
	loadUsersById : function() {
		var self = this;
		self.maskEl.mask("Cargando...");
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
				self.maskEl.unmask();
				
			},
			error : function() {
				self.maskEl.unmask();
				console.log("Error while loading Users");
			}
		});
		
		
	},
	clear : function() {
		var self = this;

	},
	
});