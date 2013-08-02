<?php
function Ini_Read($File,$Section="")
{
	if (file_exists($File))
	{
		$File=fopen($File,"r");
		if ($File)
		{
			while (!feof($File))
			{
				$Line=trim(str_replace("\n","",str_replace("\r","",fgets($File))));
				if ($Line and substr($Line,0,1)!=";")
				{
					$LineData=explode("=",$Line);
					if (count($LineData)==2)
					{
						if (!$Section or $Section==$CurrentSection)
						{
							$ReturnData[$CurrentSection][trim($LineData[0])]=trim($LineData[1]);
						}
					}
					else
					{
						if (substr($Line,0,1)=="[" and substr($Line,-1,1)=="]")
						{
							$CurrentSection=trim(substr($Line,1,-1));
						}
					}
				}
			}
			fclose($File);
		}
	}
	return $ReturnData;
}

function Ini_Write($File,$Data)
{
	$File=fopen($File,"w");
	if ($File)
	{
		ksort($Data);
		foreach ($Data as $GroupName=>$GroupData)
		{
			fwrite($File,"[$GroupName]\r\n");
			foreach ($GroupData as $Name=>$Value)
			{
				fwrite($File,"$Name = $Value\r\n");
			}
		}
		fclose($File);
		return true;
	}
}