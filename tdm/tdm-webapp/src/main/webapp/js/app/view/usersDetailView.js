tdm.UsersDetailView = Backbone.View.extend({	
	el : jQuery('#usersDiv'),
	grid : undefined,
	users : undefined,
	initialize : function(options) {
		var self = this;
		self.maskEl = self.$el;
		self.users = new tdm.Users();

		self.modelBinder = new Backbone.ModelBinder();
		_.bindAll(this, 'onGuardarClick', 'onEditarClick');
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
			
			var idUserAdm = $("#idUser")[0].innerHTML; 
			var usernameAdm = $("#usernameAdm")[0].value; 
			var profileIdAdm = $("#profileDescAdm").val(); 
			
			user.set('id', idUserAdm); 
			user.set('username', usernameAdm); 
			user.set('profileId', profileIdAdm); 
			
			user.save(user.attributes,{
				 success:function(model, response, options){ 		
					 	iosOverlay({
							text: "Cambios Guardados.",
							duration: 2e3,
							icon: "../images/photos/logo43.png"
						});
					 	self.maskEl.unmask();
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
				var usernameUsr = $("#usernameUsr")[0];
				usernameUsr.innerHTML = data.username;
				var profileDescUsr = $("#profileDescUsr")[0];
				profileDescUsr.innerHTML = data.profileDesc;
				var creationDateUsr = $("#creationDateUsr")[0];
				creationDateUsr.innerHTML = data.creationDate;
				//Adm
				var data = collection.models[0].attributes;
				var usernameAdm = $("#usernameAdm")[0];
				usernameAdm.value = data.username;
				var profileDescAdm = $("#profileDescAdm");
				profileDescAdm.val(data.profileId);
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