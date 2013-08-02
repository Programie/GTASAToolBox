function Tools_DownloadableTools_AddListButtons(Element,RowData,Tool)
{
	var Table=document.createElement("table");
	var TR=document.createElement("tr");
	var TD=document.createElement("td");
	Table.cellPadding=0;
	Table.cellSpacing=0;
	TD.onmouseover=function(){Opacity(this,0.5);}
	TD.onmouseout=function(){Opacity(this);}
	TD.onclick=function(){Tools_DownloadableTools_Install(Tool,RowData[1]);}
	TD.style.width="20px";
	TD.style.height="20px";
	TD.style.backgroundImage="url(files/listbuttons/download.png)";
	TD.style.cursor="pointer";
	TD.title=unescape("<?php echo Language("Install");?>");
	TR.appendChild(TD);
	Table.appendChild(TR);
	RemoveElementChilds(Element);
	Element.appendChild(Table);
}

function Tools_DownloadableTools_AddRow(Data)
{
	var RowData=Data.split("\t");
	var Tool=RowData[0];
	RowData.splice(0,1);
	RowData.push("");
	var Row=CreateTableRow(RowData);
	Row.id="tools_downloadabletools_row_"+Tool;
	Row.ondblclick=function(){Tools_DownloadableTools_Install(Tool,RowData[1]);}
	Row.onclick=function(){Table_MouseClick("tools_downloadabletools",document.getElementById("tools_downloadabletools_row_"+Tool));}
	var TD=Row.getElementsByTagName("td");
	TD[0].style.display="none";
	Tools_DownloadableTools_AddListButtons(TD[5],RowData,Tool);
	document.getElementById("tools_downloadabletools").appendChild(Row);
}

function Tools_DownloadableTools_Install(Tool,Name)
{
	var Progress=document.getElementById("tools_downloadabletools_progress");
	var Text="<?php echo Language("Do you want to install '%1'?");?>";
	if (confirm(unescape(Text.replace("%1",Name))))
	{
		var XmlHttp=CreateXmlHttpRequest();
		if (XmlHttp)
		{
			Progress.style.display="block";
			Tools_InstallProcesses++;
			XmlHttp.open("GET","?ajaxrequest=tools&mode=installtool&tool="+Tool,true);
			XmlHttp.onreadystatechange=Tools_DownloadableTools_Install_GetData;
			XmlHttp.send(null);
		}
	}
	function Tools_DownloadableTools_Install_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			Tools_InstalledTools_Reload();
			Tools_InstallProcesses--;
			if (Tools_InstallProcesses<=0)
			{
				Tools_InstallProcesses=0;
				Progress.style.display="none";
			}
			alert(XmlHttp.responseText);
		}
	}
}

function Tools_DownloadableTools_Reload(Sort)
{
	var Table=document.getElementById("tools_downloadabletools");
	RemoveElementChilds(Table);
	var TR=document.createElement("tr");
	var TD=document.createElement("td");
	TD.colSpan=5;
	TD.innerHTML="<?php echo Language("Loading...");?>";
	TD.style.textAlign="center";
	TR.appendChild(TD);
	Table.appendChild(TR);
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=tools&mode=getdownloadabletools&sort="+Sort,true);
		XmlHttp.onreadystatechange=Tools_DownloadableTools_Reload_GetData;
		XmlHttp.send(null);
	}
	function Tools_DownloadableTools_Reload_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			RemoveElementChilds(Table);
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				if (Data[Row])
				{
					Tools_DownloadableTools_AddRow(Data[Row]);
				}
			}
		}
	}
}

function Tools_InstalledTools_AddRow(Data)
{
	var Data=Data.split("\t");
	var UpdateIcon="";
	if (Data[1]<document.getElementById("tools_downloadabletools_row_"+Data[0]).getElementsByTagName("td")[0].innerHTML)
	{
		UpdateIcon="<img src='files/listbuttons/update.png' height='16' onclick=\"Tools_DownloadableTools_Install('"+Data[0]+"','"+Data[2]+"');\" alt='<?php echo Language("Update");?>' title='<?php echo Language("Update");?>' style='cursor:pointer;'/>";
	}
	var TR=document.createElement("tr");
	var TD_Icon=document.createElement("td");
	var TD_Content=document.createElement("td");
	var ContentTable=document.createElement("table");
	var Content_Title=document.createElement("tr");
	var Content_Title_TD=document.createElement("td");
	var Content_Description=document.createElement("tr");
	var Content_Description_TD1=document.createElement("td");
	var Content_Description_TD2=document.createElement("td");
	var Content_Author=document.createElement("tr");
	var Content_Author_TD1=document.createElement("td");
	var Content_Author_TD2=document.createElement("td");
	var Content_Date=document.createElement("tr");
	var Content_Date_TD1=document.createElement("td");
	var Content_Date_TD2=document.createElement("td");
	TD_Icon.innerHTML="<img src='tools/"+Data[0]+"/icon.png' width='64' alt='"+Data[2]+"' title='"+Data[2]+"'/>";
	TD_Icon.onclick=function(){window.open("tools/"+Data[0],"tools_"+Data[0],"width="+Data[6]+",height="+Data[7]);}
	TD_Icon.style.cursor="pointer";
	Content_Title_TD.innerHTML=Data[2]+" <img src='files/listbuttons/remove.png' height='16' onclick=\"Tools_InstalledTools_Remove('"+Data[0]+"','"+Data[2]+"');\" alt='<?php echo Language("Remove");?>' title='<?php echo Language("Remove");?>' style='cursor:pointer;'/>"+UpdateIcon;
	Content_Title_TD.colSpan=2;
	Content_Title.style.fontWeight="bold";
	Content_Title.appendChild(Content_Title_TD);
	Content_Description_TD1.innerHTML="<?php echo Language("Description");?>:";
	Content_Description_TD1.style.textAlign="right";
	Content_Description_TD2.innerHTML=Data[3];
	Content_Description.appendChild(Content_Description_TD1);
	Content_Description.appendChild(Content_Description_TD2);
	Content_Author_TD1.innerHTML="<?php echo Language("Author");?>:";
	Content_Author_TD1.style.textAlign="right";
	Content_Author_TD2.innerHTML=Data[4];
	Content_Author.appendChild(Content_Author_TD1);
	Content_Author.appendChild(Content_Author_TD2);
	Content_Date_TD1.innerHTML="<?php echo Language("Date");?>:";
	Content_Date_TD1.style.textAlign="right";
	Content_Date_TD2.innerHTML=Data[5];
	Content_Date.appendChild(Content_Date_TD1);
	Content_Date.appendChild(Content_Date_TD2);
	ContentTable.appendChild(Content_Title);
	ContentTable.appendChild(Content_Description);
	ContentTable.appendChild(Content_Author);
	ContentTable.appendChild(Content_Date);
	TD_Content.appendChild(ContentTable);
	TR.appendChild(TD_Icon);
	TR.appendChild(TD_Content);
	document.getElementById("tools_installedtools").appendChild(TR);
}

function Tools_InstalledTools_Reload()
{
	RemoveElementChilds(document.getElementById("tools_installedtools"));
	var XmlHttp=CreateXmlHttpRequest();
	if (XmlHttp)
	{
		XmlHttp.open("GET","?ajaxrequest=tools&mode=getinstalledtools",true);
		XmlHttp.onreadystatechange=Tools_InstalledTools_Reload_GetData;
		XmlHttp.send(null);
	}
	function Tools_InstalledTools_Reload_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			var Data=XmlHttp.responseText.split("\n");
			for (var Row=0;Row<Data.length;Row++)
			{
				if (Data[Row])
				{
					Tools_InstalledTools_AddRow(Data[Row]);
				}
			}
		}
	}
}

function Tools_InstalledTools_Remove(Tool,Name)
{
	var Text="<?php echo Language("Do you want to remove '%1'?");?>";
	if (confirm(unescape(Text.replace("%1",Name))))
	{
		var XmlHttp=CreateXmlHttpRequest();
		if (XmlHttp)
		{
			XmlHttp.open("GET","?ajaxrequest=tools&mode=removetool&tool="+Tool,true);
			XmlHttp.onreadystatechange=Tools_InstalledTools_Remove_GetData;
			XmlHttp.send(null);
		}
	}
	function Tools_InstalledTools_Remove_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			Tools_InstalledTools_Reload();
		}
	}
}