package com.litefeel.net 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class SimpleLoader extends Loader 
	{
		private var count:int = 0;
		private var loading:Boolean = false;
		
		private var _url:String;
		private var _callback:Function;
		
		public function SimpleLoader() 
		{
			super();
			
		}
		
		/**
		 * 
		 * @param	url
		 * @param	callback function(success:Boolean, loader:SimpleLoader):void
		 */
		public function loadURL(url:String, callback:Function):void
		{
			trace(url);
			if (loading && url == _url)
			{
				_callback = callback;
				return;
			}
			if (loading)
			{
				removeEvent();
				try {
					close();
				}catch (err:Error) { }
			}
			
			loading = true;
			count = 0;
			_url = url;
			_callback = callback;
			addEvent();
			super.load(new URLRequest(url));
		}
		
		private function addEvent():void
		{
			contentLoaderInfo.addEventListener(Event.COMPLETE, onComplte, false, int.MAX_VALUE);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, int.MAX_VALUE);
		}
		
		private function removeEvent():void
		{
			contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplte);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function onComplte(e:Event):void 
		{
			loading = false;
			if (_callback != null) _callback(true, this);
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			if (++count < 3)
			{
				var url:String = _url;
				loading = false;
				loadURL(url, _callback);
				return;
			}
			trace("can load load", url);
			if (_callback != null) _callback(false, this);
		}
		
	}

}