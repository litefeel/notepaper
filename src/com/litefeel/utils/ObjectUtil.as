package com.litefeel.utils
{
	import flash.net.getClassByAlias;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 欢迎访问我的博客
	 * www.litefeel.com
	 * lite3@qq.com
	 * @author lite3
	 */
	public class ObjectUtil 
	{
		
		/**
		 * 深复制一个对象<br/>
		 * 对象深度复制 : 将实例及子实例的所有成员(属性和方法, 静态的除外)都复制一遍, (引用要重新分配空间!)<br/>
		 * 
		 * 局限性 : 
		 * 			1. 不能对显示对象进行复制
		 * 			2. obj的必须有默认构造函数(参数个数为0,或都有默认值)
		 * 			3. obj 里有obj类型 之外 的非内置数据类型时, 返回类型将不确定
		 * 					
		 * 
		 * @param	obj	<b>	*		</b> 深复制的对象
		 * @return
		 */
		static public function deepClone(obj:*):*
		{
			var aliasClass:Class;
			var classDefinition:Class = Object(obj).constructor as Class;
			var className:String = getQualifiedClassName(obj);
			
			// 获取已注册 obj的类名的类型
			try {
				aliasClass = getClassByAlias(className);
			}catch (err:Error) { }
			
			// 没有注册 AliasName
			if (!aliasClass)
			{
				registerClassAlias(className, classDefinition);
			}
			// 已经注册了 AliasName ,且不是它的全类名,要重新注册个
			else if (aliasClass != classDefinition)
			{
				registerClassAlias(className +":/:" + className, classDefinition);
			}
			//else
			// 注册的AliasName 为 全类名
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(obj);
			byteArray.position = 0;
			return byteArray.readObject();
		}
		
		/**
		 * 浅复制一个对象<br/>
		 * 对象浅度复制 : 将实例及子实例的所有成员(属性和方法, 静态的除外)都复制一遍, (引用不必重新分配空间!)
		 * 
		 * @param	obj
		 * @return
		 */
		static public function clone(obj:*):*
		{
			if (obj == null
				|| obj is Class
				|| obj is Function
				|| isPrimitiveType(obj))
			{
				return obj;
			}
			
			var xml:XML = describeType(obj);
			var o:* = new (Object(obj).constructor as Class);
			// clone var variables
			for each(var key:XML in xml.variable)
			{
				o[key.@name] = obj[key.@name];
			}
			// clone getter setter, if the accessor is "readwrite" then set this accessor.
			for each(key in xml.accessor)
			{
				if("readwrite" == key.@access)
					o[key.@name] = obj[key.@name];
			}
			// clone dynamic variables
			for (var k:String in obj)
			{
				o[k] = obj[k];
			}
			return o;
		}
		
		/**
		 * 测试是否为原始类型 , Booelan, Number, String
		 * @param	o
		 * @return
		 */
		static public function isPrimitiveType(o:*):Boolean
		{
			return o is Boolean || o is Number || o is String;
		}
		
		/**
		 * 判断两个对象是否相等<br/>
		 * 此方法不考虑引用地址是否相同(包括属性的引用地址),只考虑值是否相等<br/>
		 * 此方法不考虑类型信息(自定义类型和Object将区分,自定义类型与自定义类型不区分), 例如int, Number只要值相等,那么就相等.<br/>
		 * 如果registerClassAlias注册类别名,将区别类型信息,但int Number依然不区分类型信息.<br/>
		 * 建议判断的类型信息都相同<br/>
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function equals(a:*, b:*):Boolean
		{
			var ba:ByteArray = new ByteArray();
			ba.writeObject(a);
			var bb:ByteArray = new ByteArray();
			bb.writeObject(b);
			
			var len:uint = ba.length;
			if(bb.length != len) return false;
			
			ba.position = 0;
			bb.position = 0;
			for(var i:int = 0; i < len; i++)
			{
				if(ba.readByte() != bb.readByte())return false;
			}
			return true;
		}
		
	}
	
}