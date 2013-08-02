<?php
echo "
	<table cellpadding='0' cellspacing='0'>
		<tr>
			<td>
				<table id='savegamemanager_backups_toolbar' cellpadding='0' cellspacing='0'>
					<tr>
						<td></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table width='100%' rules='all' class='table_grid'>
					<thead>
						<tr class='table_header'>
							<th>".Language("Time")."</th>
							<th>".Language("Files")."</th>
							<th>".Language("Size")."</th>
							<th>".Language("Comment")."</th>
							<th></th>
						</tr>
					</thead>
					<tbody id='savegamemanager_backups_tablebody'>
						<tr>
							<td colspan='4'></td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</table>
";
?>