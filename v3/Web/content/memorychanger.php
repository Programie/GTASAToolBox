<?php
echo "
	<table class='table_grid' width='100%' rules='all'>
		<thead>
			<tr class='table_header'>
				<th style='text-align:left;' onclick=\"MemoryChanger_Reload('id');\">#</th>
				<th style='text-align:left;' onclick=\"MemoryChanger_Reload('name');\">Name</th>
				<th style='text-align:left;' onclick=\"MemoryChanger_Reload('address');\">".Language("Address")."</th>
				<th style='text-align:left;' onclick=\"MemoryChanger_Reload('type');\">".Language("Type")."</th>
				<th style='text-align:left;' onclick=\"MemoryChanger_Reload('size');\">".Language("Size")."</th>
				<th style='text-align:left;'>".Language("Current value")."</th>
				<th style='text-align:left;' onclick=\"MemoryChanger_Reload('lastsetvalue');\">".Language("Last set value")."</th>
			</tr>
		</thead>
		<tbody id='memorychanger_tablebody'>
			<tr>
				<td colspan='5'></td>
			</tr>
		</tbody>
	</table>
";
?>