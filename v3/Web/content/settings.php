<?php
include(WebPath."includes/settings_controls.php");
$Languages=scandir(Root."Languages");
$LanguageList["en"]="English";
foreach ($Languages as $File)
{
	if (substr($File,0,1)!=".")
	{
		$FileInfo=pathinfo($File);
		$Info=Ini_Read(Root."Languages/$File","Info");
		$LanguageList[$FileInfo["filename"]]=$Info["Info"]["Name"];
	}
}
$Maps=scandir(HttpRoot."files/maps");
foreach ($Maps as $File)
{
	if (substr($File,0,1)!=".")
	{
		$Info=pathinfo($File);
		$MapList[$Info["filename"]]=$Info["filename"];
	}
}
for ($Level=1;$Level<=10;$Level++)
{
	$MapZoomLevelList[$Level]=$Level;
}
$ScreenshotImageTypes=array
(
	"bmp"=>"Windows Bitmap (bmp)",
	"jpg"=>"Jpeg (jpg)",
	"png"=>"Portable Network Graphic (png)"
);
$CheatSounds=scandir(Root."Sounds");
foreach ($CheatSounds as $File)
{
	if (substr($File,0,1)!=".")
	{
		$CheatSoundList[$File]=$File;
	}
}
$PathNames=array
(
	"GTASAUserFiles"=>"GTA San Andreas User Files"
);
$IsFirstFolder=true;

echo "
	<form id='settings_form' action='' method='post' onsubmit='return false;'>
		<div>
";
OpenSettingsFolder("general",Language("General"),true);
	AddSettingsList("language",Language("Language"),$LanguageList,GetConfigValue("General","Language"));
	AddSettingsList("screenshotimagetype",Language("Screenshot image type"),$ScreenshotImageTypes,GetConfigValue("General","ScreenshotImageType"));
	AddSettingsCheckbox("displaymessages",Language("Display in-game messages"),GetConfigValue("General","DisplayMessages"));
	AddSettingsCheckbox("disablesplashscreens",Language("Disable splash screens"),GetConfigValue("General","DisableSplashScreens"));
	AddSettingsCheckbox("firststart",Language("Show 'first start' window"),GetConfigValue("General","FirstStart",true));
CloseSettingsFolder();
OpenSettingsFolder("cheatsound",Language("Cheat sound"),false);
	AddSettingsCheckbox("cheatsound_use",Language("Activated"),GetConfigValue("CheatSound","Use"));
	AddSettingsList("cheatsound_sound",Language("Sound"),$CheatSoundList,GetConfigValue("CheatSound","Sound"),"Settings_SetCheatSoundPreview();","<input type='button' onclick='Settings_PlayCheatSound();' value='".Language("Preview")."'/>");
CloseSettingsFolder();
OpenSettingsFolder("autocheats",Language("Automatically activated cheats"),false,"Settings_AutoCheats_Reload();");
	echo "
		<table>
			<tbody id='settings_autocheats_tablebody'>
				<tr>
					<td></td>
				</tr>
			</tbody>
		</table>
		<table>
			<tr>
				<td class='settings_fieldlabel'><label for='settings_addcheat'>".Language("Add cheat").":</label></td>
				<td><input type='text' id='settings_addcheat'/></td>
				<td><input type='button' value='".Language("Add")."' onclick='Settings_AutoCheats_AddCheat();'/></td>
			</tr>
		</table>
	";
CloseSettingsFolder();
OpenSettingsFolder("teleporter","Teleporter",false);
	AddSettingsList("maptype",Language("Map"),$MapList,GetConfigValue("Teleporter","Map"));
	AddSettingsList("mapdefaultzoom",Language("Default map zoom level"),$MapZoomLevelList,GetConfigValue("Teleporter","DefaultZoomFactor"));
	OpenSettingsGroup(Language("Map marker colors"));
		AddSettingsColorSelector("teleporter_pointercolor_selection",Language("Selected position"),GetConfigValue("Teleporter_Pointer_Color","selection"));
		AddSettingsColorSelector("teleporter_pointercolor_current",Language("Current position"),GetConfigValue("Teleporter_Pointer_Color","current"));
		AddSettingsColorSelector("teleporter_pointercolor_ingame",Language("In-Game position"),GetConfigValue("Teleporter_Pointer_Color","ingame"));
	CloseSettingsGroup();
CloseSettingsFolder();
OpenSettingsFolder("memorychanger","Memory Changer",false);
	OpenSettingsGroup(Language("Auto update selected row"));
		AddSettingsCheckbox("memorychanger_autoupdate",Language("Activated"),GetConfigValue("MemoryChanger","AutoUpdate"));
		AddSettingsTextField("memorychanger_autoupdateinterval",Language("Interval")." (ms)",GetConfigValue("MemoryChanger","AutoUpdateInterval"));
	CLoseSettingsGroup();
CloseSettingsFolder();
OpenSettingsFolder("paths",Language("Directories"),false);
	AddSettingsTextField("paths_reg_gtasa","GTA San Andreas",rtrim(str_replace("/","\\",GetPath("gtasa")),"\\"),"300");
	foreach ($ConfigurationData["Paths"] as $Name=>$Value)
	{
		AddSettingsTextField("paths_ini_$Name",$PathNames[$Name],rtrim(str_replace("/","\\",$Value),"\\"),"300");
	}
CloseSettingsFolder();
echo "
		</div>
	</form>
	<embed src='dummy' autostart='false' id='settings_cheatsound_preview' enablejavascript='true'/>

";
?>