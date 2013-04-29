package com.litefeel.net 
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	/**
	 * 加载完成
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * 加载进度
	 */
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	
	/**
	 * IOError时触发
	 */
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	
	/**
	 * 渐进式加载类
	 * 
	 * @author lite3
	 */
	public class ProgressivePlusLoader extends Sprite
	{
		private var loader0:Loader;
		private var loader1:Loader;
		private var showingLoader:Loader;				// 当前显示的loader
		
		private var _bytesLoaded:uint = 0;			// 已加载的字节数
		private var _bytesToal:uint = 0; 			// 总字节数
		
		private var loading:Boolean = false;		// 是否有Loader正在加载
		private var dataChange:Boolean = false;		// buffer的数据是否改变	
		private var streamComplete:Boolean = false;	// 文件是否加载完成
		
		private var context:LoaderContext;			// 
		
		private var buffer:ByteArray;				// 数据缓存
		private var stream:URLStream;				// 流
		
		public function ProgressivePlusLoader()
		{
			loader0 = new Loader();
			loader1 = new Loader();
			super.addChild(loader0);
			super.addChild(loader1);
		}
		
		/**
		 * 卸载数据
		 */
		public function unload():void
		{
			close();
			loader0.unload();
			loader1.unload();
		}
		
		/**
		 * 关闭流,并清理所有侦听器
		 */
		public function close():void 
		{
			// 清除流相关
			if (stream)
			{
				if (stream.connected) stream.close();
				streamRemoveEvent(stream);
			}
			// 清除conentLoaderInfo相关的事件
			loaderInfoRemoveEvent(loader0.contentLoaderInfo);
			loaderInfoRemoveEvent(loader1.contentLoaderInfo);
			streamComplete = false;
			dataChange = false;
			buffer = null;
		}
		/**
		 * 加载字节数据
		 * @param	bytes
		 * @param	context
		 */
		public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
		{
			close();
			unload();
			streamComplete = true;
			dataChange = false;
			loading = false;
			this.context = context;
			var loader:Loader = getHideLoader();
			loader.loadBytes(bytes, context);
			loaderInfoRemoveEvent(loader.contentLoaderInfo);
		}
		
		/**
		 * 加载一个url文件,并渐进显示(如果是渐进格式)
		 * @param	request
		 * @param	context
		 */
		public function load(request:URLRequest, context:LoaderContext = null):void 
		{
			if (!stream) stream = new URLStream();
			if (stream.connected) stream.close();
			this.context = context;
			streamComplete = false;
			dataChange = false;
			loading = false;
			unload();
			buffer = new ByteArray();
			loaderInfoAddEvent(loader0.contentLoaderInfo);
			loaderInfoAddEvent(loader1.contentLoaderInfo);
			streamAddEvent(stream);
			stream.load(request);
		}
		/** 已加载的字节数 */
		public function get bytesLoaded():uint { return _bytesLoaded; }
		/** 总字节数 */
		public function get bytesToal():uint { return _bytesToal; }
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			throw new Error("ProgressiveLoader类不实现此方法!");
			return null;
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			throw new Error("ProgressiveLoader类不实现此方法!");
			return null;
		}
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			throw new Error("ProgressiveLoader类不实现此方法!");
			return null;
		}
		override public function removeChildAt(index:int):DisplayObject 
		{
			throw new Error("ProgressiveLoader类不实现此方法!");
			return null;
		}
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void 
		{
			throw new Error("ProgressiveLoader类不实现此方法!");
		}
		override public function swapChildrenAt(index1:int, index2:int):void 
		{
			throw new Error("ProgressiveLoader类不实现此方法!");
		}
		
		
		// 将缓存中的数据显示为图像
		private function showData():void 
		{
			if (loading || !dataChange) return;
			
			if (buffer.length > 0)
			{
				dataChange = false;
				getHideLoader().loadBytes(buffer, context);
				loading = true;
			}
		}
		private function showLoader(loader:Loader):void
		{
			showingLoader = loader;
			loader0.visible = loader == loader0;
			loader1.visible = loader == loader1;
		}
		private function getHideLoader():Loader
		{
			return showingLoader == loader0 ? loader1 : loader0;
		}
		
		// 显示完成
		private function loaderCompleteHandler(e:Event):void 
		{
			showLoader(e.target.loader);
			loading = false;
			if (streamComplete && !dataChange)
			{
				close();
				dispatchEvent(new Event(Event.COMPLETE, false, false));
			}else
			{
				showData();
			}
		}
		
		// 数据加载完成
		private function streamCompleteHandler(e:Event):void 
		{
			streamRemoveEvent(stream);
			
			if (stream.bytesAvailable > 0)
			{
				stream.readBytes(buffer, buffer.length, stream.bytesAvailable);
				dataChange = true;
			}
			_bytesLoaded = _bytesToal;
			streamComplete = true;
			showData();
		}
		// 数据加载中,保存数据加载的值
		private function streamProgressHandler(e:ProgressEvent):void 
		{
			_bytesLoaded = e.bytesLoaded;
			_bytesToal = e.bytesTotal;
			if (stream.bytesAvailable > 0)
			{
				stream.readBytes(buffer, buffer.length, stream.bytesAvailable);
				dataChange = true;
			}
			showData();
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _bytesLoaded, _bytesToal));
		}
		// 流错误
		private function streamErrorHandler(e:IOErrorEvent):void 
		{
			close();
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, e.text));
		}
		
		private function streamAddEvent(stream:URLStream):void
		{
			stream.addEventListener(Event.COMPLETE, streamCompleteHandler);
			stream.addEventListener(ProgressEvent.PROGRESS, streamProgressHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, streamErrorHandler);
		}
		
		private function streamRemoveEvent(stream:URLStream):void
		{
			stream.removeEventListener(Event.COMPLETE, streamCompleteHandler);
			stream.removeEventListener(ProgressEvent.PROGRESS, streamProgressHandler);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, streamErrorHandler);
		}
		
		private function loaderInfoAddEvent(loaderInfo:LoaderInfo):void
		{
			loaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
		}
		
		private function loaderInfoRemoveEvent(loaderInfo:LoaderInfo):void
		{
			loaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
		}
	}
}