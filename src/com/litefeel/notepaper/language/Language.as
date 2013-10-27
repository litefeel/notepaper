package com.litefeel.notepaper.language 
{
	import flash.globalization.StringTools;
	/**
	 * ...
	 * @author lite3
	 */
	public class Language
	{
		public static const INTERNAL_LANGUAGE_CODE:String = "en";
		
		static private var instance:Language;
		static public function getInstance():Language
		{
			if (!instance) instance = new Language(Private);
			return instance;
		}
		
		private var _currLangCode:String;
		private var languageList:Vector.<LanguageVo>;
		
		
		public function get currLangCode():String { return _currLangCode; }
		
		public function set currLangCode(value:String):void 
		{
			_currLangCode = value;
		}
		
		public function getLanguageList():Vector.<LanguageVo>
		{
			if (!languageList)
			{
				languageList = Vector.<LanguageVo>([new LanguageVo("zh_CN", "中文简体"), new LanguageVo("en", "English")]);
			}
			return languageList;
		}
		
		
		public function Language(p:Class)
		{
			if (p != Private) throw new Error("不能创建");
			
			_currLangCode = INTERNAL_LANGUAGE_CODE;
		}
		
	}
}

class Private { }