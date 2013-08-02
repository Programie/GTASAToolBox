function FirstStart_ToggleNeverShowAgain()
{
	var Element=document.getElementById("firststart_nevershowagain");
	var NewState=Element.checked?0:1;
	Element.disabled=true;
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=firststart&mode=togglenevershowagain&newstate="+NewState,true);
		XmlHttp.onreadystatechange=FirstStart_ToggleNeverShowAgain_GetData;
		XmlHttp.send(null);
	}
	function FirstStart_ToggleNeverShowAgain_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText);
			if (ReturnCode==1)
			{
				document.getElementById("settings_firststart").checked=NewState;
				Element.disabled=false;
			}
			else
			{
				var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
				alert(Text.replace("%1",ReturnCode));
			}
		}
	}
}