package com.litefeel.undo 
{
	/**
	 * 用于管理撤消堆栈和重做堆栈<br/>
	 * 撤消管理器维护可以撤消和重做的操作的堆栈
	 * @author lite3
	 */
	public class UndoManager
	{
		// 要跟踪的可撤消操作或可重做操作的最大数目
		private var _undoAndRedoItemLimit:int = 20;
		
		private var redoStack:Array = [];
		private var undoStack:Array = [];
		
		public function UndoManager() 
		{
			
		}
		
		/** 要跟踪的可撤消操作或可重做操作的最大数目。<br/>要禁用撤消函数，请将该值设置为 0。*/
		public function get undoAndRedoItemLimit():int { return _undoAndRedoItemLimit; }
		/** 要跟踪的可撤消操作或可重做操作的最大数目。<br/>要禁用撤消函数，请将该值设置为 0。*/
		public function set undoAndRedoItemLimit(value:int):void
		{
			if (value < 0) value = 0;
			_undoAndRedoItemLimit = value;
			trimUndoRedoStacks();
		}
		
		
		/** 指示当前是否存在可以重做的操作。*/
		public function canRedo():Boolean
		{
			return redoStack.length > 0;
		}
 	 	
		/** 指示当前是否存在可以撤消的操作。*/
		public function canUndo():Boolean
		{
			return undoStack.length > 0;
		}
 	 	
		/** 同时清除撤消历史记录和重做历史记录。*/
		public function clearAll():void
		{
			clearRedo();
			undoStack.splice(0, undoStack.length);
		}
 	 	
		/** 清除重做堆栈。*/
		public function clearRedo():void
		{
			redoStack.splice(0, redoStack.length);
		}
 	 	
		/** 返回要重做的下一个操作。*/
		public function peekRedo():IOperation
		{
			return redoStack[redoStack.length - 1]as IOperation;
		}
 	 	
		/** 返回要撤消的下一个操作。*/
		public function peekUndo():IOperation
		{
			return undoStack[undoStack.length - 1]as IOperation;
		}
 	 	
		/** 从重做堆栈中删除要重做的下一个操作，并返回该操作。*/
		public function popRedo():IOperation
		{
			return redoStack.pop() as IOperation;
		}
 	 	
		/** 从撤消堆栈中删除要撤消的下一个操作，并返回该操作。*/
		public function popUndo():IOperation
		{
			return undoStack.pop() as IOperation;
		}
 	 	
		/**
		 * 将可重做的操作添加到重做堆栈中。
		 * @param	operation
		 */
		public function pushRedo(operation:IOperation):void
		{
			if (!operation) return;
			redoStack.push(operation);
			trimUndoRedoStacks();
		}
		
		/**
		 * 将可撤消的操作添加到撤消堆栈中。
		 * @param	operation
		 */
		public function pushUndo(operation:IOperation):void
		{
			if (!operation) return;
			undoStack.push(operation);
			trimUndoRedoStacks();
		}
		
		/** 从重做堆栈中删除下一个 IOperation 对象，并调用该对象的 performRedo() 函数。*/
		public function redo():void
		{
			var op:IOperation = popRedo();
			if (op != null)
			{
				op.performRedo();
				pushUndo(op);
			}
		}
		
		/** 从撤消堆栈中删除下一个 IOperation 对象，并调用该对象的 performUndo() 函数。*/
		public function undo():void
		{
			var op:IOperation = popUndo();
			if (op != null)
			{
				op.performUndo();
				pushRedo(op);
			}
		}
		
		private function trimUndoRedoStacks():void
		{
			// trim the undoStack and the redoStack so its in bounds 
			var numItems:int = undoStack.length + redoStack.length;
			if (numItems > _undoAndRedoItemLimit)
			{
				// trim redoStack first
				var numToSplice:int = Math.min(numItems-_undoAndRedoItemLimit,redoStack.length);
				if (numToSplice)
				{
					redoStack.splice(0,numToSplice);
					numItems = undoStack.length+redoStack.length;
				} 
				// trim some undoable items
				if (numItems > _undoAndRedoItemLimit)
				{
					numToSplice = Math.min(numItems-_undoAndRedoItemLimit,undoStack.length);
					undoStack.splice(0,numToSplice);
				}
			}
		}
		
	}

}