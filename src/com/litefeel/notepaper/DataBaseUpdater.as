package com.litefeel.notepaper 
{
	import air.update.utils.VersionUtils;
	import com.litefeel.notepaper.managers.TableName;
	import com.litefeel.notepaper.utils.VersionUtil;
	import com.litefeel.notepaper.version.Version;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author lite3
	 */
	public class DataBaseUpdater 
	{
		private var conn:SQLConnection;
		private var stmt:SQLStatement;
		
		public function update(conn:SQLConnection):void
		{
			this.conn = conn;
			try {
				conn.loadSchema(SQLTableSchema);
			}catch (err:SQLError)
			{
				// 当新创建的一个数据库文件。会有异常。
				//[Fault] exception, information=SQLError: 'Error #3115: SQL Error.', details:'No schema objects with type 'table' in database 'main' were found.', operation:'schema', detailID:'1009'
				return;
			}
			
			var result:SQLSchemaResult = conn.getSchemaResult();
			var hasConfig:Boolean;
			for (var i:int = result.tables.length - 1; i >= 0; i--)
			{
				var table:SQLTableSchema = result.tables[i];
				if (TableName.CONFIG == table.name)
				{
					hasConfig = true;
					break;
				}
			}
			
			if (!hasConfig) return;
			
			var dbVer:String = getDBVer(conn);
			if (!dbVer || VersionUtil.isNew(dbVer, Version.DB_VERSION))
			{
				executeSQL("drop table config");
			}
		}
		
		private function getDBVer(conn:SQLConnection):String 
		{
			var result:SQLResult = executeSQL("select dbVer from config;");
			if (result && result.data && result.data.length > 0)
			{
				return result.data[0].dbVer;
			}
			return null;
		}
		
		public function executeSQL(sql:String):SQLResult
		{
			if (!stmt)
			{
				stmt = new SQLStatement();
				stmt.sqlConnection = conn;
			}
			stmt.text = sql;
			try {
				stmt.execute();
			}catch (err:SQLError)
			{
				trace(err);
				return null;
			}
			return stmt.getResult();
		}
		
	}

}