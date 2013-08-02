<?php
$ShowLogin=true;
if ($RequireLogin)
{
	if (isset($_POST["Username"]) and isset($_POST["Password"]))
	{
		$Username=$_POST["Username"];
		$Password=$_POST["Password"];
	}
	else
	{
		$Username=$_SESSION["Username"];
		$Password=$_SESSION["Password"];
	}
	if ($Username and $Password)
	{
		$File=file(ConfigPath."RemoteUsers.ini");
		foreach ($File as $Line)
		{
			$Line=trim($Line);
			if ($Line)
			{
				$Line=explode("=",$Line);
				if (strtolower($Username)==strtolower(trim($Line[0])) and strtolower(md5($Password))==strtolower(trim($Line[1])))
				{
					$_SESSION["Username"]=$Username;
					$_SESSION["Password"]=$Password;
					$ShowLogin=false;
				}
			}
		}
	}
}
else
{
	$ShowLogin=false;
}
?>