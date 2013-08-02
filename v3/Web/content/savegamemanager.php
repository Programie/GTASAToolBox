<?php
echo "
	<table class='table_grid' width='100%' rules='all'>
		<thead>
			<tr class='table_header'>
				<th style='text-align:left;' onclick=\"SaveGameManager_Reload('file');\">".Language("File")."</th>
				<th style='text-align:left;' onclick=\"SaveGameManager_Reload('lastmission');\">".Language("Last mission")."</th>
				<th style='text-align:left;' onclick=\"SaveGameManager_Reload('clock');\">".Language("Time")."</th>
				<th style='text-align:left;' onclick=\"SaveGameManager_Reload('weekday');\">".Language("Week day")."</th>
			</tr>
		</thead>
		<tbody id='savegamemanager_tablebody'>
			<tr>
				<td colspan='4'></td>
			</tr>
		</tbody>
	</table>
";
?>