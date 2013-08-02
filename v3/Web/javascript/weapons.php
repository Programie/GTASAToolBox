function Weapons_AddListButtons(Element,RowData,Type)
{
	var Table=document.createElement("table");
	var TR=document.createElement("tr");
	var TD1=document.createElement("td");
	var TD2=document.createElement("td");
	var TD3=document.createElement("td");
	Table.cellPadding=0;
	Table.cellSpacing=0;
	TD1.onclick=function(){Weapons_AddToCheatList(RowData[0],RowData[1]);}
	TD1.style.width="20px";
	TD1.style.height="20px";
	TD1.style.backgroundImage="url(files/listbuttons/addcheat.png)";
	TD1.style.cursor="pointer";
	TD1.title=unescape("<?php echo Language("Add to cheat list");?>");
	if (Type=="favorites")
	{
		TD2.onclick=function(){Weapons_RemoveFromFavorites(RowData[0],RowData[1]);}
		TD2.style.backgroundImage="url(files/listbuttons/remove.png)";
		TD2.title=unescape("<?php echo Language("Remove from favorites");?>");
	}
	else
	{
		TD2.onclick=function(){Weapons_AddToFavorites(RowData[0],RowData[1]);}
		TD2.style.backgroundImage="url(files/listbuttons/favorites.png)";
		TD2.title=unescape("<?php echo Language("Add to favorites");?>");
	}
	TD2.style.width="20px";
	TD2.style.height="20px";
	TD2.style.cursor="pointer";
	TD3.onclick=function(){Weapons_Spawn(RowData[0]);}
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

function Weapons_AddRow(RowData,Type)
{
	RowData.push("");
	var Row=CreateTableRow(RowData);
	Row.id="weapons_row_"+RowData[0];
	Row.onclick=function(){Weapons_Highlight(RowData[0]);}
	var TD=Row.getElementsByTagName("td");
	Weapons_AddListButtons(TD[6],RowData,Type);
	document.getElementById("weapons_tablebody").appendChild(Row);
}

function Weapons_AddToCheatList(WeaponID,Name)
{
	var Cheat="SpawnWeapon "+WeaponID;
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		var Description="<?php echo Language("Spawn %1");?>";
		var Url="?ajaxrequest=cheatlist&mode=setcheat";
		Url=Url+"&newcheat="+escape(Cheat);
		Url=Url+"&description="+escape(Description.replace("%1",Name));
		XmlHttp.open("GET",Url,true);
		XmlHttp.onreadystatechange=Weapons_AddToCheatList_GetData;
		XmlHttp.send(null);
	}
	function Weapons_AddToCheatList_GetData()
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
					var Text="<?php echo Language("The weapon has been added to the cheat list!\\n\\nCheat: %1");?>";
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

function Weapons_AddToFavorites(WeaponID,Name)
{
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=weapons&mode=addfavorite&weaponid="+WeaponID,true);
		XmlHttp.onreadystatechange=Weapons_AddToFavorites_GetData;
		XmlHttp.send(null);
	}
	function Weapons_AddToFavorites_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText;
			var ReturnCode=parseInt(Data.substr(0,1));
			switch (ReturnCode)
			{
				case 1:
					alert(unescape("<?php echo Language("The weapon has been added to the favorite list.");?>"));
					break;
				case 2:
					alert(unescape("<?php echo Language("The weapon already exists in the favorite list!");?>"));
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(Text.replace("%1",ReturnCode));
					break;
			}
		}
	}
}

function Weapons_Highlight(ID)
{
	Weapons_CurrentRow=ID;
	Table_MouseClick("weapons_tablebody",document.getElementById("weapons_row_"+ID));
	Weapons_LoadInfo(ID);
}

function Weapons_LoadInfo(WeaponID)
{
	Weapons_LastWeaponID=WeaponID;
	RemoveElementChilds(document.getElementById("weapons_infotable"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=weapons&mode=getinfo&weaponid="+WeaponID,true);
		XmlHttp.onreadystatechange=Weapons_LoadInfo_GetData;
		XmlHttp.send(null);
	}
	function Weapons_LoadInfo_GetData()
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
					document.getElementById("weapons_infotable").appendChild(TR);
				}
			}
		}
	}
	document.getElementById("weapons_picture").src="?ajaxrequest=weapons&mode=getpicture&weaponid="+WeaponID;
}

function Weapons_Reload(Sort,Type)
{
	if (Type=="last")
	{
		Type=Weapons_LastType;
	}
	Weapons_LastType=Type;
	RemoveElementChilds(document.getElementById("weapons_tablebody"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=weapons&mode=getlist&type="+Type+"&sort="+Sort,true);
		XmlHttp.onreadystatechange=Weapons_Reload_GetData;
		XmlHttp.send(null);
	}
	function Weapons_Reload_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				var RowData=Data[Row].split("\t");
				if (RowData[0])
				{
					Weapons_AddRow(RowData,Type);
				}
			}
			if (Weapons_CurrentRow)
			{
				Weapons_Highlight(Weapons_CurrentRow);
			}
		}
	}
}

function Weapons_RemoveFromFavorites(WeaponID,Name)
{
	if (confirm(unescape("<?php echo Language("Are you sure you want to remove the weapon from your favorites?");?>")+"\n\nName: "+Name))
	{
		var XmlHttp=CreateXmlHttpRequest();
		if (XmlHttp)
		{
			XmlHttp.open("GET","?ajaxrequest=weapons&mode=removefavorite&weaponid="+WeaponID,true);
			XmlHttp.onreadystatechange=Weapons_RemoveFromFavorites_GetData;
			XmlHttp.send(null);
		}
	}
	function Weapons_RemoveFromFavorites_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText;
			var ReturnCode=parseInt(Data.substr(0,1));
			switch (ReturnCode)
			{
				case 1:
					Weapons_Reload("","favorites");
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(Text.replace("%1",ReturnCode));
					break;
			}
		}
	}
}

function Weapons_Spawn(WeaponID)
{
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=weapons&mode=spawn&weaponid="+WeaponID,true);
		XmlHttp.onreadystatechange=Weapons_Spawn_GetData;
		XmlHttp.send(null);
	}
	function Weapons_Spawn_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText;
			var ReturnCode=parseInt(Data.substr(0,1));
			switch (ReturnCode)
			{
				case 1:
					alert(unescape("<?php echo Language("The weapons has been spawned.");?>"));
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