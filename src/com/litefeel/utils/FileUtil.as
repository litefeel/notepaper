package com.litefeel.utils 
{
	import flash.filesystem.File;
	/**
	 * 文件
	 * @author lite3
	 */
	public class FileUtil 
	{
		/**
		 * 复制目录
		 * @param	sourceDir 源目录
		 * @param	destDir 目标目录
		 * @param	overrideExistFiles (default = false) — 如果为 false，则跳过目标目录中已存在的同名文件。
		 * 												如果为 true，则覆盖目标目录中已存在的同名文件。
		 * @param	deleteFilesNotInSource (default = false) — 如果为 false，则保留目标目录中不在源目录中文件和目录。
		 * 													如果为 true，则删除目标目录中不在源目录中文件和目录。
		 */
		public static function copyDir(sourceDir:File, destDir:File, overrideExistFiles:Boolean = false, deleteFilesNotInSource:Boolean = false):void
		{
			if(!sourceDir.exists || !sourceDir.isDirectory) return;
			if(destDir.exists && sourceDir.url == destDir.url) return;
			
			if(overrideExistFiles && deleteFilesNotInSource)
			{
				sourceDir.copyTo(destDir, true);
				return;
			}
			
			if(overrideExistFiles && destDir.exists && !destDir.isDirectory)
			{
				destDir.deleteFile();
			}
			if(!destDir.exists) destDir.createDirectory();
			
			const destMap:Object = { };
			if(deleteFilesNotInSource)
			{
				for each(var file:File in destDir.getDirectoryListing())
				{
					destMap[file.name] = file;
				}
			}
			
			for each(file in sourceDir.getDirectoryListing())
			{
				destMap[file.name] &&= null;
				var newFile:File = destDir.resolvePath(file.name);
				// 复制目录
				if(file.isDirectory)
				{
					copyDir(file, newFile, overrideExistFiles, deleteFilesNotInSource);
				}
				// 复制文件
				else if(overrideExistFiles || !newFile.exists)
				{
					file.copyTo(newFile, true);
				}
			}
			
			if(deleteFilesNotInSource)
			{
				for each(file in destMap)
				{
					if(!file) continue;
					if(file.isDirectory) file.deleteDirectory(true);
					else file.deleteFile();
				}
			}
		}
	}

}