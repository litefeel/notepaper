package com.litefeel.notepaper.language 
{
	/**
	 * ...
	 * @author lite3
	 */
	public class LanguageVo
	{
		public var code:String;
		public var name:String;
		public var displayName:String;
		
		
		public function LanguageVo(code:String, displayName:String) 
		{
			this.code = code;
			this.displayName = displayName;
		}
	}
}