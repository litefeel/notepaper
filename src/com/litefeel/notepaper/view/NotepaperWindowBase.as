package com.litefeel.notepaper.view 
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class NotepaperWindowBase extends NativeWindow
	{
		
		public function NotepaperWindowBase(resizable:Boolean = false, type:String = null, maximizable:Boolean = false, minimizable:Boolean = false) 
		{
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOptions.systemChrome = NativeWindowSystemChrome.NONE;
			initOptions.type = type ? type : NativeWindowType.UTILITY;
			initOptions.transparent = true;
			initOptions.resizable = resizable;
			initOptions.maximizable = maximizable;
			initOptions.minimizable = minimizable;
			super(initOptions);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
	}

}