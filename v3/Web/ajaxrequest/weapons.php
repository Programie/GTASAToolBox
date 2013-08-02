<?php
function ReadWeaponFavorites()
{
	if (file_exists(ConfigPath."Weapons.fav"))
	{
		$File=fopen(ConfigPath."Weapons.fav","r");
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

function ReadWeaponsInfo($WeaponID=-1)
{
	if (file_exists(ConfigPath."Weapons.cfg"))
	{
		$File=fopen(ConfigPath."Weapons.cfg","r");
		if ($File)
		{
			while (!feof($File))
			{
				$Line=trim(str_replace("\n","",str_replace("\r","",fgets($File))));
				if ($Line)
				{
					if (substr($Line,0,1)!=";")
					{
						$Line=explode("\t",$Line);
						if ($WeaponID==-1 or $WeaponID==$Line[0])
						{
							$Weapons[$Line[0]]=array($Line[0],$Line[1],$Line[2],$Line[3],$Line[4],$Line[5]);
						}
					}
				}
			}
			fclose($File);
		}
	}
	return $Weapons;
}

function SaveWeaponFavorites($Favorites)
{
	$File=fopen(ConfigPath."Weapons.fav","w");
	if ($File)
	{
		foreach ($Favorites as $WeaponID=>$Added)
		{
			if ($Added)
			{
				fwrite($File,$WeaponID."\r\n");
			}
		}
		fclose($File);
	}
}

switch ($_GET["mode"])
{
	case "addfavorite":
		$WeaponID=$_GET["weaponid"];
		$Favorites=ReadWeaponFavorites();
		if ($Favorites[$WeaponID])
		{
			echo "2";
		}
		else
		{
			$Favorites[$WeaponID]=true;
			ksort($Favorites);
			SaveWeaponFavorites($Favorites);
			echo "1";
		}
		break;
	case "getinfo":
		$WeaponID=$_GET["weaponid"];
		$WeaponsInfo=ReadWeaponsInfo($WeaponID);
		echo Language("Number")."\t".$WeaponsInfo[$WeaponID][0]."\n";
		echo "Name\t".$WeaponsInfo[$WeaponID][1]."\n";
		echo "ModelID\t".$WeaponsInfo[$WeaponID][2]."\n";
		echo "Slot\t".$WeaponsInfo[$WeaponID][3]."\n";
		echo Language("Ammo in clip")."\t".$WeaponsInfo[$WeaponID][4]."\n";
		echo Language("Total ammo")."\t".$WeaponsInfo[$WeaponID][5]."\n";
		break;
	case "getlist":
		switch ($_GET["sort"])
		{
			case "number":
				$SortIndex=0;
				break;
			case "name":
				$SortIndex=1;
				break;
			case "modelid":
				$SortIndex=2;
				break;
			case "slot":
				$SortIndex=3;
				break;
			case "ammoinclip":
				$SortIndex=4;
				break;
			case "totalammo":
				$SortIndex=5;
				break;
			default:
				$SortIndex=0;
				break;
		}
		function WeaponsSortCompare($Array1,$Array2)
		{
			global $SortIndex;
			return strnatcmp($Array1[$SortIndex],$Array2[$SortIndex]);
		}
		if ($_GET["type"]=="favorites")
		{
			$Favorites=ReadWeaponFavorites();
		}
		$Weapons=ReadWeaponsInfo();
		usort($Weapons,"WeaponsSortCompare");
		foreach ($Weapons as $Line)
		{
			$Show=false;
			if ($_GET["type"]=="favorites")
			{
				if (is_array($Favorites))
				{
					foreach ($Favorites as $WeaponID=>$Enabled)
					{
						if ($Line[0]==$WeaponID)
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
				echo "$Line[0]\t$Line[1]\t$Line[2]\t$Line[3]\t$Line[4]\t$Line[5]\n";
			}
		}
		break;
	case "getpicture":
		readfile(Root."Images/Weapons/".basename($_GET["weaponid"]).".jpg");
		break;
	case "removefavorite":
		$WeaponID=$_GET["weaponid"];
		$Favorites=ReadWeaponFavorites();
		if ($Favorites[$WeaponID])
		{
			$Favorites[$WeaponID]=false;
			ksort($Favorites);
			SaveWeaponFavorites($Favorites);
			echo "1";
		}
		else
		{
			echo "2";
		}
		break;
	case "spawn":
		$Interface=new CheatProcessor_Interface();
		$Interface->SendCheat("SPAWNWEAPON ".$_GET["weaponid"]);
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