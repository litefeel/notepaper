package com.litefeel.notepaper.view 
{
	import com.litefeel.notepaper.language._;
	import com.litefeel.utils.NatiaveWindowUtil;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import org.aswing.*;
	import org.aswing.border.*;
	import org.aswing.colorchooser.*;
	import org.aswing.ext.*;
	import org.aswing.geom.*;
	
	/**
	 * NewGroupWindow
	 * @author lite3
	 */
	public class NewGroupWindow extends WindowBase
	{
		
		private var closeHandler:Function;
		private var backWindow:NativeWindow;
		
		//members define
		private var label14:JLabel;
		private var nameTxt:JTextField;
		private var panel16:JPanel;
		private var okBtn:JButton;
		private var cancelBtn:JButton;
		
		
		static public function show(defaultName:String = "", closeHandler:Function = null, back:NativeWindow = null):NewGroupWindow
		{
			return new NewGroupWindow(defaultName, closeHandler, back);
		}
		
		/**
		 * 显示一个新窗口
		 * @param	closeHandler 关闭的回调函数 function (isOk:Boolean, text:String):void;
		 * @param	defaultName 默认显示的值
		 */
		public function NewGroupWindow(defaultName:String = "", closeHandler:Function = null, backWindow:NativeWindow = null)
		{
			
			super(_("New Group"), false, NativeWindowType.UTILITY, false, false);
			this.backWindow = backWindow;
			NatiaveWindowUtil.makeModal(nativeWindow, backWindow);
			
			initUI();
			this.closeHandler = closeHandler;
			if (!defaultName) defaultName = "";
			
			nameTxt.setText(defaultName);
			nameTxtChangeHandler(null);
			
			nameTxt.getTextField().addEventListener(Event.CHANGE, nameTxtChangeHandler);
			nativeWindow.addEventListener(Event.CLOSING, clickHandler);
			okBtn.addEventListener(MouseEvent.CLICK, clickHandler);
			cancelBtn.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		override public function dispose():void 
		{
			nativeWindow.removeEventListener(Event.CLOSING, clickHandler);
			okBtn.removeEventListener(MouseEvent.CLICK, clickHandler);
			cancelBtn.removeEventListener(MouseEvent.CLICK, clickHandler);
			nameTxt.getTextField().removeEventListener(Event.CHANGE, nameTxtChangeHandler);
			closeHandler = null;
			
			super.dispose();
		}
		
		private function clickHandler(e:Event):void 
		{
			var _closeHandler:Function = closeHandler;
			var isOK:Boolean = e.currentTarget == okBtn;
			var text:String =   nameTxt.getText();
			nativeWindow.close();
			
			if (_closeHandler != null) _closeHandler(isOK, text);
		}
		
		private function nameTxtChangeHandler(e:Event):void 
		{
			okBtn.setEnabled(Boolean(nameTxt.getText()));
		}
		
		private function initUI():void 
		{
			//component creation
			nativeWindow.bounds = new Rectangle(nativeWindow.x, nativeWindow.y, 425, 128);
			var layout0:SoftBoxLayout = new SoftBoxLayout();
			layout0.setAxis(AsWingConstants.VERTICAL);
			layout0.setAlign(AsWingConstants.LEFT);
			layout0.setGap(10);
			getContentPane().setLayout(layout0);
			
			label14 = new JLabel();
			label14.setLocation(new IntPoint(168, 5));
			label14.setSize(new IntDimension(400, 17));
			label14.setText(_("Group Name"));
			label14.setHorizontalAlignment(AsWingConstants.LEFT);
			
			nameTxt = new JTextField();
			nameTxt.setLocation(new IntPoint(73, 5));
			nameTxt.setSize(new IntDimension(10, 21));
			
			panel16 = new JPanel();
			panel16.setLocation(new IntPoint(0, 58));
			panel16.setSize(new IntDimension(400, 10));
			var layout1:FlowLayout = new FlowLayout();
			layout1.setAlignment(AsWingConstants.RIGHT);
			layout1.setMargin(true);
			panel16.setLayout(layout1);
			
			okBtn = new JButton();
			okBtn.setLocation(new IntPoint(259, 5));
			okBtn.setSize(new IntDimension(100, 22));
			okBtn.setPreferredSize(new IntDimension(100, 22));
			okBtn.setText(_("OK"));
			
			cancelBtn = new JButton();
			cancelBtn.setLocation(new IntPoint(295, 5));
			cancelBtn.setSize(new IntDimension(100, 22));
			cancelBtn.setPreferredSize(new IntDimension(100, 22));
			cancelBtn.setText(_("Cancel"));
			
			//component layoution
			getContentPane().append(label14);
			getContentPane().append(nameTxt);
			getContentPane().append(panel16);
			
			panel16.append(okBtn);
			panel16.append(cancelBtn);
		}
	}
}
