package com.litefeel.notepaper.language 
{
	import com.adobe.webapis.gettext.GetText;
	import com.litefeel.notepaper.events.LanguageEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	/**
	 * 语言改变后触发
	 */
	[Event(name = "languageChange", type = "com.litefeel.notepaper.events.LanguageEvent")]
	
	/**
	 * ...
	 * @author lite3
	 */
	public class LanguageManager extends EventDispatcher
	{
		private static var instance:LanguageManager;
		
		private var langFileList:Array;
		private var langFileNameList:Array;
		
		public static function getInstance():LanguageManager
		{
			if (!instance) instance = new LanguageManager();
			
			return instance;
		}
		
		public function LanguageManager() 
		{
			Language.getInstance().currLangCode = Language.INTERNAL_LANGUAGE_CODE;
			startup();
		}
		
		public function changeLanguage(code:String):void
		{
			if (!code)
			{
				code = Capabilities.languages[0];
				code = code.replace("-", "_");
			}
			code = code.toLowerCase();
			if (code == Language.INTERNAL_LANGUAGE_CODE)
			{
				GetText.getInstance().uninstall();
				changeLang(code);
				return;
			}
			var index:int = langFileNameList.indexOf(code);
			if (index < 0) return;
			//var file:File = File.applicationStorageDirectory.resolvePath("Notepaper/languages");
			var file:File = File.applicationDirectory.resolvePath("assets/languages");
			// file.url: app-storage:/Notepaper/languages	URLRequest 接受这样的地址
			// file.nativePath: C:\..... 					URLRequest 不接受这样的地址
			var getText:GetText = GetText.getInstance();
			getText.translation(langFileList[index].name, file.url + "/", langFileList[index].name);
			getText.addEventListener(Event.COMPLETE, getTextHandler);
			getText.addEventListener(ErrorEvent.ERROR, getTextHandler);
			getText.addEventListener(IOErrorEvent.IO_ERROR, getTextHandler);
			getText.install();
		}
		
		private function getTextHandler(e:Event):void 
		{
			if (Event.COMPLETE == e.type)
			{
				changeLang(GetText.getInstance().getLocale());
			}
		}
		
		private function changeLang(code:String):void
		{
			Language.getInstance().currLangCode = code;
			dispatchEvent(new LanguageEvent(LanguageEvent.LANGUAGE_CHANGE));
		}
		
		public function getLanguageCodeList():Array
		{
			return langFileList;
		}
		
		private function startup():void
		{
			//var file:File = File.applicationStorageDirectory.resolvePath("Notepaper/languages");
			//if (!file.exists) file.createDirectory();
			
			// 复制语言文件
			//var langList:Array = File.applicationDirectory.resolvePath("assets/languages").getDirectoryListing();
			//var overwrite:Boolean = ConfigOption.version != ConfigOption.currVersion;
			//for (var i:int = langList.length - 1; i >= 0; i--)
			//{
				//try {
					//File(langList[i]).copyTo(file.resolvePath(langList[i].name), overwrite);
				//}catch (err:Error) { }
			//}
			//
			var file:File = File.applicationDirectory.resolvePath("assets/languages");
			langFileList = file.getDirectoryListing();
			langFileNameList = [];
			for (var i:int = langFileList.length - 1; i >= 0; i--)
			{
				langFileNameList[i] = File(langFileList[i]).name.toLowerCase();
			}
		}
	}

}