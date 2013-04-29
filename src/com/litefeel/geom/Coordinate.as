package com.litefeel.geom
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author fdsaf
	 */
	final public class Coordinate 
	{
		// tile的宽高
		static private const TILE_WIDTH:int = 52;
		static private const TILE_HEIGHT:int = 26;
		
//		开始坐标
//		bx = -map_width *.5;
//		by = map_width *.25;
		
		// 开始坐标,像素的
		static public var BEGIN_X:int = 1200;
		static public var BEGIN_Y:int = 10;
		
		/**
		 * 从像素坐标转到tile坐标
		 * @param	px	<b>	int		</b>
		 * @param	py	<b>	int		</b>
		 * @param	isObject<b>	Boolean	</b>	是否要返回Object类型
		 * @return	a point for x== t_col, y == t_row
		 */
		static public function pixelToTile(px:int, py:int, isObject:Boolean = false):*
		{
			var col:int = (BEGIN_X / TILE_WIDTH + py / TILE_HEIGHT - px / TILE_WIDTH - BEGIN_Y / TILE_HEIGHT + .5) >> 0;
			var row:int = (py / TILE_HEIGHT + px / TILE_WIDTH - BEGIN_X / TILE_WIDTH - BEGIN_Y / TILE_HEIGHT + .5) >> 0;
			if(isObject) return { x:col, y:row };
			return new Point(col, row);
		}
		
		/**
		 * 从tile坐标转到 像素坐标
		 * @param	col		<b>	int		</b>	tile行值
		 * @param	row		<b>	int		</b>	tile列值
		 * @param	isObject<b>	Boolean	</b>	是否要返回Object类型
		 * @return	a point for x==tile.x,  y == tile.y		tile的中心位置
		 */
		static public function tileToPixel(col:int, row:int, isObject:Boolean = false):*
		{
			var px:int = BEGIN_X - col * (TILE_WIDTH >> 1) + row * (TILE_WIDTH >> 1);
			var py:int = BEGIN_Y + col * (TILE_HEIGHT >> 1) + row * (TILE_HEIGHT >> 1);
			if (isObject) return { x:px, y:py };
			return new Point(px, py);
		}
		
		/**
		 * 将一组 tile坐标转到像素坐标 Point -> Object		就地修改
		 * @param	arr	<b>	Array	</b>	of 	Point
		 * @param	isObject<b>	Boolean	</b>	是否要返回Object类型
		 * @return	一组像{x, y}的对象
		 */
		static public function tileToPixel_Arr(arr:Array, isObject:Boolean = false):void
		{
			var len:int = arr.length;
			for (var i:int = 0; i < len; i++)
			{
				arr[i] = tileToPixel(arr[i].x, arr[i].y, isObject);
			} 
		}
		
	}
	
}