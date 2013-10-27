package com.litefeel.notepaper.vo 
{
	/**
	 * ...
	 * @author lite3
	 */
	public class ConfigVo 
	{
		public var lang:String;
		public var startAtLogin:Boolean;
		public var dbVer:String;
		public var codeVer:String;
		
		public function ConfigVo(lang:String, startAtLogin:Boolean, dbVer:String, codeVer:String) 
		{
			this.lang = lang;
			this.startAtLogin = startAtLogin;
			this.dbVer = dbVer;
			this.codeVer = codeVer;
		}
		
	}

}