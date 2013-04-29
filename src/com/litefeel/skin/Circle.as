package com.litefeel.skin 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class Circle extends Sprite
	{
		
		public function Circle(color:uint, alpha:Number, radius:Number) 
		{
			this.graphics.beginFill(color, alpha);
			this.graphics.drawCircle(0, 0, radius);
			this.graphics.endFill();
		}
		
	}
	
}