package com.litefeel.notepaper.language 
{
	import com.adobe.webapis.gettext.GetText;
	/**
	 * ...
	 * @author lite3
	 */
	public function getText():String 
	{
		try {
			return GetText.translate(msgId);
		}catch (err:Error) { }
		
		return msgId;
	}

}