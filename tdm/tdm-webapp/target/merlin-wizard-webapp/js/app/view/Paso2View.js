merlinwizard.Paso2View = Backbone.View.extend({	el : jQuery('#wiz3step2'),
	//plaza:undefined,
	pedido : undefined,
	grid : undefined,
	gridAsig : undefined,
	editMode : false,
	perfilTda : undefined,
	perfilSelected : -1,
	treeSelected : " ",
	initialize : function(options) {

		var self = this;
		self.maskEl = self.$el;

		merlinwizard.perfilesTda = new merlinwizard.PerfilesTda();
		self.tienda = new merlinwizard.Tienda();
		self.tiendasDisp = new merlinwizard.Tiendas();
		self.tiendasAsig = new merlinwizard.Tiendas();
		
		self.perfilesTdaCombo = self.$('#perfilesTdaCombo');

		//self.plaza = options.plaza;
		self.pedido = options.pedido;

		self.tiendasDisp.on('beforerequest', function(data) {
			var arrayLength = data.length;
			for (var i = 0; i < arrayLength; i++) {
				data[i].plaza.id = self.pedido.get('plaza.id');
			}
		});
		self.tiendasAsig.on('beforerequest', function(data) {
			var arrayLength = data.length;
			for (var i = 0; i < arrayLength; i++) {
				data[i].plaza.id = self.pedido.get('plaza.id');
			}
		});

		self.tiendasDisp.on('sync', function(models) {
			//self.maskEl.unmask();
		});
		self.tiendasAsig.on('sync', function(models) {
			//self.maskEl.unmask();
		});

		self.enable("#detalleTda *");

		$.proxy(self.loadPerfilesTda(), this)

		merlinwizard.perfilesTda.on('add', this.addPerfilesTda, this);
		merlinwizard.perfilesTda.on('reset', this.resetPerfilesTda, self);
		self.modelBinder = new Backbone.ModelBinder();

		var columns = [ {
			name : "",
			headerCell : Backgrid.Extension.SelectAllHeaderCell,
			cell : Backgrid.Extension.SelectRowCell
		}, {
			name : "mercado",
			label : "Mercado",
			cell : "string",
			editable : false
		}, {
			name : "tienda",
			label : "Tienda",
			cell : "string",
			editable : false
		}, {
			name : "id",
			label : "IdTienda",
			cell : "string",
			editable : false,
			renderable : false
		}];

		var columnsAsig = [ {
			name : "",
			headerCell : Backgrid.Extension.SelectAllHeaderCell,
			cell : Backgrid.Extension.SelectRowCell
		}, {
			name : "mercado",
			label : "Mercado",
			cell : "string",
			editable : false
		}, {
			name : "tienda",
			label : "Tienda",
			cell : "string",
			editable : false
		}, {
			name : "id",
			label : "IdTienda",
			cell : "string",
			editable : false,
			renderable : false
		} ];

		var FocusableRow = Backgrid.Row.extend({
			highlightColor : "lightYellow",
			events : {
				focusin : "rowFocused",
				focusout : "rowLostFocus"
			},
			rowFocused : function() {
				this.el.style.backgroundColor = this.highlightColor;
			},
			rowLostFocus : function() {
				delete this.el.style.backgroundColor;
			}
		});

		self.grid = new Backgrid.Grid({
			row : FocusableRow,
			columns : columns,
			collection : self.tiendasDisp
		});

		self.gridAsig = new Backgrid.Grid({
			row : FocusableRow,
			columns : columnsAsig,
			collection : self.tiendasAsig
		});

		$('#inputBuscarArt').on('input', function() {

			var inp = $('#inputBuscarArt').val();

			self.grid.collection.each(function(model, i) {
				var g = model.get('descripcion');
				if (g.toLowerCase().indexOf(inp) >= 0) {
					//	    		this.el.style.backgroundColor = "red";
					//alert(g + "- " + inp);
				}
			});

			var tienda = new merlinwizard.Tienda();

		});

		
		var clientSideFilter = new Backgrid.Extension.LunrFilter({
			  collection:self.tiendasDisp,
			  id: "frmBuscarTdaPaso2",
			  name: "inputBuscarTdaPaso2",
			  placeholder: "Buscar tienda",
			
			  	// Campos en los cuales se realizara la busqueda y su vallor boost
			  fields: {
				    tienda: 10
				  },
			  // lunr.js document key for indexing
			  ref: 'id',
			  wait: 150
			});
		$("#contenedorFiltrosPaso2").prepend(clientSideFilter.render().el);
		
		contextSaved = this;
	},
	render : function(event) {
		var self = this;

		self.$("#tablaTiendasDisp").append(self.grid.render().el);

		self.$("#tablaTiendasAsig").append(self.gridAsig.render().el);
		 $("#frmBuscarTdaPaso2 :input").attr("maxlength",10);
		 
		
		 //$("#frmBuscarTdaPaso2 :input").filter_input({regex:'[a-zA-Z\\s0-9]'});
		 
		 //var desc = $("#frmBuscarTdaPaso2 :input");
		  
		  //desc.filter_input({regex:'[a-zA-Z ]'}); 
		 //$("#frmBuscarTdaPaso2 :input").filter_input({regex:'[/^[a-zA-Z]+$/]'});
		 

		return this;
	},
	events : {
		"change #perfilesTdaCombo" : "onPerfilesTreeViewSelect",
		"click #tiendaadd" : "onTiendaAddClick",
		"click #tiendadel" : "onTiendaDelClick"
	},
	close : function() {
		this.modelBinder.unbind();
		this.collectionBinder.unbind();
		this.off();
		this.undelegateEvents();
		this.remove();
	},

	addPerfilesTda : function(perfilTda) {
		var view = new merlinwizard.ComboPerfilesTdaView({
			model : perfilTda
		});
		this.perfilesTdaCombo.append(view.render().el);
	},
	resetPerfilesTda : function(perfilesTda) {

		this.perfilesTdaCombo.html('');

	},
	onTreeViewClick : function(e) {
		//console.log(e);
	},
	generateSourceTree : function(response) {
		var self = this;
		var tree = {};
		for (var x = 0; x < response.length; x++) {

			hierarchy = [];
			hierarchy.push("PLAZA " + response[x].idPlaza);
			hierarchy.push("MERCADO " + response[x].idMercado);
			hierarchy.push("CAMPO " + response[x].idCampo);
			tree = self.fillTree("TIENDA " + response[x].id, hierarchy, tree);
		}
		//console.log(tree);
		source = [];
		source.push(tree);
		$jCustom('#jqxTree').jqxTree({
			source : source,
			height : '105px',
			width : '360px'
		});
		$jCustom("#jqxTree .jqx-tree-item").click($.proxy( self.onPerfilesTreeViewSelect, self ));
	},
	fillTree : function(idTienda, hierarchy, tree) {
		var current = null, existing = null, i = 0;
		//Iteracion a traves de la jerarquia proporcionada ("Plaza > Mercado > Campo")
		for (var i = 0; i < hierarchy.length; i++) {
			//Evaluacion para jerarquia Plaza
			if (i == 0) {
				//Se inserta una Plaza
				if (!tree.items || typeof tree.items == 'undefined') {
					tree = {
						label : hierarchy[i],
						expanded : true,
						items : []
					};
				}
				//Se apunta a los mercados
				current = tree.items;
			}
			//Evaluacion para jerarquia Mercado y Campo
			else {
				existing = null;
				//iteracion a traves de los mercados||campos
				for (j = 0; j < current.length; j++) {
					//Se verifica si el Mercado||Campo existe
					if (current[j].label === hierarchy[i]) {
						existing = current[j];
						break;
					}
				}
				//Si el Mercado||Campo existe se apunta a sus Campos||Tiendas
				if (existing) {
					current = existing.items;
				} else {
					//Si no existe se inserta el Mercado||Campo
					current.push({
						label : hierarchy[i],
						items : []
					});
					//Se apunta a los Campos||Tiendas
					current = current[current.length - 1].items;
				}
			}
		}
		//Se inserta la Tiedna
		current.push({
			label : idTienda
		})
		return tree;
	},
	onTiendaDelClick : function(e) {
		var self = this;
		//var plazaId = self.pedido.get('plaza.id');

		var selectedModels = self.gridAsig.getSelectedModels();

		_.each(selectedModels, function(model) {

			/*console.log(model);
			desTda = model.get('descripcion');
			idTda = model.get('id');
			desMdo = model.get('desMercado');
			idMdo = model.get('idMercado');

			tiendaD = idTda + " " + desTda;
			console.log(tiendaD);
			mercadoD = idMdo + " " + desMdo;
			console.log(mercadoD);*/
			var tiendaD= model.get('tienda');
			var mercadoD= model.get('mercado');
			var idTda = model.get('id');
			self.grid.insertRow([ {
				tienda : tiendaD,
				mercado : mercadoD,
				id : idTda 
			}]);
			
			var rowSelected = self.gridAsig.collection.where({ id: idTda });
			self.gridAsig.removeRow(rowSelected);

			$("#contadorTdaAsig").empty();
			$("#contadorTdaAsig").append("(" + self.tiendasAsig.length + ")");
			$("#contadorTdaDisp").empty();
			$("#contadorTdaDisp").append("(" + self.tiendasDisp.length + ")");

		});

	},
	onTiendaAddClick : function(e) {
		var self = this;
		//var plazaId = self.pedido.get('plaza.id');

		var selectedModels = self.grid.getSelectedModels();

		/*var idTda;
		var Des;
		var idMerc;
		var DesMerc;
		var tiendaD;
		var mercadoD;*/

		_.each(selectedModels, function(model) {
			//model.trigger("backgrid:select", model, false);

			/*desTda = model.get('descripcion');
			idTda = model.get('id');
			desMdo = model.get('desMercado');
			idMdo = model.get('idMercado');

			tiendaD = idTda + " " + desTda;
			mercadoD = idMdo + " " + desMdo;*/
			var tiendaD= model.get('tienda');
			var mercadoD= model.get('mercado');
			var idTda = model.get('id');

			self.gridAsig.insertRow([ {
				tienda : tiendaD,
				mercado : mercadoD,
				id : idTda 
			}]);
			
			var rowSelected = self.grid.collection.where({ id: idTda });
			self.grid.removeRow(rowSelected);

			$("#contadorTdaAsig").empty();
			$("#contadorTdaAsig").append("(" + self.tiendasAsig.length + ")");
			$("#contadorTdaDisp").empty();
			$("#contadorTdaDisp").append("(" + self.tiendasDisp.length + ")");

		});

	},

	disable : function(id) {
		this.$(id).prop('disabled', true);

	},
	enable : function(id) {
		this.$(id).prop('disabled', false);

	},
	performFiltering : function(e){
		var self = this;
		var idMercado = '-1';
		var idCampo = '-1';
		var idTienda = '-1';
		if (e.type === 'click'){
			//Seteo de seleccion de TreeView
			self.treeSelected = e.target.innerHTML;
			//Inicializacion de elementos de PerfilesCompo
		}
		else if (e.type === 'change'){
			var val = jQuery(e.target).val();
			self.editMode = false;
			if (val !== '') {
				var tmpmodel = merlinwizard.perfilesTda.get(val);
				var tmpperfilesTda = new merlinwizard.PerfilesTda();
				var perfilTda = new merlinwizard.PerfilTda();
				perfilTda.set('idPerfil', tmpmodel.get('id'));
				//Seteo de seleccion de Perfil
				self.perfilSelected  = perfilTda.get('idPerfil');
				
			}
			
		}
		//inicializacion de elementos de TreeView
		var value =self.treeSelected;
		if (value.search("MERCADO") != -1){
			idMercado = value.replace("MERCADO ", "");
		}else if (value.search("CAMPO") != -1){
			idCampo = value.replace("CAMPO ", "");
		}else if (value.search("TIENDA") != -1){
			idTienda = value.replace("TIENDA ", "");
		}
		
		//Filtrado
		self.maskEl.mask("Cargando Tiendas...");
		
		
		self.tiendasDisp.fetch({
			data : {
				'idPedido' : self.pedido.get('id'),
				'plaza.id' : self.pedido.get('plaza.id'),
				'idPerfil' : self.perfilSelected,
				'idMercado' : idMercado,
				'idCampo' : idCampo,
				'id' : idTienda,
				'tipoOrden': 2
			},
			success : function(collection, response, options) {
				$("#contadorTdaDisp").empty();
				$("#contadorTdaDisp").append(
						"(" + self.tiendasDisp.length + ")");
				self.maskEl.unmask();

			},
			error : function() {
				self.maskEl.unmask();
			}
		});
		
		$("#tablasTiendasDisp").css("display", "block");
		$("#btnAvanzar").css("display", "block");
		$("#detalleTiendasAsig").css("display", "block");
		paso2selected=true;
		
	},
	onPerfilesTreeViewSelect : function(e) {
		var self = this;
		if (self.grid.getSelectedModels().length > 0 /*|| self.gridAsig.getSelectedModels().length > 0*/ ){
			$jCustom.confirm({
				icon: 'fa fa-warning',
			    title: 'Confirmaci&oacute;n',
			    confirmButton: 'SI',
			    cancelButton: 'NO',
			    content: 'Existen Tiendas seleccionadas. ¿Seguro que desea continuar?',
			    confirm: function(){
			    	self.performFiltering(e);
			    }
			});
		}else{
			self.performFiltering(e);
		}
		

	},
	onGuardarTiendaClick : function(e, callback) {
		var self = this;
		var tdaid;

		if (self.tiendasAsig.length <= 0) {
			jQuery('#wizard3').smartWizard('showMessage',
					'Agregue por lo menos una tienda...');

		} else {
			var tienda = new merlinwizard.Tienda();
			var tmp = new merlinwizard.Tienda();

			self.maskEl.mask("Grabando...");
			tmp.set('idPedido', self.pedido.get('id'));
			tmp.set('consulta', 'CLEAN_TIENDAS');
			
			tmp.save(tmp.attributes, {
				success : function(model, response, options) {
					var errores = 0;

					self.gridAsig.collection.each(function(model, i) {
						model.trigger("backgrid:select", model, true);
					});
					var selectedModels = self.gridAsig.getSelectedModels();
					_.each(selectedModels, function(model) {
						//tdaid = model.get('tienda').split(" ", 1)
						tdaid = model.get('id')
						//model.set('id', tdaid);

						tienda.set('idPedido', self.pedido.get('id'));
						tienda.set('plaza', self.pedido.get('plaza'));
						//tdaid = model.get('tienda').split(" ", 1)
						tienda.set('id', tdaid);

						tienda.save(tienda.attributes, {
							success : function(model, response, options) {},
							error : function(model, response, options) {
								errores = errores + 1;
							}
						});

					});
					if (errores > 0){
						self.maskEl.unmask();
						jQuery('#wizard3').smartWizard('showMessage',
						'Hubo un error al momento de guardar los cambios, intente de nuevo.');
						//console.log("Error de tipo 1");
					}
					else{
						var tmpFin = new merlinwizard.Tienda();

						tmpFin.set('idPedido', self.pedido.get('id'));
						tmpFin.set('consulta', 'POST_TIENDAS');
						
						tmpFin.save(tmpFin.attributes, {success : function(model, response, options) {
							self.maskEl.unmask();
							jQuery('#wizard3').smartWizard('showMessage',
							'Las tiendas fueron grabadas con exito.');
							if (callback) {
								callback();
							}
						}, error : function(model, response, options) {
							self.maskEl.unmask();
							jQuery('#wizard3').smartWizard('showMessage',
							'Hubo un error al momento de guardar los cambios, intente de nuevo.');
							//console.log("Error de tipo 3");
						}
						});
					}
				},
				error : function(model, response, options) {
					self.maskEl.unmask();
					jQuery('#wizard3').smartWizard('showMessage',
					'Hubo un error al momento de guardar los cambios, intente de nuevo.');
					//console.log("Error de tipo 2");
				}
			});
		}
	},

	loadPerfilesTda : function() {
		
		if (!pedidoExistente && !paso2selected){
			$("#tablasTiendasDisp").css("display", "none");
			$("#btnAvanzar").css("display", "none");
			$("#detalleTiendasAsig").css("display", "none");
		}else{
			$("#tablasTiendasDisp").css("display", "block");
			$("#btnAvanzar").css("display", "block");
			$("#detalleTiendasAsig").css("display", "block");
		}
		
		var self = this;
		//console.log(self);

		self.tienda.set('idPlaza', self.pedido.get('plaza.id'));
		self.maskEl.mask("Cargando Tiendas...");
		merlinwizard.perfilesTda.fetch({
			success : function() {
				//self.maskEl.mask("Cargando Tiendas...");
				self.tiendasAsig.fetch({
					data : {
						'consulta' : 'T1',
						'idPedido' : self.pedido.get('id')
					}, 
					success : function(collection, response, options) {
						//self.maskEl.unmask();
						$("#contadorTdaAsig").empty();
						$("#contadorTdaAsig").append(
								"(" + self.tiendasAsig.length + ")");
						self.render();
					},
					error : function() {
						//self.maskEl.unmask();
					}
				});

			}
		});
		self.tienda.fetch({
			data : {
				'idPedido' : 0,
				'plaza.id' : self.pedido.get('plaza.id'),
				'idPerfil' : -1,
				'idMercado' : '-1',
				'idCampo' : '-1',
				'id' : '-1',
				'tipoOrden': 1
			},
			success : function(collection, response, options) {
				//console.log(collection);
				self.generateSourceTree(response);
				self.maskEl.unmask();
			},
			error : function() {
				self.maskEl.unmask();
			}
		});
	},
	clear : function() {
		var self = this;
		merlinwizard.perfilesTda.reset();
		self.tiendasDisp.reset();
		$("#contadorTdaDisp").empty();
		$("#contadorTdaDisp").append("(" + self.tiendasDisp.length + ")");
		self.gridAsig.clearSelectedModels();
		//self.gridAsig.clearSelectedModels();
		self.render() ;
	}

});