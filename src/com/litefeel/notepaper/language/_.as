package com.litefeel.notepaper.language 
{
	import com.adobe.webapis.gettext.GetText;
	/**
	 * ...
	 * @author lite3
	 */
	public function _(msgId:String):String
	{
		//if (Language.INTERNAL_LANGUAGE_CODE == Language.getInstance().currLangCode)
			//return msgId;
		
		//try {
			return GetText.translate(msgId);
		//}catch (err:Error) { }
		//
		//return msgId;
	}
}