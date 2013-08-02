<?php
$CPI=new CheatProcessor_Interface();
$Command=explode(" ",$_GET["command"],2);
switch ($Command[0])
{
	case "checkconnection":
		if ($CPI->CheckConnection())
		{
			echo "OK";
		}
		else
		{
			echo "Connection failed!";
		}
		break;
	case "help":
		echo "checkconnection   - Check if the CheatProcessor is running<br />";
		echo "logout            - Log off your current session<br />";
		echo "sendcheat [CHEAT] - Send a cheat to the CheatProcessor";
		break;
	case "logout":
		if ($RequireLogin)
		{
			session_unset();
			echo "You are now logged off!";
		}
		else
		{
			echo "You are connected locally!<br>There is no need to logout.";
		}
		break;
	case "sendcheat":
		$CPI->SendCheat($Command[1]);
		$ReturnCode=(int)$CPI->GetResult();
		switch ($ReturnCode)
		{
			case 1:
				echo "The cheat has been executed.";
				break;
			case 2:
				echo "The game is not ready!";
				break;
			case 3:
				echo "GTA San Andreas is not running!";
				break;
			case 4:
				echo "The cheat has been not processed by the CheatProcessor!";
				break;
			case -1:
				echo "The CheatProcessor is not running!";
				break;
			default:
				echo "Unknown error (Error $ReturnCode)";
				break;
		}
		break;
	default:
		echo "Unknown command!";
		break;
}
$CPI->Close();
?>