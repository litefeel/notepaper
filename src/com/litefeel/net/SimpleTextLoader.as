package com.litefeel.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 按文本格式加载一个文件
	 * 只能用一次
	 * 
	 * 属性 :
	 * 	@param 	success	<b>	Boolean	</b> 是否加载成功
	 *  @param	data	<b>	String	</b> 加载的数据
	 * 
	 * 
	 * @example 
	 * 	<code>
	 * 	import Antplay.engine.core.loader.SimpleTextLoader;
	 * 	
	 * 	var simpleTextLoader:SimpleTextLoader(filePath, completeHandler, this);
	 * 	function completeHandler(loader:SimpleTextLoader):void
	 * 	{
	 * 		if(loader.success)
	 * 		{
	 * 			trace("data = ", loader.data);
	 * 		}else trace("没有加载成功!");
	 * 	}
	 * 	</code>
	 * 
	 * 
	 * 欢迎访问我的博客
	 * www.litefeel.com
	 * lite3@qq.com
	 * @author lite3
	 * 
	 */
	public class SimpleTextLoader
	{
		
		private var _success:Boolean = false;
		private var _data:String;
		
		private var backFunction:Function;
		private var thisObj:Object;
		
		/**
		 * 
		 * @param	url			<b>	String	</b> 目标路径
		 * @param	backFunction<b>	Function</b> 回调函数	function(simpleTextLoader:SimpleTextLoader);
		 * @param	thisObj		<b>	Object	</b> 回调函数的this指向的对象 ,default:null
		 */
		public function SimpleTextLoader(url:String, backFunction:Function, thisObj:Object = null)
		{
			this.backFunction = backFunction;
			this.thisObj = thisObj;
			
			var loader:URLLoader = new URLLoader();
			addLoaderListener(loader);
			loader.load(new URLRequest(url));
		}
		
		// 是否成功
		public function get success():Boolean { return _success; }
		// 数据
		public function get data():String { return _data; }
		
		
		/**
		 * 加载出错
		 * 
		 * @param	e
		 */
		private function loaderErrorHandler(e:Event):void 
		{
			trace("this is SimpleLoader::loaderErrorHandler!");
			var loader:URLLoader = e.currentTarget as URLLoader;
			removeLoaderListener(loader);
			
			_success = false;
			
			backFunction.call(thisObj, this);
			backFunction = null;
			thisObj = null;
		}
		
		/**
		 * 加载成功
		 * 
		 * @param	e
		 */
		private function loaderCompleteHandler(e:Event):void 
		{
			trace("this is SimpleLoader::loaderCompleteHandler!");
			var loader:URLLoader = e.currentTarget as URLLoader;
			removeLoaderListener(loader);
			
			_data = String(loader.data);
			_success = true;
			
			trace(this);
			backFunction.call(thisObj, this);
			backFunction = null;
			thisObj = null;
		}
		
		/**
		 * 添加侦听器
		 * 
		 * @param	loader
		 */ 
		private function addLoaderListener(loader:URLLoader):void
		{
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderErrorHandler);
		}
		/**
		 * 移除侦听器
		 * 
		 * 
		 * @param	loader
		 */
		private function removeLoaderListener(loader:URLLoader):void
		{
			loader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderErrorHandler);
		}
	}
	
}