package com.litefeel.notepaper.events 
{
	import com.litefeel.notepaper.vo.ConfigVo;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class ConfigEvent extends Event 
	{
		public static const UPDATE:String = "config_update";
		
		public var configVo:ConfigVo;
		
		public function ConfigEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, configVo:ConfigVo = null) 
		{ 
			super(type, bubbles, cancelable);
			this.configVo = configVo;
		} 
		
		public override function clone():Event 
		{ 
			return new ConfigEvent(type, bubbles, cancelable, configVo);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ConfigEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}