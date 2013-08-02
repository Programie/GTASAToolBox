<?php
$Load="Cheatlist_Reload('');";
$Tabs=array
(
	array("add",Language("Add cheat"),"Cheatlist_ShowEditDialog('','','')"),
	array("refresh",Language("Refresh"),$Load),
	array("remove",Language("Remove all cheats"),"Cheatlist_RemoveAllCheats()")
);
?>