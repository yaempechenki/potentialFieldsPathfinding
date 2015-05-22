package  
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import com.bit101.components.FPSMeter
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author artem.kolesnikov 
	 */
	public class SettingsWindow extends Window 
	{
		public static var UNITS_COUNT:int = 300;
		public static var OBSTACLE_COUNT:int = 1;
		public static var SPEED:int = 100;
		public static var SHOW_INFLUENCE:Boolean = true;
		public static var RADIUS_INFLUENCE:int = 10;
		
		private var fpsMeter:FPSMeter;
		private var unitsCountTF:InputText;
		private var ostacleCountTF:InputText;
		private var speedValueTF:InputText;
		private var showInfluence:CheckBox;
		private var radiusInfluence:InputText;
				
		private var refreshButton:PushButton;
		public function SettingsWindow() 
		{
			title = "Settings";
			hasMinimizeButton = true;
			width = 300;
			height = 200;
			
			unitsCountTF = new InputText(this, 10, 10, UNITS_COUNT.toString() , onTFChange); 
			createLabel(unitsCountTF.x + unitsCountTF.width, unitsCountTF.y, "units count");
			
			ostacleCountTF = new InputText(this, 10, 30, OBSTACLE_COUNT.toString() , onTFChange); 
			createLabel(ostacleCountTF.x + ostacleCountTF.width, ostacleCountTF.y, "obstacle count");
			
			speedValueTF = new InputText(this, 10, 50, SPEED.toString() , onTFChange); 
			createLabel(speedValueTF.x + speedValueTF.width, speedValueTF.y, "speed %");
			
			radiusInfluence = new InputText(this, 10, 70, RADIUS_INFLUENCE.toString() , onTFChange); 
			createLabel(radiusInfluence.x + radiusInfluence.width, radiusInfluence.y, "radius influrance");
			
			showInfluence = new CheckBox(this, 10, 90, "show influence", onTFChange);
			showInfluence.selected = SHOW_INFLUENCE;
			
			fpsMeter = new FPSMeter(this, 0, 0);
			fpsMeter.x = width - fpsMeter.width -10;
			fpsMeter.y = 10;
			fpsMeter.start();
			
			refreshButton = new PushButton(this, 0, 0, "refresh", onRefreshClick);
			refreshButton.x = width - refreshButton.width - 10;
			refreshButton.y = height - refreshButton.height - 30;
		}
		
		private function createLabel(toPosX:int, toPoxY:int, title:String) : void {
			var oneLabel:Label = new Label(this, toPosX + 5, toPoxY, title);
		}
		
		private function onTFChange(event:Event):void {
			UNITS_COUNT = int(unitsCountTF.text);
			OBSTACLE_COUNT = int(ostacleCountTF.text);
			SPEED = int(speedValueTF.text);
			SHOW_INFLUENCE = showInfluence.selected;
			RADIUS_INFLUENCE = int(radiusInfluence.text);
		}
		
		private function onRefreshClick(event:MouseEvent) :void {
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}

}