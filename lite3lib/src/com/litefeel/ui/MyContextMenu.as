package com.litefeel.ui 
{
	import flash.events.ContextMenuEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class MyContextMenu
	{
		
		static public function getMyContextNenu():ContextMenu
		{
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			var contextMenuItem:ContextMenuItem = new ContextMenuItem("Power By LiteFeel.com");
			contextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, selectedHandler);
			contextMenu.customItems = [contextMenuItem];
			
			function selectedHandler(e:ContextMenuEvent):void 
			{
				navigateToURL(new URLRequest("http://www.litefeel.com/"), "_target")
			}
			
			return contextMenu;
		}
		
		
	}
	
}