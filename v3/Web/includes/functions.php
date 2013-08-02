<?php
function DeleteDirectory($Path)
{
	$Dir=scandir($Path);
	foreach ($Dir as $Item)
	{
		if ($Item!="." and $Item!="..")
		{
			$Item=$Path."/".$Item;
			if (is_dir($Item))
			{
				DeleteDirectory($Item);
			}
			else
			{
				unlink($Item);
			}
		}
	}
	if (is_dir($Path))
	{
		rmdir($Path);
	}
}

function FormatDate($Date)
{
	return date(GetConfigValue("DateTimeFormat","Date","d.m.Y"),strtotime($Date));
}

function GetPathByID($PathID)
{
	global $PathIDs;
	if (!is_array($PathIDs))
	{
		$Ini=Ini_Read(ConfigPath."Paths.info");
		$PathIDs=$Ini[0];
	}
	return $PathIDs[$PathID];
}

function GetPath($Name)
{
	$Name=explode(" ",strtolower($Name),2);
	switch ($Name[0])
	{
		case "gtasa":
			$Path=dirname(str_replace("\"","",GetRegistryValue("HKEY_LOCAL_MACHINE\\SOFTWARE\\Rockstar Games\\GTA San Andreas\\Installation\\ExePath")))."/";
			break;
		case "gtasauserfiles":
			$Path=GetConfigValue("Paths","GTASAUserFiles",GetPathByID(5)."GTA San Andreas User Files");
			break;
		case "pathid":
			$Path=GetPathByID($Name[1]);
			break;
	}
	return rtrim(str_replace("/","\\",$Path),"\\")."\\";
}

function GetRegistryValue($Path)
{
	$Shell=new COM("WScript.Shell");
	return $Shell->RegRead($Path);
}

function GetSize($Size)
{
	$Format=array("Byte","KB","MB","GB","TB","PB","EB","ZB","YB");
	while ($Size>=1024 and $Index<count($Format)-1) 
	{
		$Size/=1024;
		$Index++;
	}
	return sprintf("%01.2f",$Size)." ".$Format[intval($Index)];
}

function Language($String)
{
	global $LanguageArray;
	$LangString=$LanguageArray["Translation"][$String];
	if ($LangString)
	{
		return $LangString;
	}
	else
	{
		return $String;
	}
}

function ReadLong($File)
{
	$Long=unpack("L",fread($File,4));
	return $Long[1];
}

function ReadStringEx($File,$MaxLength,$EndByte)
{
	for ($Byte=0;$Byte<$MaxLength;$Byte++)
	{
		$Char=fgets($File,2);
		if (ord($Char)==$EndByte)
		{
			break;
		}
		else
		{
			$String.=$Char;
		}
	}
	return $String;
}

function SetRegistryValue($Path,$Type,$Value)
{
	$Shell=new COM("WScript.Shell");
	return $Shell->RegWrite($Path,$Value,$Type);
}
