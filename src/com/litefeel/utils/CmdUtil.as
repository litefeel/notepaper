package com.litefeel.utils 
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	/**
	 * 在cmd.exe（windows命令提示符）中执行一行命令
	 * @author lite3
	 */
	public class CmdUtil 
	{
		/**
		 * cmd.exe文件地址
		 * @see #setCmdFile()
		 * @see #autoSetCmdFile()
		 */
		public static var cmdFile:File;
		
		/**
		 * 与cmdFile通信使用的编码，对于windows下的cmd.exe不必设置，默认是系统编码
		 */
		public static var charset:String;
		
		/**
		 * 设置cmd.exe
		 * @param	filePath cmd.exe的文件路径
		 * @return	是否设置文件正确
		 * @see #cmdFile
		 */
		public static function setCmdFile(filePath:String):Boolean
		{
			var file:File = new File(filePath);
			if (!file.exists || file.isDirectory) return false;
			cmdFile = file;
			return true;
		}
		
		/**
		 * 设置window默认的cdm.exe路径 C:/Windows/system32/cmd.exe
		 * @see #cmdFile
		 * @see #setCmdFile()
		 */
		public static function autoSetCmdFile():void
		{
			setCmdFile("C:/Windows/system32/cmd.exe");
		}
		
		/**
		 * 执行一条命令，如果没有设置cmd.exe文件，则自动使用默认cmd.exe
		 * @param	commandStr 一条命令
		 */
		public static function call(commandStr:String):void 
		{
			if (!cmdFile) autoSetCmdFile();
			
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.executable = cmdFile;
			var process:NativeProcess = new NativeProcess();
			process.start(info);
			
			process.standardInput.writeMultiByte(commandStr, charset || File.systemCharset);
			setTimeout(process.exit, 1000);
		}
		
	}

}