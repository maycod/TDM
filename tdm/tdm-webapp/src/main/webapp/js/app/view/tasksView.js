tdm.TasksView = Backbone.View.extend({	
	el : jQuery('#tasksDiv'),
	grid : undefined,
	tasks : undefined,
	users : undefined,
	initialize : function(options) {
		var self = this;
		self.maskEl = self.$el;
		self.tasks = new tdm.Tasks();
		self.users = new tdm.Users();
		self.modelBinder = new Backbone.ModelBinder();

		//$(self.grid.el).css({float: "left", margin: "20px"});
		_.bindAll(this, 'loadTasks', 'clear', 'onEliminarClick','createMask',
				'generateTree','generateJsonTree', 'onTaskSelect','formatTree',
				'onAgregarClick', 'onGuardarClick','onGuardarModalClick','onAsignarClick',
				'loadUsers');
		self.initAssignGrid();
		self.loadTasks();
	},
	render : function(event) {
		return this;
	},
	events : {
		"click #btnEliminar" : "onEliminarClick",
		"click #btnEditar" : "onEditarClick",
		"click #btnAgregar" : "onAgregarClick",
		"click #btnGuardar" : "onGuardarClick",
		"click #btnAsignar" : "onAsignarClick"
	},
	close : function() {
		this.modelBinder.unbind();
		this.collectionBinder.unbind();
		this.off();
		this.undelegateEvents();
		this.remove();
	},
	onEditarClick : function(e, callback) {
		var self = this;
		var mask = self.createMask("Cargando...");
		var normalView = $("#taskDetailUsr");
		var editarView = $("#taskDetailAdm");
		
		
		normalView.css("display", "none");
		editarView.css("display", "block");
		
		mask.hide();
	},
	onGuardarModalClick : function(e, callback) {
		var self = this;
		var mask = self.createMask("Cargando...");
		var selectedModels = self.grid.getSelectedModels();
		var item = $('#jqxTree').jqxTree('getSelectedItem');
		var value= $(item).attr('value');
		var value = value.split("|");
		var taskIdStr = value[0];
		var taskId = parseInt(taskIdStr);
		for (var  i=0; i < self.users.models.length; i++) {
			var task = new tdm.Task();
			var userId = self.users.models[i].attributes.id;
			task.fetch({
				data : {
					'consulta' : 'DEL2',
					'id':taskId,
					'responsibleId':userId
					
				},
				success : function(collection, response, options) {


				},
				error : function() {
					mask.hide();
					console.log("Error while deleting Tasks");

				}
			});
	
			
		}		
		for (var  i=0; i < selectedModels.length; i++) {
			var task = new tdm.Task();
			var userId = selectedModels[i].attributes.id;
			task.set('id', taskId); 		
			task.set('responsibleId', userId); 	
			task.set('consulta', "C1"); 	
			task.save(task.attributes,{
				 success:function(model, response, options){
					 	mask.hide();
					 	iosOverlay({
							text: "Cambios Guardados.",
							duration: 2e3,
							icon: "../images/photos/dtchLogo125W.png"
						});
					 	
					 	setTimeout(function() {
							self.onTaskSelect();
							$('#asignarModal').modal('toggle');
						}, 3100);
						
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
		if (selectedModels.length==0){
			mask.hide();
			iosOverlay({
				text: "Cambios Guardados.",
				duration: 2e3,
				icon: "../images/photos/dtchLogo125W.png"
			});
			setTimeout(function() {
				self.onTaskSelect();
				$('#asignarModal').modal('toggle');
			}, 3000);
		}
	},
	validate : function(taskName,taskDesc) {
		var taskNameRegex = /^[^+]{1,30}$/;
		if (!taskNameRegex.test(taskName)){
			iosOverlay({
				text: "Formato de Clave Inv&aacutelido",
				duration: 2e3,
				icon: "../images/photos/dtchLogo125W.png"
			});
			return false;
		}
		var taskDescRegex = /^[^+]{1,60}$/;
		if (!taskDescRegex.test(taskDesc)){
			iosOverlay({
				text: "Formato de Nombre Inv&aacutelido",
				duration: 2e3,
				icon: "../images/photos/dtchLogo125W.png"
			});
			return false;
		}
		return true
	},
	onGuardarClick : function(e, callback) {
		var self = this;
		var taskIdStr = $("#taskId")[0].innerHTML;
		var taskIdAdm = parseInt(taskIdStr);
		var parentTaskIdStr = $("#parentTaskId")[0].innerHTML;
		var parentTaskIdAdm = parseInt(parentTaskIdStr);
		var taskNameAdm = $("#taskNameAdm")[0].value; 
		var taskDescAdm = $("#taskDescAdm")[0].value; 
		var observationsAdm = $("#observationsAdm")[0].value; 
		var timeBudgetAdm = $("#timeBudgetAdm")[0].value; 
		var activeAdm = $("#activeAdm")[0]; 

		if(self.validate(taskNameAdm,taskDescAdm)){
			var mask = self.createMask("Cargando...");
			var task = new tdm.Task();
			task.set('id', taskIdAdm); 		
			task.set('taskName', taskNameAdm); 		
			task.set('taskDesc', taskDescAdm); 
			task.set('parentTaskId', parentTaskIdAdm); 
			task.set('observations', observationsAdm); 		
			task.set('timeBudget', parseInt(timeBudgetAdm));
			task.set('active', activeAdm.checked);
			task.save(task.attributes,{
				 success:function(model, response, options){
					 	$("#jqxTree").empty();
					 	var normalView = $("#taskDetailUsr");
						var editarView = $("#taskDetailAdm");
					 	normalView.css("display", "none");
						editarView.css("display", "none");
					 	self.loadTasks();
					 	mask.hide();
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
	onAgregarClick : function(e, callback) {
		var self = this;
		var item = $('#jqxTree').jqxTree('getSelectedItem');
		if (item != null){
			var mask = self.createMask("Cargando...");
			var task = new tdm.Task();
			var parentIdStr = item.value;
			parentIdStr = parentIdStr.split("|");
			var parentIdStr = parentIdStr[0];
			var parentId = parseInt(parentIdStr);
			task.set('id', 0); 
			task.set('parentTaskId', parentId);
			
			task.save(task.attributes,{
				 success:function(model, response, options){
					 	$("#jqxTree").empty();
					 	self.loadTasks();
					 	mask.hide();
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
		else{
			iosOverlay({
				text: "Favor de seleccionar Tarea Padre.",
				duration: 2e3,
				icon: "../images/photos/dtchLogo125W.png"
			});
		}
		
	}, 
	createFilters : function(){
		var self = this; 
		
		var userDescFilter = new Backgrid.Extension.ClientSideFilter({
			  collection: self.users,
			  name: "userDescFilter",
			  placeholder: "Nombre de Usuario",
			  // The model fields to search for matches
			  fields: ['userDesc'],
			  // How long to wait after typing has stopped before searching can start
			  wait: 150
			});
		return userDescFilter;
		
	},
	initAssignGrid :function(){
		var self = this;
		var assignColumns = [ {
			name : "",
			headerCell : Backgrid.Extension.SelectAllHeaderCell,
			cell : Backgrid.Extension.SelectRowCell
		},{
			name : "userDesc",
			label : "Nombre de Usuario",
			cell : "string",
			editable : false
		},{
			name : "id",
			label : "",
			cell : "string",
			editable : false,
			renderable: false
		}];

		self.grid = new Backgrid.Grid({
			columns : assignColumns,
			collection : self.users
		});

		$(document).on("click", "#btnGuardarModal", self.onGuardarModalClick);
		self.createFilters();
		
	},
	loadUsers : function(profileId) {
		var self = this;
		var mask = self.createMask("Cargando...");
		var item = $('#jqxTree').jqxTree('getSelectedItem');
		var value= $(item).attr('value');
		var value = value.split("|");
		var taskIdStr = value[0];
		var taskId = parseInt(taskIdStr);
		var usersAux = new tdm.Users();
		self.users.fetch({
			data : {
				'profileId': profileId
			},
			success : function(collection, response, options) {
				var userDescFilter = self.createFilters();
				$("#filter1").empty();
				$("#filter1").append(userDescFilter.render().el);
				$("#usersTable").append(self.grid.render().el);

				usersAux.fetch({
					data : {
						'consulta' : 'C4',
						'id': taskId
					},
					success : function(servCollection, response, options) {
						for (var i =0; i < servCollection.length; i++){
							//var gridCollection = self.grid.collection;
							for (var  j=0; j < collection.length; j++){
								var servUserId = servCollection.models[i].attributes.id;
								var gridUserId = collection.models[j].attributes.id
								if (servUserId == gridUserId ){
									collection.models[j].trigger("backgrid:select", collection.models[j], true);			
								}
							}
						}
						mask.hide();
					},
					error : function() {
						mask.hide();
						console.log("Error while loading Users");
					}
				});
			},
			error : function() {
				mask.hide();
				console.log("Error while loading Users");
			}
		});
		
		
	},
	onAsignarClick : function(e, callback) {
		var self = this;
		var item = $('#jqxTree').jqxTree('getSelectedItem');
		if (item != null){
			var value= $(item).attr('value');
			var value = value.split("|");
			var levelStr = value[2];
			var level = parseInt(levelStr);
			console.log(value);
			if (level == 1){
				iosOverlay({
					text: "Favor de seleccionar Tarea a Asignar.",
					duration: 2e3,
					icon: "../images/photos/dtchLogo125W.png"
				});
				return;
			}else{
				if (level==2){
					 $('#myModalLabel')[0].innerHTML = "Asignar Lider De Proyecto a Tarea";
					 self.loadUsers(2);
				}else if (level>2){
					 $('#myModalLabel')[0].innerHTML = "Asignar Personal a Tarea";
					 self.loadUsers(3);
				}
				$('#asignarModal').modal({
				    show: 'false'
				});
			} 
			
			
		}
		else{
			iosOverlay({
				text: "Favor de seleccionar Tarea a Asignar.",
				duration: 2e3,
				icon: "../images/photos/dtchLogo125W.png"
			});
		}
		
	},
	onEliminarClick : function(e, callback) {
		var self = this;
		var item = $('#jqxTree').jqxTree('getSelectedItem');
		if (item != null){
			var mask = self.createMask("Cargando...");
			var task = new tdm.Task();
			var taskIdStr = $("#taskId")[0].innerHTML;
			var taskIdAdm = parseInt(taskIdStr);
			task.fetch({
				data : {
					'consulta' : 'DEL',
					'id':taskIdAdm
				},
				success : function(collection, response, options) {
					$("#jqxTree").empty();
				 	var normalView = $("#taskDetailUsr");
					var editarView = $("#taskDetailAdm");
				 	normalView.css("display", "none");
					editarView.css("display", "none");
				 	self.loadTasks();
				 	mask.hide();

				},
				error : function() {
					mask.hide();
					console.log("Error while deleting Tasks");

				}
			});
			
		}else{
			iosOverlay({
				text: "Favor de seleccionar Tarea a Eliminar.",
				duration: 2e3,
				icon: "../images/photos/dtchLogo125W.png"
			});
		}

		
	},
	loadTasks : function() {
		var self = this;
		var mask = self.createMask("Cargando...");
		//var userIdStr = $("#userId")[0].innerHTML;
		//var userId= parseInt(userIdStr);
		//'consulta' : 'C1',
		//'responsibleId': userId
		self.tasks.fetch({
			data : {

			},
			success : function(collection, response, options) {
				self.generateTree(response);
				mask.hide();
			},
			error : function() {
				mask.hide();
				console.log("Error while loading Tasks");
			}
		});
		
		
	},
	generateTree : function(response) {
		var self = this;
		var jsonData = [];
		for (var x = 0; x < response.length; x++) {
			var jsonNode = {};
			jsonNode["id"] = response[x].id;
			jsonNode["parentId"] = response[x].parentTaskId;
			jsonNode["text"] =response[x].taskDesc;
			jsonNode["value"] = response[x].id+"|"+response[x].status+ "|"+response[x].level;
			jsonData.push(jsonNode);
		}
		var jsonTree = self.generateJsonTree(jsonData);
		$('#jqxTree').jqxTree({
			source : jsonTree,
			height : '450px',
			width : '95%'
		});
		self.formatTree();
		$("#jqxTree .jqx-tree-item").click($.proxy( self.onTaskSelect, self));
	},
	generateJsonTree : function(data) {
		var source = [];
	    var items = [];
	    // build hierarchical source.
	    for (i = 0; i < data.length; i++) {
	        var item = data[i];
	        var label = item["text"];
	        var parentId = item["parentId"];
	        var id = item["id"];
	        var value = item["value"];

	        if (items[parentId]) {
	            var item = { parentId: parentId, label: label, item: item, value: value};
	            if (!items[parentId].items) {
	                items[parentId].items = [];
	            }
	            items[parentId].items[items[parentId].items.length] = item;
	            items[id] = item;
	        }
	        else {
	            items[id] = { parentId: parentId, label: label, item: item, value: value };
	            source[id] = items[id];
	        }
	    }
		return source;
	},
	onTaskSelect : function(e) {
		self = this;
		var item = $('#jqxTree').jqxTree('getSelectedItem');
		var value= $(item).attr('value');
		var value = value.split("|");
		var levelStr = value[2];
		var level = parseInt(levelStr);
		if (level > 1){
			var mask = self.createMask("Cargando...");
			var normalView = $("#taskDetailUsr");
			var editarView = $("#taskDetailAdm");
			normalView.css("display", "block");
			editarView.css("display", "none");
			var value= $(item).attr('value');
			var value = value.split("|");
			var taskIdStr = value[0];
			var taskId = parseInt(taskIdStr);
			$("#taskId")[0].innerHTML = taskIdStr;
			self.tasks.fetch({
				data : {
					'consulta' : 'C2',
					'id':taskId
				},
				success : function(collection, response, options) {
					
					//Usr
					var data = collection.models[0].attributes;
					$("#parentTaskId")[0].innerHTML = data.parentTaskId;
					var taskNameUsr = $("#taskNameUsr")[0];
					taskNameUsr.innerHTML = data.taskName;
					var taskDescUsr = $("#taskDescUsr")[0];
					taskDescUsr.innerHTML = data.taskDesc;
					var observationsUsr = $("#observationsUsr")[0];
					observationsUsr.innerHTML = data.observations;
					var responsibleNameUsr = $("#responsibleNameUsr")[0];
					responsibleNameUsr.innerHTML = data.responsibleName;
					var timeBudgetUsr = $("#timeBudgetUsr")[0];
					timeBudgetUsr.innerHTML = data.timeBudget;
					var activeUsr = $("#activeUsr")[0];
					activeUsr.checked = data.active;
					
					//Adm
					var taskNameAdm = $("#taskNameAdm")[0];
					taskNameAdm.value = data.taskName;
					var taskDescAdm = $("#taskDescAdm")[0];
					taskDescAdm.value = data.taskDesc;
					var observationsAdm = $("#observationsAdm")[0];
					observationsAdm.value = data.observations;
					var timeBudgetAdm = $("#timeBudgetAdm")[0];
					timeBudgetAdm.value = data.timeBudget;
					var activeAdm = $("#activeAdm")[0];
					activeAdm.checked = data.active;

					
					self.render();
					mask.hide();
					
				},
				error : function() {
					mask.hide();
					console.log("Error while loading Users");
				}
			});
			
			
		}
		
		
	},
	formatTree : function(){
		self = this;
		var items = $("#jqxTree").jqxTree('getItems');
		for (i = 0; i < items.length; i++) {
			var value = items[i].value;
			value = value.split("|");
			var status = value[1];
			if (status == 0){
				$("#"+items[i].id).css("color", "#CD0B1F");
			}else{
				$("#"+items[i].id).css("color", "#333");
			}

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
	clear : function() {
		var self = this;

	},
	
});