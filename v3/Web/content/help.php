<?php
echo "
	<table style='margin-left:20px;'>
		<tr onclick=\"window.open('http://chat.selfcoders.com/?channel=GTA_SA_TB','Chat','width=500,height=300');\" style='cursor:pointer;'>
			<td><img src='files/chat.png' width='64' alt='IRC Chat' title='IRC Chat'/></td>
			<td>
				<b>IRC Chat</b><br />
				".Language("Join the GTA San Andreas ToolBox IRC channel to chat with other GTA San Andreas ToolBox users and get support.")."
			</td>
		</tr>
		<tr onclick=\"window.open('http://board.selfcoders.com/index.php/board,27.0.html','Forum');\" style='cursor:pointer;'>
			<td><img src='files/forum.png' width='64' alt='Forum' title='Forum'/></td>
			<td>
				<b>Forum</b><br />
				".Language("Join our forum and discuss about various topics.")."
			</td>
		</tr>
		<tr onclick=\"window.open('http://bugreport.selfcoders.com/?product=gta_sa_toolbox&amp;version=3.0','BugReport');\" style='cursor:pointer;'>
			<td><img src='files/bugreport.png' width='64' alt='Bug Rporter' title='Bug Reporter'/></td>
			<td>
				<b>Bug Reporter</b><br />
				".Language("Submit a bug report or see which bugs were already reported.")."
			</td>
		</tr>
		<tr onclick=\"window.open('http://help.selfcoders.com/gta_sa_toolbox/3.0/".GetConfigValue("General","Language","en")."/','Help');\" style='cursor:pointer;'>
			<td><img src='files/help.png' width='64' alt='".Language("Online help")."' title='".Language("Online help")."'/></td>
			<td>
				<b>".Language("Online help")."</b><br />
				".Language("Access the online help.")."
			</td>
		</tr>
	</table>
";
?>