package com.litefeel.notepaper.managers 
{
	import com.litefeel.notepaper.DataBaseUpdater;
	import com.litefeel.notepaper.version.Version;
	import com.litefeel.notepaper.view.AlertWindow;
	import com.litefeel.notepaper.vo.ConfigVo;
	import com.litefeel.notepaper.vo.GroupVo;
	import com.litefeel.notepaper.vo.NotepaperVo;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author lite3
	 */
	public class SQLManager 
	{
		private var conn:SQLConnection;
		
		private var stmt:SQLStatement;
		
		private var addGroupStmt:SQLStatement;
		private var updateGroupStmt:SQLStatement;
		private var selectGroupStmt:SQLStatement;
		private var addNoteStmt:SQLStatement;
		private var updateNoteStmt:SQLStatement;
		private var selectNoteStmt:SQLStatement;
		private var updateConfigStmt:SQLStatement;
		
		public function SQLManager() 
		{
			
		}
		
		public function updateConfig(vo:ConfigVo):void
		{
			if (!updateConfigStmt)
			{
				updateConfigStmt = new SQLStatement();
				updateConfigStmt.sqlConnection = conn;
				updateConfigStmt.text = "UPDATE  'config' SET " +
					"'lang'=?, " +
					"'startAtLogin'=?;";
			}
			updateConfigStmt.parameters[0] = vo.lang;
			updateConfigStmt.parameters[1] = vo.startAtLogin;
			updateConfigStmt.execute();
			updateConfigStmt.getResult();
		}
		
		public function getConfig():ConfigVo
		{
			var o:Object = executeSQL("SELECT * FROM 'config'").data[0];
			return new ConfigVo(o.lang, o.startAtLogin, o.dbVer, o.codeVer);
		}
		
		public function addGroup(name:String):void
		{
			if (!addGroupStmt)
			{
				addGroupStmt = new SQLStatement();
				addGroupStmt.sqlConnection = conn;
				addGroupStmt.text = "INSERT INTO 'group' ('name', 'sync', 'ver') " +
							"VALUES (?, 0, 1)";
			}
			addGroupStmt.parameters[0] = name;
			addGroupStmt.execute();
			addGroupStmt.getResult();
		}
		
		public function updateGroup(vo:GroupVo):void
		{
			if (!updateGroupStmt)
			{
				updateGroupStmt = new SQLStatement();
				updateGroupStmt.sqlConnection = conn;
				updateGroupStmt.text = "UPDATE 'group' SET 'name'=?, WHERE id=?";
			}
			updateGroupStmt.parameters[0] = vo.name;
			updateGroupStmt.parameters[1] = vo.id;
			updateGroupStmt.execute();
			updateGroupStmt.getResult();
		}
		
		public function deleteGroup(id:int):void
		{
			executeSQL("DELETE FROM 'group' WHERE id=" + id);
			executeSQL("DELETE FROM 'note'  WHERE gid=" + id);
		}
		
		public function getGroupList():Vector.<GroupVo>
		{
			if (!selectGroupStmt)
			{
				selectGroupStmt = new SQLStatement();
				selectGroupStmt.sqlConnection = conn;
				selectGroupStmt.text = "SELECT * FROM 'group'";
			}
			selectGroupStmt.execute();
			var arr:Array = selectGroupStmt.getResult().data;
			var len:int = arr ? arr.length : 0;
			var list:Vector.<GroupVo> = new Vector.<GroupVo>(len);
			for (var i:int = 0; i < len; i++)
			{
				list[i] = new GroupVo(arr[i].id, arr[i].name);
			}
			return list;
		}
		
		public function addNote(vo:NotepaperVo):void
		{
			if (!addNoteStmt)
			{
				addNoteStmt = new SQLStatement();
				addNoteStmt.sqlConnection = conn;
				addNoteStmt.text =
					"INSERT INTO 'note' ('gid', 'title', 'content', 'unroll', 'onTop', 'visible', 'x', 'y', 'w', 'h','date', 'dateGmt', 'dateModified', 'dateModifiedGmt', 'sync', 'ver') " +
					"VALUES (?,?,?,?,?, 1,?,?,?,?,DATETIME('now','localtime'), DATETIME('now'),DATETIME('now','localtime'), DATETIME('now'), 0, 1)";
			}
			addNoteStmt.parameters[0] = vo.groupId;
			addNoteStmt.parameters[1] = vo.subject;
			addNoteStmt.parameters[2] = vo.content;
			addNoteStmt.parameters[3] = int(vo.isShowSubject);
			addNoteStmt.parameters[4] = int(vo.onTop);
			addNoteStmt.parameters[5] = int(vo.x);
			addNoteStmt.parameters[6] = int(vo.y);
			addNoteStmt.parameters[7] = int(vo.width);
			addNoteStmt.parameters[8] = int(vo.height);
			addNoteStmt.execute();
			vo.id = addNoteStmt.getResult().lastInsertRowID;
			//trace(vo.id);
		}
		
		public function updateNote(vo:NotepaperVo):void
		{
			if (!updateNoteStmt)
			{
				updateNoteStmt = new SQLStatement();
				updateNoteStmt.sqlConnection = conn;
				updateNoteStmt.text =
					"UPDATE  'note' SET " +
					"'gid'=?," +
					"'title'=?," +
					"'content'=?," +
					"'unroll'=?," +
					"'onTop'=?, " +
					"'visible'=1, " +
					"'x'=?, " +
					"'y'=?, " +
					"'w'=?, " +
					"'h'=?, " +
					"'dateModified'=DATETIME('now','localtime'), " +
					"'dateModifiedGmt'=DATETIME('now'), " +
					"'sync'=0, 'ver'=1 " +
					"WHERE id=?";
			}
			updateNoteStmt.parameters[0] = vo.groupId;
			updateNoteStmt.parameters[1] = vo.subject;
			updateNoteStmt.parameters[2] = vo.content;
			updateNoteStmt.parameters[3] = int(vo.isShowSubject);
			updateNoteStmt.parameters[4] = int(vo.onTop);
			updateNoteStmt.parameters[5] = int(vo.x);
			updateNoteStmt.parameters[6] = int(vo.y);
			updateNoteStmt.parameters[7] = int(vo.width);
			updateNoteStmt.parameters[8] = int(vo.height);
			updateNoteStmt.parameters[9] = vo.id;
			updateNoteStmt.execute();
			updateNoteStmt.getResult();
		}
		
		public function deleteNote(id:int):void
		{
			executeSQL("DELETE FROM 'note' WHERE id=" + id);
		}
		
		public function getNoteList(gid:int):Vector.<NotepaperVo>
		{
			if (!selectNoteStmt)
			{
				selectNoteStmt = new SQLStatement();
				selectNoteStmt.sqlConnection = conn;
				selectNoteStmt.text = "SELECT * FROM 'note' WHERE 1=? OR gid=?";
			}
			selectNoteStmt.parameters[0] = gid != -1 ? 2 : 1;
			selectNoteStmt.parameters[1] = gid;
			selectNoteStmt.execute();
			var arr:Array = selectNoteStmt.getResult().data;
			var len:int = arr ? arr.length : 0;
			var list:Vector.<NotepaperVo> = new Vector.<NotepaperVo>(len);
			for (var i:int = 0; i < len; i++)
			{
				var o:Object = arr[i];
				list[i] = new NotepaperVo(null, o.title, o.content, 1 == o.unroll, o.x, o.y, o.w, o.h);
				list[i].groupId = parseInt(o.gid);
				list[i].id = o.id;
				list[i].date = o.date;
				//trace(tos(o.date),tos(o.dateGmt),tos(o.dateModified),tos(o.dateModifiedGmt));
			}
			return list;
		}
		
		public function init():void
		{
			var dir:File = File.documentsDirectory.resolvePath("Notepaper");
			if (!dir.exists) dir.createDirectory();
			var file:File = dir.resolvePath("config.db");
			
			file = new File(file.nativePath);
			trace(file.nativePath);
			conn = new SQLConnection();
			try {
				conn.open(file);
			}
			catch (error:SQLError)
			{
				trace("this is init! Error opening database");
				var msg:String = "error.message:" + error.message + "\n" +
					"error.details:" + error.details;
				//AlertWindow.show(msg, "Error 1 opening database", ["OK"]);
				return;
			}
			
			trace("create db ok");
			new DataBaseUpdater().update(conn);
			trace("update db ok");
			createTables();
			trace("xxxx");
			initTables();
			trace("init oK");
		}
		
		private function initTables():Boolean 
		{
			var data:Array = executeSQL("SELECT 'dbVer' from 'config'").data;
			if (data && data.length > 0) return false;
			
			// 设置config
			var sql1:String = 
					"INSERT INTO 'config' ('lang', 'startAtLogin', 'dbVer', 'codeVer', 'sync', 'ver') " +
					"VALUES ('cn_ZH', 0, " + Version.DB_VERSION + ", '1.0', 0, 1)";
			// 创建一个组
			var sql2:String = 
					"INSERT INTO 'group' ('id', 'name', 'sync', 'ver') " +
					"VALUES (1, 'General', 0, 1)";
			try {
				executeSQL(sql1);
				executeSQL(sql2);
			}catch (err:SQLError)
			{
				var msg:String = "error.message:" + err.message + "\n" +
					"error.details:" + err.details;
					trace("Error opening database\n", msg);
				//AlertWindow.show(msg, "Error opening database", ["OK"]);
				return false;
			}
			return true;
		}
		
		private function createTables():Boolean
		{
			// 创建表
			var sql1:String = 
                    "CREATE TABLE IF NOT EXISTS 'group' (" +  
                    "    'id' INTEGER PRIMARY KEY AUTOINCREMENT, " +  
                    "    'gid' INTEGER NOT NULL DEFAULT 0, " +  
                    "    'name' VARCHAR(40), " +  
                    "    'sync' TINYINT(1) NOT NULL DEFAULT 0, " +  
                    "    'ver' INTEGER " +  
                    ")";
			var sql2:String =  
					"CREATE TABLE IF NOT EXISTS 'note' (" +  
					"    'id' INTEGER PRIMARY KEY AUTOINCREMENT, " +  
					"    'nid' INTEGER NOT NULL DEFAULT 0, " +  
					"    'gid' INTEGER, " +  
					"    'title' VARCHAR(300), " +  
					"    'content' TEXT, " +  
					"    'unroll' TINYINT(1) NOT NULL DEFAULT 0, " +
					"    'onTop' TINYINT(1) NOT NULL DEFAULT 0, " +
					"    'visible' TINYINT(1) NOT NULL DEFAULT 0, " +
					"    'x' INTEGER, " +  
					"    'y' INTEGER, " +  
					"    'w' INTEGER, " +  
					"    'h' INTEGER, " +  
					"    'date' DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', " +  
					"    'dateGmt' DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', " +  
					"    'dateModified' DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', " +  
					"    'dateModifiedGmt' DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', " +  
					"    'sync' TINYINT(1) NOT NULL DEFAULT 0, " +  
                    "    'ver' INTEGER " +   
					")";
			var sql3:String =  
					"CREATE TABLE IF NOT EXISTS 'config' (" +  
                    "    'id' INTEGER PRIMARY KEY AUTOINCREMENT, " +  
                    "    'lang' VARCHAR(6), " +  
                    "    'startAtLogin' TINYINT(1) NOT NULL DEFAULT 0, " +  
                    "    'dbVer' VARCHAR(11), " +  
                    "    'codeVer' VARCHAR(11), " +  
                    "    'sync' TINYINT(1) NOT NULL DEFAULT 0, " +  
                    "    'ver' INTEGER " +  
                    ")";
			
			try {
				executeSQL(sql1);
				executeSQL(sql2);
				executeSQL(sql3);
			}catch (err:SQLError)
			{
				var msg:String = "error.message:" + err.message + "\n" +
					"error.details:" + err.details;
				trace("createTables\n", msg);
				//AlertWindow.show(msg, "Error opening database", ["OK"]);
				return false;
			}
			return true;
		}
		private function executeSQL(sql:String):SQLResult
		{
			if (!stmt)
			{
				stmt = new SQLStatement(); 
				stmt.sqlConnection = conn;
			}
			
			stmt.text = sql;
			stmt.execute();
			return stmt.getResult();
		}
	}

}