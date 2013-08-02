function Vehicles_AddListButtons(Element,RowData,Type)
{
	var Table=document.createElement("table");
	var TR=document.createElement("tr");
	var TD1=document.createElement("td");
	var TD2=document.createElement("td");
	var TD3=document.createElement("td");
	Table.cellPadding=0;
	Table.cellSpacing=0;
	TD1.onclick=function(){Vehicles_AddToCheatList(RowData[0],RowData[1]);}
	TD1.style.width="20px";
	TD1.style.height="20px";
	TD1.style.backgroundImage="url(files/listbuttons/addcheat.png)";
	TD1.style.cursor="pointer";
	TD1.title=unescape("<?php echo Language("Add to cheat list");?>");
	if (Type=="favorites")
	{
		TD2.onclick=function(){Vehicles_RemoveFromFavorites(RowData[0],RowData[1]);}
		TD2.style.backgroundImage="url(files/listbuttons/remove.png)";
		TD2.title=unescape("<?php echo Language("Remove from favorites");?>");
	}
	else
	{
		TD2.onclick=function(){Vehicles_AddToFavorites(RowData[0],RowData[1]);}
		TD2.style.backgroundImage="url(files/listbuttons/favorites.png)";
		TD2.title=unescape("<?php echo Language("Add to favorites");?>");
	}
	TD2.style.width="20px";
	TD2.style.height="20px";
	TD2.style.cursor="pointer";
	TD3.onclick=function(){Vehicles_Spawn(RowData[0]);}
	TD3.style.width="20px";
	TD3.style.height="20px";
	TD3.style.backgroundImage="url(files/listbuttons/spawn.png)";
	TD3.style.cursor="pointer";
	TD3.title=unescape("<?php echo Language("Spawn");?>");
	TR.appendChild(TD1);
	TR.appendChild(TD2);
	TR.appendChild(TD3);
	Table.appendChild(TR);
	RemoveElementChilds(Element);
	Element.appendChild(Table);
}

function Vehicles_AddRow(RowData,Type)
{
	RowData.push("");
	var Row=CreateTableRow(RowData);
	Row.id="vehicles_row_"+RowData[0];
	Row.onclick=function(){Vehicles_Highlight(RowData[0]);}
	var TD=Row.getElementsByTagName("td");
	Vehicles_AddListButtons(TD[4],RowData,Type);
	document.getElementById("vehicles_tablebody").appendChild(Row);
}

function Vehicles_AddToCheatList(ModelID,Name)
{
	var Cheat="SpawnVehicle "+ModelID;
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		var Description="<?php echo Language("Spawn %1");?>";
		var Url="?ajaxrequest=cheatlist&mode=setcheat";
		Url=Url+"&newcheat="+escape(Cheat);
		Url=Url+"&description="+escape(Description.replace("%1",Name));
		XmlHttp.open("GET",Url,true);
		XmlHttp.onreadystatechange=Vehicles_AddToCheatList_GetData;
		XmlHttp.send(null);
	}
	function Vehicles_AddToCheatList_GetData()
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
					var Text="<?php echo Language("The vehicle has been added to the cheat list!\\n\\nCheat: %1");?>";
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

function Vehicles_AddToFavorites(ModelID,Name)
{
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=vehicles&mode=addfavorite&modelid="+ModelID,true);
		XmlHttp.onreadystatechange=Vehicles_AddToFavorites_GetData;
		XmlHttp.send(null);
	}
	function Vehicles_AddToFavorites_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText;
			var ReturnCode=parseInt(Data.substr(0,1));
			switch (ReturnCode)
			{
				case 1:
					alert(unescape("<?php echo Language("The vehicle has been added to the favorite list.");?>"));
					break;
				case 2:
					alert(unescape("<?php echo Language("The vehicle already exists in the favorite list!");?>"));
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(Text.replace("%1",ReturnCode));
					break;
			}
		}
	}
}

function Vehicles_Highlight(ID)
{
	Vehicles_CurrentRow=ID;
	Table_MouseClick("vehicles_tablebody",document.getElementById("vehicles_row_"+ID));
	Vehicles_LoadInfo(ID);
}

function Vehicles_LoadInfo(ModelID)
{
	Vehicles_LastModelID=ModelID;
	RemoveElementChilds(document.getElementById("vehicles_infotable"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=vehicles&mode=getinfo&modelid="+ModelID,true);
		XmlHttp.onreadystatechange=Vehicles_LoadInfo_GetData;
		XmlHttp.send(null);
	}
	function Vehicles_LoadInfo_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				var RowData=Data[Row].split("\t");
				if (RowData[0])
				{
					var TR=CreateTableRow(RowData);
					document.getElementById("vehicles_infotable").appendChild(TR);
				}
			}
		}
	}
	document.getElementById("vehicles_picture").src="?ajaxrequest=vehicles&mode=getpicture&modelid="+ModelID;
}

function Vehicles_Reload(Sort,Type)
{
	if (Type=="last")
	{
		Type=Vehicles_LastType;
	}
	Vehicles_LastType=Type;
	RemoveElementChilds(document.getElementById("vehicles_tablebody"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=vehicles&mode=getlist&type="+Type+"&sort="+Sort,true);
		XmlHttp.onreadystatechange=Vehicles_Reload_GetData;
		XmlHttp.send(null);
	}
	function Vehicles_Reload_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				var RowData=Data[Row].split("\t");
				if (RowData[0])
				{
					Vehicles_AddRow(RowData,Type);
				}
			}
			if (Vehicles_CurrentRow)
			{
				Vehicles_Highlight(Vehicles_CurrentRow);
			}
		}
	}
}

function Vehicles_RemoveFromFavorites(ModelID,Name)
{
	if (confirm(unescape("<?php echo Language("Are you sure you want to remove the vehicle from your favorites?");?>")+"\n\nName: "+Name))
	{
		var XmlHttp=CreateXmlHttpRequest();
		if (XmlHttp)
		{
			XmlHttp.open("GET","?ajaxrequest=vehicles&mode=removefavorite&modelid="+ModelID,true);
			XmlHttp.onreadystatechange=Vehicles_RemoveFromFavorites_GetData;
			XmlHttp.send(null);
		}
	}
	function Vehicles_RemoveFromFavorites_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText;
			var ReturnCode=parseInt(Data.substr(0,1));
			switch (ReturnCode)
			{
				case 1:
					Vehicles_Reload("","favorites");
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(Text.replace("%1",ReturnCode));
					break;
			}
		}
	}
}

function Vehicles_Spawn(ModelID)
{
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=vehicles&mode=spawn&modelid="+ModelID,true);
		XmlHttp.onreadystatechange=Vehicles_Spawn_GetData;
		XmlHttp.send(null);
	}
	function Vehicles_Spawn_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText;
			var ReturnCode=parseInt(Data.substr(0,1));
			switch (ReturnCode)
			{
				case 1:
					alert(unescape("<?php echo Language("The vehicle has been spawned.");?>"));
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