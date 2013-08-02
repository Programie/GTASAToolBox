<?php
function MemoryChanger_LoadList()
{
	if (file_exists(ConfigPath."MemoryChanger.dat"))
	{
		$File=fopen(ConfigPath."MemoryChanger.dat","r");
		if ($File)
		{
			while (!feof($File))
			{
				$Line=trim(str_replace("\n","",str_replace("\r","",fgets($File))));
				if ($Line)
				{
					$MemoryChangerList[]=explode("\t",$Line);
				}
			}
			fclose($File);
			return $MemoryChangerList;
		}
	}
}

function MemoryChanger_ReadMemory($Address,$Type,$Size=0)
{
	global $CPI;
	$CPI->ReadMemory($Address,$Type,$Size);
	$ResultCode=$CPI->GetResult();
	if ($ResultCode==1)
	{
		$Number=$CPI->ReadResult(4);
		$Long=unpack("L",$Number);
		return $ResultCode.htmlentities(str_replace("\n","",str_replace("\r","",str_replace("\t","",$CPI->ReadResult($Long[1])))));
	}
	else
	{
		return $ResultCode;
	}
}

function MemoryChanger_SaveList($MemoryChangerList)
{
	$File=fopen(ConfigPath."MemoryChanger.dat","w");
	if ($File)
	{
		foreach ($MemoryChangerList as $Line)
		{
			fwrite($File,"$Line[0]\t$Line[1]\t$Line[2]\t$Line[3]\t$Line[4]\r\n");
		}
		fclose($File);
		return true;
	}
}

function MemoryChanger_WriteMemory($Address,$Type,$Value)
{
	global $CPI;
	$CPI->WriteMemory($Address,$Type,$Value);
	return $CPI->GetResult();
}

switch ($_GET["mode"])
{
	case "getlist":
		$MemoryChangerList=MemoryChanger_LoadList();
		switch ($_GET["sort"])
		{
			case "id":
				$SortIndex=0;
				break;
			case "name":
				$SortIndex=1;
				break;
			case "address":
				$SortIndex=2;
				break;
			case "type":
				$SortIndex=3;
				break;
			case "size":
				$SortIndex=4;
				break;
			case "lastsetvalue":
				$SortIndex=5;
				break;
			default:
				$SortIndex=0;
				break;
		}
		function MemoryChangerSortCompare($Array1,$Array2)
		{
			global $SortIndex;
			return strnatcmp($Array1[$SortIndex],$Array2[$SortIndex]);
		}
		if (is_array($MemoryChangerList))
		{
			usort($MemoryChangerList,"MemoryChangerSortCompare");
			$CPI=new Cheatprocessor_Interface();
			foreach ($MemoryChangerList as $Line)
			{
				switch ($Line[3])
				{
					case 0:
						$Type="Byte";
						break;
					case 1:
						$Type="Word";
						break;
					case 2:
						$Type="Long";
						break;
					case 3:
						$Type="Float";
						break;
					case 4:
						$Type="Quad";
						break;
					case 5:
						$Type="String";
						break;
					case 6:
						$Type="Double";
						break;
					case 7:
						$Type="Character";
						break;
					case 8:
						$Type="Array";
						break;
					default:
						$Type=Language("Unknown");
						break;
				}
				$Address="0x".strtoupper(dechex($Line[2]));
				if ($CPI->CheckConnection())
				{
					$CurrentValue=substr(MemoryChanger_ReadMemory($Address,$Type,$Line[4]),1);
				}
				else
				{
					$CurrentValue="N/A";
				}
				echo "$Line[0]\t$Line[1]\t$Address\t$Type\t$Line[4]\t$CurrentValue\t$Line[5]\n";
			}
		}
		break;
	case "setaddress":
		if ($_GET["address"])
		{
			$AddIndex=-1;
			$MemoryChangerList=MemoryChanger_LoadList();
			if ($_GET["id"])
			{
				foreach ($MemoryChangerList as $Index=>$Line)
				{
					if ($Line[0]==$_GET["id"])
					{
						$AddIndex=$Index;
						break;
					}
				}
			}
			else
			{
				foreach ($MemoryChangerList as $Index=>$Line)
				{
					if ($Line[0]==$_GET["id"])
					{
						unset($MemoryChangerList[$Index]);
						break;
					}
				}
			}
			if (!$_GET["id"])
			{
				foreach ($MemoryChangerList as $Line)
				{
					if ($Line[0]>$_GET["id"])
					{
						$_GET["id"]=$Line[0];
					}
				}
				$_GET["id"]++;
			}
			if ($AddIndex==-1)
			{
				$MemoryChangerList[]=array($_GET["id"],$_GET["name"],hexdec($_GET["address"]),$_GET["type"],$_GET["size"],"");
				$AddIndex=count($MemoryChangerList)-1;
				$HasAdded=true;
			}
			else
			{
				$MemoryChangerList[$AddIndex]=array($_GET["id"],$_GET["name"],hexdec($_GET["address"]),$_GET["type"],$_GET["size"],"");
				$HasAdded=false;
			}
			if (MemoryChanger_SaveList($MemoryChangerList))
			{
				$HasAdded=(int)$HasAdded;
				switch ($MemoryChangerList[$AddIndex][3])
				{
					case 0:
						$Type="Byte";
						break;
					case 1:
						$Type="Word";
						break;
					case 2:
						$Type="Long";
						break;
					case 3:
						$Type="Float";
						break;
					case 4:
						$Type="Quad";
						break;
					case 5:
						$Type="String";
						break;
					case 6:
						$Type="Double";
						break;
					case 7:
						$Type="Character";
						break;
					case 8:
						$Type="Array";
						break;
					default:
						$Type=Language("Unknown");
						break;
				}
				$Address="0x".strtoupper(dechex($MemoryChangerList[$AddIndex][2]));
				$CPI=new Cheatprocessor_Interface();
				if ($CPI->CheckConnection())
				{
					$CurrentValue=substr(MemoryChanger_ReadMemory($Address,$Type,$MemoryChangerList[$AddIndex][4]),1);
				}
				else
				{
					$CurrentValue="N/A";
				}
				echo "1$HasAdded".$MemoryChangerList[$AddIndex][0]."\t".$MemoryChangerList[$AddIndex][1]."\t$Address\t$Type\t".$MemoryChangerList[$AddIndex][4]."\t$CurrentValue\t".$MemoryChangerList[$AddIndex][5];
			}
			else
			{
				echo "3";
			}
		}
		else
		{
			echo "2";
		}
		break;
	case "readaddress":
		$CPI=new Cheatprocessor_Interface();
		echo MemoryChanger_ReadMemory($_GET["address"],$_GET["datatype"],$_GET["size"]);
		break;
	case "writeaddress":
		$CPI=new Cheatprocessor_Interface();
		echo MemoryChanger_WriteMemory($_GET["address"],$_GET["datatype"],$_GET["size"]);
		break;
}
?>