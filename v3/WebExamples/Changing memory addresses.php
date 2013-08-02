<?php
/*
This is a small script to demostrate how to change memory addresses via PHP (e.g. for using in tools).

ReadMemory - Result Codes:
1 = Read OK
2 = Unknown data type
3 = GTA San Andreas not running
*/

//include("includes/cheatprocessor_interface.php");// Uncomment if you directly access the script (e.g. you use it in a tool)

function ReadMemory($Address,$Type,$Size=0)
{
	global $CPI;
	$CPI->ReadMemory($Address,$Type,$Size);
	$ResultCode=$CPI->GetResult();// Get the result code
	switch ($ResultCode)
	{
		case 1:
			$Number=$CPI->ReadResult(4);// Array of 4 bytes with length of data
			// A number as a 4 bytes long string? We have to convert it into a number!
			$Long=unpack("L",$Number);// Convert binary to long
			// Now we know how long the data is
			return $CPI->ReadResult($Long[1]);// Read the data and return it
		case 2:
			echo "Unknown data type!";
			break;
		case 3:
			echo "Are you crazy?!? You want to change something in GTA San Andreas without starting it!";
			break;
		default:
			echo "Unknown error (#$ResultCode)!";
			break;
	}
}

function WriteMemory($Address,$Type,$Value)
{
	global $CPI;
	$CPI->WriteMemory($Address,$Type,$Value);
	$ResultCode=$CPI->GetResult();// Get the result code
	switch ($ResultCode)
	{
		case 1:
			return true;
		case 2:
			echo "Unknown data type!";
			break;
		case 3:
			echo "Are you crazy?!? You want to change something in GTA San Andreas without starting it!";
			break;
		default:
			echo "Unknown error (#$ResultCode)!";
			break;
	}
}

$CPI=new CheatProcessor_Interface();
if ($CPI->CheckConnection())// Check if the connection was successful (If the CheatProcessor is not running, it will fail)
{
	$PED=ReadMemory(0xB6F3B8,"long");// Read the pointer to the start of the PED object
	$Pool=ReadMemory($PED+20,"long");// Read the start address of the rotation structure
	if ($Pool)// Check if the read was successful
	{
		$X=ReadMemory($Pool+48,"float");
		$Y=ReadMemory($Pool+52,"float");
		$Z=ReadMemory($Pool+56,"float");
		echo "You are at position $X x $Y x $Z!<br /><br />";
		WriteMemory($Pool+56,"float",$Z+10);
		echo "And now you may fly (Z: +10)...<br /><br /><br />";
		echo "You currently have $".ReadMemory(0xB7CE50,"long");
	}
}
else
{
	echo "
		Connection to CheatProcessor failed!<br />
		Did you started the CheatProcessor?
	";
}
$CPI->Close();
?>