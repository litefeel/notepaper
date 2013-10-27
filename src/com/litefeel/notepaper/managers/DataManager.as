package com.litefeel.notepaper.managers 
{
	import com.litefeel.notepaper.events.ConfigEvent;
	import com.litefeel.notepaper.events.DataEvent;
	import com.litefeel.notepaper.events.GroupEvent;
	import com.litefeel.notepaper.events.NoteEvent;
	import com.litefeel.notepaper.vo.ConfigVo;
	import com.litefeel.notepaper.vo.GroupVo;
	import com.litefeel.notepaper.vo.NotepaperVo;
	import flash.desktop.NativeApplication;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author lite3
	 */
	public class DataManager
	{
		
		private static var _instance:DataManager;
		public static function get instance():DataManager
		{
			if (!_instance) _instance = new DataManager();
			
			return _instance;
		}
		
		private var delaySaveTime:int = 3000;
		
		private var isNewData:Boolean = false;
		
		private var data:String = "";
		private var prevTime:int = 0;
		
		private var configVo:ConfigVo;
		private var groupList:Vector.<GroupVo>;
		private var needLoadGroup:Boolean = true;
		
		private var sqlManager:SQLManager;
		
		public function DataManager() 
		{
			needLoadGroup = true;
			EventCenter.instance.addEventListener(GroupEvent.CREATE, groupHandler);
			EventCenter.instance.addEventListener(GroupEvent.MODIFY, groupHandler);
			EventCenter.instance.addEventListener(GroupEvent.DELETE, groupHandler);
			EventCenter.instance.addEventListener(NoteEvent.CREATE,  noteHandler);
			EventCenter.instance.addEventListener(NoteEvent.MODIFY,  noteHandler);
			EventCenter.instance.addEventListener(NoteEvent.DELETE,  noteHandler);
			EventCenter.instance.addEventListener(ConfigEvent.UPDATE,  configHandler);
			
			sqlManager = new SQLManager();
			sqlManager.init();
		}
		
		public function getVersionLabel():String
		{
			var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appDescriptor.namespace();
			//var appCopyright:String = appDescriptor.ns::copyright;
			return appDescriptor.ns::versionLabel;
		}
		
		public function getVersionNum():String
		{
			var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appDescriptor.namespace();
			//var appCopyright:String = appDescriptor.ns::copyright;
			return appDescriptor.ns::versionNumber;
		}
		
		private function configHandler(e:ConfigEvent):void 
		{
			sqlManager.updateConfig(e.configVo);
			configVo = null;
		}
		
		public function getConfig():ConfigVo
		{
			if (!configVo) configVo = sqlManager.getConfig();
			return configVo;
		}
		
		private function groupHandler(e:GroupEvent):void 
		{
			switch(e.type)
			{
				case GroupEvent.CREATE :
					sqlManager.addGroup(e.groupVo.name);
					needLoadGroup = true;
					delayCall(dataUpdate);
					break;
					
				case GroupEvent.MODIFY :
					sqlManager.updateGroup(e.groupVo);
					needLoadGroup = true;
					delayCall(dataUpdate);
					break;
					
				case GroupEvent.DELETE :
					sqlManager.deleteGroup(e.groupVo.id);
					needLoadGroup = true;
					delayCall(dataUpdate);
					break;
			}
		}
		
		private function noteHandler(e:NoteEvent):void 
		{
			switch(e.type)
			{
				case NoteEvent.CREATE :
					sqlManager.addNote(e.noteVo);
					delayCall(dataUpdate);
					break;
					
				case NoteEvent.MODIFY :
					sqlManager.updateNote(e.noteVo);
					delayCall(dataUpdate);
					break;
					
				case NoteEvent.DELETE :
					sqlManager.deleteNote(e.noteVo.id);
					delayCall(dataUpdate);
					break;
			}
		}
		
		private function getGroupIndex(id:int):int 
		{
			for (var i:int = groupList.length - 1; i >= 0; i--)
			{
				if (groupList[i].id == id) return i;
			}
			return -1;
		}
		
		private function dataUpdate():void 
		{
			EventCenter.instance.dispatchEvent(new DataEvent(DataEvent.UPDATE));
		}
		
		private function delayCall(fun:Function):void 
		{
			setTimeout(fun, 0);
		}
		
		public function getNoteList(gid:int = -1):Vector.<NotepaperVo>
		{
			return sqlManager.getNoteList(gid);
		}
		
		public function getGroupList():Vector.<GroupVo>
		{
			if (needLoadGroup) groupList = sqlManager.getGroupList();
			return groupList;
		}
		
		public function sava(data:String):void
		{
			isNewData = true;
			this.data = data;
			
			if (0 == prevTime)
			{
				prevTime = getTimer();
			}else
			{
				if (getTimer() - prevTime >= delaySaveTime)
				{
					prevTime = getTimer();
					savaData();
				}
			}
		}
		
		private function savaData():void
		{
			
		}
	}

}