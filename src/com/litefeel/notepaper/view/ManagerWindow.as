package com.litefeel.notepaper.view
{
	
	import com.litefeel.notepaper.events.CloseEvent;
	import com.litefeel.notepaper.events.DataEvent;
	import com.litefeel.notepaper.events.GroupEvent;
	import com.litefeel.notepaper.language._;
	import com.litefeel.notepaper.language.__;
	import com.litefeel.notepaper.managers.DataManager;
	import com.litefeel.notepaper.managers.EventCenter;
	import com.litefeel.notepaper.vo.GroupVo;
	import com.litefeel.notepaper.vo.NotepaperVo;
	import com.litefeel.utils.DateUtil;
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import org.aswing.*;
	import org.aswing.border.*;
	import org.aswing.colorchooser.*;
	import org.aswing.event.AWEvent;
	import org.aswing.event.TreeSelectionEvent;
	import org.aswing.ext.*;
	import org.aswing.geom.*;
	import org.aswing.table.DefaultTableModel;
	import org.aswing.tree.DefaultMutableTreeNode;
	import org.aswing.tree.DefaultTreeModel;
	import org.aswing.tree.DefaultTreeSelectionModel;
	import org.aswing.tree.TreePath;
	
	/**
	 * MyPane
	 */
	public class ManagerWindow extends WindowBase
	{
		private static var window:ManagerWindow;
		//members define
		private var splitpane8:JSplitPane;
		private var panel14:JPanel;
		private var menubar16:JMenuBar;
		private var newGroupItem:JMenuItem;
		private var modifyGroupItem:JMenuItem;
		private var deleteGroupItem:JMenuItem;
		private var tree:JTree;
		private var panel15:JScrollPane;
		private var button20:JButton;
		private var table:JTable;
		
		public static function showWindow():void
		{
			if (!window) window = new ManagerWindow();
			NativeApplication.nativeApplication.activate(window.nativeWindow);
			window.nativeWindow.orderToFront();
		}
		
		/**
		 * MyPane Constructor
		 */
		public function ManagerWindow()
		{
			super(_("Manager Panel"), true, null, true, true);
			getNativeWindow().bounds = new Rectangle(getNativeWindow().x, getNativeWindow().y, 695, 457);
			
			splitpane8 = new JSplitPane();
			splitpane8.setSize(new IntDimension(695, 412));
			splitpane8.setConstraints(BorderLayout.CENTER);
			
			panel14 = new JPanel();
			panel14.setSize(new IntDimension(281, 346));
			panel14.setConstraints(BorderLayout.CENTER);
			var layout0:BorderLayout = new BorderLayout();
			layout0.setHgap(10);
			layout0.setVgap(10);
			panel14.setLayout(layout0);
			
			menubar16 = new JMenuBar();
			menubar16.setOpaque(true);
			menubar16.setForeground(new ASColor(0x666666, 1));
			menubar16.setBackground(new ASColor(0xac1af, 1));
			menubar16.setLocation(new IntPoint(5, 5));
			menubar16.setSize(new IntDimension(281, 17));
			menubar16.setConstraints("North");
			
			newGroupItem = new JMenuItem(_("New Group"));
			modifyGroupItem = new JMenuItem(_("Modify Group"));
			deleteGroupItem = new JMenuItem(_("Delete Group"));
			newGroupItem.addActionListener(menuClick);
			modifyGroupItem.addActionListener(menuClick);
			deleteGroupItem.addActionListener(menuClick);
			menubar16.append(newGroupItem);
			menubar16.append(modifyGroupItem);
			menubar16.append(deleteGroupItem);
			
			tree = new JTree();
			tree.getSelectionModel().setSelectionMode(DefaultTreeSelectionModel.SINGLE_TREE_SELECTION);
			//refreshTreeData(null);
			tree.setLocation(new IntPoint(0, 17));
			//tree.setSize(new IntDimension(281, 329));
			tree.setConstraints("Center");
			tree.addSelectionListener(selectHandler);
			
			panel15 = new JScrollPane();
			panel15.setLocation(new IntPoint(240, 0));
			panel15.setSize(new IntDimension(200, 346));
			panel15.setConstraints(BorderLayout.CENTER);
			
			//component layoution
			getContentPane().append(splitpane8, BorderLayout.CENTER);
			
			splitpane8.append(panel14);
			splitpane8.append(panel15);
			
			panel14.append(menubar16);
			panel14.append(tree);
			
			
			table = createTable();
			//refreshTableData(null);
			panel15.append(table, BorderLayout.CENTER);
			//this.addEventListener(MouseEvent.CLICK, clickHandler);
			
			EventCenter.instance.addEventListener(DataEvent.UPDATE, dataUpdateHandler);
			dataUpdateHandler(null);
			
			window = this;
		}
		
		private function dataUpdateHandler(e:DataEvent):void
		{
			refreshTreeData(null);
			tree.setSelectionInterval(0, 0);
		}
		
		override public function dispose():void 
		{
			window = null;
			
			splitpane8 = null;
			panel14 = null;
			menubar16 = null;
			newGroupItem = null;
			modifyGroupItem = null;
			deleteGroupItem = null;
			tree = null;
			panel15 = null;
			button20 = null;
			table = null;
			EventCenter.instance.removeEventListener(DataEvent.UPDATE, dataUpdateHandler);
			
			super.dispose();
		}
		
		private function selectHandler(e:TreeSelectionEvent):void 
		{
			var node:GroupNode = getTreeSelectionNode();
			if (!node) return;
			
			var noteList:Vector.<NotepaperVo> = DataManager.instance.getNoteList(node.id > 0 ? node.id : -1);
			refreshTableData(noteList);
			//trace("this is selectHandler", node.id, node.name);
		}
		
		private function menuClick(e:AWEvent):void 
		{
			switch(e.target)
			{
				case newGroupItem :
					trace("new");
					NewGroupWindow.show("", newGroupHandler, nativeWindow);
					break;
					
				case modifyGroupItem :
					var node:GroupNode = getTreeSelectionNode();
					if (!node || node.id <= 1) break;
					trace("modify");
					NewGroupWindow.show(node.name, modifyGroupHandler, nativeWindow);
					break;
					
				case deleteGroupItem :
					node = getTreeSelectionNode();
					if (!node || node.id <= 1) break;
					
					var msg:String = __("Are you sure you want to delete the group \"{1}\" and all notes?", node.name);
					AlertWindow.show(msg, _("Confirm Group Delete"), [_("OK"), _("Cancel")], deleteGroupHandler, 0, nativeWindow);
					break;
			}
		}
		
		private function getTreeSelectionNode():GroupNode 
		{
			var path:TreePath = tree.getSelectionPath();
			if (!path) return null;
			return path.getLastPathComponent().getUserObject() as GroupNode;
		}
		
		private function newGroupHandler(isOk:Boolean, name:String):void 
		{
			if (!isOk || !name) return;
			trace("create new group", name);
			EventCenter.instance.dispatchEvent(new GroupEvent(GroupEvent.CREATE, false, false, new GroupVo(0, name)));
		}
		private function modifyGroupHandler(isOk:Boolean, name:String):void 
		{
			if (!isOk || !name) return;
			
			var vo:GroupNode = tree.getSelectionPath().getLastPathComponent().getUserObject();
			if (name == vo.name) return;
			
			trace("notify group name from ", vo.name, "to", name);
			EventCenter.instance.dispatchEvent(new GroupEvent(GroupEvent.MODIFY, false, false, new GroupVo(vo.id, name)));
		}
		
		private function deleteGroupHandler(e:CloseEvent):void
		{
			if (e.isCloseBtn || 1 == e.selectedIndex) return;
			
			var node:GroupNode = getTreeSelectionNode();
			EventCenter.instance.dispatchEvent(new GroupEvent(GroupEvent.DELETE, false, false, new GroupVo(node.id, name)));
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			//setTimeout(refreshTableData, 1000, table);
			setTimeout(refreshTreeData, 1000, tree);
		}
		
		//_________getters_________
		
		private function refreshTreeData(data:Vector.<GroupVo>):void
		{
			if (!data) data = DataManager.instance.getGroupList();
			
			
			var root:DefaultMutableTreeNode = new DefaultMutableTreeNode(new GroupNode(-1, _("All Groups")));
			var len:int = data.length;
			for (var i:int = 0; i < len; i++)
			{
				var node:DefaultMutableTreeNode = new DefaultMutableTreeNode(new GroupNode(data[i].id, data[i].name));
				root.append(node);
			}
			//var parent:DefaultMutableTreeNode = new 
			//root.append(parent);
			//for (var i:int = 0; i < 10; i++)
			//{
				//parent.append(new DefaultMutableTreeNode(new GroupNode("one" + i, "name"+i)));
			//}
			//parent = new DefaultMutableTreeNode(new GroupNode("falod2", "falod2"));
			//root.append(parent);
			var model:DefaultTreeModel = new DefaultTreeModel(root);
			tree.setModel(model);
		}
		
		private function refreshTableData(list:Vector.<NotepaperVo>):void
		{
			if (!list) list = DataManager.instance.getNoteList();
			
			var data:Array = [];
			var len:int = list.length;
			for (var i:int = 0; i < len; i++)
			{
				data[i] = [list[i].subject, DateUtil.toString(list[i].date)];
			}
			
			var column:Array = [_("Name"), _("Created Date")];
			
			var model:DefaultTableModel = (new DefaultTableModel()).initWithDataNames(data, column);
			//model.setColumnClass(1, "Number");
			//model.setColumnClass(2, "Boolean");
			table.setModel(model);
		}
		
		private function createTable():JTable
		{
			var table:JTable = new JTable();
			table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
			return table
		}
	
	}
}

class GroupNode
{
	public var id:int;
	public var name:String;
	
	public function GroupNode(id:int, name:String)
	{
		this.id = id;
		this.name = name;
	}
	
	public function toString():String
	{
		return name;
	}
}