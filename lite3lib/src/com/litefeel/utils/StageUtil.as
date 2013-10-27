package com.litefeel.utils 
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	/**
	 * ...
	 * @author lite3
	 */
	public class StageUtil
	{
		/**
		 * 设置舞台不缩放并且左上角对齐
		 * @param	stage
		 */
		public static function setNoScaleAndTopLeft(stage:Stage):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
	}
}