tdm.UsersView = Backbone.View.extend({	
	el : jQuery('#usersDiv'),
	grid : undefined,
	users : undefined,
	initialize : function(options) {
		var self = this;
		self.maskEl = self.$el;
		self.users = new tdm.Users();

		self.modelBinder = new Backbone.ModelBinder();
		
		var UriCell = Backgrid.UriCell.extend({
		    render: function () {
		        this.$el.empty();
		        var rawValue = this.model.get(this.column.get("name"));
		        var formattedValue = this.formatter.fromRaw(rawValue, this.model);
		        var href = _.isFunction(this.column.get("href")) ? this.column.get('href')(rawValue, formattedValue, this.model) : this.column.get('href');
		        this.$el.append($("<a>", {
		          tabIndex: -1,
		          href: href || rawValue,
		          title: "Ver Detalle",
		          target: "_self"
		        }).text("Ver Detalle"));
		        this.delegateEvents();
		        return this;
		    }
		});
		
		var columns = [ {
			name : "",
			headerCell : Backgrid.Extension.SelectAllHeaderCell,
			cell : Backgrid.Extension.SelectRowCell
		},{
			name : "codename",
			label : "Codigo de Usuario",
			cell : "string",
			editable : false
		},{
			name : "userDesc",
			label : "Nombre de Usuario",
			cell : "string",
			editable : false
		},{
			name : "profileDesc",
			label : "Perfil",
			cell : "string",
			editable : false,
		},{
			name : "id",
			label : "",
			cell : UriCell,
			editable : false,
			href: function(rawValue, formattedValue, model){
				  return "usuarioDetalle.jsp?id=" + formattedValue;
				}
		}];

		self.grid = new Backgrid.Grid({
			columns : columns,
			collection : self.users
		});
		
		$(self.grid .el).css({float: "left", margin: "20px"});
		_.bindAll(this, 'loadUsers', 'clear', 'onEliminarClick','createMask');
		self.createFilters();
		self.loadUsers();
	},
	render : function(event) {
		this.$("#usersTable").append(this.grid.render().el);
		return this;
	},
	events : {
		"click #btnEliminar" : "onEliminarClick"	
	},
	close : function() {
		this.modelBinder.unbind();
		this.collectionBinder.unbind();
		this.off();
		this.undelegateEvents();
		this.remove();
	},
	createFilters : function(){
		var self = this; 
		var codenameFilter = new Backgrid.Extension.ClientSideFilter({
			  collection: self.users,
			  name: "codename",
			  placeholder: "Codigo de Usuario",
			  // The model fields to search for matches
			  fields: ['codename'],
			  // How long to wait after typing has stopped before searching can start
			  wait: 150
			});

		$("#filter1").prepend(codenameFilter.render().el);
		
		var userDescFilter = new Backgrid.Extension.ClientSideFilter({
			  collection: self.users,
			  name: "userDescFilter",
			  placeholder: "Nombre de Usuario",
			  // The model fields to search for matches
			  fields: ['userDesc'],
			  // How long to wait after typing has stopped before searching can start
			  wait: 150
			});

		$("#filter2").prepend(userDescFilter.render().el);
		
		var profileDescFilter = new Backgrid.Extension.ClientSideFilter({
			  collection: self.users,
			  name: "profileDescFilter",
			  placeholder: "Perfil",
			  // The model fields to search for matches
			  fields: ['profileDesc'],
			  // How long to wait after typing has stopped before searching can start
			  wait: 150
			});

		$("#filter3").prepend(profileDescFilter.render().el);
		

		
		

	},
	onEliminarClick : function(e, callback) {
		var self = this;
		var mask = self.createMask("Eliminando...");
		var user = new tdm.User();
		
		var selectedModels = self.grid.getSelectedModels();
		
		for (var i = 0; i< selectedModels.length; i++){
			var data = selectedModels[i].attributes;
			console.log(data.id);
			self.users.fetch({
				data : {
					'consulta' : 'DEL',
					'id':data.id
				},
				success : function(collection, response, options) {
					self.render();
					mask.hide();

				},
				error : function() {
					mask.hide();
					console.log("Error while deleting Users");

				}
			});
		}
		window.location="usuarios.jsp";
		
	},
	loadUsers : function() {
		var self = this;
		var mask = self.createMask("Cargando...");
		
		self.users.fetch({
			data : {
			},
			success : function(collection, response, options) {
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