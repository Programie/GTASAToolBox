<?php
$Load="Weapons_Reload();Weapons_LoadInfo(Weapons_LastWeaponID);";
$Tabs=array(
	array("",Language("All weapons"),"Weapons_Reload('','all')"),
	array("favorites",Language("Favorites"),"Weapons_Reload('','favorites')")
);
?>