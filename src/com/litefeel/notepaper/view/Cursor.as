package com.litefeel.notepaper.view 
{
	import com.litefeel.net.SimpleLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	/**
	 * ...
	 * @author lite3
	 */
	public class Cursor 
	{
		public static const NWSE:String = "nwse";
		
		public static function init():void 
		{
			var file:File = File.applicationDirectory.resolvePath("assets/aero_nwse_.png");
			new SimpleLoader().loadURL(file.url, setCursorData);
		}
		
		private static function setCursorData(success:Boolean, loader:SimpleLoader):void
		{
			if (success)
			{
				var bitmap:Bitmap = loader.content as Bitmap;
				var cursor:MouseCursorData = new MouseCursorData();
				cursor.data = new <BitmapData>[bitmap.bitmapData];
				cursor.hotSpot = new Point(14, 14);
				Mouse.registerCursor(NWSE, cursor);
			}
		}
		
	}

}