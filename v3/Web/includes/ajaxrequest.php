<?php
$File=basename($_GET["ajaxrequest"]);
if ($File)
{
	if (file_exists(WebPath."ajaxrequest/$File.php"))
	{
		include(WebPath."ajaxrequest/$File.php");
		SaveConfiguration();
		exit;
	}
}
?>