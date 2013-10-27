package com.litefeel.notepaper.view 
{
	import org.aswing.AsWingConstants;
	import org.aswing.geom.IntDimension;
	import org.aswing.geom.IntPoint;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JTextField;
	import org.aswing.SoftBoxLayout;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class LoginWindowUI extends JPanel{
		
		//members define
		private var panel8:JPanel;
		private var label9:JLabel;
		private var idText:JTextField;
		private var panel11:JPanel;
		private var label12:JLabel;
		private var psText:JTextField;
		private var panel14:JPanel;
		private var loginButton:JButton;
		private var registerButton:JButton;
		
		public function LoginWindowUI()
		{
			//component creation
			setSize(new IntDimension(400, 400));
			var layout0:SoftBoxLayout = new SoftBoxLayout();
			layout0.setAxis(AsWingConstants.VERTICAL);
			setLayout(layout0);
			
			panel8 = new JPanel();
			panel8.setSize(new IntDimension(400, 10));
			
			label9 = new JLabel();
			label9.setLocation(new IntPoint(5, 5));
			label9.setSize(new IntDimension(40, 17));
			label9.setText("帐号：");
			
			idText = new JTextField();
			idText.setLocation(new IntPoint(50, 5));
			idText.setSize(new IntDimension(88, 21));
			idText.setColumns(12);
			
			panel11 = new JPanel();
			panel11.setLocation(new IntPoint(0, 31));
			panel11.setSize(new IntDimension(400, 10));
			
			label12 = new JLabel();
			label12.setLocation(new IntPoint(5, 5));
			label12.setSize(new IntDimension(40, 17));
			label12.setText("密码：");
			
			psText = new JTextField();
			psText.setLocation(new IntPoint(36, 5));
			psText.setSize(new IntDimension(104, 21));
			psText.setColumns(12);
			
			panel14 = new JPanel();
			panel14.setLocation(new IntPoint(0, 62));
			panel14.setSize(new IntDimension(400, 10));
			
			loginButton = new JButton();
			loginButton.setLocation(new IntPoint(5, 5));
			loginButton.setSize(new IntDimension(31, 22));
			loginButton.setText("登录");
			
			registerButton = new JButton();
			registerButton.setLocation(new IntPoint(43, 5));
			registerButton.setSize(new IntDimension(33, 22));
			registerButton.setText("注册");
			
			//component layoution
			append(panel8);
			append(panel11);
			append(panel14);
			
			panel8.append(label9);
			panel8.append(idText);
			
			panel11.append(label12);
			panel11.append(psText);
			
			panel14.append(loginButton);
			panel14.append(registerButton);
		}
		//_________getters_________
		
		
		
		public function getIdText():JTextField{
			return idText;
		}
		
		
		
		public function getPsText():JTextField{
			return psText;
		}
		
		
		public function getLoginButton():JButton{
			return loginButton;
		}
		
		public function getRegisterButton():JButton{
			return registerButton;
		}
	}
}