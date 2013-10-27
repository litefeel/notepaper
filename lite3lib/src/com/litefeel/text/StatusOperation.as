package com.litefeel.text 
{
	import com.litefeel.undo.IOperation;
	import flash.globalization.CurrencyFormatter;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class StatusOperation implements IOperation
	{
		
		public var prevStatus:TextStatus;
		public var currStatus:TextStatus;
		public var nextStatus:TextStatus;
		
		public var undoText:UndoTextField;
		
		use namespace utf_internal;
		
		public function StatusOperation(undoText:UndoTextField = null, prev:TextStatus = null, curr:TextStatus = null, next:TextStatus = null) 
		{
			prevStatus = prev;
			currStatus = curr;
			nextStatus = next;
			this.undoText = undoText;
		}
		
		/* INTERFACE com.litefeel.undo.IOperation */
		
		public function performRedo():void
		{
			if (nextStatus)
			{
				undoText.setStatus(nextStatus);
				prevStatus = currStatus;
				currStatus = nextStatus;
				nextStatus = null;
			}
		}
		
		public function performUndo():void
		{
			if (prevStatus)
			{
				undoText.setStatus(prevStatus);
				nextStatus = currStatus;
				currStatus = prevStatus;
				prevStatus = null;
			}
		}
		
	}

}