<?php
echo "
	<div style='position:absolute;left:0px;top:0px;right:0px;bottom:0px;overflow:auto;'>
		<table class='table_grid' width='100%' rules='all'>
			<thead>
				<tr class='table_header'>
					<th style='text-align:left;' onclick=\"Cheatlist_Reload('cheat');\">Cheat</th>
					<th style='text-align:left;' onclick=\"Cheatlist_Reload('description');\">".Language("Description")."</th>
					<th style='text-align:left;' onclick=\"Cheatlist_Reload('shortcut');\">".Language("Shortcut")."</th>
					<th></th>
				</tr>
			</thead>
			<tbody id='cheatlist_tablebody'>
				<tr>
					<td colspan='3'></td>
				</tr>
			</tbody>
		</table>
	</div>
";
?>