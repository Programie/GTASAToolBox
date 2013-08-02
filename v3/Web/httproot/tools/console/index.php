<?php
echo "
	<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>
	<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'>
		<head>
			<title>GTA San Andreas ToolBox Console</title>
			<meta http-equiv='Content-Type' content='text/html;charset=ISO-8859-15'/>
			<link rel='stylesheet' type='text/css' href='style.css'/>
			<script type='text/javascript' src='script.js'></script>
		</head>
		<body>
			<div id='output_div'>
				<table id='output' cellpadding='0' cellspacing='0'>
					<tr>
						<td>GTA San Andreas ToolBox Console</td>
					</tr>
					<tr>
						<td>Type 'help'  to see a list of available commands.</td>
					</tr>
				</table>
			</div>
			<form action='' onsubmit='SendRequest();return false;'>
				<div id='input_div'>
					<input type='text' id='input' onblur='Refocus(this);'/>
				</div>
			</form>
		</body>
	</html>
";
?>