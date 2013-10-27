package com.litefeel.notepaper.view
{
	import com.litefeel.notepaper.events.NotepaperEvent;
	import com.litefeel.notepaper.managers.NotepaperWindowManager;
	import com.litefeel.notepaper.vo.NotepaperVo;
	import com.litefeel.utils.GraphicsUtil;
	import flash.display.NativeWindowResize;
	import flash.display.Shape;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.IME;
	import flash.text.TextFormat;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.ContextMenuItem;
	
	
	/**
	 * 有数据更新的时候触发
	 */
	[Event(name="dataChange", type="com.litefeel.notepaper.events.NotepaperEvent")]
	
	public class NotepaperWindow extends NativeWindow
	{
		private var subjectTxt:TextField;
		private var contentTxt:TextField;
		private var bg:Shape;
		
		private var editer:TextField = null;
		private var _this:NotepaperWindow;
		
		private var vo:NotepaperVo;
		
		public function NotepaperWindow()
		{
			_this = this;
			
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOptions.systemChrome = NativeWindowSystemChrome.NONE;
			initOptions.type = NativeWindowType.UTILITY;
			initOptions.transparent = true;
			initOptions.resizable = true;
			initOptions.maximizable = false;
			initOptions.minimizable = false;
			super(initOptions);
			
			vo = new NotepaperVo(null, NotepaperConstant.DEFAULT_SUBJECT, NotepaperConstant.DEFAULT_CONTENT);
			
			initUI();
			this.alwaysInFront = true;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, beginEditHandler);
			stage.addEventListener(FocusEvent.FOCUS_OUT, endEditHandler);
			this.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeHandler);
			this.addEventListener(NativeWindowBoundsEvent.MOVE, moveHandler);
			resizeHandler(null);
		}
		
		private function moveHandler(e:NativeWindowBoundsEvent):void 
		{
			dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
		}
		
		public function getVo():NotepaperVo
		{
			return new NotepaperVo(null, subject, content, x, y, width, height);
		}
		
		public function setVo(value:NotepaperVo):void
		{
			this.subject = value.subject;
			this.content = value.content;
			this.x = value.x;
			this.y = value.y;
			this.width = value.width;
			this.height = value.height;
		}
		
		public function get subject():String { return subjectTxt.text; }
		public function set subject(value:String):void
		{
			if(null == value) value = "";
			subjectTxt.text = value;
		}
		
		public function get content():String { return contentTxt.text; }
		public function set content(value:String):void
		{
			if(null == value) value = "";
			contentTxt.text = value;
			
		}
		
		private function initUI():void
		{
			bg = new Shape();
			stage.addChild(bg);
			
			subjectTxt = new TextField();
			subjectTxt.multiline = false;
			subjectTxt.wordWrap = false;
			subjectTxt.doubleClickEnabled = true;
			var tf:TextFormat = new TextFormat("宋体", 14, 0x0, null, null, null, null, null, "center");
			subjectTxt.defaultTextFormat = tf;
			subjectTxt.text = vo.subject;
			subjectTxt.height = 21;
			subjectTxt.x = 0;
			subjectTxt.y = 1;
			
			subjectTxt.contextMenu; // 必须先调用一下,才能正常初始化,类似SoundChannel.position
			endEditTxt(subjectTxt);
			stage.addChild(subjectTxt);
			
			contentTxt = new TextField();
			contentTxt.multiline = true;
			contentTxt.wordWrap = true;
			contentTxt.doubleClickEnabled = true;
			contentTxt.text = vo.content;
			contentTxt.x = 0;
			contentTxt.y = 22;
			contentTxt.contextMenu;	// 必须先调用一下,才能正常初始化,类似SoundChannel.position
			endEditTxt(contentTxt);
			stage.addChild(contentTxt);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			width  = NotepaperDefaultSize.WIDTH;
			height = NotepaperDefaultSize.HEIGHT;
			
			//stage.contextMenu = getMenu();
		}
		
		private function resizeHandler(e:NativeWindowBoundsEvent):void 
		{
			var rect:Rectangle = e ? e.afterBounds : this.bounds;
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFE66, 1);
			bg.graphics.drawRect(0, 0, rect.width, 22);
			bg.graphics.beginFill(0xA1E565, 1);
			bg.graphics.drawRect(0, 22, rect.width, rect.height - 22);
			bg.graphics.lineStyle(1, 0, 1);
			GraphicsUtil.drawDashed(bg.graphics, new Point(0, 22), new Point(rect.width, 22), 7, 5);
			bg.graphics.endFill();
			
			subjectTxt.width = rect.width - 1;
			contentTxt.width = rect.width - 1;
			contentTxt.height = rect.height - 24;
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			// 在编辑状态
			if (editer != null) return;
			
			var resizer:String = "";
			if (e.stageY < 6) resizer = "TOP";
			else if (e.stageY > this.height - 6) resizer = "BOTTOM";
			
			if (e.stageX < 6) resizer += resizer ? "_LEFT" : "LEFT";
			else if (e.stageX > this.width - 6) resizer += resizer ? "_RIGHT" : "RIGHT";
			
			if (resizer)
			{
				//trace(NativeWindowResize[resizer], resizer)
				startResize(NativeWindowResize[resizer]);
			}else
			{
				startMove();
			}
		}
		
		private function beginEditHandler(e:MouseEvent):void
		{
			//trace("this is beginEditHandler");
			var txt:TextField = e.target as TextField;
			if(txt != null)
				beginEditTxt(txt);
		}
		
		private function endEditHandler(e:Event):void
		{
			if (!editer) return;
			
			//trace("this is endEditHandler!", e.target);
			var txt:TextField = e.target as TextField;
			if(txt != null)
				endEditTxt(txt);
		}
		
		private function beginEditTxt(txt:TextField):void
		{
			//trace("this is beginEdiatTxt:", txt.name);
			editer = txt;
			txt.border = true;
			txt.selectable = true;
			txt.setSelection(0, txt.text.length);
			txt.type = TextFieldType.INPUT;
			changTxtMenu(txt, false);
			IME.enabled = true;
		}
		private function endEditTxt(txt:TextField):void
		{
			//trace("this is endEditTxt:", txt.name);
			editer = null;
			txt.selectable = false;
			txt.border = false;
			txt.type = TextFieldType.DYNAMIC;
			changTxtMenu(txt, true);
			dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
		}
		
		private function getMenu():NativeMenu
		{
			var newNotepaperItem:NativeMenuItem = new NativeMenuItem("新建便签");
			newNotepaperItem.addEventListener(Event.SELECT, function (e:Event):void
			{
				NotepaperWindowManager.getInstance().createWindow();
			});
			
			var exitItem:NativeMenuItem = new NativeMenuItem("删除");
			exitItem.addEventListener(Event.SELECT, function (e:Event):void
			{
				NotepaperWindowManager.getInstance().removeWindow(_this);
			});
			
			var menu:NativeMenu = new NativeMenu();
			menu.addItem(newNotepaperItem);
			menu.addItem(exitItem);
			return menu;
		}
		
		private function changTxtMenu(txt:TextField, isEdit:Boolean = true):void
		{
			const EDIT_STRING:String = "编辑";
			const OVER_STRING:String = "完成"; 
			var editItem:NativeMenuItem = null;
			
			//			trace(txt.contextMenu , "txt.contentMenu");
			if(0 == txt.contextMenu.items.length)
			{	
				var newNotepaperItem:NativeMenuItem = new NativeMenuItem("新建便签");
				newNotepaperItem.addEventListener(Event.SELECT, function (e:Event):void
				{
					NotepaperWindowManager.getInstance().createWindow();
				});
				
				var deleteItem:NativeMenuItem = new NativeMenuItem("删除");
				deleteItem.addEventListener(Event.SELECT, function (e:Event):void
				{
					NotepaperWindowManager.getInstance().removeWindow(_this);
				});
				editItem = new NativeMenuItem(EDIT_STRING);
				editItem.addEventListener(Event.SELECT, txtMenuSelctHandler);
				txt.contextMenu.addItem(newNotepaperItem);
				txt.contextMenu.addItem(deleteItem);
				txt.contextMenu.addItem(new NativeMenuItem("", true));
				txt.contextMenu.addItem(editItem);
			}else
			{
				editItem = txt.contextMenu.items[3];
			}
			
			editItem.label = isEdit ? EDIT_STRING : OVER_STRING;
			
			function txtMenuSelctHandler(e:Event):void
			{
				if(EDIT_STRING == editItem.label)
				{
					beginEditTxt(txt);
				}else
				{
					endEditTxt(txt);
				}
			}
		}
	}
}