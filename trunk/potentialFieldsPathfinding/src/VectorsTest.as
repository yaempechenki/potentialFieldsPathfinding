package  {
import flash.display.Graphics;
import flash.display.InterpolationMethod;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

 public class VectorsTest extends Sprite {

	private var units:Vector.<Unit>;
	private var targetDot:Dot;
	private var map:Map;
	
	private var settingsWindow:SettingsWindow;
    public function VectorsTest() { 
		map = new Map(400, 400);
		addChild(map);
				
		targetDot = new Dot(5, 0x33DD33);
		addChild(targetDot);
		
		settingsWindow = new SettingsWindow();
		settingsWindow.x = stage.stageWidth - settingsWindow.width - 50;
		settingsWindow.y = 100;
		settingsWindow.addEventListener(Event.CHANGE, onSettingsChange);
		addChild(settingsWindow);
		
		onSettingsChange(null);
    }

	static private function getRandomPoint():int {
		return 400 * Math.random();
	}

	private function onEnterFrame(event:Event):void {
		var maxLength:int;
		for each (var unit:Unit in units) 
		{
			var unitPoint:Point = unit.position;
			var targetPoint:Point = targetDot.position;
			
			const target:Point = targetPoint.subtract(unitPoint);
			if (target.length < 10 ) {  continue; } // приехал уже харош
			maxLength = Math.max(maxLength, target.length);
			target.normalize(1);
			const oppose:Point = map.getPoint(unitPoint.x, unitPoint.y);
			oppose.normalize(1);

			const modifier:Point = getModifier(target, oppose);
			modifier.normalize(2);
			const result:Point = target.add(modifier);
			
			// отрисовка векторов
			//unit.visualiseVectors(target, oppose, modifier, result);
			unit.update(result);
		}
		
		if (maxLength < 15) {
			onSettingsChange(null);
		}
	}

    private function getModifier(target:Point, oppose:Point):Point {
        const targetLength:Number = target.length;
        const opposeLength:Number = oppose.length;

        if (targetLength == 0 || opposeLength == 0) {
            return new Point();
        }

        const cos:Number = (target.x * oppose.x + target.y * oppose.y) / (targetLength * opposeLength);
        const projectionOnSelf:Number = cos * opposeLength;
        if (projectionOnSelf >= 0) {
            return new Point();
        }

        const isOnLeftSide:Boolean = (oppose.x * target.y - oppose.y * target.x) < 0;

        var projectionToPerpendicular:Point = isOnLeftSide ? new Point(-target.y, target.x) : new Point(target.y, -target.x);
        projectionToPerpendicular.normalize(-projectionOnSelf);
        return projectionToPerpendicular;
    }
	
	private function onSettingsChange(event:Event) :void {
		if (this.hasEventListener(Event.ENTER_FRAME)) {
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);	
		}
		
		if(units) {
			while(units.length>0) {
				removeChild(units.pop());
			}
		}
		
		units = new Vector.<Unit>;
		for (var i:int = 0; i < SettingsWindow.UNITS_COUNT; i++) 
		{
			var oneUnit:Unit = new Unit();
			units.push(oneUnit);
			addChild(oneUnit);
		}
		
		map.rebuildMap(SettingsWindow.OBSTACLE_COUNT);
		for each (var unit:Unit in units) 
		{
			unit.x = getRandomPoint();
			unit.y = getRandomPoint();
		}
		// build random target;
		do {
			targetDot.x = getRandomPoint();
			targetDot.y = getRandomPoint();
		} while (map.isBorder(targetDot.x, targetDot.y, true));
		
		addChild(targetDot);
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}	
}
}