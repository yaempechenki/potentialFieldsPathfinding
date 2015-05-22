package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author yaempechenki@gmail.com
	 */
	public class Map extends Sprite 
	{
		public static const COLS:int = 40;
		public static const ROWS:int = 40;

		private var map:Vector.<Point>;
		private var mapWidth:int = 0;
		private var mapHeight:int = 0;
		private var borderArray:Vector.<Point>;
		private var borderChildList:Vector.<Sprite>;
		private var obstacleCount:int;
		public function Map(mapWidth:int, mapHeight:int) 
		{
			this.mapWidth = mapWidth;
			this.mapHeight = mapHeight;
		}
		
		public function rebuildMap(obstacleCount:int):void {
			this.obstacleCount = obstacleCount;
			buildMap();
			buildBorder();
			buildVectors();
			drawMap();
		}
		
		private function drawMap():void {
			while (numChildren) {
				removeChildAt(0);
			}
			borderChildList = new Vector.<Sprite>;
			
			for (var xx:int = 0; xx < COLS; xx++) {
				for (var yy:int = 0; yy < ROWS; yy++) {
					createOneRect(xx, yy, map[ xx + yy * COLS]);
				}
			}
		}
		
		private function buildMap():void {
			if (map) {
				while (map.length > 0) {
					map.pop();
				}
			}
			map = new Vector.<Point>(COLS * ROWS);
			for (var xx:int = 0; xx < COLS; xx++) {
				for (var yy:int = 0; yy < ROWS; yy++) {
					map[ xx + yy * COLS] = new Point(0, 0);
				}
			}
		}
		
		public function buildBorder():void {
			if (borderArray) {
				while (borderArray.length > 0) {
					borderArray.pop();
				}
			}
			borderArray = new Vector.<Point>;
			while (borderArray.length < obstacleCount) {
				var xx:int = Math.random() * COLS;
				var yy:int = Math.random() * ROWS;
				borderArray.push(new Point(xx, yy));
				//borderArray.push(new Point(xx+1, yy));
				//borderArray.push(new Point(xx, yy+1));
				//borderArray.push(new Point(xx+1, yy+1));
			}
		}
		
		private function buildVectors():void {
			// проставляем вектора
			for (var xx:int = 0; xx < COLS; xx++) 
			{
				for (var yy:int = 0; yy < ROWS; yy++) 
				{
					if (isBorder(xx,yy)) {
						buildVectorInflurence(xx, yy);
					}
				}
			}
		}
		
		
		private function buildVectorInflurence( x:int, y:int):void {
			const  RADIUS:int = SettingsWindow.RADIUS_INFLUENCE;
			for (var i:int = x - RADIUS; i <= x + RADIUS; i++){
				for (var j:int = y - RADIUS; j <= y + RADIUS; j++){
					if (i < 0 || j < 0 || i >= ROWS || y >= COLS){
						continue;
					}
					if (x == i && y == j){
						continue;
					}
					if ((i + j * COLS) >= (COLS * ROWS)) continue; // out of range !
					
					const distPoint:Point = new Point(i, j);
					const sourcePoint:Point = new Point(x, y);
					var vector:Point = distPoint.subtract(sourcePoint);
					const dist:Number = vector.length;
					if (dist > RADIUS){
						continue;
					}
					
					const strength:Number = (1 - (dist - 1) / RADIUS);
					vector.normalize(strength);
					map[i + j * COLS] = map[i + j * COLS].add(vector); 
				}
			}
		}
		
		public function isBorder(xx:int, yy:int, needConvert:Boolean = false):Boolean {
			
			if (needConvert) {
				xx = int(xx / mapWidth * COLS);
				yy = int(yy / mapHeight * ROWS);
			}
			
			for (var i:int = 0; i < borderArray.length; i++) 
			{
				if (borderArray[i].x == xx && borderArray[i].y == yy) {
					return true;
				}
			}
			return false;
		}
		
		public function getPoint(xx:int, yy:int):Point {
			
			xx = int(xx / mapWidth * COLS);
			yy = int(yy / mapHeight * ROWS);
			
			if (xx < 0 || yy < 0) return  new Point();
			var point:Point = new Point();
			if (xx < ROWS && yy < COLS) {
				point = map[xx + yy * COLS];
			}
			return  point;
		}

		private function createOneRect(xx:int, yy:int, point:Point):void {
			var color:uint = 0xFFFFFF;
			
			var length:Number = point.length;
			
			if (SettingsWindow.SHOW_INFLUENCE && length > 0) {
				var a:Number = 1 - length;
				var r:uint = color >> 16 & 0xFF;
				var g:uint = color >>  8 & 0xFF;
				var b:uint = color >>  0 & 0xFF;
				var rgb_new:uint = (r * a) << 16 | (g * a) << 8 | (b * a);

				color = rgb_new;
			}
			
			if(isBorder(xx,yy)){
				color = 0x000000;
			}	
			
			var one:Sprite = new Sprite();
			one.graphics.beginFill(color);
			one.graphics.lineStyle(1,0xAAAAAA);
			const STEP:int = mapWidth / COLS;
			one.graphics.drawRect(0, 0, STEP, STEP);
			one.graphics.endFill();
			one.x = xx * STEP;
			one.y = yy * STEP;
			addChild(one);
		}
	}
}