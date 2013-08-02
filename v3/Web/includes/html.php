<?php
echo "
	<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>
	<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'>
		<head>
			<title>".PageTitle."</title>
			<meta http-equiv='Content-Type' content='text/html;charset=ISO-8859-15'/>
			<link rel='stylesheet' type='text/css' href='files/style.css'/>
			<script type='text/javascript' src='index.php?getjs&amp;page=".$_GET["page"]."'></script>
			<script type='text/javascript' src='files/jscolor/script.js'></script>
";
if (!$ShowLogin and $_POST["Username"])
{
	echo "
		<script type='text/javascript'>
			document.location='index.php';
		</script>
	";
}
echo "
		</head>
		<body>
";
if ($ShowLogin)
{
	include(WebPath."includes/login.php");
}
else
{
	echo "
				<div id='menubar_background'>
					<table id='menubar' cellpadding='0' cellspacing='0'>
						<tr>
	";
	foreach ($Pages as $Name=>$Title)
	{
		echo "
			<td align='center' style='padding-left:10px;padding-right:10px;' title='$Title'>
				<table class='menubar_button_icon' id='menubar_button_$Name' style='cursor:pointer;font-size:10px;' onclick=\"LoadPage('$Name');\" onmouseover=\"Opacity(this,0.5);\" onmouseout=\"Opacity(this);\" cellpadding='0' cellspacing='0'>
					<tr>
						<td align='center'><div style='width:48px;height:48px;background-image:url(files/menubar/$Name.png);background-repeat:no-repeat;'></div></td>
					</tr>
					<tr>
						<td align='center'>$Title</td>
					</tr>
					<tr>
						<td align='center'><div id='menubar_active_$Name' style='width:9px;height:5px;background-image:url(files/currentpagemarker.png);visibility:hidden;'></div></td>
					</tr>
				</table>
			</td>
		";
	}
	echo "
						</tr>
					</table>
				</div>
				<div style='position:absolute;left:0px;top:90px;right:0px;height:10px;background-image:url(files/shadow.png);'></div>
				<table id='tabbar' cellpadding='0' cellspacing='0'>
					<tr>
						<td></td>
					</tr>
				</table>
	";
	foreach ($Pages as $PageName=>$PageTitle)
	{
		echo "<div class='content' id='content_$PageName'>";
		if (file_exists(WebPath."content/$PageName.php"))
		{
			include(WebPath."content/$PageName.php");
		}
		echo "
			</div>
			<div class='dialog_container_1' id='dialog_$PageName'>
				<div class='dialog_container_2' align='center'>
					<table cellpadding='0' cellspacing='0' class='dialog_table'>
						<tr>
							<td style='width:8px;height:26px;background-image:url(files/window/titlebar_left.png);'></td>
							<td style='height:26px;background-image:url(files/window/titlebar_middle.png);'>
								<span class='dialog_title' id='dialog_".$PageName."_title'>Untitled</span>
							</td>
							<td style='width:26px;height:26px;background-image:url(files/window/close_bg.png);'>
								<div style='position:relative;left:5px;top:3px;width:16px;height:16px;background-image:url(files/window/close.png);cursor:pointer;' onmouseover='Opacity(this,0.5);' onmouseout='Opacity(this);' onclick=\"HideDialog('$PageName');\" title='".Language("Close")."'></div>
							</td>
							<td style='width:8px;height:26px;background-image:url(files/window/titlebar_right.png);'></td>
						</tr>
						<tr>
							<td style='width:8px;background-image:url(files/window/border_left.png);'></td>
							<td class='dialogcontent' colspan='2'>
		";
		if (file_exists(WebPath."dialog/$PageName.php"))
		{
			include(WebPath."dialog/$PageName.php");
		}
		echo "
							</td>
							<td style='width:8px;background-image:url(files/window/border_right.png);'></td>
						</tr>
						<tr>
							<td style='width:8px;height:9px;background-image:url(files/window/bottom_left.png);'></td>
							<td style='height:9px;background-image:url(files/window/bottom_middle.png);' colspan='2'></td>
							<td style='width:8px;height:9px;background-image:url(files/window/bottom_right.png);'></td>
						</tr>
					</table>
				</div>
			</div>
		";
	}
	$File=WebPath."firststart/".GetConfigValue("General","Language").".php";
	if (GetConfigValue("General","FirstStart",true) and file_exists($File))
	{
		echo "
			<div class='dialog_container_1' id='dialog_firststart' style='visibility:visible;'>
				<div class='dialog_container_2' align='center' style='overflow:auto;'>
					<table cellpadding='0' cellspacing='0' class='dialog_table'>
						<tr>
							<td style='width:8px;height:26px;background-image:url(files/window/titlebar_left.png);'></td>
							<td style='height:26px;background-image:url(files/window/titlebar_middle.png);'>
								<span class='dialog_title'>".Language("First start")."</span>
							</td>
							<td style='width:26px;height:26px;background-image:url(files/window/close_bg.png);'>
								<div style='position:relative;left:5px;top:3px;width:16px;height:16px;background-image:url(files/window/close.png);cursor:pointer;' onmouseover='Opacity(this,0.5);' onmouseout='Opacity(this);' onclick=\"HideDialog('firststart');\" title='".Language("Close")."'></div>
							</td>
							<td style='width:8px;height:26px;background-image:url(files/window/titlebar_right.png);'></td>
						</tr>
						<tr>
							<td style='width:8px;background-image:url(files/window/border_left.png);'></td>
							<td class='dialogcontent' colspan='2' style='padding:5px;'>
		";
		include($File);
		echo "
							</td>
							<td style='width:8px;background-image:url(files/window/border_right.png);'></td>
						</tr>
						<tr>
							<td style='width:8px;height:9px;background-image:url(files/window/bottom_left.png);'></td>
							<td style='height:9px;background-image:url(files/window/bottom_middle.png);' colspan='2'></td>
							<td style='width:8px;height:9px;background-image:url(files/window/bottom_right.png);'></td>
						</tr>
					</table>
				</div>
			</div>
		";
	}
}
echo "
			<div style='position:absolute;top:10px;left:10px;font-size:10px;'>Dev Start:<br />26.05.2010</div>
			<div style='position:absolute;top:10px;right:10px;font-size:10px;'>Developer Version<br />Copyright &copy; 2010 SelfCoders</div>
		</body>
	</html>
";
?>