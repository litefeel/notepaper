package com.litefeel.notepaper.managers
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	public class FileIOManager
	{
		
		public static const FileName:String = "config.ini";
		public var xml:XML;
		private var file:File;
		private var fileStream:FileStream;
		
		public function FileIOManager()
		{
			file = File.documentsDirectory.resolvePath("Notepaper/"+FileName);
			file = new File(file.nativePath);
//			fileStream = new FileStream();
//			fileStream.open(file, FileMode.UPDATE);
		}
		
		public function readData():String
		{
			fileStream = new FileStream();
			fileStream.open(file, FileMode.UPDATE);
			fileStream.position = 0;
			var str:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();
			return str;
		}
		
		public function wrightData(data:String):void
		{
			// 转换 \n 为 \r\n 消除 记事本里的黑色方块 
			data = data.replace(/\n/g, File.lineEnding);
			
			fileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.position = 0;
			fileStream.truncate();
			fileStream.writeUTFBytes(data);
			fileStream.close();
		}
	}
}