<?php
echo "<table cellspacing='0' width='100%' style='border-color:#000000;'>";
$Dir=scandir(Root."CheatPlugins");
foreach ($Dir as $File)
{
	if ($File!="." and $File!="..")
	{
		if ($Info["extension"]=="dll")
		{
			echo "
				<tr>
					<td colspan='2'>&nbsp;</td>
				</tr>
			";
		}
		$Info=pathinfo($File);
		if ($Info["extension"]=="dll")
		{
			$Return=array();
			echo "
				<tr>
					<td colspan='2' style='font-weight:bold;'>".$Info["filename"]."</td>
				</tr>
				<tr>
					<th style='border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;'>Name</th>
					<th style='border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000;'>Cheat</th>
				</tr>
			";
			exec("\"".Root."PluginInfos.exe\" ".$Info["filename"],$Return);
			foreach ($Return as $Line)
			{
				echo "
					<tr>
						<td style='border-bottom:1px solid #000000;border-left:1px solid #000000;'>$Line</td>
						<td style='border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000;'>CallPlugin ".$Info["filename"]." $Line</td>
					</tr>
				";
			}
		}
	}
}
echo "</table>";
?>