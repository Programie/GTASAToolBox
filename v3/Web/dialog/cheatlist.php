<?php
echo "
	<form action='' onsubmit='Cheatlist_AddEditCheat();return false;'>
		<div>
			<input type='hidden' id='dialog_cheatlist_edit_oldcheat'/>
			<table style='padding:10px;border:1px solid #C0C0C0;background-color:#FFFFFF;'>
				<tr>
					<td><label for='dialog_cheatlist_edit_cheat'>Cheat:</label></td>
					<td><input type='text' id='dialog_cheatlist_edit_cheat' class='cheatlist_edit_inputfield'/></td>
				</tr>
				<tr>
					<td><label for='dialog_cheatlist_edit_description'>".Language("Description").":</label></td>
					<td><input type='text' id='dialog_cheatlist_edit_description' class='cheatlist_edit_inputfield'/></td>
				</tr>
				<tr>
					<td><label for='dialog_cheatlist_edit_shortcut_key'>".Language("Shortcut").":</label></td>
					<td>
						<input type='checkbox' id='dialog_cheatlist_edit_shortcut_ctrl'/><label for='dialog_cheatlist_edit_shortcut_ctrl' id='dialog_cheatlist_edit_shortcut_ctrl_label'>".Language("Ctrl")."</label>
						<input type='checkbox' id='dialog_cheatlist_edit_shortcut_shift'/><label for='dialog_cheatlist_edit_shortcut_shift' id='dialog_cheatlist_edit_shortcut_shift_label'>".Language("Shift")."</label>
						<input type='checkbox' id='dialog_cheatlist_edit_shortcut_alt'/><label for='dialog_cheatlist_edit_shortcut_alt' id='dialog_cheatlist_edit_shortcut_alt_label'>Alt</label>
						<select id='dialog_cheatlist_edit_shortcut_key' onchange=\"Cheatlist_CheckShortcutSelection();\">
							<option value=''>".Language("No shortcut")."</option>
";
for ($Char=65;$Char<=90;$Char++)
{
	echo "<option value='$Char'>".chr($Char)."</option>";
}
for ($Char=48;$Char<=57;$Char++)
{
	echo "<option value='$Char'>".chr($Char)."</option>";
}
for ($Char=96;$Char<=105;$Char++)
{
	echo "<option value='$Char'>NumPad ".($Char-96)."</option>";
}
for ($Char=112;$Char<=135;$Char++)
{
	echo "<option value='$Char'>F".($Char-111)."</option>";
}
echo "
							<option value='46'>".Language("Del")."</option>
							<option value='45'>".Language("Insrt")."</option>
							<option value='19'>Pause</option>
							<option value='42'>".Language("Prnt")."</option>
						</select>
					</td>
				</tr>
				<tr>
					<td id='dialog_cheatlist_edit_existingcheatsdiv' colspan='2' style='display:none;'>
						<div style='width:100%;height:150px;border:1px solid #C0C0C0;overflow:auto;'>
							<table width='100%' rules='all' class='table_grid'>
								<thead>
									<tr class='table_header'>
										<th>Cheat</th>
										<th>".Language("Description")."</th>
									</tr>
								</thead>
								<tbody id='dialog_cheatlist_edit_existingcheats'>
									<tr>
										<td colspan='2'></td>
									</tr>
								</tbody>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan='2' align='right'>
						<input type='button' onclick='Cheatlist_ToggleShowExistingCheats();' value='".Language("Show cheats")."'/>
						<input type='submit' value='OK'/>
					</td>
				</tr>
			</table>
		</div>
	</form>
";
?>