<?php
echo "
	<div style='position:absolute;left:0px;top:0px;right:400px;bottom:0px;overflow:auto;'>
		<table class='table_grid' width='100%' rules='all'>
			<thead>
				<tr class='table_header'>
					<th style='text-align:left;' onclick=\"Vehicles_Reload('modelid','last');\">Model ID</th>
					<th style='text-align:left;' onclick=\"Vehicles_Reload('name','last');\">Name</th>
					<th style='text-align:left;' onclick=\"Vehicles_Reload('radio','last');\">Radio</th>
					<th style='text-align:left;' onclick=\"Vehicles_Reload('type','last');\">".Language("Type")."</th>
					<th></th>
				</tr>
			</thead>
			<tbody id='vehicles_tablebody'>
				<tr>
					<td colspan='5'></td>
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
			<tbody id='vehicles_infotable'>
				<tr>
					<td colspan='2'></td>
				</tr>
			</tbody>
		</table>
	</div>
	<table style='position:absolute;right:0px;bottom:0px;width:400px;height:350px;overflow:auto;' cellpadding='0' cellspacing='0'>
		<tr>
			<td align='center'><img id='vehicles_picture' src='' alt='".Language("Picture")."'/></td>
		</tr>
	</table>
";