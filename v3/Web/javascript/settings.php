function Settings_AutoCheats_AddCheat(Cheat)
{
	if (!Cheat)
	{
		Cheat=document.getElementById("settings_addcheat").value.toUpperCase();
	}
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=settings&mode=addautocheat&cheat="+Cheat,true);
		XmlHttp.onreadystatechange=Settings_AutoCheats_AddCheat_GetData;
		XmlHttp.send(null);
	}
	function Settings_AutoCheats_AddCheat_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ResultCode=parseInt(XmlHttp.responseText);
			switch (ResultCode)
			{
				case 1:
					Settings_AutoCheats_AddRow(Cheat);
					break;
				case 2:
					alert(unescape("<?php echo Language("The cheat already exists!");?>"));
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(unescape(Text.replace("%1",ReturnCode)));
					break;
			}
		}
	}
}

function Settings_AutoCheats_AddListButtons(Element,RowData)
{
	var Table=document.createElement("table");
	var TR=document.createElement("tr");
	var TD1=document.createElement("td");
	var TD2=document.createElement("td");
	Table.cellPadding=0;
	Table.cellSpacing=0;
	TD1.onmouseover=function(){Opacity(this,0.5);}
	TD1.onmouseout=function(){Opacity(this);}
	TD1.onclick=function(){Settings_AutoCheats_RemoveCheat(RowData[0]);}
	TD1.style.width="20px";
	TD1.style.height="20px";
	TD1.style.backgroundImage="url(files/listbuttons/remove.png)";
	TD1.style.cursor="pointer";
	TD1.title=unescape("<?php echo Language("Remove");?>");
	TD2.onmouseover=function(){Opacity(this,0.5);}
	TD2.onmouseout=function(){Opacity(this);}
	TD2.onclick=function(){Cheatlist_Execute(RowData[0]);}
	TD2.style.width="20px";
	TD2.style.height="20px";
	TD2.style.backgroundImage="url(files/listbuttons/execute.png)";
	TD2.style.cursor="pointer";
	TD2.title=unescape("<?php echo Language("Execute");?>");
	TR.appendChild(TD1);
	TR.appendChild(TD2);
	Table.appendChild(TR);
	RemoveElementChilds(Element);
	Element.appendChild(Table);
}

function Settings_AutoCheats_AddRow(Data)
{
	var RowData=Data.split("\t");
	if (RowData[0])
	{
		var TR=document.createElement("tr");
		var TD1=document.createElement("td");
		var TD2=document.createElement("td");
		TR.id="settings_autocheats_tablebody_row_"+RowData[0];
		TR.onclick=function(){Table_MouseClick("settings_autocheats_tablebody",RowData[0]);}
		TD1.innerHTML=RowData[0];
		TD1.style.whiteSpace="nowrap";
		TD2.style.whiteSpace="nowrap";
		TR.appendChild(TD1);
		TR.appendChild(TD2);
		Settings_AutoCheats_AddListButtons(TD2,RowData);
		document.getElementById("settings_autocheats_tablebody").appendChild(TR);
	}
}

function Settings_AutoCheats_Reload()
{
	RemoveElementChilds(document.getElementById("settings_autocheats_tablebody"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=settings&mode=getautocheats",true);
		XmlHttp.onreadystatechange=Settings_AutoCheats_Reload_GetData;
		XmlHttp.send(null);
	}
	function Settings_AutoCheats_Reload_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				Settings_AutoCheats_AddRow(Data[Row]);
			}
		}
	}
}

function Settings_AutoCheats_RemoveCheat(Cheat)
{
	if (confirm(unescape("<?php echo Language("Are you sure you want to remove the cheat?");?>")+"\n\nCheat: "+Cheat))
	{
		var XmlHttp=CreateXmlHttpRequest();
		if (XmlHttp)
		{
			XmlHttp.open("GET","?ajaxrequest=settings&mode=removeautocheat&cheat="+Cheat,true);
			XmlHttp.onreadystatechange=Settings_AutoCheats_RemoveCheat_GetData;
			XmlHttp.send(null);
		}
	}
	function Settings_AutoCheats_RemoveCheat_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText);
			switch (ReturnCode)
			{
				case 1:
					var Table=document.getElementById("settings_autocheats_tablebody");
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
					alert(unescape("<?php echo Language("The cheat does not exists!");?>"));
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(unescape(Text.replace("%1",ReturnCode)));
					break;
			}
		}
	}
}

function Settings_PlayCheatSound()
{
	var PreviewElement=document.getElementById("settings_cheatsound_preview");
	try
	{
		PreviewElement.Play();
	}
	catch(e)
	{
		PreviewElement.DoPlay();
	}
}

function Settings_Reset()
{
	document.getElementById("settings_form").reset();
}

function Settings_Save()
{
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		var Parameters="";
		var Form=document.getElementById("settings_form");
		var InputElements=Form.getElementsByTagName("input");
		var SelectElements=Form.getElementsByTagName("select");
		for (var Element=0;Element<InputElements.length;Element++)
		{
			if (Parameters)
			{
				Parameters=Parameters+"&";
			}
			if (InputElements[Element].type=="checkbox")
			{
				if (InputElements[Element].checked)
				{
					Value=1;
				}
				else
				{
					Value=0;
				}
			}
			else
			{
				Value=InputElements[Element].value;
			}
			Parameters=Parameters+InputElements[Element].id+"="+encodeURI(Value);
		}
		for (var Element=0;Element<SelectElements.length;Element++)
		{
			if (Parameters)
			{
				Parameters=Parameters+"&";
			}
			Parameters=Parameters+SelectElements[Element].id+"="+encodeURI(SelectElements[Element].value);
		}
		XmlHttp.open("POST","?ajaxrequest=settings&mode=save",true);
		XmlHttp.onreadystatechange=Settings_Save_GetData;
		XmlHttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		XmlHttp.setRequestHeader("Content-length",Parameters.length);
		XmlHttp.setRequestHeader("Connection","close");
		XmlHttp.send(Parameters);
	}
	function Settings_Save_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			alert(unescape("<?php echo Language("The settings were saved!\\nYou may have to reload the webinterface to see the changes.");?>"));
		}
	}
}

function Settings_SetCheatSoundPreview()
{
	var List=document.getElementById("settings_cheatsound_sound");
	alert(document.getElementById("settings_cheatsound_preview").src);
	document.getElementById("settings_cheatsound_preview").src="?ajaxrequest=settings&mode=playcheatsound&file="+List.options[List.selectedIndex].value;
	alert(document.getElementById("settings_cheatsound_preview").src);
}

function Settings_ToggleFold(Name)
{
	var Element=document.getElementById("settings_content_"+Name);
	var Folder=document.getElementById("settings_folder_"+Name);
	var Title=Folder.innerHTML.substring(0,Folder.innerHTML.lastIndexOf(" "));
	if (Element.style.display=="none")
	{
		Element.style.display="block";
		Folder.innerHTML=Title+" &lt;&lt;";
		Folder.title=unescape("<?php echo Language("Click to fold");?>");
	}
	else
	{
		Element.style.display="none";
		Folder.innerHTML=Title+" &gt;&gt;";
		Folder.title=unescape("<?php echo Language("Click to unfold");?>");
	}
}