package com.litefeel.notepaper 
{
	import com.litefeel.net.SimpleLoader;
	import com.litefeel.notepaper.events.ConfigEvent;
	import com.litefeel.notepaper.events.LanguageEvent;
	import com.litefeel.notepaper.language._;
	import com.litefeel.notepaper.language.Language;
	import com.litefeel.notepaper.language.LanguageManager;
	import com.litefeel.notepaper.language.LanguageVo;
	import com.litefeel.notepaper.managers.DataManager;
	import com.litefeel.notepaper.managers.EventCenter;
	import com.litefeel.notepaper.managers.NotepaperWindowManager;
	import com.litefeel.notepaper.view.AboutWindow;
	import com.litefeel.notepaper.view.ManagerWindow;
	import com.litefeel.notepaper.vo.ConfigVo;
	import com.litefeel.notepaper.vo.GroupVo;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	/**
	 * 系统托盘图标
	 * @author lite3
	 */
	public class TrayIcon
	{
		private var langItemList:Vector.<NativeMenuItem>;
		
		private var notepaperWindowManager:NotepaperWindowManager;
		private var trayIcon:SystemTrayIcon;
		
		public function TrayIcon(_trayIcon:SystemTrayIcon) 
		{
			langItemList = new Vector.<NativeMenuItem>();
			
			notepaperWindowManager = NotepaperWindowManager.getInstance();
			
			trayIcon = _trayIcon;
			trayIcon.menu = getTrayMenu();
			trayIcon.addEventListener(MouseEvent.CLICK, showAllNotepaperWindow);
			
			LanguageManager.getInstance().addEventListener(LanguageEvent.LANGUAGE_CHANGE, langChangeHandler);
		}
		
		/**
		 * 显示任务栏图标
		 */
		public function showIcon():void
		{
			var file:File = File.applicationDirectory.resolvePath("assets/trayIcon.png");
			new SimpleLoader().loadURL(file.url, setIcon);
		}
		
		private function setIcon(success:Boolean, loader:SimpleLoader):void
		{
			if (success)
			{
				var bitmap:Bitmap = loader.content as Bitmap;
				trayIcon.bitmaps = [bitmap.bitmapData];
				trace(bitmap.bitmapData);
			}
		}
		
		private function showAllNotepaperWindow(e:MouseEvent):void 
		{
			if (notepaperWindowManager.getNotepaperWindowCount() > 0)
			{
				if (notepaperWindowManager.getNotepaperWindowShowCount() > 0)
				{
					notepaperWindowManager.hideAll();
				}else
				{
					notepaperWindowManager.showAll();
				}
			}
		}
		
		private function getTrayMenu():NativeMenu
		{
			var newNotepaperItem:NativeMenuItem = new NativeMenuItem(_("New Notepaper"));
			langItemList.push(newNotepaperItem);
			newNotepaperItem.name = "New Notepaper";
			newNotepaperItem.addEventListener(Event.SELECT, function(e:Event):void
			{
				notepaperWindowManager.createWindow();
			});
			
			var showGroupsItem:NativeMenuItem = new NativeMenuItem(_("Show Groups"));
			langItemList.push(showGroupsItem);
			showGroupsItem.name = "Show Groups";
			showGroupsItem.submenu = createShowHideGroupsMenu(true);
			var hideGroupsItem:NativeMenuItem = new NativeMenuItem(_("Hide Groups"));
			langItemList.push(hideGroupsItem);
			hideGroupsItem.name = "Hide Groups";
			hideGroupsItem.submenu = createShowHideGroupsMenu(false);
			
			//var alwaysInFrontItem:NativeMenuItem = new NativeMenuItem(_("Always In Front"));
			//langItemList.push(alwaysInFrontItem);
			//alwaysInFrontItem.name = "Always In Front";
			//alwaysInFrontItem.checked = NotepaperWindowManager.getInstance().alwaysInFrontAll;
			//alwaysInFrontItem.addEventListener(Event.SELECT, function(e:Event):void
			//{
				//alwaysInFrontItem.checked = !alwaysInFrontItem.checked;
				//NotepaperWindowManager.getInstance().alwaysInFrontAll = alwaysInFrontItem.checked;
			//});
			
			var startAtLoginItem:NativeMenuItem = new NativeMenuItem(_("Start At Login"));
			langItemList.push(startAtLoginItem);
			startAtLoginItem.name = "Start At Login";
			startAtLoginItem.addEventListener(Event.SELECT, function(e:Event):void
			{
				var startAtLogin:Boolean = !startAtLoginItem.checked;
				NativeApplication.nativeApplication.startAtLogin = startAtLogin;
				var vo:ConfigVo = DataManager.instance.getConfig();
				vo.startAtLogin = startAtLogin;
				EventCenter.instance.dispatchEvent(new ConfigEvent(ConfigEvent.UPDATE, false, false, vo));
			});
			startAtLoginItem.addEventListener(Event.DISPLAYING, function(e:Event):void
			{
				startAtLoginItem.checked = NativeApplication.nativeApplication.startAtLogin;
			});
			
			var aboutItem:NativeMenuItem = new NativeMenuItem(_("About..."));
			langItemList.push(aboutItem);
			aboutItem.name = "About...";
			aboutItem.addEventListener(Event.SELECT, function (e:Event):void
			{
				AboutWindow.showWindow();
			});
			
			var exitItem:NativeMenuItem = new NativeMenuItem(_("Exit"));
			langItemList.push(exitItem);
			exitItem.name = "Exit";
			exitItem.addEventListener(Event.SELECT, function (e:Event):void
			{
				NativeApplication.nativeApplication.dispatchEvent(new Event(Event.EXITING));
				NativeApplication.nativeApplication.exit();
			});
			
			var managerItem:NativeMenuItem = new NativeMenuItem(_("Manager..."));
			langItemList.push(managerItem);
			managerItem.name = "Manager...";
			managerItem.addEventListener(Event.SELECT, function (e:Event):void
			{
				ManagerWindow.showWindow();
			});
			
			//var loginItem:NativeMenuItem = new NativeMenuItem(_("Login"));
			//loginItem.name = "Login";
			//loginItem.addEventListener(Event.SELECT, function(e:Event):void
			//{
				//new LoginWindow();
			//});
			
			var languageItem:NativeMenuItem = new NativeMenuItem(_("Language"));
			langItemList.push(languageItem);
			languageItem.name = "Language";
			languageItem.submenu = new NativeMenu();
			languageItem.submenu.addEventListener(Event.DISPLAYING, showLanguageMenuHandler);
			
			
			var menu:NativeMenu = new NativeMenu();
			menu.addItem(newNotepaperItem);
			menu.addItem(getSeparatorItem());
			
			menu.addItem(showGroupsItem);
			menu.addItem(hideGroupsItem);
			menu.addItem(getSeparatorItem());
			
			//menu.addItem(alwaysInFrontItem);
			CONFIG::release {
				menu.addItem(startAtLoginItem);
			}
			menu.addItem(languageItem);
			menu.addItem(managerItem);
			menu.addItem(aboutItem);
			menu.addItem(new NativeMenuItem("", true));
			menu.addItem(exitItem);
			//menu.addItem(loginItem);
			
			return menu;
		}
		
		private function showLanguageMenuHandler(e:Event):void 
		{
			var languageMenu:NativeMenu = NativeMenu(e.currentTarget);
			languageMenu.removeAllItems();
			var langList:Vector.<LanguageVo> = Language.getInstance().getLanguageList();
			var len:int =  langList.length;
			
			for (var i:int = 0; i < len; i++)
			{
				var item:NativeMenuItem = new NativeMenuItem(langList[i].displayName);
				item.addEventListener(Event.SELECT, selectLanguageHandler);
				item.checked = langList[i].code == Language.getInstance().currLangCode;
				item.name = langList[i].code;
				languageMenu.addItem(item);
			}
		}
		
		private function selectLanguageHandler(e:Event):void 
		{
			var item:NativeMenuItem = NativeMenuItem(e.currentTarget);
			var vo:ConfigVo = DataManager.instance.getConfig();
			vo.lang = item.name;
			EventCenter.instance.dispatchEvent(new ConfigEvent(ConfigEvent.UPDATE, false, false, vo));
			LanguageManager.getInstance().changeLanguage(item.name);
		}
		
		private function createShowHideGroupsMenu(isShow:Boolean):NativeMenu
		{
			var menu:NativeMenu = new NativeMenu();
			menu.addEventListener(Event.DISPLAYING, displayGroupListHandler);
			
			var allItem:NativeMenuItem = new NativeMenuItem(isShow ? _("Show All") : _("Hide All"));
			langItemList.push(allItem);
			allItem.name = isShow ? "Show All" : "Hide All";
			allItem.addEventListener(Event.SELECT, showHideAllGroupSelectHandler);
			menu.addItem(allItem);
			menu.addItem(getSeparatorItem());
			
			function displayGroupListHandler(e:Event):void
			{
				for (var i:int = menu.numItems -1; i >= 2; i--)
				{
					menu.removeItemAt(i).removeEventListener(Event.SELECT, showHideGroupSelectHandler);
				}
				var list:Vector.<GroupVo> = DataManager.instance.getGroupList();
				for (i = 0; i < list.length; i++)
				{
					var vo:GroupVo = list[i];
					var item:NativeMenuItem = new NativeMenuItem(vo.name);
					item.name = vo.id + "";
					item.addEventListener(Event.SELECT, showHideGroupSelectHandler);
					menu.addItem(item);
				}
			}
			
			function showHideAllGroupSelectHandler(e:Event):void 
			{
				if (isShow) notepaperWindowManager.showAll();
				else notepaperWindowManager.hideAll();
			}
			function showHideGroupSelectHandler(e:Event):void 
			{
				var _item:NativeMenuItem = e.currentTarget as NativeMenuItem;
				if (isShow) notepaperWindowManager.showAll(parseInt(_item.name));
				else notepaperWindowManager.hideAll(parseInt(_item.name));
			}
			
			return menu;
		}
		
		private function getSeparatorItem():NativeMenuItem 
		{
			return new NativeMenuItem("", true);
		}
		
		
		private function langChangeHandler(e:LanguageEvent):void 
		{
			for each(var item:NativeMenuItem in langItemList)
			{
				item.label = _(item.name);
			}
		}
		
	}
}