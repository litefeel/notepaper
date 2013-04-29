package com.litefeel.utils 
{
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * www.litefeel.com
	 * lite3@qq.com
	 * @author lite3
	 */
	public class MultiTimer 
	{
		private var queue:Array = []; // 对象池
		private var timer:Timer;
		
		/**
		 * 构造函数
		 * @param	delay	<b>	int	</b> Timer的间隔 单位:ms
		 */
		public function MultiTimer(delay:int) 
		{
			timer = new Timer(delay);
		}
		
		/**
		 * 添加一个时间函数
		 * 
		 * @param	time		<b>	int		</b> 运行的时间, 单位:ms
		 * @param	completeFunc<b>	Function</b> 结束时函数
		 * @param	completeArgs<b>	Array	</b> 结束时函数的参数
		 * @param	timerFunc	<b>	Function</b> timer时函数
		 * @param	timerArgs	<b>	Array	</b> timer时函数的参数
		 */
		public function addTimer(time:int, 
								 completeFunc:Function = null, 	completeArgs:Array = null,
								 timerFunc:Function = null,     timerArgs:Array = null):void
		{
			
			if (null == completeFunc && null == timerFunc) return;
			
			// 时间为0, 则马上调用回调函数
			if (time <= 0)
			{
				if (completeFunc != null)
					completeFunc.apply(null, completeArgs);
				return;
			}
			
			// 运行timer
			if (!timer.running)
			{
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				timer.start();
			}
			
			// 添加事件到队里
			var vo:Vo = new Vo( getTimer() + time,
								completeFunc, completeArgs,
								timerFunc,    timerArgs);
			
			addToQueue(vo);
		}
		
		/**
		 * @private	执行循环
		 * @param	e
		 */
		private function timerHandler(e:TimerEvent):void 
		{
			var currTime:int = getTimer();
			for (var i:int = queue.length -1; i >= 0; i--)
			{
				var vo:Vo = queue[i] as Vo;
				
				// Timer 事件
				if (vo.timerFunc != null) 
					vo.timerFunc.apply(null, vo.timerArgs);
				
				// TimerComplete 事件
				if (vo.time <= currTime)
				{
					queue.pop();
					if (vo.completeFunc != null)
						vo.completeFunc.apply(null, vo.completeArgs);
				}
			}
			
			if (queue.length <= 0)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			}
		}
		
		/**
		 * @private	添加一个事件到 有序队列(按time 从大到小排列)
		 * @private 
		 * @param	vo
		 */
		private function addToQueue(vo:Vo):void
		{
			var time:int = vo.time;
			var index:int = 0;
			for each(var tem:Vo in queue)
			{
				if (tem.time <= time) break;
				
				index++;
			}
			for (var i:int = queue.length; i > index; i--)
			{
				queue[i] = queue[i - 1];
			}
			
			queue[index] = vo;
		}
	}
	
}

// 存放 相关信息
class Vo
{
	public var time:int
	public var completeFunc:Function;
	public var completeArgs:Array;
	public var timerFunc:Function;
	public var timerArgs:Array;
	
	public function Vo( time:int, 
						completeFunc:Function, 	completeArgs:Array,
						timerFunc:Function,     timerArgs:Array):void
	{
		this.time = time;
		this.completeFunc = completeFunc;
		this.completeArgs = completeArgs;
		this.timerFunc	  = timerFunc;
		this.timerArgs	  = timerArgs;
	}
}