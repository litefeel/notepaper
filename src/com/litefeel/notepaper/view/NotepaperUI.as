package com.litefeel.notepaper.view 
{
	import com.litefeel.notepaper.events.NotepaperEvent;
	import com.litefeel.notepaper.language._;
	import com.litefeel.notepaper.managers.DataManager;
	import com.litefeel.notepaper.vo.GroupVo;
	import com.litefeel.notepaper.vo.NotepaperVo;
	import com.litefeel.text.UndoTextField;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.system.IME;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	[Event(name = "dataChange", type = "com.litefeel.notepaper.events.NotepaperEvent")]
	[Event(name = "create", type = "com.litefeel.notepaper.events.NotepaperEvent")]
	[Event(name = "delete", type = "com.litefeel.notepaper.events.NotepaperEvent")]
	[Event(name = "hide",   type = "com.litefeel.notepaper.events.NotepaperEvent")]
	[Event(name = "showBigSize",   type = "com.litefeel.notepaper.events.NotepaperEvent")]
	[Event(name = "showNormalSize",   type = "com.litefeel.notepaper.events.NotepaperEvent")]
	[Event(name = "startResize",   type = "com.litefeel.notepaper.events.NotepaperEvent")]
	[Event(name = "startMove",   type = "com.litefeel.notepaper.events.NotepaperEvent")]
	
	
	/**
	 * Notepaper的界面
	 * @author lite3
	 */
	public class NotepaperUI extends Sprite
	{
		private var w:Number;
		private var h:Number;
		
		private var _isShowSubject:Boolean = true;
		
		private var vo:NotepaperVo;
		
		private var _content:String = "";
		private var _subject:String = "";
		
		private var contentTxt : UndoTextField;
		private var subjectTxt : UndoTextField;
		
		private var contextMenuAtTxt:UndoTextField;
		
		// 右键菜单项
		private var createItem:NativeMenuItem;
		private var deleteItem:NativeMenuItem;
		private var hideItem:NativeMenuItem;
		private var isShowSubjectItem:NativeMenuItem;
		private var onTopItem:NativeMenuItem;
		private var editItem:NativeMenuItem;
		private var completeEditItem:NativeMenuItem;
		private var completeEditItem1:NativeMenuItem;
		private var groupsItem:NativeMenuItem;
		
		private var resizer:Resizer;
		
		public function NotepaperUI(vo:NotepaperVo) 
		{
			super();
			this.vo = vo;
			initNativeMenu();
			initUI();
			this.content = vo.content;
			this.subject = vo.subject;
			setSize(vo.width, vo.height);
		}
		
		//public function completeEdit():void
		//{
			//completeEditTxt(subjectTxt);
			//completeEditTxt(contentTxt);
		//}
		
		public function setSize(w:Number, h:Number):void
		{
			if (isNaN(w) || !isFinite(w) || w <= 0 || isNaN(h) || !isFinite(h) || h <= 0) {
				return;
			}
			this.w = w;
			this.h = h;
			
			graphics.clear();
			
			var tmpY:Number = 0;
			if (_isShowSubject)
			{
				tmpY = subjectTxt.height;
				subjectTxt.width = w;
				graphics.beginFill(0xFFFE66, 1);
				graphics.drawRect(0, 0, w, subjectTxt.height);
				
				//graphics.lineStyle(1, 0, 1);
				//GraphicsUtil.drawDashed(graphics, new Point(0, tmpY), new Point(w, tmpY), 7, 5);
				//graphics.lineStyle(Number.NaN);
			}
			contentTxt.width = w;
			contentTxt.height = h - tmpY;
			graphics.beginFill(0xA1E565, 1);
			graphics.drawRect(0, tmpY, w, h - tmpY);
			graphics.endFill();
			
			resizer.x = w;
			resizer.y = h;
		}
		
		override public function set width(value:Number):void
		{
			setSize(value, h);
		}
		override public function set height(value:Number):void
		{
			setSize(w, value);
		}
		
		public function get isShowSubject():Boolean { return _isShowSubject; }
		
		public function set isShowSubject(value:Boolean):void 
		{
			if (_isShowSubject != value)
			{
				_isShowSubject = value;
				
				var w:Number = width;
				var h:Number = height;
				if (value)
				{
					addChild(subjectTxt);
					contentTxt.y = subjectTxt.height;
				}else
				{
					removeChild(subjectTxt);
					contentTxt.y = 0;
				}
				setSize(w, h);
			}
		}
		
		public function get subject():String { return _subject; }
		
		public function set subject(value:String):void 
		{
			if (!value) value = "";
			if (value != _subject)
			{
				_subject = value;
				subjectTxt.text = value;
			}
		}
		
		public function get content():String { return _content; }
		
		public function set content(value:String):void 
		{
			if (!value) value = "";
			if (value != _content)
			{
				_content = value;
				contentTxt.text = value;
			}
		}
		
		private function initUI():void
		{
			subjectTxt = new UndoTextField();
			subjectTxt.name = "_subject";
			subjectTxt.multiline = false;
			subjectTxt.wordWrap = false;
			var tf:TextFormat = new TextFormat(null, 14, 0x0, null, null, null, null, null, "center");
			subjectTxt.defaultTextFormat = tf;
			subjectTxt.text = "_subject";
			subjectTxt.height = subjectTxt.textHeight + 4;
			subjectTxt.mouseEnabled = false;
			subjectTxt.addEventListener(KeyboardEvent.KEY_DOWN, txtKeyDownHandler);
			subjectTxt.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			
			subjectTxt.contextMenu; // 必须先调用一下,才能正常初始化,类似SoundChannel.position
			subjectTxt.contextMenu.addItem(completeEditItem);
			subjectTxt.contextMenu.addEventListener(Event.DISPLAYING, menuTransformLanguageHandler);
			completeEditItem.data = subjectTxt;
			addChild(subjectTxt);
			
			resizer = new Resizer();
			addChild(resizer);
			
			contentTxt = new UndoTextField();
			contentTxt.name = "_content";
			contentTxt.multiline = true;
			contentTxt.wordWrap = true;
			contentTxt.y = subjectTxt.height;
			contentTxt.mouseEnabled = false;
			contentTxt.addEventListener(Event.CHANGE, changeHandler);
			contentTxt.addEventListener(KeyboardEvent.KEY_DOWN, txtKeyDownHandler);
			contentTxt.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			
			//contentTxt.contextMenu;	// 必须先调用一下,才能正常初始化,类似SoundChannel.position
			contentTxt.contextMenu.addItem(completeEditItem1);
			contentTxt.contextMenu.addEventListener(Event.DISPLAYING, menuTransformLanguageHandler);
			completeEditItem1.data = contentTxt;
			addChild(contentTxt);
			
			this.filters = [new DropShadowFilter(4,45,0xCCCCCC), new GlowFilter(0xFFFFFF, 1, 2, 2)];
			
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			resizer.addEventListener(MouseEvent.ROLL_OVER, resizerOverOutHandler);
			resizer.addEventListener(MouseEvent.ROLL_OUT, resizerOverOutHandler);
			
			// 右键菜单
			contextMenu = new NativeMenu();
			contextMenu.addItem(createItem);
			contextMenu.addItem(deleteItem);
			contextMenu.addItem(hideItem);
			contextMenu.addItem(new NativeMenuItem("", true));
			contextMenu.addItem(groupsItem);
			contextMenu.addItem(new NativeMenuItem("", true));
			contextMenu.addItem(isShowSubjectItem);
			contextMenu.addItem(onTopItem);
			contextMenu.addItem(editItem);
			contextMenu.addEventListener(Event.DISPLAYING, displayContextMenuHandler);
		}
		
		private function resizerOverOutHandler(e:MouseEvent):void 
		{
			var auto:Boolean = !resizer.visible || MouseEvent.ROLL_OUT == e.type
			Mouse.cursor = auto ? MouseCursor.AUTO : Cursor.NWSE;
		}
		
		private function txtKeyDownHandler(e:KeyboardEvent):void 
		{
			// Tab switch suject and content editor state
			if (Keyboard.TAB == e.keyCode)
			{
				e.preventDefault();
				var txt:UndoTextField = getOtherDisplayingTxt(e.target as UndoTextField);
				if (txt != null) editTxt(txt);
			}
			// Enter end subject editor state
			else if (Keyboard.ENTER == e.keyCode && e.target == subjectTxt)
			{
				completeEditTxt(subjectTxt);
			}
			// Ctrl+S save the notepaper
			else if (Keyboard.S == e.keyCode && e.ctrlKey)
			{
				completeEditTxt(e.target as UndoTextField);
			}
		}
		
		private function changeHandler(e:Event):void 
		{
			//contentTxt.height = contentTxt.textHeight + 4;
			//height = contentTxt.y + contentTxt.height;
		}
		
		private function menuTransformLanguageHandler(e:Event):void 
		{
			// multilingual
			var menu:NativeMenu = NativeMenu(e.currentTarget);
			for each(var item:NativeMenuItem in menu.items)
			{
				if (!item.isSeparator)
				{
					item.label = _(item.name);
				}
			}
		}
		
		private function doubleClickHandler(e:MouseEvent):void 
		{
			if (EventPhase.AT_TARGET == e.eventPhase)
			{
				var txt:UndoTextField = getTxtAtPoint(mouseX, mouseY);
				if (txt != null)
				{
					editTxt(txt);
				}
			}
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			if (e.target == resizer)
			{
				dispatchEvent(new NotepaperEvent(NotepaperEvent.START_RESIZE));
				Mouse.cursor = Cursor.NWSE;
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				return;
			}
			
			var txt:UndoTextField = e.target as UndoTextField;
			if (txt && "input" == txt.type)
			{
				e.stopImmediatePropagation();
			}else
			{
				dispatchEvent(new NotepaperEvent(NotepaperEvent.START_MOVE));
			}
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			Mouse.cursor = MouseCursor.AUTO;
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function focusOutHandler(e:FocusEvent):void 
		{
			completeEditTxt(e.currentTarget as UndoTextField);
		}
		
		private function displayContextMenuHandler(e:Event):void 
		{
			contextMenuAtTxt = getTxtAtPoint(mouseX, mouseY);
			
			if (isShowSubjectItem.checked != isShowSubject)
			{
				isShowSubjectItem.checked = isShowSubject;
			}
			
			if (onTopItem.checked != vo.onTop)
			{
				onTopItem.checked = vo.onTop;
			}
			
			// multilingual
			menuTransformLanguageHandler(e);
			
			/*
			// 这里不用判断是输入文本还是动态文本了,因为输入文本的右键菜单是文本的菜单
			if ("input" == contextMenuAtTxt.type)
			{
				contextMenu.addItem(completeEditItem);
			}else
			{
				contextMenu.addItem(editItem);
			}*/
		}
		
		/**
		 * 
		 * @param	获取当前显示的另一个文本
		 * @return
		 */
		private function getOtherDisplayingTxt(txt:UndoTextField):UndoTextField
		{
			if (txt == subjectTxt)
				return contentTxt;
			else if (txt == contentTxt && _isShowSubject)
				return subjectTxt;
				
			return null;
		}
		
		private function getTxtAtPoint(x:Number, y:Number):UndoTextField
		{
			//先用content 是因为content不会消失,而subject会消失
			
			// 在content上
			if (contentTxt.hitTestPoint(x, y))
			{
				return contentTxt;
			}
			
			// 在suject上
			if (subjectTxt.hitTestPoint(x, y))
			{
				return subjectTxt;
			}
			
			return null;
		}
		
		private function initNativeMenu():void
		{
			createItem = new NativeMenuItem(_("New"));
			createItem.name = "New";
			createItem.addEventListener(Event.SELECT, createItemHandler);
			deleteItem = new NativeMenuItem(_("Delete..."));
			deleteItem.name = "Delete...";
			deleteItem.addEventListener(Event.SELECT, deleteItemHandler);
			hideItem = new NativeMenuItem(_("Hide"));
			hideItem.name = "Hide";
			hideItem.addEventListener(Event.SELECT, hideItemHandler);
			isShowSubjectItem = new NativeMenuItem(_("Show Title"));
			isShowSubjectItem.name = "Show Title"; 
			isShowSubjectItem.addEventListener(Event.SELECT, isShowSubjectItemHandler);
			onTopItem = new NativeMenuItem(_("OnTop"));
			onTopItem.name = "OnTop";
			onTopItem.addEventListener(Event.SELECT, selectOnTopHandler);
			editItem = new NativeMenuItem(_("Edit"));
			editItem.name = "Edit";
			editItem.addEventListener(Event.SELECT, editItemHandler);
			completeEditItem = new NativeMenuItem(_("Finish Editing"));
			completeEditItem.name = "Finish Editing";
			completeEditItem.addEventListener(Event.SELECT, completeEditItemHandler);
			completeEditItem1 = new NativeMenuItem(_("Finish Editing"));
			completeEditItem1.name = "Finish Editing";
			completeEditItem1.addEventListener(Event.SELECT, completeEditItemHandler);
			
			groupsItem = new NativeMenuItem(_("Groups"));
			groupsItem.name = "Groups";
			groupsItem.submenu = new NativeMenu();;
			groupsItem.addEventListener(Event.DISPLAYING, displayingGroupsMenuHandler);
		}
		
		private function displayingGroupsMenuHandler(e:Event):void
		{
			var groupsMenu:NativeMenu = NativeMenuItem(e.currentTarget).submenu;
			groupsMenu.removeAllItems();
			var list:Vector.<GroupVo> = DataManager.instance.getGroupList();
			for (var i:int = 0; i < list.length; i++)
			{
				var item:NativeMenuItem = new NativeMenuItem(list[i].name);
				item.name = list[i].id + "";
				item.checked = list[i].id == vo.groupId;
				groupsMenu.addItem(item);
				item.addEventListener(Event.SELECT, selectGroupHandler);
			}
			groupsMenu.getItemAt(0).label = _(list[0].name);
		}
		
		private function selectOnTopHandler(e:Event):void 
		{
			vo.onTop = !onTopItem.checked;
			dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
		}
		
		private function selectGroupHandler(e:Event):void 
		{
			var item:NativeMenuItem = e.currentTarget as NativeMenuItem;
			if (item.checked) return;
			
			var old:NativeMenuItem = item.menu.getItemByName(vo.groupId + "");
			if (old) old.checked = false;
			
			vo.groupId = parseInt(item.name);
			dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
		}
		
		private function createItemHandler(e:Event):void 
		{
			dispatchEvent(new NotepaperEvent(NotepaperEvent.CREATE));
		}
		
		private function deleteItemHandler(e:Event):void 
		{
			dispatchEvent(new NotepaperEvent(NotepaperEvent.DELETE));
		}
		
		private function hideItemHandler(e:Event):void 
		{
			dispatchEvent(new NotepaperEvent(NotepaperEvent.HIDE));
		}
		
		private function isShowSubjectItemHandler(e:Event):void 
		{
			isShowSubject = !isShowSubject;
			vo.isShowSubject = isShowSubject;
			vo.width = width;
			vo.height = height;
			dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
		}
		
		private function editItemHandler(e:Event):void 
		{
			completeEditTxt(contextMenuAtTxt != subjectTxt ? subjectTxt : contentTxt);
			editTxt(contextMenuAtTxt != subjectTxt ? contentTxt : subjectTxt);
		}
		
		private function completeEditItemHandler(e:Event):void 
		{
			var item:NativeMenuItem = NativeMenuItem(e.currentTarget);
			var txt:UndoTextField = UndoTextField(item.data);
			completeEditTxt(txt);
		}
		
		private function editTxt(txt:UndoTextField):void
		{
			if (!txt.mouseEnabled)
			{
				//dispatchEvent(new NotepaperEvent(NotepaperEvent.SHOW_BIG_SIZE));
				
				stage.focus = txt;
				IME.enabled = true;
				txt.mouseEnabled = true;
				txt.type = "input";
				txt.border = true;
				txt.setSelection(0, int.MAX_VALUE);
				txt.clearAllUndoRedo();
				
				resizer.visible = false;
			}
		}
		
		private function completeEditTxt(txt:UndoTextField):void
		{
			if (txt.mouseEnabled)
			{
				txt.mouseEnabled = false;
				txt.border = false;
				txt.setSelection(0, 0);
				txt.type = "dynamic";
				txt.clearAllUndoRedo();
				
				resizer.visible = true;
				
				//dispatchEvent(new NotepaperEvent(NotepaperEvent.SHOW_NORMAL_SIZE));
				
				if (this[txt.name] != txt.text)
				{
					this[txt.name] = txt.text;
					vo.subject = subjectTxt.text;
					vo.content = contentTxt.text;
					dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
				}
			}
		}
	}
}