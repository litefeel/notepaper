package com.litefeel.text 
{
	import com.litefeel.text.TextStatus;
	import com.litefeel.undo.UndoManager;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class UndoTextField extends TextField
	{
		private var ignoreChangeHandler:Boolean = false;
		private var currStatus:TextStatus;
		private var undoManager:UndoManager
		
		public function UndoTextField() 
		{
			super();
			addEventListener(Event.CHANGE, changeHandler);
			addEventListener(KeyboardEvent.KEY_DOWN, keyDonwHandler);
			
			undoManager = new UndoManager();
			createCurrentStatus();
		}
		
		public function clearAllUndoRedo():void
		{
			undoManager.clearAll();
			createCurrentStatus();
		}
		
		private function keyDonwHandler(e:KeyboardEvent):void 
		{
			if (e.ctrlKey)
			{
				if (Keyboard.Y == e.keyCode)
				{
					redo();
					e.preventDefault();
				}else if (Keyboard.Z == e.keyCode)
				{
					undo();
					e.preventDefault();
				}
			}
		}
		
		private function changeHandler(e:Event):void 
		{
			if (ignoreChangeHandler) return;
			
			undoManager.clearRedo();
			
			
			var op:StatusOperation = new StatusOperation(this, currStatus, createCurrentStatus());
			undoManager.pushUndo(op);
		}
		
		override public function set text(value:String):void 
		{
			super.text = value;
			undoManager.clearAll();
			createCurrentStatus();
		}
		
		override public function set htmlText(value:String):void 
		{
			super.htmlText = value;
			undoManager.clearAll();
			createCurrentStatus();
		}
		
		public function undo():void
		{
			undoManager.undo();
		}
		
		public function redo():void
		{
			undoManager.redo();
		}
		
		utf_internal function setStatus(status:TextStatus):void
		{
			if (!status) return;
			super.htmlText = status.htmlText;
			super.setSelection(status.selectionBegin, status.selectionEnd);
			ignoreChangeHandler = true;
			dispatchEvent(new Event(Event.CHANGE));
			ignoreChangeHandler = false;
		}
		
		private function createCurrentStatus():TextStatus
		{
			currStatus = new TextStatus();
			currStatus.htmlText = htmlText;
			currStatus.selectionBegin = selectionBeginIndex;
			currStatus.selectionEnd = selectionEndIndex;
			return currStatus;
		}
		
	}

}