package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author yaempechenki@gmail.com
	 */
	public class Dot extends Sprite 
	{
		
		public function Dot(radius:int, color:uint) 
		{
			super();
			this.graphics.beginFill(color);
			this.graphics.drawCircle(0, 0, radius);
			this.graphics.endFill();
			
		}
		
		public function set position(point:Point):void {
			this.x = point.x;
			this.y = point.y;
		}
		
		public function get position():Point {
			return new Point(this.x, this.y);
		}
		
	}

}