merlinwizard.UsersView = Backbone.View.extend({	
	el : jQuery('#usersDiv'),
	grid : undefined,
	users : undefined,
	initialize : function(options) {
		var self = this;
		self.maskEl = self.$el;
		self.users = new merlinwizard.Users();

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
		}, {
			name : "username",
			label : "Nombre de Usuario",
			cell : "string",
			editable : false
		}, {
			name : "profileDesc",
			label : "Perfil",
			cell : "string",
			editable : false,
		}, {
			name : "creationDate",
			label : "Fecha de Creacion",
			cell : "string",
			editable : false
		}, {
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
		_.bindAll(this, 'loadUsers', 'clear', 'onEliminarClick');
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
		var usernameFilter = new Backgrid.Extension.ClientSideFilter({
			  collection: self.users,
			  name: "usernameFilter",
			  placeholder: "Nombre de Usuario",
			  // The model fields to search for matches
			  fields: ['username'],
			  // How long to wait after typing has stopped before searching can start
			  wait: 150
			});

		$("#filter1").prepend(usernameFilter.render().el);
		
		var profileDescFilter = new Backgrid.Extension.ClientSideFilter({
			  collection: self.users,
			  name: "profileDescFilter",
			  placeholder: "Perfil",
			  // The model fields to search for matches
			  fields: ['profileDesc'],
			  // How long to wait after typing has stopped before searching can start
			  wait: 150
			});

		$("#filter2").prepend(profileDescFilter.render().el);
		
		var creationDateFilter = new Backgrid.Extension.ClientSideFilter({
			  collection: self.users,
			  name: "creationDate",
			  placeholder: "Fecha de Creacion",
			  // The model fields to search for matches
			  fields: ['creationDate'],
			  // How long to wait after typing has stopped before searching can start
			  wait: 150
			});

		$("#filter3").prepend(creationDateFilter.render().el);
		
		

	},
	onEliminarClick : function(e, callback) {
		var self = this;
		self.maskEl.mask("Eliminando...");
		var user = new merlinwizard.User();
		
		var selectedModels = self.grid.getSelectedModels();
		
		for (var i = 0; i< selectedModels.length; i++){
			var data = selectedModels[0].attributes;
			self.users.fetch({
				data : {
					'consulta' : 'DEL',
					'id':data.id
				},
				success : function(collection, response, options) {
					self.render();
					self.maskEl.unmask();
					window.location="usuarios.jsp";
					
				},
				error : function() {
					self.maskEl.unmask();
					console.log("Error while deleting Users");
					window.location="alumnos.jsp";
				}
			});
		}
		
	},
	loadUsers : function() {
		var self = this;
		self.maskEl.mask("Cargando...");
		
		self.users.fetch({
			data : {
			},
			success : function(collection, response, options) {
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