<?php

class Display 
{

  function Display(&$app)
  {
    $this->app=&$app; 
  
    $this->app->ActionHandlerInit($this);

    $this->app->ActionHandler("list","DisplayList");
    $this->app->ActionHandler("set","DisplaySet");
  
    $this->app->DefaultActionHandler("list");
    $this->app->Tpl->ReadTemplatesFromPath("./pages/content/");

    $this->app->ActionHandlerListen(&$app);
  }


  function DisplayList()
  {
    $this->app->Tpl->Parse(PAGE,"display_list.tpl");
  }

	function DisplaySet()
	{
		$text = str_replace("\n", '', $_GET['text']);

		$len = strlen($text);

		if($len > 16) {
			$this->SetLine(substr($text, 0, 16), true);
			$this->NewLine();
			$this->SetLine(substr($text, 16, $len - 16));
		}else
			$this->SetLine($text, true);
		exit;	
	}

	private function SetLine($text, $clr=false) 
	{
		if($clr)
			exec("/usr/bin/gnublin-dogm -n -d /dev/spidev0.11 -w'$text'");
		else
			exec("/usr/bin/gnublin-dogm -d /dev/spidev0.11 -w'$text'");
	}

	private function NewLine()
	{
		exec("/usr/bin/gnublin-dogm -o 192 -d /dev/spidev0.11");
	}


}
?>
