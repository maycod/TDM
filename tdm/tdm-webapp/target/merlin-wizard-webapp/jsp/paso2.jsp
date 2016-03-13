
<div class="row"
	style="border-bottom: 4px solid rgba(17, 53, 26, 0.6); margin-bottom: 10px;">
	<div class="span12" style="margin-bottom: 15px;">
		<div class="span6"
			style="border-right: 2px solid rgba(17, 53, 26, 0.6); width: 480px;">
			<div>
				<label for="estComercialCombo">Estructura Comercial:</label>
			</div>
			<div id="jqxTree"></div>
		</div>
		<div class="span5" style="margin-left: 35px;">
			<div>
				<label for="perfilesTdaCombo">Estructura Perfil de Tiendas:</label>
			</div>
			<div>

				<select id="perfilesTdaCombo" class="selectpicker" name="id"
					size="15" style="width: 100%; height: 105px; margin-bottom: 3px;">
				</select>

			</div>
		</div>
	</div>
</div>
<div class="row" id="detalleTda"
	style="background-color: white; display: block; min-height: 200px">

	<div id="tablasTiendasDisp" class="span6">

		<div style="vertical-align: middle; display: table-cell;">
			<label for="inputBuscarTdaPaso2" style="width: 40px;">Buscar:</label>
			 <div class="span4" id="contenedorFiltrosPaso2">
				<!-- Textbox dinamico creado en js -->
			 </div>
		</div>
		<div>
			<label class="control-label"
				style="width: 155px; padding-right: 0px; font-size: 16px;">Tiendas
				Encontradas</label> <label class="control-label" id="contadorTdaDisp"
				style="width: 20px; font-size: 16px;"></label>
		</div>
		<div class="row"
			style="max-height: 150px; width: 100%; overflow-x: hidden"
			id="tablaTiendasDisp"></div>
	</div>
	<div id="btnAvanzar" class="span">
		<div style="margin-top: 70px;">
			<button type="button" class="btn btn-verde"
				style="width: 40px; margin-bottom: 15px; padding: 0px;"
				id="tiendaadd">&raquo;</button>
		</div>
		<div>
			<button type="button" class="btn btn-verde"
				style="width: 40px; padding: 0px;" id="tiendadel">&laquo;</button>
		</div>
	</div>

	<div id="detalleTiendasAsig" class="span4">
		<div>
			<label class="control-label"
				style="width: 170px; padding-right: 0px; font-size: 16px;">Tiendas
				Seleccionadas</label> <label class="control-label" id="contadorTdaAsig"
				style="width: 20px; font-size: 16px;"></label>
		</div>
		<div class="row" id="tablaTiendasAsig"
			style="max-height: 190px; width: 460px; overflow-x: hidden; padding-left: 0%;">
		</div>

	</div>


</div>



