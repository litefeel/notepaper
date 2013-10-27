package com.litefeel.notepaper.language 
{
	import com.adobe.webapis.gettext.GetText;
	/**
	 * ...
	 * @author lite3
	 */
	public function __(msgId:String, ...args):String
	{
		var s:String = GetText.translate(msgId);
		for (var i:int = args.length - 1; i >= 0; --i)
		{
			var reg:String = "{" + (i + 1) + "}";
			while (s.indexOf(reg) >= 0)
			{
				s = s.replace(reg, args[i]);
			}
		}
		return s;
	}
}