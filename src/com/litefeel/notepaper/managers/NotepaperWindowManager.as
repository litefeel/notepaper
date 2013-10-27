package com.litefeel.notepaper.managers
{
	import com.litefeel.notepaper.events.CloseEvent;
	import com.litefeel.notepaper.events.GroupEvent;
	import com.litefeel.notepaper.events.NoteEvent;
	import com.litefeel.notepaper.events.NotepaperEvent;
	import com.litefeel.notepaper.language._;
	import com.litefeel.notepaper.language.__;
	import com.litefeel.notepaper.view.AlertWindow;
	import com.litefeel.notepaper.view.NotepaperConstant;
	import com.litefeel.notepaper.view.NotepaperDefaultSize;
	import com.litefeel.notepaper.view.NotepaperWindow;
	import com.litefeel.notepaper.vo.NotepaperVo;
	import flash.desktop.NativeApplication;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 有数据更新的时候触发
	 */
	[Event(name="dataChange", type="com.litefeel.notepaper.events.NotepaperEvent")]
	
	public class NotepaperWindowManager extends EventDispatcher
	{
		
		private static var instance:NotepaperWindowManager = null;
		
		private var alertWindow:AlertWindow;
		
		public function NotepaperWindowManager()
		{
			EventCenter.instance.addEventListener(GroupEvent.DELETE, removeGroupWindow);
		}
		
		private function removeGroupWindow(e:GroupEvent):void 
		{
			for each(var window:NotepaperWindow in dict)
			{
				var vo:NotepaperVo = window.getVo();
				if (vo.groupId == e.groupVo.id)
				{
					_removeWindow(window);
				}
			}
		}
		
		/**
		 * 获取NotepaperWindowManager 的唯一实例
		 * @return
		 */
		public static function getInstance():NotepaperWindowManager
		{
			if (!instance) instance = new NotepaperWindowManager();
			return instance;
		}
		
		private const dict:Dictionary = new Dictionary();
		
		private var _alwaysInFrontAll:Boolean = true;
		private var _showCount:int = 0;
		private var _count:int = 0;
		
		
		/** 是否所有notepaerWindow都总在最前端 */
		public function get alwaysInFrontAll():Boolean { return _alwaysInFrontAll; }
		/** 是否所有notepaerWindow都总在最前端 */
		public function set alwaysInFrontAll(value:Boolean):void
		{
			if(_alwaysInFrontAll != value)
			{
				_alwaysInFrontAll = value;
				for each(var window:NotepaperWindow in dict)
				{
					if(window.alwaysInFront != value)
					{
						window.alwaysInFront = value;
					}
				}
			}
		}
		
		/**
		 * notepaerWindow的个数
		 * @return
		 */
		public function getNotepaperWindowCount():int
		{
			return _count;
		}
		
		/**
		 * notepaperWindow显示的个数
		 * @return
		 */
		public function getNotepaperWindowShowCount():int
		{
			return _showCount;
		}
		
		public function getDict():Dictionary
		{
			return dict;
		}
		
		/**
		 * 创建一个窗口
		 * @param	vo	窗口初始化对象
		 * @return
		 */
		public function createWindow(vo:NotepaperVo = null):NotepaperWindow
		{
			var evt:NoteEvent;
			if (!vo)
			{
				vo = new NotepaperVo(null, NotepaperConstant.DEFAULT_SUBJECT, NotepaperConstant.DEFAULT_CONTENT, true, Number.NaN, Number.NaN, NotepaperDefaultSize.WIDTH, NotepaperDefaultSize.HEIGHT);
				vo.onTop = true;
				vo.groupId = 1;
				evt = new NoteEvent(NoteEvent.CREATE, false, false, vo);
			}
			var window:NotepaperWindow = new NotepaperWindow(vo);
			
			window.addEventListener(NotepaperEvent.DATA_CHANGE, dataChangeHandler);
			
			dict[window] = window;
			
			window.activate();
			if(evt != null) EventCenter.instance.dispatchEvent(evt);
			_count++;
			_showCount++;
			return window;
		}
		
		private function dataChangeHandler(e:NotepaperEvent):void 
		{
			dispatchEvent(e);
			EventCenter.instance.dispatchEvent(new NoteEvent(NoteEvent.MODIFY, false, false, e.target.getVo()));
		}
		
		/**
		 * 删除一个窗口
		 * @param	window
		 */
		public function removeWindow(window:NotepaperWindow):void
		{
			if (!dict[window]) return;
			
			var msg:String = __("Are you sure you want to delete the notepaper \"{1}\" ?", window.getVo().subject);
			var title:String = _("Confirm Notepaper Delete");
			var yes:String = _("OK");
			var no:String = _("Cancel");
			alertWindow = AlertWindow.show(msg, title, [yes, no], confirmDeleteNotepaperHandler, 1);
			alertWindow.data = window;
			alertWindow.getNativeWindow().alwaysInFront = window.alwaysInFront;
			
		}
		
		private function confirmDeleteNotepaperHandler(e:CloseEvent):void
		{
			if (0 == e.selectedIndex)
			{
				var window:NotepaperWindow = e.target.data as NotepaperWindow;
				if (_removeWindow(window))
				{
					window.removeEventListener(NotepaperEvent.DATA_CHANGE, dataChangeHandler);
					dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
					EventCenter.instance.dispatchEvent(new NoteEvent(NoteEvent.DELETE, false, false, window.getVo()));
				}
			}
		}
		
		private function _removeWindow(window:NotepaperWindow):Boolean
		{
			if (!dict[window]) return false;
			delete dict[window];
			
			_count--;
			if (window.visible) _showCount--;
			window.close();
			return true;
		}
		
		/**
		 * 隐藏一个窗口
		 * @param	window
		 */
		public function hideWindow(window:NotepaperWindow):void
		{
			if (!dict[window]) return;
			
			if (window.visible)
			{
				_showCount--;
				window.visible = false;
			}
			//dispatchEvent(new NotepaperEvent(NotepaperEvent.DATA_CHANGE));
			EventCenter.instance.dispatchEvent(new NoteEvent(NoteEvent.MODIFY, false, false, window.getVo()));
		}
		
		/**
		 * 显示所有notepaer窗口 active
		 * @param	groupId 分组id, 如果为-1,表示所有组, default -1
		 */
		public function showAll(groupId:int = -1):void
		{
			changNotepaperDisplay(true, groupId);
		}
		
		/**
		 * 隐藏所有notepaer窗口 close
		 * @param	groupId 分组id, 如果为-1,表示所有组, default -1
		 */
		public function hideAll(groupId:int = -1):void
		{
			changNotepaperDisplay(false, groupId);
		}
		
		/**
		 * 改变notepaer窗口的现实状态
		 * @param	isShow	是否显示
		 * @param	group 组名 如果为-1, 表示所有组, default -1 
		 */
		private function changNotepaperDisplay(isShow:Boolean, groupId:int = -1):void
		{
			for each(var window:NotepaperWindow in dict)
			{
				if (groupId != -1 && window.getVo().groupId != groupId) continue;
				if(window.visible != isShow)
				{
					window.visible = isShow;
					_showCount = isShow ? _showCount + 1 : _showCount - 1;
				}
				if (isShow)
				{
					// 需要使用NativeApplication才行，否则不能彻底激活窗口
					NativeApplication.nativeApplication.activate(window);
					window.orderToFront();
				}
			}
		}
	}
}