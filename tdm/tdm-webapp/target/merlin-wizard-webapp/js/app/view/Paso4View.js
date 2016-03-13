merlinwizard.Paso4View = Backbone.View.extend({	el : jQuery('#wiz3step4'),
	pedido : undefined,
	grid : undefined,
	showCols : [],
	currentColSet : null,
	numArticulos: null,
	colSetLength:null,
	relArtColArtId: {}, 
	dataToSend : [],
	colPadding: false,
	initialize : function(options) {

		//var paso4next = true;
		var self = this;
		self.maskEl = self.$el;
		self.currentColSet = 0;
		self.colSetLength = 5;
		
		jQuery('#wizard3').smartWizard('hideMessage', "");
		self.pedido = options.pedido;
		self.excepciones = new merlinwizard.Excepcions();



		self.excepciones.on('sync', function(models) {

			//self.maskEl.unmask();

			if (paso4next == true) {
				jQuery('#wizard3').smartWizard('goForward');
			}

		});

		self.modelBinder = new Backbone.ModelBinder();
		/*Intento de codigo*/
		CustomModel = Backbone.Model.extend({
		    /* Empty Model definition */    
		}),

		CustomCollection = Backbone.Collection.extend({
		    model: CustomModel 
		}),
		
		self.customCollection = new CustomCollection();
		self.columns = new Backgrid.Columns([
	    {
			name : "id",
			label : "IdTienda",
			cell : "string",
			editable : false,
			renderable : false
		},{
			name : "descPlaza",
			label : "Plaza",
			cell : "string",
			editable : false
		}, {
			name : "idMercado",
			label : "Mercado",
			cell : "integer",
			editable : false
		}, {
			name : "descTienda",
			label : "Tienda",
			cell : "string",
			editable : false
		} ]);
		
		
	 	
		self.grid = new Backgrid.Grid({
			//row: customRow,
			columns : self.columns,
			collection : self.customCollection
		});
		
		self.customCollection.on('backgrid:editing', function(a,b,c){	
			for (var i = 0; i < self.numArticulos; i++){
				var colName = ".articulo";
				colName = colName.concat((i+1).toString());
				var articulo = jQuery(colName).children(":text");
				articulo.attr("maxlength", 5);
				articulo.filter_input({regex:'[0-9]'});
			}
			
			
		});
		
		self.grid.listenTo(self.customCollection,"backgrid:edited",function(e){
			var objKey = Object.keys(e.changed)[0];
			var objValue = e.changed[objKey];
			var idArticulo = self.relArtColArtId[objKey]
			//console.log(e);
			self.dataToSend.push({
				idTienda :  e.attributes.idTienda,
		        idArticulo: idArticulo,
		        value: objValue
		    });

		});
		

		_.bindAll(this, 'loadMatrizExcepciones', 'onAnteriorClick', 'onSiguienteClick', 'clear','onDelFilArt');
		self.crearFiltros();
		self.loadMatrizExcepciones();
	},
	render : function(event) {
		this.$("#tablaMatrizExcepciones").append(this.grid.render().el);
		return this;
	},
	events : {
		"click #anterior" : "onAnteriorClick",
		"click #siguiente" : "onSiguienteClick",
		"click #delInputBuscarArtPaso4" : "onDelFilArt",
		"input #inputBuscarArtPaso4" : "buscarArticulo",
	},
	close : function() {
		this.modelBinder.unbind();
		this.collectionBinder.unbind();
		this.off();
		this.undelegateEvents();
		this.remove();
	},
	crearFiltros : function(){
		var self = this; 
		
		var clientSideFilter = new Backgrid.Extension.ClientSideFilter({
			  collection: self.customCollection,
			  name: "inputBuscarTdaPaso4",
			  placeholder: "Buscar tienda",
			  // The model fields to search for matches
			  fields: ['descTienda'],
			  // How long to wait after typing has stopped before searching can start
			  wait: 150
			});

		$("#contenedorFiltrosPaso4").prepend(clientSideFilter.render().el);
		

	},
	buscarArticulo : function(event) {
		var self = this;
		var $table = $('#tablaMatrizExcepciones');
		//Se obtiene valor ingresado
		var input = $('#inputBuscarArtPaso4').val();
		input = input.toUpperCase();
		if (input != ""){
			$("#delInputBuscarArtPaso4").css("display", "block");
			var colMatchIndex = null;
			//Se itera a traves de las columnas
			for (var i = 0; i< self.showCols.length; i++){
				var colName = "articulo";
				colName = colName.concat((i+1).toString());
				var column = self.grid.columns.where({ name: colName });
				columnLabel = column[0].attributes.label;
				//Si el label de la columna empata con el valor ingresado se guarda el numero de la columna
				if (columnLabel.search(input) != -1){
					colMatchIndex = i;
					i= self.showCols.length;
				}
			}

			//Si alguna columna empato se muestra el ColSet de dicha columna
			if (colMatchIndex != null){
				var newColSet =  Math.floor(colMatchIndex / self.colSetLength);
				self.showColSet(newColSet);
			}
		}
		else{
			self.showColSet(0);
		}
		
		
	}, highlightSearchedArts : function(){
		var self = this;
		var $table = $('#tablaMatrizExcepciones');
		//Se obtiene valor ingresado
		var input = $('#inputBuscarArtPaso4').val();
		input = input.toUpperCase();
		if (input != ""){
			//Se itera a traves de las columnas
			for (var i = 0; i< self.showCols.length; i++){
				var colName = "articulo";
				colName = colName.concat((i+1).toString());
				var column = self.grid.columns.where({ name: colName });
				columnLabel = column[0].attributes.label;
				//Si el label de la columna empata con el valor ingresado se guarda el numero de la columna
				if (columnLabel.search(input) != -1){
					$('th:eq('+(i+4)+')', $table).css('background-color', 'yellow');
				}
			}
		}
		
	},
	loadMatrizExcepciones : function() {
		var self = this;
		self.clear();
		self.maskEl.mask("Cargando...");
		
		self.excepciones.fetch({
			data : {
				'plaza.id' : self.pedido.get('plaza.id'),
				'consulta' : 'C1',
				'referencia' : self.pedido.get('referencia')
			},
			success : function(collection, response, options) {
				self.addDynmicColumns(response);
				self.excepciones.fetch({
					data : {
						'plaza.id' : self.pedido.get('plaza.id'),
						'consulta' : 'C2',
						'referencia' : self.pedido.get('referencia')
					},
					success : function(collection, response, options) {
						self.populateDynamicColumns(response);
						self.showColSet(self.currentColSet);
						self.render();
						self.maskEl.unmask();
					},
					error : function() {
						self.maskEl.unmask();
					}
				});
			},
			error : function() {
				self.maskEl.unmask();
			}
		});
		
		
	},
	onAnteriorClick : function(e, callback) {
		var self = this;
		self.maskEl.mask("Cargando...");
		setTimeout(function(){
			var minColset = 0;
			if (self.currentColSet > minColset){
				self.currentColSet--;
				self.updateShowCols(self.currentColSet);
				self.showColSet(self.currentColSet);
			}
			self.maskEl.unmask();
		}, 1);

	},
	onDelFilArt: function(e, callback) {
		var self = this;
		$('#inputBuscarArtPaso4').val('');
		$("#delInputBuscarArtPaso4").css("display", "none");
		self.showColSet(0);

	},
	onSiguienteClick : function(e, callback) {
		var self = this;
		self.maskEl.mask("Cargando...");
		setTimeout(function(){
			var maxColSet = Math.ceil(self.numArticulos/self.colSetLength);
			maxColSet--;
			if (self.currentColSet < maxColSet){
				self.currentColSet++;
				self.updateShowCols(self.currentColSet);
				self.showColSet(self.currentColSet);
			}
			self.maskEl.unmask();	
		}, 1);
		
	},
	onGuardarClick : function(e, callback) {
		//alert('entroo');
		var self = this;
		var errores = 0;
		if (self.dataToSend.length >0){
			//alert('entroo22222');
			self.maskEl.mask("Guardando...");
			for (var i = 0; i <self.dataToSend.length; i++){
				var excep = new merlinwizard.Excepcions({'referencia' : self.pedido.get('referencia'),
														'idArticulo' : self.dataToSend[i].idArticulo,
														'valueArticulo' : self.dataToSend[i].value,
														'idTienda' : self.dataToSend[i].idTienda});
				//console.log(excep.attributes);
				excep.save(excep.attributes,{
	 				 success:function(model, response, options){}, error:function(model, response, options){ errores = errores + 1;}});
			}
			self.maskEl.unmask();
			if (errores > 0)
			{
				jQuery('#wizard3').smartWizard('showMessage','Hubo un error al intentar grabar, intente de nuevo.');
			}
			else
			{
				jQuery('#wizard3').smartWizard('showMessage','Las excepciones fueron grabadas con �xito.');
				if(callback){
					callback();
				}
			}
		}
		else
		{
			if(callback){
				callback();
			}
		}
	},
	addDynmicColumns : function(response) {
		var self = this;
		self.numArticulos = response.length;
		for (var i = 0; i <  response.length; i++){
			var colLabel = response[i].nameArticulo; 
			var colName = "articulo";
			colName = colName.concat((i+1).toString());
			self.grid.insertColumn([{
				name: colName,
				label: colLabel,
				editable: false,
				sortable: false,
				renderable :false,
				cell: 'integer'
			}]);
			self.relArtColArtId[colName] = response[i].idArticulo;
			self.showCols.push(true); 
			
		}
		self.updateShowCols(self.currentColSet);
	},
	populateDynamicColumns : function(response) {
		var self = this;
		for (var i = 0; i < response.length; i++){
			var arrDataArticulos = response[i].arrDataArticulos;
			arrDataArticulos = arrDataArticulos.split("|");
			delete response[i].arrDataArticulos;
			for (var j = 0; j < arrDataArticulos.length-1; j++){
				var colName = "articulo";
				colName = colName.concat((j+1).toString());
				response[i][colName] = parseInt(arrDataArticulos[j]);
			}
		}
		self.customCollection.reset(response);

	},
	updateShowCols : function(columnSet) {
		var self = this;
		var startIndex = (columnSet*self.colSetLength);
		var endIndex = startIndex+(self.colSetLength-1);
		for (var i = 0; i < self.showCols.length; i++){
			if (i>=startIndex &&i<=endIndex){
				self.showCols[i] = true; 
			}
			else{
				self.showCols[i] = false; 
			}
			
		}
	},
	showColSet : function(columnSet) {
		var self = this;
		self.updateShowCols(columnSet);
		
		var remainder =  self.showCols.length % self.colSetLength;
		var numColumns = self.showCols.length;
		if (remainder != 0){
			numColumns = numColumns + (5-remainder);
		}
		if (self.colPadding ==true){
			var idCol = self.grid.columns.where({ name: "padding" });
			for (var i = 0; i< idCol.length; i++){
				self.grid.removeColumn(idCol);
			}
			self.colPadding =false;
		}
		for (var i = 0; i< numColumns; i++){
			var colName = "articulo";
			colName = colName.concat((i+1).toString());
			if (i < self.showCols.length){
				var idCol = self.grid.columns.where({ name: colName });
				var colLabel = idCol[0].attributes.label;
				if (self.showCols[i] == true){
					self.grid.removeColumn(idCol);
					self.grid.insertColumn([{
						name: colName,
						//label: colName,
						label: colLabel,
						renderable: true,
						editable: true,
						sortable: false,
						cell: 'integer'
					}]);
					
				}
				else{
					self.grid.removeColumn(idCol);
					self.grid.insertColumn([{
						name: colName,
						//label: colName,
						label: colLabel,
						renderable: false,
						editable: true,
						sortable: false,
						cell: 'integer'
					}]);
				}
			}else{
				var maxColSet = Math.ceil(self.numArticulos/self.colSetLength);
				maxColSet--;
				if (columnSet == maxColSet ){
					self.colPadding =true;
					self.grid.insertColumn([{
						name: "padding",
						//label: colName,
						//label: "padding",
						label: "",
						renderable: true,
						editable: false,
						sortable: false,
						cell: 'string'
					}]);
				}
				
			}
			
		}
		
		self.highlightSearchedArts();
		self.render();
		

	},
	clear : function() {
		var self = this;
		//self.excepciones.reset();
		//self.grid = undefined;
		self.showCols = [];
		self.currentColSet = 0;
		self.colSetLength = 5;
		self.relArtColArtId= {};
		self.dataToSend = [];
		//self.colPadding= false;
		//console.log(self.numArticulos);
		for (var i = 0; i< self.numArticulos; i++){
			var colName = "articulo";
			colName = colName.concat((i+1).toString());
			var idCol = self.grid.columns.where({ name: colName });
			self.grid.removeColumn(idCol);			
		}
	}
	
});