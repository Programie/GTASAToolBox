<?php
echo "
	<form action='' onsubmit='Teleporter_AddEditPlace();return false;'>
		<div>
			<input type='hidden' id='dialog_teleporter_edit_oldcheat'/>
			<table style='padding:10px;border:1px solid #C0C0C0;background-color:#FFFFFF;'>
				<tr>
					<td><label for='dialog_teleporter_edit_id'>ID:</label></td>
					<td><input type='text' id='dialog_teleporter_edit_id' class='teleporter_edit_inputfield' disabled='disabled'/></td>
				</tr>
				<tr>
					<td><label for='dialog_teleporter_edit_description'>".Language("Description").":</label></td>
					<td><input type='text' id='dialog_teleporter_edit_description' class='teleporter_edit_inputfield'/></td>
				</tr>
				<tr>
					<td><label for='dialog_teleporter_edit_posx'>Position:</label></td>
					<td>
						<input type='text' id='dialog_teleporter_edit_posx' style='width:80px;'/>
						&nbsp;<label for='dialog_teleporter_edit_posy'>x</label>&nbsp;
						<input type='text' id='dialog_teleporter_edit_posy' style='width:80px;'/>
						&nbsp;<label for='dialog_teleporter_edit_posz'>x</label>&nbsp;
						<input type='text' id='dialog_teleporter_edit_posz' style='width:80px;'/>
					</td>
				</tr>
				<tr>
					<td><label for='dialog_teleporter_edit_interior'>Interior:</label></td>
					<td>
						<select id='dialog_teleporter_edit_interior' class='teleporter_edit_inputfield'>
							<option value='-1'>".Language("Do not change")."</option>
							<option value='0'>San Andreas</option>
";
for ($Interior=1;$Interior<=18;$Interior++)
{
	echo "<option value='$Interior'>Interior $Interior</option>";
}
echo "
						</select>
					</td>
				</tr>
				<tr>
					<td colspan='2' align='right'><input type='submit' value='OK'/></td>
				</tr>
			</table>
		</div>
	</form>
";
?>