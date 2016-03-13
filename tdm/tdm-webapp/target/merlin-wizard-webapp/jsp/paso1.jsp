<div class="row" style=" margin: 0px 20px 25px 20px; padding: 10px 20px; border-bottom: 2px solid #006650;">                                	
		<button type="button" class="btn btn-verde" id="agregarNuevo"> Nuevo </button>
		  	<span style="margin: 0 15px;">&oacute;</span>
		<input type="text" id="referenexiste" name="referenexiste" style="width:300px; height: 29px; margin-bottom: 0px; margin-right: 10px;" placeholder="Teclea el ID del pedido" maxlength="20">
		<button type="button" class="btn btn-verde" id="buscarExistente"> Existente </button>
		</br>	
</div>

 <div class="row" id="detallePedido" style="width: 970px; margin: auto;">
	 <div class="span6" style="border-right: 1px solid rgba(17, 53, 26, 0.6); border-style: solid;">
		<div class="form-group">
			<label for="inputReferencia">ID:</label>
			<input type="text" class="form-control" id="inputReferencia" name="referencia" placeholder="" required="required" value=""></input>
			<input type="hidden" class="form-control" id="inputID" name="id"></input>
		</div>
		<div class="form-group">
		    <label for="plazasCombo">Plaza: <span class="red">*</span></label>
			    <select id="plazasCombo" class="selectpicker" name="plaza">
					<option value="">--Seleccione plaza--</option>
				</select>
	    </div>
	     <div class="form-group">
			<label for="inputDescPedido">Descripci&oacute;n del Pedido: <span class="red">*</span></label>
			 <textarea class="form-control" id="inputDescPedido" name="descripcion" placeholder="" required="required" maxlength="100"></textarea>
		</div>
	     <div class="form-group">
			<label for="inputActivoPedido">Activo:</label> 
			<input type="checkbox" id="inputActivoPedido" name="activo" checked>
		</div>
	 </div>	  
	 <div class="span6" >
   
      	<div class="form-group">
		    <label for="tiposPedidoCombo">Tipo de Pedido:</label>
			    <select id="tiposPedidoCombo" name="tipoPedido">
					<option value="1">PEDIDO CENTRALIZADO</option>
				</select>	
	    </div>
    	<div class="form-group">
			<label for="inputEstatus">Estatus:</label>
			 <input class="form-control" id="inputEstatus" name="estatus" value="" placeholder="" required="required" maxlength="20"></input>
			 <input type="hidden" class="form-control" id="inputEstatusClav" name="estatusclav"></input>
		</div>
		<div class="form-group" >
			<label for="inputFechaPedido" >Fecha del Pedido: <span class="red">*</span></label>
			<div class="input-append date" id="divFechaPedido" data-date="29/09/2015" data-date-format="dd/mm/yyyy">
  				<input class="input-small" id="inputFechaPedido" type="text" readonly name="fechapedido">
  				<span class="add-on"><i class="icon-calendar"></i></span>
			</div>
		</div>
    </div>
	<div class="row" >
			<div class="span12 text-center" style="margin-top: 25px; margin-left: 5px;">			                                	
				<span>
						  <span class="red">*</span> Campos requeridos
				</span>												
			</div>
	</div>	
</div>
