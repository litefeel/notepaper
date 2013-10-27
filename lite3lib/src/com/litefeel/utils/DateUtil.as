package com.litefeel.utils 
{
	/**
	 * ...
	 * @author lite3
	 */
	public class DateUtil 
	{
		
		public static function toString(d:Date):String 
		{
			if (!d) return "";
			return d.fullYear + "-" + IntUtil.toString(d.month + 1, 2) + "-" + IntUtil.toString(d.date, 2) + " " +
				IntUtil.toString(d.hours, 2) + ":" + IntUtil.toString(d.minutes, 2) + ":" + IntUtil.toString(d.seconds, 2);
		}
		
	}

}