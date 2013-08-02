<?php
echo "
	<div style='position:absolute;left:0px;top:0px;right:0px;height:50%;'>
		<div style='position:absolute;bottom:-60px;left:0px;right:0px;' align='center'>
			<form action='index.php' method='post'>
				<table cellpadding='0' cellspacing='0'>
					<tr>
						<td style='width:8px;height:26px;background-image:url(files/window/titlebar_left.png);'></td>
						<td style='height:26px;background-image:url(files/window/titlebar_middle.png);'>
							<span style='margin-top:5px;font-size:14px;display:block;text-align:center;'>".PageTitle."</span>
						</td>
						<td style='width:8px;height:26px;background-image:url(files/window/titlebar_right.png);'></td>
					</tr>
					<tr>
						<td style='width:8px;background-image:url(files/window/border_left.png);'></td>
						<td align='center'>
							<table>
								<tr>
									<td><label for='username'>".Language("User name").":</label></td>
									<td><input class='login_inputfield' type='text' name='Username' id='username'/></td>
								</tr>
								<tr>
									<td><label for='password'>".Language("Password").":</label></td>
									<td><input class='login_inputfield' type='password' name='Password' id='password'/></td>
								</tr>
								<tr>
									<td colspan='2' style='text-align:right;'><input type='submit' value='Login'/></td>
								</tr>
							</table>
						</td>
						<td style='width:8px;background-image:url(files/window/border_right.png);'></td>
					</tr>
					<tr>
						<td style='width:8px;height:9px;background-image:url(files/window/bottom_left.png);'></td>
						<td style='height:9px;background-image:url(files/window/bottom_middle.png);'></td>
						<td style='width:8px;height:9px;background-image:url(files/window/bottom_right.png);'></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
";
?>