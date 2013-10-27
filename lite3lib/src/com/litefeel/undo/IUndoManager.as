package com.litefeel.undo 
{
	
	/**
	 * IUndoManager 定义用于管理撤消堆栈和重做堆栈的接口。<br/>
	 * 撤消管理器维护可以撤消和重做的操作的堆栈。
	 * @author lite3
	 */
	public interface IUndoManager 
	{
		/** 要跟踪的可撤消操作或可重做操作的最大数目。*/
		function get undoAndRedoItemLimit():int;
		/** 要跟踪的可撤消操作或可重做操作的最大数目。*/
		function set undoAndRedoItemLimit(value:int):void; 
		
		
		/** 指示当前是否存在可以重做的操作。*/
		function canRedo():Boolean
 	 	
		/** 指示当前是否存在可以撤消的操作。*/
		function canUndo():Boolean
 	 	
		/** 同时清除撤消历史记录和重做历史记录。*/
		function clearAll():void
 	 	
		/** 清除重做堆栈。*/
		function clearRedo():void
 	 	
		/** 返回要重做的下一个操作。*/
		function peekRedo():IOperation
 	 	
		/** 返回要撤消的下一个操作。*/
		function peekUndo():IOperation
 	 	
		/** 从重做堆栈中删除要重做的下一个操作，并返回该操作。*/
		function popRedo():IOperation
 	 	
		/** 从撤消堆栈中删除要撤消的下一个操作，并返回该操作。*/
		function popUndo():IOperation
 	 	
		/** 将可重做的操作添加到重做堆栈中。*/
		function pushRedo(operation:IOperation):void
		
		/** 将可撤消的操作添加到撤消堆栈中。*/
		function pushUndo(operation:IOperation):void
		
		/** 从重做堆栈中删除下一个 IOperation 对象，并调用该对象的 performRedo() 函数。*/
		function redo():void
		
		/** 从撤消堆栈中删除下一个 IOperation 对象，并调用该对象的 performUndo() 函数。*/
		function undo():void
	}
	
}