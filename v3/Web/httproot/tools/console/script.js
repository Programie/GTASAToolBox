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

function Refocus(Element)
{
	setTimeout(function(){Element.focus()},10);
}

function SendRequest(Command,AppendToElement)
{
	var Input=document.getElementById("input");
	if (!Command)
	{
		Command=Input.value;
	}
	if (Command)
	{
		var XmlHttp=CreateXmlHttpRequest();
		if (XmlHttp)
		{
			XmlHttp.open("GET","cpi.php?command="+Command,true);
			XmlHttp.onreadystatechange=SendRequest_GetData;
			XmlHttp.send(null);
		}
	}
	function SendRequest_GetData()
	{
		if (XmlHttp.readyState==4)
		{
			if (AppendToElement)
			{
				AppendToElement.innerHTML=AppendToElement.innerHTML+XmlHttp.responseText;
			}
			else
			{
				var Table=document.getElementById("output");
				var TR=document.createElement("tr");
				var TD=document.createElement("td");
				TD.innerHTML=XmlHttp.responseText;
				TR.appendChild(TD);
				Table.appendChild(TR);
			}
			Input.value="";
			Input.focus();
		}
	}
}