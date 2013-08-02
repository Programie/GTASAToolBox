<?php
if (!is_dir(HttpRoot."tools"))
{
	mkdir(HttpRoot."tools");
}
switch ($_GET["mode"])
{
	case "getinstalledtools":
		$Tools=scandir(HttpRoot."tools");
		if (is_array($Tools))
		{
			foreach ($Tools as $Name)
			{
				$Data=Ini_Read(HttpRoot."tools/$Name/info.ini");
				if (is_array($Data))
				{
					echo "$Name\t".strtotime($Data["Info"]["Date"])."\t".$Data["Name"][GetConfigValue("General","Language")]."\t".$Data["Description"][GetConfigValue("General","Language")]."\t".$Data["Info"]["Author"]."\t".FormatDate($Data["Info"]["Date"])."\t".$Data["Window"]["Width"]."\t".$Data["Window"]["Height"]."\n";
				}
			}
		}
		break;
	case "getdownloadabletools":
		$Curl=curl_init();
		curl_setopt($Curl,CURLOPT_URL,"http://projects.selfcoders.com/gta_sa_toolbox/tools.php?language=".GetConfigValue("General","Language"));
		curl_setopt($Curl,CURLOPT_RETURNTRANSFER,true);
		$Data=explode("\n",curl_exec($Curl));
		curl_close($Curl);
		foreach ($Data as $Tool)
		{
			if ($Tool)
			{
				$Tools[]=explode("\t",$Tool);
			}
		}
		switch ($_GET["sort"])
		{
			case "name":
				$SortIndex=1;
				break;
			case "description":
				$SortIndex=2;
				break;
			case "author":
				$SortIndex=3;
				break;
			case "date":
				$SortIndex=4;
				break;
			default:
				$SortIndex=1;
				break;
		}
		function DownloadableToolsSortCompare($Array1,$Array2)
		{
			global $SortIndex;
			return strnatcmp($Array1[$SortIndex],$Array2[$SortIndex]);
		}
		usort($Tools,"DownloadableToolsSortCompare");
		foreach ($Tools as $Tool)
		{
			echo "$Tool[0]\t".strtotime($Tool[4])."\t$Tool[1]\t$Tool[2]\t$Tool[3]\t".FormatDate($Tool[4])."\n";
		}
		break;
	case "installtool":
		$Tool=basename($_GET["tool"]);
		$Path=HttpRoot."tools/$Tool";
		if (!is_dir($Path))
		{
			mkdir($Path);
		}
		set_time_limit(0);
		$Curl=curl_init();
		curl_setopt($Curl,CURLOPT_URL,"http://projects.selfcoders.com/gta_sa_toolbox/tools/$Tool.zip");
		curl_setopt($Curl,CURLOPT_CONNECTTIMEOUT,30);
		curl_setopt($Curl,CURLOPT_RETURNTRANSFER,true);
		curl_setopt($Curl,CURLOPT_BINARYTRANSFER,true);
		$File=fopen($Path.".zip","w");
		if ($File)
		{
			fwrite($File,curl_exec($Curl));
			fclose($File);
			$Zip=zip_open($Path.".zip");
			if ($Zip)
			{
				while ($ZipEntry=zip_read($Zip))
				{
					$File=$Path."/".zip_entry_name($ZipEntry);
					if (!is_dir(dirname($File)))
					{
						mkdir(dirname($File));
					}
					$File=fopen($File,"w");
					if ($File)
					{
						if (zip_entry_open($Zip,$ZipEntry,"r"))
						{
							fwrite($File,zip_entry_read($ZipEntry,zip_entry_filesize($ZipEntry)));
							zip_entry_close($ZipEntry);
						}
						fclose($File);
					}
				}
				zip_close($Zip);
			}
			unlink($Path.".zip");
			$DownloadOK++;
		}
		curl_setopt($Curl,CURLOPT_URL,"http://projects.selfcoders.com/gta_sa_toolbox/tools/$Tool.ini");
		$File=fopen($Path."/info.ini","w");
		if ($File)
		{
			fwrite($File,curl_exec($Curl));
			fclose($File);
			$DownloadOK++;
		}
		curl_close($Curl);
		if ($DownloadOK==2)
		{
			echo Language("Installation successful!");
		}
		else
		{
			echo Language("Installation failed!");
		}
		break;
	case "removetool":
		DeleteDirectory(HttpRoot."tools/".basename($_GET["tool"]));
		break;
}
?>