package com.litefeel.utils 
{
	
	/**
	 * ...
	 * @author lite3
	 */
	public class MathUtil 
	{
		/**
		 * 返回一个数字的符号		-1, 0, 1
		 * @param	num		<b>	Number	</b>
		 * @return
		 */
		static public function sign(num:Number):int
		{
			if (num > 0) return 1;
			if (num < 0) return -1;
			return 0;
		}
		
	}
	
}