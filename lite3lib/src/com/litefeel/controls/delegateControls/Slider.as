package com.litefeel.controls.delegateControls 
{
	import com.litefeel.events.SliderEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	/**
	 * 用户拖动滑块,并松开后触发
	 */
	[Event(name = "change", type = "com.litefeel.events.SliderEvent")]
	
	
	/**
	 * 用户拖动滑块值改变时触发
	 */
	[Event(name="changing", type="com.litefeel.events.SliderEvent")]
	
	/**
	 * 通过使用 Slider 组件，用户可以在滑块轨道的端点之间移动滑块来选择值。
	 * Slider 组件的当前值由滑块端点之间滑块的相对位置确定，端点对应于 Slider 组件的 minimum 和 maximum 值。
	 * @author lite3
	 */
	public class Slider extends DelegateControls
	{
		
		private var _maximum:Number = 10;
		private var _minimum:Number = 0;
		private var _value:Number = 0;
		
		private var lockX:Number;
		// thumb可移动的边界
		private var left:Number;
		private var right:Number;
		
		private var thumb:DisplayObject;
		private var track:DisplayObject;
		
		public function Slider() 
		{
			super();
			
		}
		
		public function get value():Number { return _value; }
		
		public function set value(value:Number):void 
		{
			if (isNaN(value)) return;
			if (value > _maximum) value = _maximum;
			else if (value < _minimum) value = _minimum;
			_value = value;
			// 应用到显示
			if (getSkin())
			{
				var rate:Number = _maximum == _minimum ? 0 : (value-_minimum) / (_maximum - _minimum);
				thumb.x = left + rate * (right - left);
				//trace(thumb.x, "thumb.x", rate, left, right, _maximum, _minimum);
			}
		}
		
		public function get minimum():Number { return _minimum; }
		
		public function set minimum(value:Number):void 
		{
			if (isNaN(value)) return;
			if (value >= _maximum) value = _maximum;
			if (_minimum != value)
			{
				_minimum = value;
				this.value = _value;
			}
		}
		
		public function get maximum():Number { return _maximum; }
		
		public function set maximum(value:Number):void 
		{
			if (isNaN(value)) return;
			if (value <= _minimum) value = _minimum;
			if (_maximum != value)
			{
				_maximum = value;
				this.value = _value;
			}
		}
		
		override public function destroySkin():void 
		{
			var skin:DisplayObject = getSkin();
			if (skin)
			{
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
				if (thumb.stage)
				{
					thumb.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
					thumb.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
				}
				thumb = null;
				track = null;
			}
			super.destroySkin();
		}
		
		override public function setSkin(skin:DisplayObject):void 
		{
			super.setSkin(skin);
			thumb = skin["thumb"];
			track = skin["track"];
			if (thumb is Sprite) Sprite(thumb).buttonMode = true;
			left = track.x;
			right = track.width - thumb.width + left;
			if (right < left) right = left;
			value = _value;
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		private function downHandler(e:MouseEvent):void 
		{
			lockX = getSkin().mouseX - thumb.x;
			thumb.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			thumb.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			trace(e, e.target.name, e.currentTarget.name);
		}
		
		private function moveHandler(e:MouseEvent):void 
		{
			trace(e);
			var tmp:Number = getSkin().mouseX - lockX;
			if (tmp < left) tmp = left;
			else if (tmp > right) tmp = right;
			thumb.x = tmp;
			tmp = (tmp - left) / (right - left) * (_maximum - _minimum) + _minimum;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGING, tmp));
		}
		
		private function upHandler(e:MouseEvent):void 
		{
			var tmp:Number = getSkin().mouseX - lockX;
			if (tmp < left) tmp = left;
			else if (tmp > right) tmp = right;
			thumb.x = tmp;
			_value = (tmp - left) / (right - left) * (_maximum - _minimum) + _minimum;
			thumb.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			thumb.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			dispatchEvent(new SliderEvent(SliderEvent.CHANGE, _value));
		}
	}
}