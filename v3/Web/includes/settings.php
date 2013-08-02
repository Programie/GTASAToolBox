<?php
function GetConfigValue($Group,$Name,$DefaultValue="")
{
	global $ConfigurationData;
	$Value=$ConfigurationData[$Group][$Name];
	if (!isset($Value))
	{
		$Value=$DefaultValue;
	}
	return $Value;
}

function LoadConfiguration()
{
	global $ConfigurationData;
	global $ConfigurationFile;
	$ConfigurationData=Ini_Read($ConfigurationFile);
}

function SaveConfiguration()
{
	global $ConfigurationData;
	global $ConfigurationFile;
	global $ConfigurationChanged;
	if ($ConfigurationChanged)
	{
		Ini_Write($ConfigurationFile,$ConfigurationData);
	}
}

function SetConfigValue($Group,$Name,$Value)
{
	global $ConfigurationData;
	global $ConfigurationChanged;
	$ConfigurationData[$Group][$Name]=$Value;
	$ConfigurationChanged=true;
}

$ConfigurationFile=ConfigPath."Settings.ini";
LoadConfiguration();
?>