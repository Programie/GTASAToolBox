function Teleporter_AddEditPlace()
{
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		var Url="?ajaxrequest=teleporter&mode=setlocation";
		Url=Url+"&id="+escape(document.getElementById("dialog_teleporter_edit_id").value);
		Url=Url+"&description="+escape(document.getElementById("dialog_teleporter_edit_description").value);
		Url=Url+"&posx="+escape(document.getElementById("dialog_teleporter_edit_posx").value);
		Url=Url+"&posy="+escape(document.getElementById("dialog_teleporter_edit_posy").value);
		Url=Url+"&posz="+escape(document.getElementById("dialog_teleporter_edit_posz").value);
		Url=Url+"&interior="+escape(document.getElementById("dialog_teleporter_edit_interior").value);
		XmlHttp.open("GET",Url,true);
		XmlHttp.onreadystatechange=Teleporter_AddEditPlace_GetData;
		XmlHttp.send(null);
	}
	function Teleporter_AddEditPlace_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText.substr(0,1));
			switch (ReturnCode)
			{
				case 1:
					var RowData=unescape(XmlHttp.responseText.substr(1));
					var ID=document.getElementById("dialog_teleporter_edit_id").value;
					if (ID)
					{
						Teleporter_EditRow(ID,RowData);
					}
					else
					{
						Teleporter_AddRow(RowData);
					}
					HideDialog("teleporter");
					break;
				case 2:
					alert("<?php echo Language("There exists already a place with the same coordinates!");?>");
					break;
				case 3:
					alert("<?php echo Language("No coordinates entered!");?>");
					break;
				case 4:
					alert("<?php echo Language("Place not found!\\nPlease cancel and click on refresh.");?>");
					break;
				case 5:
					alert("<?php echo Language("Can not save teleport list!");?>");
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(Text.replace("%1",ReturnCode));
					break;
			}
		}
	}
}

function Teleporter_AddListButtons(Element,RowData)
{
	var Table=document.createElement("table");
	var TR=document.createElement("tr");
	var TD1=document.createElement("td");
	var TD2=document.createElement("td");
	var TD3=document.createElement("td");
	var TD4=document.createElement("td");
	Table.cellPadding=0;
	Table.cellSpacing=0;
	TD1.onmouseover=function(){Opacity(this,0.5);}
	TD1.onmouseout=function(){Opacity(this);}
	TD1.onclick=function(){Teleporter_ShowEditDialog(RowData[0],RowData[1],RowData[2],RowData[3],RowData[4],RowData[5]);}
	TD1.style.width="20px";
	TD1.style.height="20px";
	TD1.style.backgroundImage="url(files/listbuttons/edit.png)";
	TD1.style.cursor="pointer";
	TD1.title="<?php echo Language("Edit");?>";
	TD2.onmouseover=function(){Opacity(this,0.5);}
	TD2.onmouseout=function(){Opacity(this);}
	TD2.onclick=function(){Teleporter_RemovePlace(RowData[0],RowData[1]);}
	TD2.style.width="20px";
	TD2.style.height="20px";
	TD2.style.backgroundImage="url(files/listbuttons/remove.png)";
	TD2.style.cursor="pointer";
	TD2.title="<?php echo Language("Remove");?>";
	TD3.onmouseover=function(){Opacity(this,0.5);}
	TD3.onmouseout=function(){Opacity(this);}
	TD3.onclick=function(){Teleporter_TeleportToPlace(RowData[2],RowData[3],RowData[4]);}
	TD3.style.width="20px";
	TD3.style.height="20px";
	TD3.style.backgroundImage="url(files/listbuttons/teleport.png)";
	TD3.style.cursor="pointer";
	TD3.title=unescape("<?php echo Language("Teleport to this place");?>");
	TD4.onmouseover=function(){Opacity(this,0.5);}
	TD4.onmouseout=function(){Opacity(this);}
	TD4.onclick=function(){Teleporter_AddToCheatList(RowData[0],RowData[1]);}
	TD4.style.width="20px";
	TD4.style.height="20px";
	TD4.style.backgroundImage="url(files/listbuttons/addcheat.png)";
	TD4.style.cursor="pointer";
	TD4.title=unescape("<?php echo Language("Add to cheat list");?>");
	TR.appendChild(TD1);
	TR.appendChild(TD2);
	TR.appendChild(TD3);
	TR.appendChild(TD4);
	Table.appendChild(TR);
	RemoveElementChilds(Element);
	Element.appendChild(Table);
}

function Teleporter_AddRow(Data)
{
	var RowData=Data.split("\t");
	if (RowData[0])
	{
		var Interior=parseInt(RowData[5]);
		switch (Interior)
		{
			case -1:
				RowData[5]="<?php echo Language("Do not change");?>";
				break;
			case 0:
				RowData[5]="San Andreas";
				break;
			default:
				RowData[5]="Interior "+Interior;
				break;
		}
		RowData.push("");
		var Row=CreateTableRow(RowData);
		Row.id="teleporter_row_"+RowData[0];
		Row.onclick=function(){Teleporter_Highlight(RowData[0],RowData[2],RowData[3]);}
		Row.ondblclick=function(){Teleporter_ShowEditDialog(RowData[0],RowData[1],RowData[2],RowData[3],RowData[4],Interior);}
		var TD=Row.getElementsByTagName("td");
		RowData[5]=Interior;
		Teleporter_AddListButtons(TD[6],RowData);
		document.getElementById("teleporter_tablebody").appendChild(Row);
	}
}

function Teleporter_AddToCheatList(ID,Description)
{
	var Cheat="TeleportTo "+ID;
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		var Url="?ajaxrequest=cheatlist&mode=setcheat";
		Url=Url+"&newcheat="+escape(Cheat);
		Url=Url+"&description="+escape(Description);
		XmlHttp.open("GET",Url,true);
		XmlHttp.onreadystatechange=Teleporter_AddToCheatList_GetData;
		XmlHttp.send(null);
	}
	function Teleporter_AddToCheatList_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText;
			var ReturnCode=parseInt(Data.substr(0,1));
			switch (ReturnCode)
			{
				case 1:
					var RowData=Data.substr(1);
					Cheatlist_AddRow(RowData);
					var Text="<?php echo Language("The place has been added to the cheat list!\\n\\nCheat: %1");?>";
					alert(unescape(Text.replace("%1",Cheat)));
					break;
				case 2:
					alert("<?php echo Language("Can not save cheatlist!");?>");
					break;
				case 3:
					var Text="<?php echo Language("The cheat already exists!\\n\\nCheat: %1");?>";
					alert(Text.replace("%1",Cheat));
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(Text.replace("%1",ReturnCode));
					break;
			}
		}
	}
}

function Teleporter_EditRow(ID,Data)
{
	var RowData=Data.split("\t");
	if (RowData[0])
	{
		var Row=document.getElementById("teleporter_row_"+ID);
		var Interior=parseInt(RowData[5]);
		Row.onclick=function(){Teleporter_Highlight(RowData[0],RowData[2],RowData[3]);}
		Row.ondblclick=function(){Teleporter_ShowEditDialog(RowData[0],RowData[1],RowData[2],RowData[3],RowData[4],Interior);}
		var Row=Row.getElementsByTagName("td");
		switch (Interior)
		{
			case -1:
				RowData[5]="<?php echo Language("Do not change");?>";
				break;
			case 0:
				RowData[5]="San Andreas";
				break;
			default:
				RowData[5]="Interior "+Interior;
				break;
		}
		Row[0].innerHTML=RowData[0];
		Row[1].innerHTML=RowData[1];
		Row[2].innerHTML=RowData[2];
		Row[3].innerHTML=RowData[3];
		Row[4].innerHTML=RowData[4];
		Row[5].innerHTML=RowData[5];
		RowData[5]=Interior;
		Teleporter_AddListButtons(Row[6],RowData);
	}
}

function Teleporter_Highlight(ID,X,Y)
{
	Table_MouseClick("teleporter_tablebody",document.getElementById("teleporter_row_"+ID));
	Teleporter_ShowOnMap(X,Y)
}

function Teleporter_MapClick()
{
	var Div=document.getElementById("teleporter_maparea");
	var X=(MousePositionX-GetAbsoluteX(Div)+Div.scrollLeft)/Teleporter_MapZoomFactor*10;
	var Y=(MousePositionY-GetAbsoluteY(Div)+Div.scrollTop)/Teleporter_MapZoomFactor*10;
	document.getElementById("dialog_teleporter_edit_posx").value=X-3000;
	if (Y>3000)
	{
		Y2=parseFloat("-"+(Y-3000));
	}
	else
	{
		Y2=3000-Y;
	}
	document.getElementById("dialog_teleporter_edit_posy").value=Y2;
	Teleporter_MovePointer("current",X,Y,false);
}

function Teleporter_MovePointer(LineType,X,Y,Scroll)
{
	var Div=document.getElementById("teleporter_maparea");
	var Map=document.getElementById("teleporter_mapimage");
	var LineX=document.getElementById("teleporter_mapline_"+LineType+"_x");
	var LineY=document.getElementById("teleporter_mapline_"+LineType+"_y");
	Opacity(LineX,0.7);
	Opacity(LineY,0.7);
	Teleporter_MapLine[LineType][0]=X;
	Teleporter_MapLine[LineType][1]=Y;
	X=X/10*Teleporter_MapZoomFactor;
	Y=Y/10*Teleporter_MapZoomFactor;
	if (X>=0 && Y>=0)
	{
		LineX.style.left=(X-1)+"px";
		LineX.style.height=Map.height+"px";
		LineX.style.display="";
		LineY.style.top=(Y-1)+"px";
		LineY.style.width=Map.width+"px";
		LineY.style.display="";
		if (Scroll)
		{
			Div.scrollLeft=X-Div.offsetWidth/2;
			Div.scrollTop=Y-Div.offsetHeight/2;
		}
	}
	else
	{
		LineX.style.display="none";
		LineY.style.display="none";
	}
}

function Teleporter_RecalculateMapSize(ScrollType)
{
	var Map=document.getElementById("teleporter_mapimage");
	Map.width=Teleporter_MapZoomFactor*600;
	Map.height=Teleporter_MapZoomFactor*600;
	for (var Pointer in Teleporter_MapLine)
	{
		if (Pointer==ScrollType)
		{
			Scroll=true;
		}
		else
		{
			Scroll=false;
		}
		Teleporter_MovePointer(Pointer,Teleporter_MapLine[Pointer][0],Teleporter_MapLine[Pointer][1],Scroll);
	}
}

function Teleporter_Reload(Sort)
{
	RemoveElementChilds(document.getElementById("teleporter_tablebody"));
	document.getElementById("teleporter_mapimage").src="<?php echo GetConfigValue("Teleporter","MapUrl","files/maps");?>/"+Teleporter_MapFile+".jpg";
	Teleporter_RecalculateMapSize("");
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=teleporter&mode=getlist&sort="+Sort,true);
		XmlHttp.onreadystatechange=Teleporter_Reload_GetData;
		XmlHttp.send(null);
	}
	function Teleporter_Reload_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				Teleporter_AddRow(Data[Row]);
			}
		}
	}
}

function Teleporter_RemoveAllPlaces()
{
	if (confirm(unescape("<?php echo Language("Are you sure you want to remove all teleport locations?");?>")))
	{
		var XmlHttp=CreateXmlHttpRequest();
		if (XmlHttp)
		{
			XmlHttp.open("GET","?ajaxrequest=teleporter&mode=removeallplaces",true);
			XmlHttp.onreadystatechange=Teleporter_RemoveAllPlaces_GetData;
			XmlHttp.send(null);
		}
	}
	function Teleporter_RemoveAllPlaces_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText);
			if (ReturnCode==1)
			{
				Teleporter_Reload('');
			}
			else
			{
				var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
				alert(Text.replace("%1",ReturnCode));
			}
		}
	}
}

function Teleporter_RemovePlace(ID,Name)
{
	if (confirm(unescape("<?php echo Language("Are you sure you want to remove the place?");?>\n\nName: "+Name)))
	{
		var XmlHttp=CreateXmlHttpRequest();
		if (XmlHttp)
		{
			XmlHttp.open("GET","?ajaxrequest=teleporter&mode=removeplace&id="+ID,true);
			XmlHttp.onreadystatechange=Teleporter_RemovePlace_GetData;
			XmlHttp.send(null);
		}
	}
	function Teleporter_RemovePlace_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText);
			switch (ReturnCode)
			{
				case 1:
					var Table=document.getElementById("teleporter_tablebody");
					for (var Row=0;Row<Table.rows.length;Row++)
					{
						if (Table.rows[Row].cells[0].innerHTML==ID)
						{
							Table.deleteRow(Row);
							break;
						}
					}
					break;
				case 2:
					alert("<?php echo Language("Can not save teleport list!");?>");
					break;
				case 2:
					alert("<?php echo Language("Place not found!\\nClick on refresh and try again.");?>");
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(Text.replace("%1",ReturnCode));
					break;
			}
		}
	}
}

function Teleporter_ShowEditDialog(ID,Description,X,Y,Z,Interior)
{
	if (ID)
	{
		SetDialogTitle('teleporter','<?php echo Language("Edit location");?>');
	}
	else
	{
		SetDialogTitle('teleporter','<?php echo Language("Add location");?>');
	}
	var Dialog=document.getElementById("dialog_teleporter");
	var InteriorList=document.getElementById("dialog_teleporter_edit_interior");
	document.getElementById("dialog_teleporter_edit_id").value=unescape(ID);
	document.getElementById("dialog_teleporter_edit_description").value=unescape(Description);
	document.getElementById("dialog_teleporter_edit_posx").value=unescape(X);
	document.getElementById("dialog_teleporter_edit_posy").value=unescape(Y);
	document.getElementById("dialog_teleporter_edit_posz").value=unescape(Z);
	for (var Int=0;Int<InteriorList.length;Int++)
	{
		if (InteriorList[Int].value==unescape(Interior))
		{
			InteriorList.selectedIndex=Int;
			break;
		}
	}
	Dialog.style.visibility="visible";
}

function Teleporter_ShowOnMap(X,Y)
{
	X=parseFloat(X)+3000;
	Y=parseFloat(Y);
	if (Y<0)
	{
		Y=Math.abs(Y)+3000;
	}
	else
	{
		Y=3000-Y;
	}
	Teleporter_MovePointer("selection",X,Y,true);
}

function Teleporter_TeleportToPlace(X,Y,Z)
{
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=teleporter&mode=teleporttoplace&x="+X+"&y="+Y+"&z="+Z,true);
		XmlHttp.onreadystatechange=Teleporter_TeleportToPlace_GetData;
		XmlHttp.send(null);
	}
	function Teleporter_TeleportToPlace_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText);
			switch (ReturnCode)
			{
				case 1:
					alert(unescape("<?php echo Language("You have been teleported to your selected place.");?>"));
					break;
				case 2:
					alert(unescape("<?php echo Language("The game is not ready!");?>"));
					break;
				case 3:
					alert(unescape("<?php echo Language("GTA San Andreas is not running!");?>"));
					break;
				case 4:
					alert(unescape("<?php echo Language("The cheat has been not processed by the CheatProcessor!");?>"));
					break;
				case 5:
					alert(unescape("<?php echo Language("The CheatProcessor is not running!");?>"));
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(unescape(Text.replace("%1",ReturnCode)));
					break;
			}
		}
	}
}

function Teleporter_TeleportToTarget()
{
	if (Teleporter_MapLine["current"][0] &&Teleporter_MapLine["current"][1])
	{
		var Z=prompt(unescape("<?php echo Language("Input the value for the Z-axis (Height).");?>"));
		var X=Teleporter_MapLine["current"][0];
		var Y=Teleporter_MapLine["current"][1];
		if (Z)
		{
			if (Y>3000)
			{
				Y=parseFloat("-"+(Y-3000));
			}
			else
			{
				Y=3000-Y;
			}
			Teleporter_TeleportToPlace(X,Y,parseFloat(Z));
		}
	}
	else
	{
		alert(unescape("<?php echo Language("Please select a target on the map!");?>"));
	}
}

function Teleporter_ZoomMap(Step)
{
	Teleporter_MapZoomFactor=Teleporter_MapZoomFactor+Step;
	if (Teleporter_MapZoomFactor<1 || Teleporter_MapZoomFactor>10)
	{
		if (Step<0)
		{
			Teleporter_MapZoomFactor=1;
		}
		else
		{
			Teleporter_MapZoomFactor=10;
		}
	}
	Teleporter_RecalculateMapSize("current");
}