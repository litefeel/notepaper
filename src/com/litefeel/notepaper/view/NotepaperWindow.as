package com.litefeel.notepaper.view
{
	import com.litefeel.notepaper.events.NotepaperEvent;
	import com.litefeel.notepaper.managers.NotepaperWindowManager;
	import com.litefeel.notepaper.vo.NotepaperVo;
	import flash.display.NativeWindowResize;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Rectangle;
	
	/**
	 * 有数据更新的时候触发
	 */
	[Event(name="dataChange", type="com.litefeel.notepaper.events.NotepaperEvent")]
	
	public class NotepaperWindow extends NotepaperWindowBase
	{
		private var ui:NotepaperUI;
		
		private var vo:NotepaperVo;
		private var moving:Boolean;
		private var resizing:Boolean;
		
		public function NotepaperWindow(vo:NotepaperVo)
		{
			super(true);
			if (isNaN(vo.x) || isNaN(vo.y))
			{
				vo.x = x;
				vo.y = y;
			}
			this.vo = vo;
			initUI();
			setVo(vo);
			vo.x = x;
			vo.y = y;
			if(vo.onTop) alwaysInFront = true;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(NativeWindowBoundsEvent.RESIZE, resizeHandler);
			addEventListener(NativeWindowBoundsEvent.MOVE, moveHandler);
			addEventListener(Event.DEACTIVATE, deactivateHandler);
			addEventListener(Event.CLOSING, preventClose);
		}
		
		private function preventClose(e:Event):void 
		{
			e.preventDefault()
		}
		
		private function deactivateHandler(e:Event):void 
		{
			stage.focus = null;
			stopMove(null);
			stopResize(null);
		}
		
		private function stopResize(e:MouseEvent):void 
		{
			if (resizing)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopResize);
				resizing = false;
				vo.width = ui.width >> 0;
				vo.height = ui.height >> 0;
				dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
			}
		}
		
		private function stopMove(e:MouseEvent):void
		{
			if (moving)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopMove);
				moving = false;
				vo.x = x;
				vo.y = y;
				dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
			}
		}
		
		private function moveHandler(e:NativeWindowBoundsEvent):void 
		{
			//trace(e);
			if (moving) return;
			vo.x = e.afterBounds.x;
			vo.y = e.afterBounds.y;
			dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
		}
		
		public function getVo():NotepaperVo
		{
			return vo;
		}
		
		public function setVo(value:NotepaperVo):void
		{
			vo = value;
			ui.subject = value.subject;
			ui.content = value.content;
			ui.isShowSubject = value.isShowSubject;
			ui.setSize(value.width, value.height);
			_setBounds(value.x, value.y, width, height);
			setSizeByUI();
		}
		
		private function _setBounds(x:Number, y:Number, width:Number, height:Number):void
		{
			removeEventListener(NativeWindowBoundsEvent.RESIZE, resizeHandler);
			removeEventListener(NativeWindowBoundsEvent.MOVE, moveHandler);
			bounds = new Rectangle(x, y, width, height);
			addEventListener(NativeWindowBoundsEvent.RESIZE, resizeHandler);
			addEventListener(NativeWindowBoundsEvent.MOVE, moveHandler);
		}
		
		private function initUI():void
		{
			ui = new NotepaperUI(vo);
			
			ui.addEventListener(NotepaperEvent.DATA_CHANGE, notepaperHandler);
			ui.addEventListener(NotepaperEvent.CREATE, notepaperHandler);
			ui.addEventListener(NotepaperEvent.DELETE, notepaperHandler);
			ui.addEventListener(NotepaperEvent.HIDE, notepaperHandler);
			ui.addEventListener(NotepaperEvent.SHOW_BIG_SIZE, notepaperHandler);
			ui.addEventListener(NotepaperEvent.SHOW_NORMAL_SIZE, notepaperHandler);
			ui.addEventListener(NotepaperEvent.START_RESIZE, notepaperHandler);
			ui.addEventListener(NotepaperEvent.START_MOVE, notepaperHandler);
			ui.x = ui.y = 2;
			stage.addChild(ui);
		}
		
		private function notepaperHandler(e:NotepaperEvent):void 
		{
			switch(e.type)
			{
				case NotepaperEvent.DATA_CHANGE :
					if (alwaysInFront != vo.onTop) alwaysInFront = vo.onTop;
					dispatchEvent(e.clone());
					break;
				case NotepaperEvent.CREATE :
					NotepaperWindowManager.getInstance().createWindow();
					break;
				case NotepaperEvent.DELETE :
					NotepaperWindowManager.getInstance().removeWindow(this);
					break;
				case NotepaperEvent.HIDE :
					NotepaperWindowManager.getInstance().hideWindow(this);
					break;
				case NotepaperEvent.SHOW_BIG_SIZE :
					_setBounds(x, y, 2000, 20000);
					//removeEventListener(NativeWindowBoundsEvent.RESIZE, resizeHandler);
					//bounds = new Rectangle(x, y, 2000, 2000);
					//addEventListener(NativeWindowBoundsEvent.RESIZE, resizeHandler);
					break;
				case NotepaperEvent.SHOW_NORMAL_SIZE :
					setSizeByUI();
					break;
				case NotepaperEvent.START_RESIZE :
				startResize(NativeWindowResize.BOTTOM_RIGHT);
				resizing = true;
				stage.addEventListener(MouseEvent.MOUSE_UP, stopResize);
				break;
				
				case NotepaperEvent.START_MOVE :
				startMove();
				moving = true;
				stage.addEventListener(MouseEvent.MOUSE_UP, stopMove);
			}
		}
		
		private function setSizeByUI():void
		{
			//removeEventListener(NativeWindowBoundsEvent.RESIZE, resizeHandler);
			//bounds = new Rectangle(x, y, ui.width + 5, ui.height + 5);
			//addEventListener(NativeWindowBoundsEvent.RESIZE, resizeHandler);
			_setBounds(x, y, ui.width + 5, ui.height + 5);
		}
		
		private function resizeHandler(e:NativeWindowBoundsEvent):void 
		{
			var rect:Rectangle = e ? e.afterBounds : this.bounds;
			//trace(e.afterBounds, width, height);
			ui.setSize(rect.width - 5, rect.height - 5);
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			this.orderToFront();
			//var resizer:String = "";
			//if (e.stageY < 6) resizer = "TOP";
			//else if (e.stageY > this.height - 11) resizer = "BOTTOM";
			//
			//if (e.stageX < 6) resizer += resizer ? "_LEFT" : "LEFT";
			//else if (e.stageX > this.width - 11) resizer += resizer ? "_RIGHT" : "RIGHT";
			//
			//if (resizer)
			//{
				//trace(NativeWindowResize[resizer], resizer)
				//startResize(NativeWindowResize[resizer]);
			//}else
			//{
				//startMove();
			//}
		}
	}
}