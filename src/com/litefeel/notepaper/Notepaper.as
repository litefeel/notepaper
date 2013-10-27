package com.litefeel.notepaper
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	import com.litefeel.notepaper.events.NotepaperEvent;
	import com.litefeel.notepaper.language.Language;
	import com.litefeel.notepaper.language.LanguageManager;
	import com.litefeel.notepaper.managers.DataManager;
	import com.litefeel.notepaper.managers.FileIOManager;
	import com.litefeel.notepaper.managers.NotepaperWindowManager;
	import com.litefeel.notepaper.view.Cursor;
	import com.litefeel.notepaper.vo.ConfigVo;
	import com.litefeel.notepaper.vo.NotepaperVo;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;
	import flash.utils.setTimeout;
	import org.aswing.AsWingManager;
	
	
	/**
	 * ...
	 * @author lite3
	 */
	public class Notepaper extends Sprite 
	{
		
		
		// Instantiate the updater
		private var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		
		private var dataSaving:Boolean = false;
		private var trayIcon:TrayIcon;
		public var fileIOManager:FileIOManager
		
		public function Notepaper():void 
		{
			NativeApplication.nativeApplication.autoExit = false;
			
			if (!stage) addEventListener(Event.ADDED_TO_STAGE, init);
			else setTimeout(init, 100);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//NativeApplication.nativeApplication.autoExit = false;
			
			// 窗口在最后关闭 能报错
			stage.nativeWindow.close();
			
			Cursor.init();
			
			
			//NativeApplication.nativeApplication.addEventListener(Event.EXITING, saveFile);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, showTrayIcon);
			
			AsWingManager.initAsStandard(this);
			
			// check config.ini file path 
			//checkConfigFilePath();
			
			// readFile
			//fileIOManager = new FileIOManager();
			//initData(fileIOManager.readData());
			initData(null);
			
			CONFIG::release {
				checkForUpdate();
			}
			//NotepaperWindowManager.getInstance().addEventListener(NotepaperEvent.DATA_CHANGE, dataChangeHandler);
			
			// init trayIcon
			setTimeout(showTrayIcon, 2000);
			
			//dataChangeHandler(null);
			
			// 窗口在最后关闭 能报错
			//stage.nativeWindow.close();
		}
		
		private function showTrayIcon(e:InvokeEvent = null):void 
		{
			if (!trayIcon)
			{
				trayIcon = new TrayIcon(NativeApplication.nativeApplication.icon as SystemTrayIcon);
			}
			trayIcon.showIcon();
		}
		
		private function dataChangeHandler(e:NotepaperEvent):void 
		{
			if (!dataSaving)
			{
				dataSaving = true;
				//setTimeout(saveFile, 3000);
			}
		}
		
		private function initData(data:String):void
		{
			//var xml:XML = new XML(data);
			//
			//ConfigOption.initConfig(xml.config[0]);
			
			var config:ConfigVo = DataManager.instance.getConfig();
			if (Language.getInstance().currLangCode != config.lang)
			{
				LanguageManager.getInstance().changeLanguage(config.lang);
			}
			
			/*var xmlList:XMLList = xmlList = xml.groups.group;
			var groupList:Vector.<GroupVo> = new Vector.<GroupVo>();
			var notGeneral:Boolean = true;
			for each(var tmp:XML in xmlList)
			{
				var gvo:GroupVo = new GroupVo(tmp.@id, tmp.@name);
				if (notGeneral && 0 == gvo.id) notGeneral = false;
				groupList.push(gvo);
			}*/
			
			CONFIG::release {
				if (NativeApplication.nativeApplication.startAtLogin != config.startAtLogin)
				{
					try{
						NativeApplication.nativeApplication.startAtLogin = config.startAtLogin;
					}catch (err:IllegalOperationError) { } // 已经配置了同名的但路径不同的应用在开机启动
				}
			}
			
			var noteList:Vector.<NotepaperVo> = DataManager.instance.getNoteList();
			var len:int = noteList.length;
			if (len > 0)
			{
				for (var i:int = noteList.length - 1; i >= 0; i--)
				{
					NotepaperWindowManager.getInstance().createWindow(noteList[i]);
				}
			}else
			{
				NotepaperWindowManager.getInstance().createWindow();
			}
			
			/*xmlList = xmlList = xml.notepapers.notepaper;
			
			if (xmlList.length() > 0)
			{
				for each(tmp in xmlList)
				{
					var vo:NotepaperVo = NotepaperVo.createNotepaperVo(tmp);
					NotepaperWindowManager.getInstance().createWindow(vo);
				}
			}else
			{
				
			}*/
			
			//NotepaperWindowManager.getInstance().hideAll();
			
			// 销毁XML
			CONFIG::release {
				//System.disposeXML(xml);
			}
		}
		
		// 保存文件
		/*private function saveFile(e:Event = null):void
		{
			dataSaving = false;
			var xml:XML = <notepaper>
				<groups></groups>
				<notepapers></notepapers>
			</notepaper>
			
			xml.config = ConfigOption.createConfigXML();
			
			var groupsXML:XML = xml.groups[0];
			var groupList:Vector.<GroupVo> = ConfigOption.groupList;
			for (var i:int = 0; i < groupList.length; i++)
			{
				groupsXML.appendChild(XML('<group id="'+ groupList[i].id +'" name="'+groupList[i].name+'"/>'));
			}
			
			var notepaperXML:XML = xml.notepapers[0];
			var dict:Dictionary = NotepaperWindowManager.getInstance().getDict();
			for each(var window:NotepaperWindow in dict)
			{
				notepaperXML.appendChild(window.getVo().toXML());
			}
			fileIOManager.wrightData(xml.toXMLString());
			
			System.disposeXML(xml);
		}*/
		
		
		private function checkForUpdate():void 
		{
			// Configuration stuff - see update framework docs for more details
			appUpdater.updateURL = "http://www.litefeel.com/air/notepaper/update.xml"; // Server-side XML file describing update
			appUpdater.isCheckForUpdateVisible = false; // We won't ask permission to check for an update
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate); // Once initialized, run onUpdate
			//appUpdater.addEventListener(ErrorEvent.ERROR, onError); // If something goes wrong, run onError
			appUpdater.initialize(); // Initialize the update framework
		}
		
		/*private function onError(event:ErrorEvent):void {
			//Alert.show(event.toString());
		}*/
		
		private function onUpdate(event:UpdateEvent):void {
			appUpdater.checkNow(); // Go check for an update now
		}
		
		private function checkConfigFilePath():void
		{
			var newFile:File = new File(File.documentsDirectory.resolvePath("Notepaper/"+FileIOManager.FileName).nativePath);
			var oldFile:File = new File(File.applicationDirectory.resolvePath(FileIOManager.FileName).nativePath);
			if(!newFile.exists && oldFile.exists)
			{
				var fileStream:FileStream = new FileStream();
				fileStream.open(oldFile, FileMode.READ);
				fileStream.position = 0;
				var data:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
				fileStream.close();
				
				fileStream.open(newFile, FileMode.WRITE);
				fileStream.position = 0;
				fileStream.truncate();
				fileStream.writeUTFBytes(data);
				fileStream.close();
			}
			if(oldFile.exists)
			{
				oldFile.deleteFile();
			}
		}
		
	}
	
}