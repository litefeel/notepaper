package test 
{
	import com.litefeel.utils.Int64;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class Int64Test extends Sprite 
	{
		
		public function Int64Test() 
		{
			var int64:Int64 = new Int64(0xFFFFFFFF, 0xFFFFFFFF);
			trace(int64.toNumber()); // -1
			int64 = new Int64(0, 0);
			trace(int64.toNumber()); // 0
			int64 = new Int64(0, 0xFFFFFFFF);
			trace(int64.toNumber()); // 4294967295
			int64 = new Int64(0x7FFFFFFF, 0xFFFFFFFF);
			trace(int64.toNumber()); // 9223372036854776000
			int64 = new Int64(uint(-1), uint(-3));
			trace(int64.toNumber()); // -3
		}
	}
}