<?php
function AddSettingsCheckbox($Name,$Title,$State,$AdditionalColumn="")
{
	global $TableOpened;
	if ($TableOpened<=0)
	{
		OpenSettingsTable();
	}
	if ($State)
	{
		$Checked="checked='checked'";
	}
	echo "
		<tr>
			<td class='settings_fieldlabel'><label for='settings_$Name'>$Title:</label></td>
			<td><input type='checkbox' id='settings_$Name' value='1' $Checked/></td>
	";
	if ($AdditionalColumn)
	{
		echo "<td>$AdditionalColumn</td>";
	}
	echo "</tr>";
}

function AddSettingsColorSelector($Name,$Title,$Value,$AdditionalColumn="")
{
	global $TableOpened;
	if ($TableOpened<=0)
	{
		OpenSettingsTable();
	}
	echo "
		<tr>
			<td class='settings_fieldlabel'><label for='settings_$Name'>$Title:</label></td>
			<td><input type='text' id='settings_$Name' class='colorselector' value='$Value'/></td>
	";
	if ($AdditionalColumn)
	{
		echo "<td>$AdditionalColumn</td>";
	}
	echo "</tr>";
}

function AddSettingsList($Name,$Title,$List,$SelectedValue,$OnChange="",$AdditionalColumn="")
{
	global $TableOpened;
	if ($TableOpened<=0)
	{
		OpenSettingsTable();
	}
	echo "
		<tr>
			<td class='settings_fieldlabel'><label for='settings_$Name'>$Title:</label></td>
			<td>
				<select id='settings_$Name' onchange='$OnChange'>
	";
	foreach ($List as $ItemValue=>$ItemText)
	{
		if ($ItemValue==$SelectedValue)
		{
			$Selected="selected='selected'";
		}
		else
		{
			$Selected="";
		}
		echo "<option value='$ItemValue' $Selected>$ItemText</option>";
	}
	echo "
				</select>
			</td>
	";
	if ($AdditionalColumn)
	{
		echo "<td>$AdditionalColumn</td>";
	}
	echo "</tr>";
}

function AddSettingsTextField($Name,$Title,$Value,$Width="",$AdditionalColumn="")
{
	global $TableOpened;
	if ($TableOpened<=0)
	{
		OpenSettingsTable();
	}
	if ($Width)
	{
		$Style.="width:".$Width."px;";
	}
	if ($Style)
	{
		$Style="style='$Style'";
	}
	echo "
		<tr>
			<td class='settings_fieldlabel'><label for='settings_$Name'>$Title:</label></td>
			<td><input type='text' id='settings_$Name' value='$Value' $Style/></td>
	";
	if ($AdditionalColumn)
	{
		echo "<td>$AdditionalColumn</td>";
	}
	echo "</tr>";
}

function CloseSettingsFolder()
{
	global $FolderOpened;
	if ($FolderOpened>0)
	{
		CloseSettingsGroup();
		CloseSettingsTable();
		echo "
				</div>
			</fieldset>
		";
		$FolderOpened--;
	}
}

function CloseSettingsGroup()
{
	global $GroupOpened;
	if ($GroupOpened>0)
	{
		CloseSettingsTable();
		echo "</fieldset>";
		$GroupOpened--;
	}
}

function CloseSettingsTable()
{
	global $TableOpened;
	if ($TableOpened>0)
	{
		echo "</table>";
		$TableOpened--;
	}
}

function OpenSettingsFolder($Name,$Title,$Show,$OnClick="")
{
	global $FolderOpened;
	CloseSettingsFolder();
	if ($Show)
	{
		$Show="block";
		$State="&lt;&lt;";
		$Title2=Language("Click to fold");
	}
	else
	{
		$Show="none";
		$State="&gt;&gt;";
		$Title2=Language("Click to unfold");
	}
	global $IsFirstFolder;
	if ($IsFirstFolder)
	{
		$IsFirstFolder=false;
	}
	else
	{
		echo "<br />";
	}
	echo "
		<fieldset>
			<legend id='settings_folder_$Name' style='font-size:14px;font-weight:bold;cursor:pointer;' onclick=\"Settings_ToggleFold('$Name');$OnClick\" title='$Title2'>$Title $State</legend>
			<div id='settings_content_$Name' style='display:$Show;'>
	";
	$FolderOpened++;
}

function OpenSettingsGroup($Title)
{
	global $GroupOpened;
	global $FolderOpened;
	if ($FolderOpened<=0)
	{
		OpenSettingsFolder();
	}
	CloseSettingsTable();
	echo "
		<fieldset>
			<legend><b>$Title</b></legend>
	";
	$GroupOpened++;
}

function OpenSettingsTable()
{
	global $TableOpened;
	global $FolderOpened;
	if ($FolderOpened<=0)
	{
		OpenSettingsFolder();
	}
	echo "<table>";
	$TableOpened++;
}
?>