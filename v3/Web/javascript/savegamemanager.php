function SaveGameManager_AddRow(Row,RowData)
{
	var TR=CreateTableRow(RowData);
	TR.onclick=function(){Table_MouseClick("savegamemanager_tablebody",TR);}
	document.getElementById("savegamemanager_tablebody").appendChild(TR);
}

function SaveGameManager_Backups_AddRow(Row,RowData)
{
	RowData.push("");
	var TR=CreateTableRow(RowData);
	TR.onclick=function(){Table_MouseClick("savegamemanager_tablebody",TR);}
	var TD=TR.getElementsByTagName("td");
	var ButtonTable=document.createElement("table");
	var ButtonTR=document.createElement("tr");
	var ButtonTD1=document.createElement("td");
	var ButtonTD2=document.createElement("td");
	ButtonTable.cellPadding=0;
	ButtonTable.cellSpacing=0;
	ButtonTD1.onmouseover=function(){Opacity(this,0.5);}
	ButtonTD1.onmouseout=function(){Opacity(this);}
	ButtonTD1.onclick=function(){SaveGameManager_Backups_Restore(RowData[0]);}
	ButtonTD1.style.width="20px";
	ButtonTD1.style.height="20px";
	ButtonTD1.style.backgroundImage="url(files/listbuttons/restore.png)";
	ButtonTD1.style.cursor="pointer";
	ButtonTD1.title=unescape("<?php echo Language("Restore");?>");
	ButtonTD2.onmouseover=function(){Opacity(this,0.5);}
	ButtonTD2.onmouseout=function(){Opacity(this);}
	ButtonTD2.onclick=function(){SaveGameManager_Backups_Remove(RowData[0]);}
	ButtonTD2.style.width="20px";
	ButtonTD2.style.height="20px";
	ButtonTD2.style.backgroundImage="url(files/listbuttons/remove.png)";
	ButtonTD2.style.cursor="pointer";
	ButtonTD2.title=unescape("<?php echo Language("Remove");?>")
	ButtonTR.appendChild(ButtonTD1);
	ButtonTR.appendChild(ButtonTD2);
	ButtonTable.appendChild(ButtonTR);
	RemoveElementChilds(TD[4]);
	TD[4].appendChild(ButtonTable);
	document.getElementById("savegamemanager_backups_tablebody").appendChild(TR);
}

function SaveGameManager_Backups_Remove(ID)
{
}

function SaveGameManager_Backups_Restore(ID)
{
}

function SaveGameManager_CreateToolBar()
{
	var Icons=new Array(Array("add","<?php echo Language("New");?>","function(){alert('test');}"));
	CreateTabBar("savegamemanager_backups_toolbar",Icons);
}

function SaveGameManager_ShowBackupManager()
{
	SetDialogTitle("savegamemanager","Backup Manager");
	document.getElementById("dialog_savegamemanager").style.visibility="visible";
	SaveGameManager_ReloadBackups();
}

function SaveGameManager_Reload(Sort)
{
	RemoveElementChilds(document.getElementById("savegamemanager_tablebody"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=savegamemanager&mode=getsavegame&sort="+Sort,true);
		XmlHttp.onreadystatechange=SaveGameManager_Reload_GetData;
		XmlHttp.send(null);
	}
	function SaveGameManager_Reload_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				var RowData=Data[Row].split("\t");
				if (RowData[0])
				{
					SaveGameManager_AddRow(Row,RowData);
				}
			}
		}
	}
}

function SaveGameManager_ReloadBackups()
{
	RemoveElementChilds(document.getElementById("savegamemanager_backups_tablebody"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=savegamemanager&mode=getsavegamebackups",true);
		XmlHttp.onreadystatechange=SaveGameManager_ReloadBackup_GetData;
		XmlHttp.send(null);
	}
	function SaveGameManager_ReloadBackup_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				var RowData=Data[Row].split("\t");
				if (RowData[0])
				{
					SaveGameManager_Backups_AddRow(Row,RowData);
				}
			}
		}
	}
}