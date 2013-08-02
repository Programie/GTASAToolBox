<?php
session_start();
$Root=dirname(dirname($_SERVER["DOCUMENT_ROOT"]));
if (!$Root)
{
	$Root=$argv[1];
}
if (!$Root)
{
	echo "Can not get root path!";
	exit;
}
define("Root",trim(str_replace("\\","/",$Root),"/")."/");
define("ConfigPath",Root."Config/");
define("WebPath",Root."Web/");
define("HttpRoot",WebPath."httproot/");
if ($_SERVER["SERVER_ADDR"]!=$_SERVER["REMOTE_ADDR"])
{
	$AddTitle=" @ ".$_ENV["COMPUTERNAME"];
	$RequireLogin=true;
}
define("PageTitle","GTA San Andreas ToolBox".$AddTitle);
$Teleporter_MapLines=array("selection","current","ingame");
include(WebPath."includes/ini.php");
include(WebPath."includes/settings.php");
$LanguageArray=Ini_Read(Root."Languages/".GetConfigValue("General","Language").".lang","Translation");
include(WebPath."includes/functions.php");
include(WebPath."includes/cheatprocessor_interface.php");
include(WebPath."includes/pages.php");
include(WebPath."includes/keymap.php");
include(WebPath."includes/checklogin.php");
if (!$ShowLogin)
{
	include(WebPath."includes/ajaxrequest.php");
}
if ($_GET["tool"])
{
	if ($ShowLogin)
	{
		header("HTTP/1.0 401 Authentication Required");
	}
	else
	{
		define("ToolRoot",HttpRoot."tools/".basename($_GET["tool"])."/");
		$File=ToolRoot."index.php";
		if (file_exists($File))
		{
			include($File);
		}
		else
		{
			header("HTTP/1.0 404 Not Found");
		}
	}
	SaveConfiguration();
	exit;
}
if (isset($_GET["getjs"]))
{
	include(WebPath."includes/javascript.php");
	SaveConfiguration();
	exit;
}
?>