<?php
$Load="SaveGameManager_Reload('');SaveGameManager_CreateToolBar();";
$Tabs=array
(
	array("refresh",Language("Refresh"),$Load),
	array("save","Backup Manager","SaveGameManager_ShowBackupManager()"),
	array("remove",Language("Remove all save games"),"SaveGameManager_RemoveAllSaveGames()")
);
?>