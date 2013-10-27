package com.litefeel.notepaper.view 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class Resizer extends Sprite
	{
		
		public function Resizer() 
		{
			mouseChildren = false;
			
			drawBg();
		}
		
		private function drawBg():void 
		{
			graphics.beginFill(0, 0);
			graphics.lineTo(-15, 0);
			graphics.lineTo(0, -15);
			graphics.lineTo(0, 0);
			graphics.endFill();
			graphics.lineStyle(1);
			graphics.moveTo(0, -15);
			graphics.lineTo( -15, 0);
			graphics.moveTo(0, -10);
			graphics.lineTo( -10, 0);
			graphics.moveTo(0, -5);
			graphics.lineTo( -5, 0);
		}
		
	}

}