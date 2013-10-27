package com.litefeel.notepaper.view 
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.aswing.air.JNativeFrame;
	import org.aswing.air.JNativeWindow;
	import org.aswing.AsWingManager;
	import org.aswing.event.AWEvent;
	import org.aswing.event.FrameEvent;
	import org.aswing.geom.IntDimension;
	import org.aswing.JFrame;
	import org.aswing.LoadIcon;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class WindowBase extends JNativeWindow
	{
		/** 存放数据用的 */
		public var data:Object;
		
		public function WindowBase(title:String = "", resizable:Boolean = false, type:String = null, maximizable:Boolean = false, minimizable:Boolean = false) 
		{
			var initOps:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOps.resizable = resizable;
			initOps.type = type ? type : NativeWindowType.NORMAL;
			initOps.maximizable = maximizable;
			initOps.minimizable = minimizable;
			
			super(new NativeWindow(initOps), true);
			//super(new NotepaperWindowBase(resizable, NativeWindowType.NORMAL, maximizable, minimizable));
			//setResizable(resizable);
			//setTitle(title);
			nativeWindow.title = title;
			//setIcon(new LoadIcon("app:/assets/icon_16.png", 16, 16));
		}
	}
}