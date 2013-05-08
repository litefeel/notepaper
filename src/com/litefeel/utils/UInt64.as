package  
{
	import com.litefeel.utils.StringUtil;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	/**
	 * UInt64 64位无符号整形
	 * @author lite3
	 */
	public final class UInt64 
	{
		private var high:uint;
		private var low:uint;
		
		public function UInt64(high:uint = 0, low:uint = 0) 
		{
			this.high = high;
			this.low = low;
		}
		public function isEmpty():Boolean
		{
			return 0 == high && 0 == low;
		}
		
		public function isEqual(v:UInt64):Boolean
		{
			return v ? (v.high == high && v.low == low) : false;
		}
		
		public function isEqualHL(high:uint, low:uint):Boolean
		{
			return this.high == high && this.low == low;
		}
		
		public function readFrom(data:IDataInput):void
		{
			high = data.readUnsignedInt();
			low  = data.readUnsignedInt();
		}
		
		public function writeTo(data:IDataOutput):void
		{
			data.writeUnsignedInt(high);
			data.writeUnsignedInt(low);
		}
		
		public function toString():String
		{
			return null;
		}
		
		public function toHex():String
		{
			var s:String = low.toString(16);
			if (s.length < 8) s = StringUtil.memset("0", 8 - str.length) + s;
			return high.toString(16) + s;
		}
		
		/**
		 * 返回相对应的Number值,注意有精度达不到UInt64的精度,只保证Number的15位精度
		 * @return
		 */
		public function toNumber():Number
		{
			var masker:uint = uint(1 << 31);
			var result:Number = high * masker * 2;
			result += low;
			return result;
		}
	}

}