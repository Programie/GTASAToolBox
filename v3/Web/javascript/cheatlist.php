function Cheatlist_AddEditCheat()
{
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		var Ctrl="";
		var Shift="";
		var Alt="";
		if (document.getElementById("dialog_cheatlist_edit_shortcut_ctrl").checked)
		{
			Ctrl="1";
		}
		if (document.getElementById("dialog_cheatlist_edit_shortcut_shift").checked)
		{
			Shift="1";
		}
		if (document.getElementById("dialog_cheatlist_edit_shortcut_alt").checked)
		{
			Alt="1";
		}
		var Url="?ajaxrequest=cheatlist&mode=setcheat";
		Url=Url+"&oldcheat="+escape(document.getElementById("dialog_cheatlist_edit_oldcheat").value);
		Url=Url+"&newcheat="+escape(document.getElementById("dialog_cheatlist_edit_cheat").value);
		Url=Url+"&description="+escape(document.getElementById("dialog_cheatlist_edit_description").value);
		Url=Url+"&shortcut_ctrl="+Ctrl;
		Url=Url+"&shortcut_shift="+Shift;
		Url=Url+"&shortcut_alt="+Alt;
		Url=Url+"&shortcut_key="+escape(document.getElementById("dialog_cheatlist_edit_shortcut_key").value);
		XmlHttp.open("GET",Url,true);
		XmlHttp.onreadystatechange=Cheatlist_AddEditCheat_GetData;
		XmlHttp.send(null);
	}
	function Cheatlist_AddEditCheat_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText;
			var ReturnCode=parseInt(Data.substr(0,1));
			Data=Data.substr(1);
			switch (ReturnCode)
			{
				case 1:
					var OldCheat=document.getElementById("dialog_cheatlist_edit_oldcheat").value;
					if (OldCheat)
					{
						Cheatlist_EditRow(OldCheat,Data);
					}
					else
					{
						Cheatlist_AddRow(Data);
					}
					HideDialog("cheatlist");
					break;
				case 2:
					alert("<?php echo Language("Can not save cheatlist!");?>");
					break;
				case 3:
					alert("<?php echo Language("The cheat already exists!");?>");
					break;
				case 4:
					Text="<?php echo Language("The shortcut is already in use by %1!");?>";
					alert(Text.replace("%1",Data));
					break;
				case 5:
					alert("<?php echo Language("No cheat entered!");?>");
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(Text.replace("%1",ReturnCode));
					break;
			}
		}
	}
}

function Cheatlist_AddListButtons(Element,RowData)
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
	TD1.onclick=function(){Cheatlist_ShowEditDialog(RowData[0],RowData[1],RowData[2],RowData[0]);}
	TD1.style.width="20px";
	TD1.style.height="20px";
	TD1.style.backgroundImage="url(files/listbuttons/edit.png)";
	TD1.style.cursor="pointer";
	TD1.title=unescape("<?php echo Language("Edit");?>");
	TD2.onmouseover=function(){Opacity(this,0.5);}
	TD2.onmouseout=function(){Opacity(this);}
	TD2.onclick=function(){Cheatlist_RemoveCheat(RowData[0]);}
	TD2.style.width="20px";
	TD2.style.height="20px";
	TD2.style.backgroundImage="url(files/listbuttons/remove.png)";
	TD2.style.cursor="pointer";
	TD2.title=unescape("<?php echo Language("Remove");?>");
	TD3.onmouseover=function(){Opacity(this,0.5);}
	TD3.onmouseout=function(){Opacity(this);}
	TD3.onclick=function(){Cheatlist_Execute(RowData[0]);}
	TD3.style.width="20px";
	TD3.style.height="20px";
	TD3.style.backgroundImage="url(files/listbuttons/execute.png)";
	TD3.style.cursor="pointer";
	TD3.title=unescape("<?php echo Language("Execute");?>");
	TD4.onmouseover=function(){Opacity(this,0.5);}
	TD4.onmouseout=function(){Opacity(this);}
	TD4.onclick=function(){Settings_AutoCheats_AddCheat(RowData[0]);}
	TD4.style.width="20px";
	TD4.style.height="20px";
	TD4.style.backgroundImage="url(files/listbuttons/addcheat.png)";
	TD4.style.cursor="pointer";
	TD4.title=unescape("<?php echo Language("Add to automatically activated cheats");?>");
	TR.appendChild(TD1);
	TR.appendChild(TD2);
	TR.appendChild(TD3);
	TR.appendChild(TD4);
	Table.appendChild(TR);
	RemoveElementChilds(Element);
	Element.appendChild(Table);
}

function Cheatlist_AddRow(Data)
{
	var RowData=Data.split("\t");
	if (RowData[0])
	{
		RowData.push("");
		var Row=CreateTableRow(RowData);
		Row.id="cheatlist_row_"+RowData[0];
		Row.ondblclick=function(){Cheatlist_ShowEditDialog(RowData[0],RowData[1],RowData[2],RowData[0]);}
		Row.onclick=function(){Table_MouseClick("cheatlist_tablebody",document.getElementById("cheatlist_row_"+RowData[0]));}
		var TD=Row.getElementsByTagName("td");
		Cheatlist_AddListButtons(TD[3],RowData);
		document.getElementById("cheatlist_tablebody").appendChild(Row);
	}
}

function Cheatlist_CheckShortcutSelection()
{
	var Ctrl=document.getElementById("dialog_cheatlist_edit_shortcut_ctrl");
	var Shift=document.getElementById("dialog_cheatlist_edit_shortcut_shift");
	var Alt=document.getElementById("dialog_cheatlist_edit_shortcut_alt");
	if (document.getElementById("dialog_cheatlist_edit_shortcut_key").selectedIndex==0)
	{
		Ctrl.disabled="disabled";
		Ctrl.checked=false;
		Shift.disabled="disabled";
		Shift.checked=false;
		Alt.disabled="disabled";
		Alt.checked=false;
	}
	else
	{
		Ctrl.disabled="";
		Shift.disabled="";
		Alt.disabled="";
	}
}

function Cheatlist_EditRow(OldCheat,Data)
{
	var RowData=Data.split("\t");
	if (RowData[0])
	{
		var Row=document.getElementById("cheatlist_row_"+OldCheat);
		Row.id="cheatlist_row_"+RowData[0];
		Row.ondblclick=function(){Cheatlist_ShowEditDialog(RowData[0],RowData[1],RowData[2],RowData[0]);}
		var Row=Row.getElementsByTagName("td");
		Row[0].innerHTML=RowData[0];
		Row[1].innerHTML=RowData[1];
		Row[2].innerHTML=RowData[2];
	}
}

function Cheatlist_Execute(Cheat)
{
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=cheatlist&mode=execute&cheat="+Cheat,true);
		XmlHttp.onreadystatechange=Cheatlist_Execute_GetData;
		XmlHttp.send(null);
	}
	function Cheatlist_Execute_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText);
			switch (ReturnCode)
			{
				case 1:
					alert(unescape("<?php echo Language("The cheat has been executed.");?>"));
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

function Cheatlist_Reload(Sort)
{
	RemoveElementChilds(document.getElementById("cheatlist_tablebody"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=cheatlist&mode=getlist&sort="+Sort,true);
		XmlHttp.onreadystatechange=Cheatlist_Reload_GetData;
		XmlHttp.send(null);
	}
	function Cheatlist_Reload_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				Cheatlist_AddRow(Data[Row]);
			}
		}
	}
}

function Cheatlist_RemoveAllCheats()
{
	if (confirm(unescape("<?php echo Language("Are you sure you want to remove all cheats?");?>")))
	{
		var XmlHttp=CreateXmlHttpRequest();
		if (XmlHttp)
		{
			XmlHttp.open("GET","?ajaxrequest=cheatlist&mode=removeallcheats",true);
			XmlHttp.onreadystatechange=Cheatlist_RemoveAllCheats_GetData;
			XmlHttp.send(null);
		}
	}
	function Cheatlist_RemoveAllCheats_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText);
			if (ReturnCode==1)
			{
				Cheatlist_Reload('');
			}
			else
			{
				var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
				alert(Text.replace("%1",ReturnCode));
			}
		}
	}
}

function Cheatlist_RemoveCheat(Cheat)
{
	if (confirm(unescape("<?php echo Language("Are you sure you want to remove the cheat?");?>")+"\n\nCheat: "+Cheat))
	{
		var XmlHttp=CreateXmlHttpRequest();
		if (XmlHttp)
		{
			XmlHttp.open("GET","?ajaxrequest=cheatlist&mode=removecheat&cheat="+Cheat,true);
			XmlHttp.onreadystatechange=Cheatlist_RemoveCheat_GetData;
			XmlHttp.send(null);
		}
	}
	function Cheatlist_RemoveCheat_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText);
			switch (ReturnCode)
			{
				case 1:
					var Table=document.getElementById("cheatlist_tablebody");
					for (var Row=0;Row<Table.rows.length;Row++)
					{
						if (Table.rows[Row].cells[0].innerHTML==Cheat)
						{
							Table.deleteRow(Row);
							break;
						}
					}
					break;
				case 2:
					alert("<?php echo Language("Can not save cheatlist!");?>");
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(Text.replace("%1",ReturnCode));
					break;
			}
		}
	}
}

function Cheatlist_ShowEditDialog(Cheat,Description,Shortcut,OldCheat)
{
	if (OldCheat)
	{
		SetDialogTitle('cheatlist','<?php echo Language("Edit cheat");?>');
	}
	else
	{
		SetDialogTitle('cheatlist','<?php echo Language("Add cheat");?>');
		OldCheat="";
	}
	var Dialog=document.getElementById("dialog_cheatlist");
	document.getElementById("dialog_cheatlist_edit_oldcheat").value=OldCheat;
	document.getElementById("dialog_cheatlist_edit_cheat").value=Cheat;
	document.getElementById("dialog_cheatlist_edit_description").value=Description;
	var Ctrl=document.getElementById('dialog_cheatlist_edit_shortcut_ctrl');
	var Shift=document.getElementById('dialog_cheatlist_edit_shortcut_shift');
	var Alt=document.getElementById('dialog_cheatlist_edit_shortcut_alt');
	var KeySelection=document.getElementById('dialog_cheatlist_edit_shortcut_key');
	Ctrl.checked=false;
	Shift.checked=false;
	Alt.checked=false;
	KeySelection.selectedIndex=0;
	if (typeof(Shortcut)!="undefined")
	{
		Shortcut=Shortcut.split('+');
		for (var Key=0;Key<Shortcut.length;Key++)
		{
			Shortcut[Key]=Shortcut[Key].trim();
			if (Shortcut[Key]==document.getElementById('dialog_cheatlist_edit_shortcut_ctrl_label').innerHTML)
			{
				Ctrl.checked=true;
			}
			if (Shortcut[Key]==document.getElementById('dialog_cheatlist_edit_shortcut_shift_label').innerHTML)
			{
				Shift.checked=true;
			}
			if (Shortcut[Key]==document.getElementById('dialog_cheatlist_edit_shortcut_alt_label').innerHTML)
			{
				Alt.checked=true;
			}
			for (AddKey=0;AddKey<KeySelection.length;AddKey++)
			{
				if (Shortcut[Key]==KeySelection[AddKey].innerHTML)
				{
					KeySelection.selectedIndex=AddKey;
					break;
				}
			}
		}
	}
	RemoveElementChilds(document.getElementById("dialog_cheatlist_edit_existingcheats"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=cheatlist&mode=getcheats",true);
		XmlHttp.onreadystatechange=Cheatlist_ShowEditDialog_GetData;
		XmlHttp.send(null);
	}
	function Cheatlist_ShowEditDialog_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var CheatList=document.getElementById("dialog_cheatlist_edit_existingcheats");
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				var RowData=Data[Row].split("\t");
				if (RowData[0])
				{
					var TR=CreateTableRow(RowData);
					TR.onclick=function()
					{
						var ThisRow=this.getElementsByTagName("td");
						document.getElementById("dialog_cheatlist_edit_cheat").value=ThisRow[0].innerHTML;
						document.getElementById("dialog_cheatlist_edit_description").value=ThisRow[1].innerHTML;
					}
					CheatList.appendChild(TR);
				}
			}
		}
	}
	Cheatlist_CheckShortcutSelection();
	document.getElementById("dialog_cheatlist_edit_existingcheatsdiv").style.display="none";
	Dialog.style.visibility="visible";
}

function Cheatlist_ToggleShowExistingCheats()
{
	var Element=document.getElementById("dialog_cheatlist_edit_existingcheatsdiv");
	if (Element.style.display=="none")
	{
		Element.style.display="";
	}
	else
	{
		Element.style.display="none";
	}
}