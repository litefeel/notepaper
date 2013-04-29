package com.litefeel.net 
{
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * Loader 的加强版,安全性跟Loader一样
	 * 
	 * 功能		:	改善Loader 没有内容时设置width,height属性后出错
	 * 				LoaderPlus可以在任何时间设置 width,height 属性
	 * 使用方法	:	跟 Loader 类一样
	 * 
	 * www.litefeel.com
	 * lite3@qq.com
	 * @author lite3
	 */
	public class LoaderPlus extends Loader
	{
		
		private var _w:Number = Number.NaN;
		private var _h:Number = Number.NaN;
		private var notHasListener:Boolean = true;
		
		public function LoaderPlus() 
		{
			super();
		}
		
		// 高度
		override public function get height():Number { return isNaN(_h) ? super.height : _h; }
		override public function set height(value:Number):void 
		{
			_h = value;
			if (content) resize();
		}
		
		// 宽度
		override public function get width():Number { return isNaN(_w) ? super.width : _w;; }
		override public function set width(value:Number):void 
		{
			_w = value;
			if (content) resize();
		}
		
		
		// 加载文件
		override public function load(request:URLRequest, context:LoaderContext = null):void 
		{
			super.load(request, context);
			
			addListener();
		}
		
		// 加载字节码
		override public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void 
		{
			super.loadBytes(bytes, context);
			
			addListener();
		}
		
		
		// 更新尺寸
		private function resize():void
		{
			if (!isNaN(_w))
			{
				super.width = _w;
				_w = Number.NaN;
			}
			
			if (!isNaN(_h))
			{
				super.height = _h;
				_h = Number.NaN;
			}
		}
		
		// 加载完成
		private function initHandler(e:Event):void 
		{
			removeListener();
			resize();
		}
		
		// 加载出错
		private function errorHandler(e:Event):void 
		{
			trace(e);
			removeListener();
			_w = _h = Number.NaN;
		}
		
		// 添加侦听
		private function addListener():void
		{
			contentLoaderInfo.addEventListener(Event.INIT,						  initHandler);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,			  errorHandler);
			contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		}
		
		// 移除侦听
		private function removeListener():void
		{
			contentLoaderInfo.removeEventListener(Event.INIT,						 initHandler);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,			 errorHandler);
			contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		}
	}
}