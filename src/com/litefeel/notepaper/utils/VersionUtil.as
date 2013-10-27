package com.litefeel.notepaper.utils 
{
	/**
	 * ...
	 * @author lite3
	 */
	public final class VersionUtil 
	{
		/**
		 * 
		 * @param	ver1 1.0[.0] 版本号
		 * @param	ver2 1.0[.0] 版本号
		 * @return -1:ver1>ver2 0:ver1==ver2 1:ver1<ver2
		 */
		public static function compare(ver1:String, ver2:String):int
		{
			var ver1Arr:Array = ver1.split(".");
			var ver2Arr:Array = ver2.split(".");
			for (var i:int = 0; i < 3; i++)
			{
				var v1:int = ver1Arr[i];
				var v2:int = ver2Arr[i];
				if (v1 > v2) return -1;
				else if (v1 < v2) return 1;
			}
			return 0;
		}
		
		public static function isNew(curVer:String, newVer:String):Boolean
		{
			return 1 == compare(curVer, newVer);
		}
	}

}