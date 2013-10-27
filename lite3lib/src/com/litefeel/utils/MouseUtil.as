/**
 * MouseUtil 方法:
 * 					MouseUtil.init(stage); // 初始化
 * 					MouseUtil.destroy()	// 不用了要销毁
 * 					MouseUtil.show()		// 显示鼠标
 * 					MouseUtil.hide()		// 隐藏鼠标
 * 					MouseUtil.isMoving();	// 是否正在移动
 * 					MouseUtil.getAngle()	// 鼠标移动的角度, 先判断是否在移动,没移动则是以前的角度
 * 					MouseUtil.getDelay()	// 检测的精度 单位:ms
 * 					MouseUtil.setDelay(t)	// 检测的精度 单位:ms
 * 				
 * bug:
 * 		MouseUtil.hide()  		选择右键菜单项后,鼠标会自动显示,不知道怎么解决,
 * 						 		先用MouseEvent.MOUSE_DOWN 让鼠标再次隐藏(o(╯□╰)o
 * 
 * 		MouseUtil.getAngle()	连续获取的角度不够平滑,有待解决
 * 
 * 	ps:
 * 		哪位大哥大姐有更好的方法,请告诉小弟,先谢谢了O(∩_∩)O
 * 		我的邮箱: lite3@qq.com
 * `	qq:		 735486078
 */

package com.litefeel.utils 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * www.litefeel.com
	 * lite3@qq.com
	 * @author lite3
	 */
	public class MouseUtil 
	{
		
		static private var _stage:Stage;
		
		static private var _delay:int = 100;
		
		static private var _moving:Boolean = false;
		static private var _angle:Number = 0;
		
		static private var prevX:Number = 0;
		static private var prevY:Number = 0;
		
		static private var prevTime:uint = 0;
		
		
		static private var isMouseHide:Boolean = false;
		
		// 初始化
		static public function init(stage:Stage):void
		{
			if (!stage || _stage) return;
			
			_stage = stage;
			stage.addEventListener(Event.ACTIVATE, 		  checkMouseHideShow);
			stage.addEventListener(Event.DEACTIVATE, 	  checkMouseHideShow);
			stage.addEventListener(Event.ENTER_FRAME,	  enterFrameHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, checkMouseHideShow);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		// 销毁
		static public function destroy():void
		{
			if (!_stage) return;
			
			_stage.removeEventListener(Event.ACTIVATE, 		  checkMouseHideShow);
			_stage.removeEventListener(Event.DEACTIVATE, 	  checkMouseHideShow);
			_stage.removeEventListener(Event.ENTER_FRAME,	  enterFrameHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, checkMouseHideShow);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_stage = null;
		}
		
		// 显示鼠标
		static public function hide():void
		{
			isMouseHide = true;
			Mouse.hide();
		}
		
		// 隐藏鼠标
		static public function show():void
		{
			isMouseHide = false;
			Mouse.show();
		}
		
		//鼠标是否在移动
		static public function isMoving():Boolean
		{
			return _moving;
		}
		
		/**
		 * 鼠标当前移动的方向, 如果没有移动则为以前移动到 方向
		 * @return
		 */
		static public function getAngle():Number
		{
			return _angle;
		}
		
		/**
		 * 获取鼠标移动的精度
		 * @return <b>	int	</b> 毫秒为单位
		 */
		static public function getDelay():int
		{
			return _delay;
		}
		
		/**
		 * 设置检测的精度
		 * @param	delay	<b>	int	</b> 毫秒为单位
		 */
		static public function setDelay(delay:int):void
		{
			_delay = delay;
		}
		
		//----------------------------- 私有方法 -----------------------------------------
		// 检测鼠标隐藏显示状态
		static private function checkMouseHideShow(arg:Event = null):void 
		{
			if (_stage)
			{
				isMouseHide ? Mouse.hide() : Mouse.show();
			}
		}
		
		// ------------------------------ 事件 -------------------------------------------
		static private function enterFrameHandler(e:Event):void 
		{
			// _delay时间后鼠标未移动则,鼠标没移动
			if (_moving && getTimer() - prevTime > _delay)
			{
				_moving = false;
			}
		}
		
		static private function mouseMoveHandler(e:MouseEvent):void 
		{
			// 检测移动
			_moving = true;
			prevTime = getTimer();
			
			//检测方向
			var vx:Number = e.stageX - prevX;
			var vy:Number = e.stageY - prevY;
			if (Math.sqrt(vx * vx + vy * vy) > 5)
			{
				var currAngle:Number = Math.atan2(e.stageY - prevY, e.stageX - prevX);
				currAngle = (currAngle / Math.PI * 180 + 360) % 360;
				//平滑抖动
				if (Math.abs(currAngle-_angle) < 30) currAngle = (currAngle + _angle) * .5;
				_angle = currAngle;
				prevX = e.stageX;
				prevY = e.stageY;
			}
		}
		
		
	}
	
}