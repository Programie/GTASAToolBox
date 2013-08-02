<?php
function LoadAutoCheats()
{
	if (file_exists(ConfigPath."AutoCheats.dat"))
	{
		$File=fopen(ConfigPath."AutoCheats.dat","r");
		if ($File)
		{
			while (!feof($File))
			{
				$Line=trim(str_replace("\n","",str_replace("\r","",fgets($File))));
				if ($Line and substr($Line,0,1)!=";")
				{
					$AutoCheats[strtoupper($Line)]=true;
				}
			}
			fclose($File);
		}
	}
	return $AutoCheats;
}

function SaveAutoCheats($AutoCheats)
{
	$File=fopen(ConfigPath."AutoCheats.dat","w");
	if ($File)
	{
		foreach ($AutoCheats as $Cheat=>$InList)
		{
			if ($InList)
			{
				fwrite($File,$Cheat."\r\n");
			}
		}
	}
}

function SetConfigValue2($Group,$Name,$PostKey)
{
	if (isset($_POST["settings_".$PostKey]))
	{
		SetConfigValue($Group,$Name,stripslashes($_POST["settings_".$PostKey]));
	}
}

switch ($_GET["mode"])
{
	case "addautocheat":
		$AutoCheats=LoadAutoCheats();
		if ($AutoCheats[strtoupper($_GET["cheat"])])
		{
			echo "2";
		}
		else
		{
			$AutoCheats[strtoupper($_GET["cheat"])]=true;
			SaveAutoCheats($AutoCheats);
			echo "1";
		}
		break;
	case "getautocheats":
		$AutoCheats=LoadAutoCheats();
		if (is_array($AutoCheats))
		{
			foreach ($AutoCheats as $Cheat=>$InList)
			{
				echo $Cheat."\n";
			}
		}
		break;
	case "playcheatsound":
		$File=basename($_GET["file"]);
		if ($File)
		{
			$File=Root."Sounds/$File";
			if (file_exists($File))
			{
				$Info=pathinfo($File);
				header("Content-Type:audio/".$Info["extension"]);
				readfile($File);
			}
		}
		break;
	case "removeautocheat":
		$AutoCheats=LoadAutoCheats();
		if ($AutoCheats[strtoupper($_GET["cheat"])])
		{
			$AutoCheats[strtoupper($_GET["cheat"])]=false;
			SaveAutoCheats($AutoCheats);
			echo "1";
		}
		else
		{
			echo "2";
		}
		break;
	case "save":
		SetConfigValue2("General","Language","language");
		SetConfigValue2("General","ScreenshotImageType","screenshotimagetype");
		SetConfigValue2("General","DisplayMessages","displaymessages");
		SetConfigValue2("General","DisableSplashScreens","disablesplashscreens");
		SetConfigValue2("General","FirstStart","firststart");
		SetConfigValue2("CheatSound","Use","cheatsound_use");
		SetConfigValue2("CheatSound","Sound","cheatsound_sound");
		SetConfigValue2("Teleporter","Map","maptype");
		SetConfigValue2("Teleporter","DefaultZoomFactor","mapdefaultzoom");
		SetConfigValue2("Teleporter_Pointer_Color","selection","teleporter_pointercolor_selection");
		SetConfigValue2("Teleporter_Pointer_Color","current","teleporter_pointercolor_current");
		SetConfigValue2("Teleporter_Pointer_Color","ingame","teleporter_pointercolor_ingame");
		SetConfigValue2("MemoryChanger","AutoUpdate","memorychanger_autoupdate");
		SetConfigValue2("MemoryChanger","AutoUpdateInterval","memorychanger_autoupdateinterval");
		SetRegistryValue("HKEY_LOCAL_MACHINE\\SOFTWARE\\Rockstar Games\\GTA San Andreas\\Installation\\ExePath","REG_SZ","\"".rtrim(str_replace("/","\\",stripslashes($_POST["settings_paths_reg_gtasa"])))."\\gta_sa.exe\"");
		foreach ($_POST as $Name=>$Value)
		{
			$Name=explode("_",$Name,4);
			if ($Name[1]=="paths" and $Name[2]=="ini" and $Name[3])
			{
				$_POST[$Name]=rtrim(str_replace("/","\\",$Value),"\\");
				SetConfigValue2("Paths",$Name[3],$Name[1]."_".$Name[2]."_".$Name[3]);
			}
		}
		break;
}
?>