<?php
echo "
	<div style='position:absolute;left:0px;top:0px;right:600px;bottom:0px;overflow:auto;'>
		<table class='table_grid' width='100%' rules='all'>
			<thead>
				<tr class='table_header'>
					<th style='text-align:left;' onclick=\"Teleporter_Reload('id');\">ID</th>
					<th style='text-align:left;' onclick=\"Teleporter_Reload('description');\">".Language("Description")."</th>
					<th style='text-align:left;' onclick=\"Teleporter_Reload('posx');\">X</th>
					<th style='text-align:left;' onclick=\"Teleporter_Reload('posy');\">Y</th>
					<th style='text-align:left;' onclick=\"Teleporter_Reload('posz');\">Z</th>
					<th style='text-align:left;' onclick=\"Teleporter_Reload('interior');\">Interior</th>
					<th></th>
				</tr>
			</thead>
			<tbody id='teleporter_tablebody'>
				<tr>
					<td colspan='7'></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div style='position:absolute;top:0px;right:0px;bottom:0px;width:600px;'>
		<div id='teleporter_maparea' style='position:absolute;left:0px;top:0px;right:0px;bottom:0px;overflow:auto;'>
			<img id='teleporter_mapimage' src='' onclick='Teleporter_MapClick();' alt='Map' style='cursor:crosshair;'/>
";
foreach ($Teleporter_MapLines as $Name)
{
	echo "
		<div id='teleporter_mapline_".$Name."_x' style='position:absolute;top:0px;width:2px;background-color:#".GetConfigValue("Teleporter_Pointer_Color",$Name,"FF0000").";display:none;'></div>
		<div id='teleporter_mapline_".$Name."_y' style='position:absolute;left:0px;height:2px;background-color:#".GetConfigValue("Teleporter_Pointer_Color",$Name,"FF0000").";display:none;'></div>
	";
}
echo "
		</div>
		<div style='position:absolute;left:10px;top:10px;'>
			<div onclick=\"Teleporter_ZoomMap(1);\" style='position:absolute;left:0px;top:0px;width:24px;height:24px;background-image:url(files/zoom_in.png);cursor:pointer;'></div>
			<div onclick=\"Teleporter_ZoomMap(-1);\" style='position:absolute;left:40px;top:0px;width:24px;height:24px;background-image:url(files/zoom_out.png);cursor:pointer;'></div>
		</div>
	</div>
";
?>