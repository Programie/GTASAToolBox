function MemoryChanger_AddEditAddress()
{
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		var Url="?ajaxrequest=memorychanger&mode=setaddress";
		Url=Url+"&id="+escape(document.getElementById("dialog_memorychanger_edit_id").value);
		Url=Url+"&name="+escape(document.getElementById("dialog_memorychanger_edit_name").value);
		Url=Url+"&address="+escape(document.getElementById("dialog_memorychanger_edit_address").value);
		Url=Url+"&type="+escape(document.getElementById("dialog_memorychanger_edit_type").value);
		Url=Url+"&size="+escape(document.getElementById("dialog_memorychanger_edit_size").value);
		XmlHttp.open("GET",Url,true);
		XmlHttp.onreadystatechange=MemoryChanger_AddEditAddress_GetData;
		XmlHttp.send(null);
	}
	function MemoryChanger_AddEditAddress_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText.substr(0,1));
			switch (ReturnCode)
			{
				case 1:
					var RowData=unescape(XmlHttp.responseText.substr(2));
					if (parseInt(XmlHttp.responseText.substr(1,1)))
					{
						MemoryChanger_AddRow(RowData,true);
					}
					else
					{
						MemoryChanger_EditRow(document.getElementById("dialog_memorychanger_edit_id").value,RowData);
					}
					MemoryChanger_HideEditDialog();
					break;
				case 2:
					alert("<?php echo Language("No address entered!");?>");
					break;
				case 3:
					alert("<?php echo Language("Can not save address list!");?>");
					break;
				default:
					var Text="<?php echo Language("Unknown error\\n\\nCode: %1");?>";
					alert(Text.replace("%1",ReturnCode));
					break;
			}
		}
	}
}

function MemoryChanger_AddRow(Data,ReadCurrentValue)
{
	var RowData=Data.split("\t");
	if (RowData[0])
	{
		var Row=CreateTableRow(RowData);
		Row.id="memorychanger_table_row"+RowData[0];
		Row.onclick=function(){MemoryChanger_Click(Row);}
		Row.ondblclick=function(){MemoryChanger_ShowEditDialog(RowData[0],RowData[1],RowData[2],RowData[3],RowData[4],RowData[6]);}
		document.getElementById("memorychanger_tablebody").appendChild(Row);
		if (ReadCurrentValue)
		{
			MemoryChanger_ReadCurrentValue(Row);
		}
	}
}

function MemoryChanger_EditRow(ID,Data)
{
	var RowData=Data.split("\t");
	var Row=document.getElementById("memorychanger_table_row"+ID);
	var TD=Row.getElementsByTagName("td");
	for (var Column=0;Column<RowData.length;Column++)
	{
		TD[Column].innerHTML=RowData[Column];
	}
	Row.ondblclick=function(){MemoryChanger_ShowEditDialog(RowData[0],RowData[1],RowData[2],RowData[3],RowData[4],RowData[6]);}
}

function MemoryChanger_AutoUpdate()
{
	if (CurrentPage=="memorychanger")
	{
		MemoryChanger_ReadCurrentValue(MemoryChanger_CurrentSelection);
	}
	else
	{
		clearInterval(MemoryChanger_CurrentSelectionUpdater);
	}
}

function MemoryChanger_Click(Row)
{
	Table_MouseClick("memorychanger_tablebody",Row);
	MemoryChanger_CurrentSelection=Row;
	if (MemoryChanger_CurrentSelectionUpdater)
	{
		clearInterval(MemoryChanger_CurrentSelectionUpdater);
	}
	<?php
	if (GetConfigValue("MemoryChanger","AutoUpdate","1"))
	{
		echo "MemoryChanger_CurrentSelectionUpdater=setInterval('MemoryChanger_AutoUpdate()',".GetConfigValue("MemoryChanger","AutoUpdateInterval","2000").");";
	}
	?>
}

function MemoryChanger_Dialog_CheckType()
{
	var SelectionElement=document.getElementById("dialog_memorychanger_edit_type");
	var SizeInputElement=document.getElementById("dialog_memorychanger_edit_size");
	if (SelectionElement.value==5 || SelectionElement.value==8)
	{
		SizeInputElement.disabled="";
	}
	else
	{
		SizeInputElement.disabled="disabled";
	}
}

function MemoryChanger_Dialog_CheckValue()
{
	var Element=document.getElementById("dialog_memorychanger_edit_value");
	if (document.getElementById("dialog_memorychanger_edit_value_checkbox").checked)
	{
		Element.disabled="";
	}
	else
	{
		Element.disabled="disabled";
	}
}

function MemoryChanger_HideEditDialog()
{
	document.getElementById("dialog_memorychanger").style.visibility="hidden";
}

function MemoryChanger_ReadCurrentValue(Row)
{
	var TD=Row.getElementsByTagName("td");
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=memorychanger&mode=readaddress&address="+TD[2].innerHTML+"&datatype="+TD[3].innerHTML+"&size="+TD[4].innerHTML,true);
		XmlHttp.onreadystatechange=MemoryChanger_ReadCurrentValue_GetData;
		XmlHttp.send(null);
	}
	function MemoryChanger_ReadCurrentValue_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var ReturnCode=parseInt(XmlHttp.responseText.substr(0,1));
			if (ReturnCode==1)
			{
				TD[5].innerHTML=XmlHttp.responseText.substr(1);
			}
		}
	}
}

function MemoryChanger_Reload(Sort)
{
	if (MemoryChanger_CurrentSelectionUpdater)
	{
		clearInterval(MemoryChanger_CurrentSelectionUpdater);
	}
	RemoveElementChilds(document.getElementById("memorychanger_tablebody"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=memorychanger&mode=getlist&sort="+Sort,true);
		XmlHttp.onreadystatechange=MemoryChanger_Reload_GetData;
		XmlHttp.send(null);
	}
	function MemoryChanger_Reload_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				MemoryChanger_AddRow(Data[Row],false);
			}
		}
	}
}

function MemoryChanger_ShowEditDialog(ID,Name,Address,Type,Size,Value)
{
	if (ID)
	{
		SetDialogTitle("memorychanger","<?php echo Language("Change memory address");?>");
	}
	else
	{
		SetDialogTitle("memorychanger","<?php echo Language("Add memory address");?>");
	}
	var Dialog=document.getElementById("dialog_memorychanger");
	var TypeList=document.getElementById("dialog_memorychanger_edit_type");
	document.getElementById("dialog_memorychanger_edit_id").value=unescape(ID);
	document.getElementById("dialog_memorychanger_edit_name").value=unescape(Name);
	document.getElementById("dialog_memorychanger_edit_address").value=unescape(Address).replace("0x","");
	document.getElementById("dialog_memorychanger_edit_size").value=unescape(Size);
	document.getElementById("dialog_memorychanger_edit_value").value=unescape(Value);
	TypeList.selectedIndex=0;
	for (var TypeID=0;TypeID<TypeList.length;TypeID++)
	{
		if (TypeList[TypeID].innerHTML==unescape(Type))
		{
			TypeList.selectedIndex=TypeID;
			break;
		}
	}
	MemoryChanger_Dialog_CheckType();
	Dialog.style.visibility="visible";
}