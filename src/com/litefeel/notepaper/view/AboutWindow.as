package com.litefeel.notepaper.view 
{
	import com.litefeel.notepaper.language._;
	import com.litefeel.notepaper.managers.DataManager;
	import com.litefeel.utils.StageUtil;
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author lite3
	 */
	public class AboutWindow extends NativeWindow
	{
		private static var aboutWindow:AboutWindow = null;
		
		public static function showWindow():void
		{
			if (!aboutWindow) aboutWindow = new AboutWindow(); 
			
			NativeApplication.nativeApplication.activate(aboutWindow);
			aboutWindow.orderToFront();
		}
		
		private var loader:Loader;
		private var txt:TextField;
		public function AboutWindow() 
		{
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOptions.systemChrome = NativeWindowSystemChrome.NONE;
			initOptions.type = NativeWindowType.UTILITY;
			initOptions.transparent = true;
			initOptions.resizable = false;
			initOptions.maximizable = false;
			initOptions.minimizable = false;
			//initOptions.owner = NativeApplication.nativeApplication.applicationDescriptor
			super(initOptions);
			title = _("About Notepaper");
			
			StageUtil.setNoScaleAndTopLeft(stage);
			stage.quality = StageQuality.LOW;
			initUI();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			activate();
		}
		
		private function downHandler(e:MouseEvent):void 
		{
			if (e.target == txt)
			{
				var idx:int = txt.getCharIndexAtPoint(e.localX, e.localY);
				if (idx != -1)
				{
					var tf:TextFormat = txt.getTextFormat(idx, idx + 1);
					if (tf && tf.url) return;
				}
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			try {
				loader.unloadAndStop();
			}catch (err:Error) { }
			visible = false;
			loader = null;
			txt = null;
			aboutWindow = null;
			
			// 必须要等一段时间再close，窗口需要再次click AIR的Stage内容(费NativeWindow本身)才能真正被激活
			setTimeout(close, 500);
		}
		
		private function initUI():void 
		{
			width = 450;
			height = 242;
			var rect:Rectangle = Screen.mainScreen.visibleBounds;
			x = rect.x  + (rect.width - 450) / 2;
			y = rect.y + (rect.height - 242) / 2;
			
			
			var style:StyleSheet = new StyleSheet();
			style.parseCSS("a:hover{text-decoration:underline;color:#0000CC;}p{font-family:Tahoma;font-size:14pt;line-height:150%}");
			txt = new TextField();
			txt.x = 28;
			txt.y = 164;
			txt.multiline = true;
			txt.selectable = false;
			txt.textColor = 0xFFFFFF;
			txt.styleSheet = style;
			var version:String = DataManager.instance.getVersionLabel();
			txt.htmlText = "<p><b>" + version + " for Adobe AIR 3.6</b><br/><underline><a href='http://www.litefeel.com/notepaper/'>http://www.litefeel.com/notepaper/</a></underline></p>";
			txt.width = txt.textWidth + 4;
			txt.height = txt.textHeight + 4;
			stage.addChild(txt);
			
			loader = new Loader();
			try {
				loader.load(new URLRequest("app:/assets/About.jpg"));
			}catch (err:Error) { }
			stage.addChildAt(loader, 0);
		}
		
	}

}