package com.litefeel.notepaper.view 
{
	import com.litefeel.notepaper.events.CloseEvent;
	import com.litefeel.utils.NatiaveWindowUtil;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import org.aswing.AsWingConstants;
	import org.aswing.ext.MultilineLabel;
	import org.aswing.FlowLayout;
	import org.aswing.geom.IntDimension;
	import org.aswing.geom.IntPoint;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;
	
	[Event(name="_close", type="com.litefeel.notepaper.events.CloseEvent")]
	
	/**
	 * 警告窗口
	 * @author lite3
	 */
	public class AlertWindow extends WindowBase
	{
		private var closeHandler:Function;
		private var buttonArr:Array;
		private var defaultBtnIndex:uint;
		private var backWindow:NativeWindow;
		
		//members define
		private var txt:MultilineLabel;
		private var panel18:JPanel;
		private var panel21:JPanel;
		private var buttonContainer:JPanel;
		
		public static function show(msg:String, title:String, buttonArr:Array, closeHandler:Function = null, defaultButtonIndex:uint = 0, backWindow:NativeWindow = null):AlertWindow
		{
			trace(title + "\n" + msg);
			var window:AlertWindow = new AlertWindow(backWindow);
			window.showMsg(msg, title, buttonArr, closeHandler, defaultButtonIndex);
			return window;
		}
		
		public function AlertWindow(backWindow:NativeWindow = null) 
		{
			super("", false, NativeWindowType.UTILITY);
			setVisible(false);
			buttonArr = [];
			initUI();
			this.backWindow = backWindow;
			NatiaveWindowUtil.makeModal(nativeWindow, backWindow);
			addEventListener(CloseEvent.CLOSE, _closeHandler, false, int.MAX_VALUE);
			nativeWindow.addEventListener(Event.CLOSING, closingHandler);
		}
		
		/**
		 * @private
		 * @param	msg
		 * @param	title
		 * @param	labelArr
		 * @param	closeHandler
		 * @param	defaultBtnIndex
		 */
		public function showMsg(msg:String, title:String, labelArr:Array, closeHandler:Function, defaultBtnIndex:uint):void
		{
			setVisible(false);
			this.closeHandler = closeHandler;
			nativeWindow.title = title;
			txt.setText(msg);
			
			if (!labelArr) labelArr = [];
			var labelLen:int = labelArr.length;
			this.defaultBtnIndex = defaultBtnIndex >= labelLen ? 0 : defaultBtnIndex;
			
			var btnLen:int = buttonArr.length;
			for (var i:int = 0; i < labelLen; i++)
			{
				var btn:JButton = buttonArr[i] as JButton;
				if (!btn)
				{
					btn = new JButton();
					buttonArr[i] = btn;
					buttonContainer.append(btn);
					btn.addEventListener(MouseEvent.CLICK, selectButtonHandler);
				}
				btn.setText(labelArr[i]);
			}
			buttonArr.splice(i);
			for (; i < btnLen; i++)
			{
				buttonContainer.removeAt(i).removeEventListener(MouseEvent.CLICK, selectButtonHandler);
			}
			
			//setSize(new IntDimension(520, 190));
			//setX((rect.width - 520) / 2);
			//setY((rect.height - 190) / 2);
			setVisible(true);
			//this.pack();
		}
		
		private function closingHandler(e:Event):void 
		{
			if (closeHandler != null)
			{
				dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, defaultBtnIndex, true));
			}
		}
		
		override public function dispose():void 
		{
			trace("this is AlertWindow::dispose!");
			closeHandler = null;
			removeEventListener(CloseEvent.CLOSE, _closeHandler);
			nativeWindow.addEventListener(Event.CLOSING, closingHandler);
			
			for (var i:int = buttonArr.length - 1; i >= 0; i--)
			{
				buttonArr[i].removeEventListener(MouseEvent.CLICK, selectButtonHandler);
			}
			
			buttonArr = null;
			txt = null;
			panel18 = null;
			panel21 = null;
			buttonContainer = null;
			
			super.dispose();
		}
		
		private function _closeHandler(e:CloseEvent):void 
		{
			e.stopImmediatePropagation();
			if (closeHandler != null)
				closeHandler(e);
		}
		
		private function selectButtonHandler(e:MouseEvent):void 
		{
			if (closeHandler != null)
			{
				var selectedIndex:int = buttonArr.indexOf(e.currentTarget);
				dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, selectedIndex, false));
			}
			
			nativeWindow.close();
		}
		
		private function initUI():void
		{
			var rect:Rectangle = Screen.mainScreen.bounds;
			nativeWindow.bounds = new Rectangle((rect.width - 520) / 2, (rect.height - 190) / 2, 520, 190);
			
			setConstraints("Center");
			panel18 = new JPanel();
			//panel18.setSize(new IntDimension(581, 400));
			//panel18.setPreferredSize(new IntDimension(400, 400));
			var layout0:SoftBoxLayout = new SoftBoxLayout();
			layout0.setAxis(AsWingConstants.VERTICAL);
			layout0.setAlign(AsWingConstants.LEFT);
			layout0.setGap(0);
			panel18.setLayout(layout0);
			
			panel21 = new JPanel();
			panel21.setSize(new IntDimension(581, 30));
			panel21.setPreferredSize(new IntDimension(400, 30));
			var layout1:FlowLayout = new FlowLayout();
			layout1.setAlignment(AsWingConstants.CENTER);
			layout1.setMargin(true);
			panel21.setLayout(layout1);
			
			txt = new MultilineLabel();
			txt.setLocation(new IntPoint(50, 5));
			txt.setSize(new IntDimension(500, 23));
			txt.setPreferredSize(new IntDimension(500, 23));
			txt.setWordWrap(true);
			
			buttonContainer = new JPanel();
			buttonContainer.setLocation(new IntPoint(0, 10));
			buttonContainer.setSize(new IntDimension(581, 30));
			buttonContainer.setPreferredSize(new IntDimension(400, 30));
			var layout2:FlowLayout = new FlowLayout();
			layout2.setAlignment(AsWingConstants.CENTER);
			layout2.setMargin(true);
			buttonContainer.setLayout(layout2);
			
			//component layoution
			setContentPane(panel18);
			
			panel18.append(panel21);
			panel18.append(buttonContainer);
			
			panel21.append(txt);
			
			//this.setContentPane(panel18);
			//this.show();
		}
	}
}