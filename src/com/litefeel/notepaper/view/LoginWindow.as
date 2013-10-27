package com.litefeel.notepaper.view 
{
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import org.aswing.AsWingManager;
	import org.aswing.event.FrameEvent;
	import org.aswing.JFrame;
	import org.aswing.JFrameTitleBar;
	import org.aswing.JPanel;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class LoginWindow extends NotepaperWindowBase
	{
		
		private var frame:JFrame;
		private var loginPanel:LoginWindowUI;
		
		
		public function LoginWindow() 
		{
			super(false, NativeWindowType.NORMAL);
			
			initUI();
			this.activate();
		}
		
		private function initUI():void
		{
			AsWingManager.initAsStandard(stage);
			frame = new JFrame(null, "Login Panel");
			frame.setResizable(false);
			frame.setDragable(true);
			loginPanel = new LoginWindowUI();
			frame.setContentPane(loginPanel);
			frame.pack();
			frame.show();
			frame.addEventListener(FrameEvent.FRAME_CLOSING, closeWindow);
			JFrameTitleBar(frame.getTitleBar()).addEventListener(MouseEvent.MOUSE_DOWN, startMoveWindow);
			
			var rect:Rectangle = frame.getBounds(stage);
			width = 400
			height = 400;
			
			loginPanel.getRegisterButton().addEventListener(MouseEvent.CLICK, register);
		}
		
		private function register(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://lite3.cn/wp-login.php?action=register"), "_blank");
		}
		
		private function closeWindow(e:FrameEvent):void 
		{
			close();
		}
		
		private function startMoveWindow(e:MouseEvent):void 
		{
			startMove();
		}
	}
}