<?php
class CheatProcessor_Interface
{
	private $Connection;
	
	public function __construct()
	{
		$this->Connection=@fsockopen("127.0.0.1",8476,$ErrNo,$ErrStr,1);
		if ($this->Connection)
		{
			stream_set_timeout($this->Connection,1);
		}
	}
	
	public function CheckConnection()
	{
		if ($this->Connection)
		{
			return true;
		}
	}
	
	public function Close()
	{
		if ($this->Connection)
		{
			fclose($this->Connection);
		}
	}
	
	public function GetResult()
	{
		return (int)ord($this->ReadResult(1));
	}
	
	public function ReadMemory($Address,$Type,$Size=0)
	{
		if (substr($Address,0,2)=="0x")
		{
			$Address=substr($Address,2);
		}
		else
		{
			$Address=dechex($Address);
		}
		$this->Result=$this->SendCommand("ReadMemory",$Address.chr(9).$Type.chr(9).$Size);
	}
	
	public function ReadResult($Size)
	{
		if ($this->Connection and $Size>0)
		{
			return fread($this->Connection,$Size);
		}
		else
		{
			return -1;
		}
	}
	
	public function SendCommand($Command,$Parameters="")
	{
		if ($this->Connection)
		{
			fwrite($this->Connection,$Command.chr(9).$Parameters);
			return true;
		}
	}
	
	public function SendCheat($Cheat)
	{
		$this->Result=$this->SendCommand("SendCheat",$Cheat);
	}
	
	public function WriteMemory($Address,$Type,$Value)
	{
		if (substr($Address,0,2)=="0x")
		{
			$Address=substr($Address,2);
		}
		else
		{
			$Address=dechex($Address);
		}
		$this->Result=$this->SendCommand("WriteMemory",$Address.chr(9).$Type.chr(9).$Value);
	}
}