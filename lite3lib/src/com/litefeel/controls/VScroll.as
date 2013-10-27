package com.litefeel.controls 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class VScroll extends Sprite
	{
		// 属性
		private var _minScrollPosition:Number = 0;
		private var _maxScrollPosition:Number = 100;
		private var _scrollPosition:Number = 0;
		
		private var isDown:Boolean = false;
		
		private var t:Number = -10;
		
		private var _height:Number = 400;
		private var _width:Number = 100;
		private var controlP:Point = new Point(_width*2, _height / 2);
		// ui
		private var thumb:Sprite;
		private var bg:Sprite;
		
		public function VScroll() 
		{
			buildUI();
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			if (e.target == thumb)
			{
				isDown = true;
			}else
			{
				var pos:Number = this.mouseY;
				if (pos < 0) pos = 0;
				if (pos > _height) pos = _height;
				t = pos / _height;
				// 二次贝塞尔公式, p0:开始点, p1:控制点, p3:结束点
				// B(t) = (1-t)^2 * p0 + 2t(1-t)*p1 + t^2 * p2, t[0,1]
				thumb.x = 2 * t * (1 - t) * controlP.x;
				thumb.y = 2 * t * (1 - t) * controlP.y + t * t * _height;
				e.updateAfterEvent();
			}
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			isDown = false;
		}
		
		private function mouseMoveHandler(e:MouseEvent):void 
		{
			if (isDown)
			{
				var pos:Number = this.mouseY;
				if (pos < 0) pos = 0;
				if (pos > _height) pos = _height;
				t = pos / _height;
				// 二次贝塞尔公式, p0:开始点, p1:控制点, p3:结束点
				// B(t) = (1-t)^2 * p0 + 2t(1-t)*p1 + t^2 * p2, t[0,1]
				thumb.x = 2 * t * (1 - t) * controlP.x;
				thumb.y = 2 * t * (1 - t) * controlP.y + t * t * _height;
				e.updateAfterEvent();
			}
		}
		
		public function get scrollPosition():Number { return _scrollPosition; }
		
		public function set scrollPosition(value:Number):void 
		{
			_scrollPosition = value;
		}
		
		public function get maxScrollPosition():Number { return _maxScrollPosition; }
		
		public function set maxScrollPosition(value:Number):void 
		{
			_maxScrollPosition = value;
		}
		
		public function get minScrollPosition():Number { return _minScrollPosition; }
		
		public function set minScrollPosition(value:Number):void 
		{
			_minScrollPosition = value;
		}
		
		
		
		private function buildUI():void
		{
			// bg
			bg = new Sprite();
			bg.graphics.lineStyle(1);
			bg.graphics.curveTo(controlP.x, controlP.y, 0, _height);
			bg.graphics.lineStyle();
			bg.graphics.beginFill(0, 0);
			bg.graphics.drawRect(0, 0, _width, _height);
			bg.graphics.endFill();
			addChild(bg);
			// thumb
			thumb = new Sprite()
			thumb.graphics.beginFill(0xFF0000);
			thumb.graphics.drawCircle(0, 0, 5);
			thumb.graphics.endFill();
			thumb.buttonMode = true;
			thumb.useHandCursor = true;
			addChild(thumb);
		}
		
	}
	
}