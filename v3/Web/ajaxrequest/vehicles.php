<?php
function ReadVehicleFavorites()
{
	if (file_exists(ConfigPath."Vehicles.fav"))
	{
		$File=fopen(ConfigPath."Vehicles.fav","r");
		if ($File)
		{
			while (!feof($File))
			{
				$Line=trim(str_replace("\n","",str_replace("\r","",fgets($File))));
				if ($Line)
				{
					$Favorites[$Line]=true;
				}
			}
			fclose($File);
		}
	}
	return $Favorites;
}

function ReadVehiclesInfo($ModelID=-1)
{
	if (file_exists(ConfigPath."Vehicles.cfg"))
	{
		$File=fopen(ConfigPath."Vehicles.cfg","r");
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
						if ($ModelID==-1 or $ModelID==$Line[0])
						{
							if ($Line[1])
							{
								$Radio=Language("Yes");
							}
							else
							{
								$Radio=Language("No");
							}
							$Vehicles[$Line[0]]=array($Line[0],$Line[2],$Radio);
						}
					}
				}
			}
			fclose($File);
		}
		$File=fopen(GetPath("GTASA")."data/vehicles.ide","r");
		if ($File)
		{
			while (!feof($File))
			{
				$Line=str_replace("\n","",str_replace("\r","",fgets($File)));
				if ($Line and substr($Line,0,1)!="#")
				{
					switch (strtolower($Line))
					{
						case "cars":
							$VehicleList=true;
							break;
						case "end":
							$VehicleList=false;
							break;
						default:
							if ($VehicleList)
							{
								$Line=explode(",",$Line,9);
								foreach ($Line as $Index=>$Value)
								{
									$Line[$Index]=trim($Value);
								}
								if ($ModelID==-1 or $Line[0]==$ModelID)
								{
									switch (strtolower(trim($Line[3])))
									{
										case "bike":
											$Vehicles[$Line[0]][3]=Language("Bike");
											break;
										case "bmx":
											$Vehicles[$Line[0]][3]="BMX";
											break;
										case "boat":
											$Vehicles[$Line[0]][3]=Language("Boat");
											break;
										case "car":
											$Vehicles[$Line[0]][3]=Language("Car");
											break;
										case "heli":
											$Vehicles[$Line[0]][3]=Language("Helicopter");
											break;
										case "mtruck":
											$Vehicles[$Line[0]][3]="Monster Truck";
											break;
										case "trailer":
											$Vehicles[$Line[0]][3]=Language("Trailer");
											break;
										case "train":
											$Vehicles[$Line[0]][3]=Language("Train");
											break;
										case "plane":
											$Vehicles[$Line[0]][3]=Language("Plane");
											break;
										case "quad":
											$Vehicles[$Line[0]][3]="Quad";
											break;
										default:
											$Vehicles[$Line[0]][3]="N/A";
											break;
									}
									$Vehicles[$Line[0]][4]=$Line[1];
									$Vehicles[$Line[0]][5]=$Line[2];
									$Vehicles[$Line[0]][6]=$Line[4];
									$Vehicles[$Line[0]][7]=$Line[5];
									$Vehicles[$Line[0]][8]=$Line[6];
									$Vehicles[$Line[0]][9]=$Line[7];
									$LineEx=explode(",\t\t",$Line[8]);
									$Vehicles[$Line[0]][10]=trim(str_replace("\t"," ",$LineEx[0]));
									$Vehicles[$Line[0]][11]=trim(str_replace("\t"," ",$LineEx[1]));
								}
							}
							break;
					}
				}
			}
			fclose($File);
		}
	}
	return $Vehicles;
}

function SaveVehicleFavorites($Favorites)
{
	$File=fopen(ConfigPath."Vehicles.fav","w");
	if ($File)
	{
		foreach ($Favorites as $ModelID=>$Added)
		{
			if ($Added)
			{
				fwrite($File,$ModelID."\r\n");
			}
		}
		fclose($File);
	}
}

switch ($_GET["mode"])
{
	case "addfavorite":
		$ModelID=$_GET["modelid"];
		$Favorites=ReadVehicleFavorites();
		if ($Favorites[$ModelID])
		{
			echo "2";
		}
		else
		{
			$Favorites[$ModelID]=true;
			ksort($Favorites);
			SaveVehicleFavorites($Favorites);
			echo "1";
		}
		break;
	case "getinfo":
		$ModelID=$_GET["modelid"];
		$VehiclesInfo=ReadVehiclesInfo($ModelID);
		echo "ModelID\t".$VehiclesInfo[$ModelID][0]."\n";
		echo "Name\t".$VehiclesInfo[$ModelID][1]."\n";
		echo "Radio\t".$VehiclesInfo[$ModelID][2]."\n";
		echo Language("Type")."\t".$VehiclesInfo[$ModelID][3]."\n";
		echo "Model Name\t".$VehiclesInfo[$ModelID][4].".dff\n";
		echo "Txd Name\t".$VehiclesInfo[$ModelID][5].".txd\n";
		echo "Handling ID\t".$VehiclesInfo[$ModelID][6]."\n";
		echo "Game Name\t".$VehiclesInfo[$ModelID][7]."\n";
		echo "Anims\t".$VehiclesInfo[$ModelID][8]."\n";
		echo "Class\t".$VehiclesInfo[$ModelID][9]."\n";
		echo "Frq Flags\t".$VehiclesInfo[$ModelID][10]."\n";
		echo "Comprules\t".$VehiclesInfo[$ModelID][11]."\n";
		break;
	case "getlist":
		switch ($_GET["sort"])
		{
			case "modelid":
				$SortIndex=0;
				break;
			case "name":
				$SortIndex=1;
				break;
			case "radio":
				$SortIndex=2;
				break;
			case "type":
				$SortIndex=3;
				break;
			default:
				$SortIndex=0;
				break;
		}
		function VehiclesSortCompare($Array1,$Array2)
		{
			global $SortIndex;
			return strnatcmp($Array1[$SortIndex],$Array2[$SortIndex]);
		}
		if ($_GET["type"]=="favorites")
		{
			$Favorites=ReadVehicleFavorites();
		}
		$Vehicles=ReadVehiclesInfo();
		usort($Vehicles,"VehiclesSortCompare");
		foreach ($Vehicles as $Line)
		{
			$Show=false;
			if ($_GET["type"]=="favorites")
			{
				if (is_array($Favorites))
				{
					foreach ($Favorites as $ModelID=>$Enabled)
					{
						if ($Line[0]==$ModelID)
						{
							$Show=true;
							break;
						}
					}
				}
			}
			else
			{
				$Show=true;
			}
			if ($Show)
			{
				echo "$Line[0]\t$Line[1]\t$Line[2]\t$Line[3]\n";
			}
		}
		break;
	case "getpicture":
		readfile(Root."/Images/Vehicles/".basename($_GET["modelid"]).".jpg");
		break;
	case "removefavorite":
		$ModelID=$_GET["modelid"];
		$Favorites=ReadVehicleFavorites();
		if ($Favorites[$ModelID])
		{
			$Favorites[$ModelID]=false;
			ksort($Favorites);
			SaveVehicleFavorites($Favorites);
			echo "1";
		}
		else
		{
			echo "2";
		}
		break;
	case "spawn":
		$Interface=new CheatProcessor_Interface();
		$Interface->SendCheat("SPAWNVEHICLE ".$_GET["modelid"]);
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