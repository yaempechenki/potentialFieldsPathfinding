package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.display.Graphics;
	
	/**
	 * ...
	 * @author yaempechenki@gmail.com
	 */
	public class Unit extends Dot 
	{
		private static const CELL_SIZE:int = 40;
		private var radius:int;
		private var SPEED:int;
		
		public function Unit() 
		{
			mouseEnabled = false;
			mouseChildren = false;

			SPEED = Math.random() * 3 + 2;
			radius = 5 / SPEED + 2;
			
			SPEED = (SPEED) / 100 * SettingsWindow.SPEED + 1;
			
			const color:uint = 0x232323;
			super(radius, color);
		}
		
		public function update(vector:Point):void {
			vector.normalize(SPEED);
			position = position.add(vector);
		}
		
		public function visualiseVectors(target:Point, oppose:Point, modifier:Point, result:Point):void {
			drawLine(this.graphics, target, 0xFF00FF00);
			drawLine(this.graphics, oppose, 0xFFFF0000);
			drawLine(this.graphics, modifier, 0xFF0000FF);
			drawLine(this.graphics, result, 0xFF000000);
		}
		
		private function drawLine(graphics:Graphics, target:Point, color:uint):void {
		    
			graphics.lineStyle(1, color);
			graphics.moveTo(0, 0);
			graphics.lineTo(target.x * CELL_SIZE, target.y * CELL_SIZE);
		}
	}
}