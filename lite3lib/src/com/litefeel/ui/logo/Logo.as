package com.litefeel.ui.logo 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * logo
	 * @author lite3
	 */
	public class Logo extends Sprite
	{
		private var html:String;
		private var txt:TextField;
		
		public static function show(stage:Stage):void
		{
			var logo:Logo = new Logo();
			stage.addChild(logo);
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler(null);
			function resizeHandler(e:Event):void 
			{
				logo.x = stage.stageWidth - logo.width - 5;
				logo.y = stage.stageHeight - logo.height - 5;
			}
		}
		
		/**
		 * 
		 * @param	html
		 */
		public function Logo(html:String = null) 
		{
			super();
			this.html = html != null ? html : getLite3Html();
			
			initUI();
		}
		
		private function initUI():void
		{
			txt = new TextField();
			txt.border = true;
			txt.multiline = false;
			txt.htmlText = html;
			txt.textColor = 0x0;
			txt.width = txt.textWidth + 4;
			txt.height = txt.textHeight + 4;
			addChild(txt);
		}
		
		private function getLite3Html():String
		{
			return "<a target=\"_parent\" href=\"http://www.litefeel.com/\">by lite3</a>";
		}
	}

}