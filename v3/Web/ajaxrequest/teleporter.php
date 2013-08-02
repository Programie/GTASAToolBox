<?php
function TeleportListSortCompare($Array1,$Array2)
{
	global $SortIndex;
	return strnatcmp($Array1[$SortIndex],$Array2[$SortIndex]);
}

function SortTeleportList($TeleportList)
{
	global $SortIndex;
	switch ($_GET["sort"])
	{
		case "id":
			$SortIndex=0;
			break;
		case "description":
			$SortIndex=1;
			break;
		case "posx":
			$SortIndex=2;
			break;
		case "posy":
			$SortIndex=3;
			break;
		case "posz":
			$SortIndex=4;
			break;
		case "interior":
			$SortIndex=5;
			break;
		default:
			$SortIndex=0;
			break;
	}
	if (is_array($TeleportList))
	{
		usort($TeleportList,"TeleportListSortCompare");
	}
	return $TeleportList;
}

function LoadTeleportList()
{
	global $TeleportListFile;
	if (file_exists($TeleportListFile))
	{
		$File=fopen($TeleportListFile,"r");
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
						$TeleportList[]=array(strtoupper($Line[0]),$Line[1],$Line[2],$Line[3],$Line[4],$Line[5]);
					}
				}
			}
			fclose($File);
			return $TeleportList;
		}
	}
}

function OutputTeleportLine($Line)
{
	return utf8_encode("$Line[0]\t$Line[1]\t$Line[2]\t$Line[3]\t$Line[4]\t$Line[5]\n");
}

function SaveTeleportList($TeleportList)
{
	global $TeleportListFile;
	$File=fopen($TeleportListFile,"w");
	if ($File)
	{
		foreach ($TeleportList as $Line)
		{
			fwrite($File,"$Line[0]\t$Line[1]\t$Line[2]\t$Line[3]\t$Line[4]\t$Line[5]\r\n");
		}
		fclose($File);
		return true;
	}
}

$TeleportListFile=ConfigPath."Teleporter.dat";
switch ($_GET["mode"])
{
	case "getlist":
		$TeleportList=SortTeleportList(LoadTeleportList());
		if (is_array($TeleportList))
		{
			foreach ($TeleportList as $Line)
			{
				echo OutputTeleportLine($Line);
			}
		}
		break;
	case "map":
		$File="../Map".$_GET["type"].".jpg";
		if (file_exists($File))
		{
			readfile($File);
		}
		break;
	case "removeallplaces":
		if (file_exists($TeleportListFile))
		{
			unlink($TeleportListFile);
		}
		echo "1";
		break;
	case "removeplace":
		$_GET["id"]=trim($_GET["id"]);
		if ($_GET["id"])
		{
			$TeleportList=LoadTeleportList();
			if (is_array($TeleportList))
			{
				foreach ($TeleportList as $Index=>$Line)
				{
					if ($Line[0]==$_GET["id"])
					{
						unset($TeleportList[$Index]);
						$Found=true;
						if (SaveTeleportList($TeleportList))
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
			if (!$Found)
			{
				echo "3";
			}
		}
		break;
	case "setlocation":
		$_GET["id"]=trim($_GET["id"]);
		$_GET["description"]=trim(stripslashes($_GET["description"]));
		if ($_GET["posx"]=="" or $_GET["posy"]=="" or $_GET["posz"]=="")
		{
			echo "3";
		}
		else
		{
			$TeleportList=LoadTeleportList();
			if (!$_GET["id"])
			{
				if (is_array($TeleportList))
				{
					foreach ($TeleportList as $Index=>$Line)
					{
						if ($Line[0]>$CurrentID)
						{
							$CurrentID=$Line[0];
						}
					}
				}
				$_GET["id"]=$CurrentID+1;
				$AddLocation=true;
			}
			$TeleportData=array($_GET["id"],$_GET["description"],$_GET["posx"],$_GET["posy"],$_GET["posz"],$_GET["interior"]);
			if (is_array($TeleportList))
			{
				$EditIndex=-1;
				foreach ($TeleportList as $Index=>$Line)
				{
					if ($_GET["id"]!=$Line[0] and $_GET["posx"]==$Line[2] and $_GET["posy"]==$Line[3] and $_GET["posz"]==$Line[4])
					{
						$LocationExists=true;
						break;
					}
					if (!$AddLocation and $_GET["id"]==$Line[0])
					{
						$EditIndex=$Index;
					}
				}
				if ($LocationExists)
				{
					echo "2";
				}
				else
				{
					if (!$AddLocation)
					{
						if ($EditIndex==-1)
						{
							echo "4";
						}
						else
						{
							$TeleportList[$EditIndex]=$TeleportData;
							$Save=true;
						}
					}
				}
			}
			else
			{
				$AddLocation=true;
			}
			if ($AddLocation and !$LocationExists and !$IDExists)
			{
				$TeleportList[]=$TeleportData;
				$Save=true;
			}
			if ($Save)
			{
				if (SaveTeleportList(SortTeleportList($TeleportList)))
				{
					echo "1".OutputTeleportLine($TeleportData);
				}
				else
				{
					echo "5";
				}
			}
		}
		break;
	case "teleporttoplace":
		$Interface=new CheatProcessor_Interface();
		$Interface->SendCheat("GOTOPOSITION ".$_GET["x"].",".$_GET["y"].",".$_GET["z"]);
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
}
?>