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
		// cmd.exe 文件，直接设置或者使用CmdUtil.setCmdFile方法
		public static var cmdFile:File;
		
		/** 与cmdFile通信使用的编码，对于windows下的cmd.exe不必设置，默认是系统编码 */
		public static var charset:String;
		
		/**
		 * 设置cmd.exe
		 * @param	filePath cmd.exe的文件路径
		 * @return	是否设置文件正确
		 */
		public static function setCmdFile(filePath:String):Boolean
		{
			var file:File = new File(filePath);
			if (!file.exists || file.isDirectory) return false;
			cmdFile = file;
			return true;
		}
		
		/**
		 * 执行一条命令
		 * @param	commandStr 一条命令
		 */
		public static function call(commandStr:String):void 
		{
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.executable = cmdFile;
			var process:NativeProcess = new NativeProcess();
			process.start(info);
			
			process.standardInput.writeMultiByte(commandStr, charset || File.systemCharset);
			setTimeout(process.exit, 1000);
		}
		
	}

}