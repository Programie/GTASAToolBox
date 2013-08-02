<?php
header("Content-Type:text/javascript");
?>
var Teleporter_MapZoomFactor;
var Teleporter_MapFile;
var Teleporter_MapLine=Array();
var Vehicles_CurrentRow;
var Vehicles_LastModelID=400;
var Vehicles_LastType="";
var Weapons_CurrentRow;
var Weapons_LastWeaponID=1;
var Weapons_LastType="";
var MemoryChanger_CurrentSelectionUpdater;
var MemoryChanger_CurrentSelection;
var Tools_InstallProcesses=0;
var MousePositionX;
var MousePositionY;
var CurrentPage="";
var IsIE=/*@cc_on!@*/false;
if (IsIE)
{
	if (confirm(unescape("<?php echo Language("This site may not work with Internet Explorer!\\nYou should use another browser like Mozilla Firefox (http://www.mozilla.com).\\n\\nDo you want to open the Mozilla website now?");?>")))
	{
		document.location="http://www.mozilla.com";
	}
}
document.onmousemove=GetMousePosition;
onload=OnLoad;
<?php
foreach ($Teleporter_MapLines as $Name)
{
	echo "Teleporter_MapLine['$Name']=Array(0,0);";
}
$Dir=scandir(WebPath."javascript");
foreach ($Dir as $File)
{
	if ($File!="." and $File!="..")
	{
		if (is_file(WebPath."javascript/$File"))
		{
			include(WebPath."javascript/$File");
		}
	}
}
?>