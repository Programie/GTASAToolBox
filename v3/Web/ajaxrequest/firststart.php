<?php
switch ($_GET["mode"])
{
	case "togglenevershowagain":
		SetConfigValue("General","FirstStart",$_GET["newstate"]);
		echo "1";
		break;
}