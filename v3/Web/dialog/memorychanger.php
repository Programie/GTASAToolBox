<?php
echo "
	<form action='' onsubmit='MemoryChanger_AddEditAddress();return false;'>
		<div>
			<table style='padding:10px;border:1px solid #C0C0C0;background-color:#FFFFFF;'>
				<tr>
					<td><label for='dialog_memorychanger_edit_id'>ID:</label></td>
					<td align='right'><input type='text' id='dialog_memorychanger_edit_id' class='memorychanger_edit_inputfield' disabled='disabled'/></td>
					<td></td>
				</tr>
				<tr>
					<td><label for='dialog_memorychanger_edit_name'>Name:</label></td>
					<td align='right'><input type='text' id='dialog_memorychanger_edit_name' class='memorychanger_edit_inputfield'/></td>
					<td></td>
				</tr>
				<tr>
					<td><label for='dialog_memorychanger_edit_address'>".Language("Address").":</label></td>
					<td align='right'>0x<input type='text' id='dialog_memorychanger_edit_address' class='memorychanger_edit_inputfield'/></td>
					<td></td>
				</tr>
				<tr>
					<td><label for='dialog_memorychanger_edit_type'>".Language("Type").":</label></td>
					<td align='right'>
						<select id='dialog_memorychanger_edit_type' class='memorychanger_edit_inputfield' onchange='MemoryChanger_Dialog_CheckType();'>
							<option value='0'>Byte</option>
							<option value='1'>Word</option>
							<option value='2'>Long</option>
							<option value='3'>Float</option>
							<option value='4'>Quad</option>
							<option value='5'>String</option>
							<option value='6'>Double</option>
							<option value='7'>Character</option>
							<option value='8'>Array</option>
						</select>
					</td>
					<td><input type='text' id='dialog_memorychanger_edit_size' style='width:50px;' disabled='disabled'/></td>
				</tr>
				<tr>
					<td><label for='dialog_memorychanger_edit_value'>".Language("Value").":</label></td>
					<td align='right'><input type='text' id='dialog_memorychanger_edit_value' class='memorychanger_edit_inputfield' disabled='disabled'/></td>
					<td><input type='checkbox' id='dialog_memorychanger_edit_value_checkbox' onclick='MemoryChanger_Dialog_CheckValue();' value='1'/><label for='dialog_memorychanger_edit_value_checkbox'>".Language("Change")."</label></td>
				</tr>
				<tr>
					<td colspan='3' align='right'>
						<input type='submit' value='OK'/>
						<input type='button' onclick='MemoryChanger_HideEditDialog();' value='".Language("Cancel")."'/>
					</td>
				</tr>
			</table>
		</div>
	</form>
";