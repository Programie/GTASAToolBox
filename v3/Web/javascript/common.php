function CreateTabBar(TabBar,Tabs)
{
	TabBar=document.getElementById(TabBar);
	RemoveElementChilds(TabBar);
	var TR=document.createElement("tr");
	for (var Tab=0;Tab<Tabs.length;Tab++)
	{
		var TabElement=document.createElement("td");
		var TabElement2=document.createElement("table");
		var TabTR=document.createElement("tr");
		var TabTD1=document.createElement("td");
		var TabTD2=document.createElement("td");
		var TabTD3=document.createElement("td");
		var Code="<table class='tabbar_table' cellpadding='0' cellspacing='0'>";
		Code=Code+"<tr>";
		if (Tabs[Tab][0])
		{
			Code=Code+"<td style='height:32px;width:30px;'>";
			Code=Code+"<div class='tabbar_icon' style='background-image:url(files/tabbar/"+Tabs[Tab][0]+".png);'></div>";
			Code=Code+"</td>";
		}
		Code=Code+"<td>"+Tabs[Tab][1]+"</td>";
		Code=Code+"</tr>";
		Code=Code+"</table>";
		TabTD1.style.width="10px";
		TabTD1.style.height="32px";
		TabTD1.style.backgroundImage="url(files/tabs/active_left.png)";
		TabTD2.style.backgroundImage="url(files/tabs/active_middle.png)";
		TabTD2.innerHTML=Code;
		TabTD3.style.width="10px";
		TabTD3.style.height="32px";
		TabTD3.style.backgroundImage="url(files/tabs/active_right.png)";
		TabTR.appendChild(TabTD1);
		TabTR.appendChild(TabTD2);
		TabTR.appendChild(TabTD3);
		TabElement2.cellPadding="0";
		TabElement2.cellSpacing="0";
		TabElement2.appendChild(TabTR);
		TabElement.appendChild(TabElement2);
		TabElement.style.cursor="pointer";
		TabElement.onclick=Tabs[Tab][2];
		LoadPage_AddHoverEffect(TabElement);
		TR.appendChild(TabElement);
	}
	TabBar.appendChild(TR);
	function LoadPage_AddHoverEffect(Element)
	{
		Element.onmouseover=function(){Opacity(Element,0.7);}
		Element.onmouseout=function(){Opacity(Element);}
	}
}

function CreateTableRow(RowArray)
{
	var TR=document.createElement("tr");
	for (var Cell=0;Cell<RowArray.length;Cell++)
	{
		var TD=document.createElement("td");
		TD.innerHTML=RowArray[Cell];
		TD.style.whiteSpace="nowrap";
		TR.appendChild(TD);
	}
	TR.style.height="20px";
	TR.onmouseover=function(){Table_MouseOver(TR,true);}
	TR.onmouseout=function(){Table_MouseOver(TR,false);}
	return TR;
}

function CreateXmlHttpRequest()
{
	var XmlHttp=new XMLHttpRequest();
	if (!XmlHttp)
	{
		try
		{
			XmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch(e)
		{
			try
			{
				XmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch(e)
			{
				XmlHttp=null;
			}
		}
	}
	return XmlHttp;
}

function GetAbsoluteX(Element)
{
	var X;
	X=0;
	while (Element!=null)
	{
		X+=Element.offsetLeft;
		Element=Element.offsetParent;
	}
	return X;
}

function GetAbsoluteY(Element)
{
	var Y;
	Y=0;
	while (Element!=null)
	{
		Y+=Element.offsetTop;
		Element=Element.offsetParent;
	}
	return Y;
}

function GetMousePosition(Event)
{
	if (IsIE)
	{
		MousePositionX=event.clientX+document.body.scrollLeft;
		MousePositionY=event.clientY+document.body.scrollTop;
	}
	else
	{
		MousePositionX=Event.pageX;
		MousePositionY=Event.pageY;
	}
	if (MousePositionX<0)
	{
		MousePositionX=0
	}
	if (MousePositionY<0)
	{
		MousePositionY=0;
	}
	return true;
}

function HideDialog(Dialog)
{
	document.getElementById("dialog_"+Dialog).style.visibility="hidden";
}

function LoadPage(Page)
{
	var MenubarTable=document.getElementById("menubar");
	var Buttons=MenubarTable.getElementsByTagName("table");
	for (var Button=0;Button<Buttons.length;Button++)
	{
		if (Buttons[Button].className=="menubar_button")
		{
			Buttons[Button].style.backgroundImage="url(files/menubar_button.png)";
		}
		var ID=Buttons[Button].id.replace("menubar_button","");
		if (document.getElementById("menubar_active"+ID))
		{
			document.getElementById("menubar_active"+ID).style.visibility="hidden";
		}
		if (document.getElementById("content"+ID))
		{
			document.getElementById("content"+ID).style.visibility="hidden";
		}
		if (document.getElementById("dialog"+ID))
		{
			document.getElementById("dialog"+ID).style.visibility="hidden";
		}
	}
	var Button=document.getElementById("menubar_button_"+Page);
	if (Button.className=="menubar_button")
	{
		Button.style.backgroundImage="url(files/menubar_button_active.png)";
	}
	document.getElementById("menubar_active_"+Page).style.visibility="visible";
	document.getElementById("content_"+Page).style.visibility="visible";
	CurrentPage=Page;
	var Tabs=Array();
	switch (Page)
	{
<?php
foreach ($Pages as $Name=>$Title)
{
	if (file_exists(WebPath."javascript/onload/$Name.php"))
	{
		include(WebPath."javascript/onload/$Name.php");
		$TabsArray="";
		foreach ($Tabs as $TabData)
		{
			if ($TabsArray)
			{
				$TabsArray.=",";
			}
			$TabsArray.="Array('$TabData[0]','$TabData[1]',function(){".$TabData[2].";})";
		}
		echo "
			case '$Name':
				$Load
				Tabs=Array($TabsArray);
				document.title='".PageTitle." - $Title';
				break;
		";
	}
}
?>
	}
	CreateTabBar("tabbar",Tabs);
}

function OnLoad()
{
<?php
if (!$_GET["page"])
{
	$_GET["page"]="cheatlist";
}
echo "
	Teleporter_MapZoomFactor=".GetConfigValue("Teleporter","DefaultZoomFactor",1).";
	Teleporter_MapFile='".GetConfigValue("Teleporter","Map","2d")."';
	LoadPage('".strtolower($_GET["page"])."');
";
?>
}

function Opacity(Element,Level)
{
	if (typeof(Level)=="undefined")
	{
		Level=1.0;
	}
	if (IsIE)
	{
		Element.style.filter="alpha(opacity="+(Level*100)+")";
	}
	else
	{
		Element.style.opacity=Level;
	}
}

function RemoveElementChilds(Element)
{
	while (Element.hasChildNodes())
	{
		Element.removeChild(Element.firstChild);
	}
}

function SetDialogTitle(Dialog,Title)
{
	document.getElementById("dialog_"+Dialog+"_title").innerHTML=Title;
}

function Table_MouseClick(TableID,Row)
{
	var Table=document.getElementById(TableID).getElementsByTagName("tr");
	for (var RowID=0;RowID<Table.length;RowID++)
	{
		Table[RowID].style.backgroundColor=null;
	}
	Row.style.backgroundColor="#DEDEDE";
}

function Table_MouseOver(Element,State)
{
	if (State)
	{
		Element.style.backgroundImage="url(files/table_row_hover.png)";
	}
	else
	{
		Element.style.backgroundImage="none";
	}
}

String.prototype.trim=function()
{
	return this.replace(/^\s+|\s+$/g,"");
}

String.prototype.ltrim=function()
{
	return this.replace(/^\s+/,"");
}

String.prototype.rtrim=function()
{
	return this.replace(/\s+$/,"");
}
