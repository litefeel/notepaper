package com.litefeel.utils 
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	/**
	 * Int64 64位有符号整形
	 * @author lite3
	 */
	public final class Int64 
	{
		// 符号位
		private static const MASK:uint = 1 << 31;
		
		// 补码
		private var high:uint;
		private var low:uint;
		// 源码
		private var trueHigh:uint;
		private var trueLow:uint;
		
		public function Int64(high:uint = 0, low:uint = 0) 
		{
			this.high = high;
			this.low = low;
		}
		
		public function isEmpty():Boolean
		{
			return 0 == high && 0 == low;
		}
		
		public function isEqual(v:Int64):Boolean
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
			getTrueCode();
			var s:String = trueLow.toString(16);
			if (s.length < 8) s = StringUtil.memset("0", 8 - s.length) + s;
			s = (trueHigh & 0x7FFFFFFF).toString(16) + s;
			return (trueHigh & MASK) != 0 ? "-" + s : s;
		}
		
		/**
		 * 返回相对应的Number值,注意有精度达不到Int64的精度,只保证Number的15位精度
		 * @return
		 */
		public function toNumber():Number
		{
			getTrueCode();
			var result:Number = int(trueHigh & 0x7FFFFFFF) * MASK * 2 + trueLow;
			return (trueHigh & MASK) != 0 ? -result : result;
		}
		
		/**
		 * 获取原码
		 */
		[Inline]
		private function getTrueCode():void
		{
			trueHigh = high;
			trueLow = low;
			// 负数
			if ((trueHigh & MASK) != 0)
			{
				var f1:uint = trueLow & MASK;
				trueLow -= 1;
				var f2:uint = trueLow & MASK;
				if (f1 !== f2) trueHigh -= 1;
				trueHigh ^= 0x7FFFFFFF;
				trueLow  ^= 0xFFFFFFFF;
			}
		}
	}
}