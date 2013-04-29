package com.litefeel.utils 
{
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * www.litefeel.com
	 * lite3@qq.com
	 * @author lite3
	 */
	public class GraphicsUtil 
	{
		
		/**
		 * 画斑马线
		 * 
		 * @param	graphics	<b>	Graphics</b> 
		 * @param	beginPoint	<b>	Point	</b> 
		 * @param	endPoint	<b>	Point	</b> 
		 * @param	width		<b>	Number	</b> 斑马线的宽度
		 * @param	grap		<b>	Number	</b> 
		 */
		static public function drawZebraStripes(graphics:Graphics, beginPoint:Point, endPoint:Point, width:Number, grap:Number):void
		{
			if (!graphics || !beginPoint || !endPoint || width <= 0 || grap <= 0) return;
			
			var Ox:Number = beginPoint.x;
			var Oy:Number = beginPoint.y;
			
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var halfWidth:Number = width * .5;
			
			var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var radian1:Number = (radian / Math.PI * 180 + 90) / 180 * Math.PI;
			var radian2:Number = (radian / Math.PI * 180 - 90) / 180 * Math.PI;
			
			var currX:Number, currY:Number;
			var p1x:Number, p1y:Number;
			var p2x:Number, p2y:Number;
			
			while (currLen <= totalLen)
			{
				currX = Ox + Math.cos(radian) * currLen;
				currY = Oy + Math.sin(radian) * currLen;
				p1x = currX + Math.cos(radian1) * halfWidth;
				p1y = currY + Math.sin(radian1) * halfWidth;
				p2x = currX + Math.cos(radian2) * halfWidth;
				p2y = currY + Math.sin(radian2) * halfWidth;
				
				graphics.moveTo(p1x, p1y);
				graphics.lineTo(p2x, p2y);
				
				currLen += grap;
			}
			
		}
		
		
		/**
		 * 画虚线
		 * 
		 * @param	graphics	<b>	Graphics</b> 
		 * @param	beginPoint	<b>	Point	</b> 
		 * @param	endPoint	<b>	Point	</b> 
		 * @param	width		<b>	Number	</b> 虚线的长度
		 * @param	grap		<b>	Number	</b> 
		 */
		static public function drawDashed(graphics:Graphics, beginPoint:Point, endPoint:Point, width:Number, grap:Number):void
		{
			if (!graphics || !beginPoint || !endPoint || width <= 0 || grap <= 0) return;
			
			var Ox:Number = beginPoint.x;
			var Oy:Number = beginPoint.y;
			
			var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var x:Number, y:Number;
			
			while (currLen <= totalLen)
			{
				x = Ox + Math.cos(radian) * currLen;
				y = Oy +Math.sin(radian) * currLen;
				graphics.moveTo(x, y);
				
				currLen += width;
				if (currLen > totalLen) currLen = totalLen;
				
				x = Ox + Math.cos(radian) * currLen;
				y = Oy +Math.sin(radian) * currLen;
				graphics.lineTo(x, y);
				
				currLen += grap;
			}
			
		}
		
	}
	
}