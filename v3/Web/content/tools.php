<?php
echo "
	<div style='position:absolute;left:0px;top:0px;right:0px;bottom:150px;overflow:auto;'>
		<table id='tools_installedtools' style='margin-left:10px;' cellpadding='0' cellspacing='20'>
			<tr>
				<td></td>
			</tr>
		</table>
	</div>
	<div style='position:absolute;left:0px;bottom:0px;right:0px;height:150px;overflow:auto;'>
		<table width='100%' rules='all' class='table_grid'>
			<thead>
				<tr class='table_header'>
					<th onclick=\"Tools_DownloadableTools_Reload('name');\">Name</th>
					<th onclick=\"Tools_DownloadableTools_Reload('description');\">".Language("Description")."</th>
					<th onclick=\"Tools_DownloadableTools_Reload('author');\">".Language("Author")."</th>
					<th onclick=\"Tools_DownloadableTools_Reload('data');\">".Language("Date")."</th>
					<th align='right'><div id='tools_downloadabletools_progress' class='progress'></div></th>
				</tr>
			</thead>
			<tbody id='tools_downloadabletools'>
				<tr>
					<td colspan='5'></td>
				</tr>
			</tbody>
		</table>
	</div>
";
?>