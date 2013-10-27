package com.litefeel.notepaper.managers 
{
	import flash.events.EventDispatcher;
	
	/**
	 * 事件中心,大部分事件都经过这里转发
	 * @author lite3
	 */
	public class EventCenter extends EventDispatcher 
	{
		private static var _instance:EventCenter;
		
		public static function get instance():EventCenter
		{
			if (!_instance) _instance = new EventCenter();
			
			return _instance;
		}
		
	}

}