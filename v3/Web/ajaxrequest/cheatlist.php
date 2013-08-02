<?php
function CheatListSortCompare($Array1,$Array2)
{
	global $SortIndex;
	return strnatcmp($Array1[$SortIndex],$Array2[$SortIndex]);
}

function SortCheatList($CheatList)
{
	global $SortIndex;
	if (isset($_GET["sort"]))
	{
		switch ($_GET["sort"])
		{
			case "cheat":
				$SortIndex=0;
				break;
			case "description":
				$SortIndex=1;
				break;
			case "shortcut":
				$SortIndex=2;
				break;
			default:
				$SortIndex=0;
				break;
		}
		usort($CheatList,"CheatListSortCompare");
	}
	return $CheatList;
}

function LoadCheatList()
{
	global $CheatListFile;
	if (file_exists($CheatListFile))
	{
		$File=fopen($CheatListFile,"r");
		if ($File)
		{
			while (!feof($File))
			{
				$Line=str_replace("\n","",str_replace("\r","",fgets($File)));
				if ($Line)
				{
					if (substr($Line,0,1)!=";")
					{
						$Line=explode("\t",$Line);
						$CheatList[]=array($Line[0],$Line[1],$Line[2]);
					}
				}
			}
			fclose($File);
			return SortCheatList($CheatList);
		}
	}
}

function OutputCheatLine($Line)
{
	$ShortcutArray=explode("+",$Line[2]);
	$Shortcut="";
	for ($Key=0;$Key<count($ShortcutArray);$Key++)
	{
		if ($Shortcut)
		{
			$Shortcut.="+";
		}
		$Shortcut.=KeyMap($ShortcutArray[$Key]);
	}
	return utf8_encode("$Line[0]\t$Line[1]\t$Shortcut\n");
}

function SaveCheatList($CheatList)
{
	global $CheatListFile;
	$File=fopen($CheatListFile,"w");
	if ($File)
	{
		foreach ($CheatList as $Line)
		{
			fwrite($File,"$Line[0]\t$Line[1]\t$Line[2]\r\n");
		}
		fclose($File);
		return true;
	}
}

$CheatListFile=ConfigPath."Cheats.dat";
switch ($_GET["mode"])
{
	case "execute":
		$Interface=new CheatProcessor_Interface();
		$Interface->SendCheat($_GET["cheat"]);
		$Result=$Interface->GetResult();
		if ($Result==-1)
		{
			echo "5";
		}
		else
		{
			echo $Result;
		}
		$Interface->Close();
		break;
	case "getcheats":
		if (file_exists(ConfigPath."Cheats.info"))
		{
			$File=fopen(ConfigPath."Cheats.info","r");
			if ($File)
			{
				while (!feof($File))
				{
					$Line=explode("\t",str_replace("\n","",str_replace("\r","",fgets($File))));
					if (trim($Line[0]))
					{
						if (GetConfigValue("General","Language")=="de")
						{
							$Text=$Line[2];
						}
						else
						{
							$Text=$Line[1];
						}
						echo utf8_encode("$Line[0]\t$Text\n");
					}
				}
				fclose($File);
			}
		}
		break;
	case "getlist":
		$CheatList=LoadCheatList();
		if (is_array($CheatList))
		{
			foreach ($CheatList as $Line)
			{
				echo OutputCheatLine($Line);
			}
		}
		break;
	case "removeallcheats":
		if (file_exists($CheatListFile))
		{
			unlink($CheatListFile);
		}
		echo "1";
		break;
	case "removecheat":
		$_GET["cheat"]=strtoupper(trim($_GET["cheat"]));
		if ($_GET["cheat"])
		{
			$CheatList=LoadCheatList();
			if (is_array($CheatList))
			{
				foreach ($CheatList as $Index=>$Line)
				{
					if (strtoupper($Line[0])==$_GET["cheat"])
					{
						unset($CheatList[$Index]);
						if (SaveCheatList($CheatList))
						{
							echo "1";
						}
						else
						{
							echo "2";
						}
						break;
					}
				}
			}
		}
		break;
	case "setcheat":
		$_GET["oldcheat"]=trim(stripslashes($_GET["oldcheat"]));
		$_GET["newcheat"]=trim(stripslashes($_GET["newcheat"]));
		$_GET["description"]=trim(stripslashes($_GET["description"]));
		if ($_GET["newcheat"])
		{
			if (!$_GET["oldcheat"])
			{
				$AddCheat=true;
				$_GET["oldcheat"]=$_GET["newcheat"];
			}
			if ($_GET["shortcut_ctrl"])
			{
				if ($Shortcut)
				{
					$Shortcut.="+";
				}
				$Shortcut.="17";
			}
			if ($_GET["shortcut_shift"])
			{
				if ($Shortcut)
				{
					$Shortcut.="+";
				}
				$Shortcut.="16";
			}
			if ($_GET["shortcut_alt"])
			{
				if ($Shortcut)
				{
					$Shortcut.="+";
				}
				$Shortcut.="18";
			}
			if ($_GET["shortcut_key"])
			{
				if ($Shortcut)
				{
					$Shortcut.="+";
				}
				$Shortcut.=$_GET["shortcut_key"];
			}
			else
			{
				$Shortcut="";
			}
			$CheatData=array($_GET["newcheat"],$_GET["description"],$Shortcut);
			$CheatList=LoadCheatList();
			$ShortcutAlreadyUsed="";
			$Save=true;
			if (is_array($CheatList))
			{
				foreach ($CheatList as $Index=>$Line)
				{
					if ($Line[2] and $Line[2]==$Shortcut and strtoupper($Line[0])!=strtoupper($_GET["oldcheat"]))
					{
						$ShortcutAlreadyUsed=$Line[0];
					}
					if (strtoupper($Line[0])==strtoupper($_GET["oldcheat"]))
					{
						if ($AddCheat)
						{
							$Save=false;
							echo "3";
							break;
						}
						$CheatList[$Index]=$CheatData;
						$EditCheat=true;
					}
				}
			}
			if (!$EditCheat)
			{
				$CheatList[]=$CheatData;
			}
			if ($Save)
			{
				if ($ShortcutAlreadyUsed)
				{
					echo "4$ShortcutAlreadyUsed";
				}
				else
				{
					if (SaveCheatList(SortCheatList($CheatList)))
					{
						echo "1".OutputCheatLine($CheatData);
					}
					else
					{
						echo "2";
					}
				}
			}
		}
		else
		{
			echo "5";
		}
		break;
}
?>