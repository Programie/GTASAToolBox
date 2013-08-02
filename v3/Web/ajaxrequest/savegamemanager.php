<?php
function ReadSaveGame($Path,$Slot)
{
	$File=$Path."/GTASAsf$Slot.b";
	if (file_exists($File))
	{
		$FileInfo=pathinfo($File);
		$File=fopen($File,"r");
		if ($File)
		{
			$WeekDayNames=array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
			fseek($File,9);
			$Name=ReadStringEx($File,100,0);
			fseek($File,139);
			$Hour=str_pad(ord(fread($File,1)),2,"0",STR_PAD_LEFT);
			$Minute=str_pad(ord(fread($File,1)),2,"0",STR_PAD_LEFT);
			$WeekDay=ord(fread($File,1));
			fclose($File);
			if ($WeekDay>=1 And $WeekDay<=7)
			{
				$WeekDay=Language($WeekDayNames[$WeekDay-1]);
			}
			else
			{
				$WeekDay="N/A";
			}
			echo $FileInfo["basename"]."\t$Name\t$Hour:$Minute\t$WeekDay\n";
		}
	}
}

switch ($_GET["mode"])
{
	case "getsavegame":
		$Path=GetPath("GTASAUserFiles");
		if ($_GET["slot"]>=1 and $_GET["slot"]<=8)
		{
			ReadSaveGame($Path,$_GET["slot"]);
		}
		else
		{
			for ($Slot=1;$Slot<=8;$Slot++)
			{
				ReadSaveGame($Path,$Slot);
			}
		}
		break;
	case "getsavegamebackups":
		$Path=Root."Backups/SaveGames";
		$BackupDir=scandir($Path);
		foreach ($BackupDir as $BackupTime)
		{
			if ($BackupTime!="." and $BackupTime!="..")
			{
				$Size=0;
				$Files=0;
				$Slots=scandir("$Path/$BackupTime");
				foreach ($Slots as $File)
				{
					if ($File!="." and $File!="..")
					{
						$Slot=preg_replace("/GTASAsf(.*).b/Usi","\\1",$File);
						if ($Slot>=1 and $Slot<=8)
						{
							$Size+=filesize("$Path/$BackupTime/$File");
							$Files++;
						}
					}
				}
				if ($Files)
				{
					$Info=Ini_Read("$Path/$BackupTime/Info.ini");
					$Info=$Info[""];
					echo date(GetConfigValue("DateTimeFormat","Date","d.m.Y")." ".GetConfigValue("DateTimeFormat","Time","H:i:s"),$BackupTime)."\t$Files\t".GetSize($Size)."\t".$Info["Comment"]."\n";
				}
			}
		}
		break;
}
?>