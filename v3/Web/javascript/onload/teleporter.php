<?php
$Load="Teleporter_Reload('');";
$Tabs=array
(
	array("add",Language("Add location"),"Teleporter_ShowEditDialog('','','','','','','')"),
	array("refresh",Language("Refresh"),$Load),
	array("teleport",Language("Teleport to selected place"),"Teleporter_TeleportToTarget()"),
	array("remove",Language("Remove all locations"),"Teleporter_RemoveAllPlaces()")
);
?>