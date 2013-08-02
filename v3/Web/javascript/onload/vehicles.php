<?php
$Load="Vehicles_Reload();Vehicles_LoadInfo(Vehicles_LastModelID);";
$Tabs=array(
	array("",Language("All vehicles"),"Vehicles_Reload('','all')"),
	array("favorites",Language("Favorites"),"Vehicles_Reload('','favorites')")
);
?>