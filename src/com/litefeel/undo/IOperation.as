package com.litefeel.undo 
{
	
	/**
	 * IOperation 定义可以撤消和重做的操作的接口。
	 * @author lite3
	 */
	public interface IOperation 
	{
		/** 重新执行操作。*/
		function performRedo():void
		
		/** 取消操作。*/
		function performUndo():void
	}
	
}