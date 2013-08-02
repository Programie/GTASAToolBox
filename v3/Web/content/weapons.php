<?php
echo "
	<div style='position:absolute;left:0px;top:0px;right:400px;bottom:0px;overflow:auto;'>
		<table class='table_grid' width='100%' rules='all'>
			<thead>
				<tr class='table_header'>
					<th style='text-align:left;' onclick=\"Weapons_Reload('number','last');\">".Language("Number")."</th>
					<th style='text-align:left;' onclick=\"Weapons_Reload('name','last');\">Name</th>
					<th style='text-align:left;' onclick=\"Weapons_Reload('modelid','last');\">Model ID</th>
					<th style='text-align:left;' onclick=\"Weapons_Reload('slot','last');\">Slot</th>
					<th style='text-align:left;' onclick=\"Weapons_Reload('ammoinclip','last');\">".Language("Ammo in clip")."</th>
					<th style='text-align:left;' onclick=\"Weapons_Reload('totalammo','last');\">".Language("Total ammo")."</th>
					<th></th>
				</tr>
			</thead>
			<tbody id='weapons_tablebody'>
				<tr>
					<td colspan='7'></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div style='position:absolute;top:0px;right:0px;bottom:350px;width:400px;overflow:auto;'>
		<table class='table_grid' width='100%' rules='all'>
			<thead>
				<tr class='table_header'>
					<th style='text-align:left;'>Name</th>
					<th style='text-align:left;'>".Language("Value")."</th>
				</tr>
			</thead>
			<tbody id='weapons_infotable'>
				<tr>
					<td colspan='2'></td>
				</tr>
			</tbody>
		</table>
	</div>
	<table style='position:absolute;right:0px;bottom:0px;width:400px;height:350px;overflow:auto;' cellpadding='0' cellspacing='0'>
		<tr>
			<td align='center'><img id='weapons_picture' src='' alt='".Language("Picture")."'/></td>
		</tr>
	</table>
";
?>