package com.litefeel.controls.delegateControls 
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	/**
	 * 委托控件的基类
	 * @author lite3
	 */
	public class DelegateControls extends EventDispatcher
	{
		
		protected var w:Number;
		protected var h:Number;
		
		private var _data:Object;
		private var _skin:DisplayObject = null;
		
		public function DelegateControls() 
		{
			super();
		}
		
		/**
		 * 获取skin
		 * @return
		 */
		public function getSkin():DisplayObject { return _skin; }
		/**
		 * 设置skin 不能为null
		 * @param	skin
		 */
		public function setSkin(skin:DisplayObject):void
		{
			if (null == skin) throw new Error("参数不能为null!");
			
			// 不是原来的skin,并且已经有了skin,则销毁原来的skin
			if(skin != _skin && _skin)
				destroySkin();
				
			// 设置新skin
			_skin = skin;
		}
		
		/**
		 * 销毁这个skin
		 * 需要被重写的,并且在最后调用这个方法
		 */
		public function destroySkin():void
		{
			if(_skin != null)
				_skin = null;
		}
		
		public function destroy():void
		{
			destroySkin();
		}
		
		public function setSize(w:Number, h:Number):void
		{
			
		}
		
		public function get data():Object { return _data; }
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
	}
}