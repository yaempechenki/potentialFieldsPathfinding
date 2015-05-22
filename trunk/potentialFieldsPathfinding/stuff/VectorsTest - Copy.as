package  {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

 public class VectorsTest extends Sprite {

    private static const CELL_SIZE:int = 40;

    public function VectorsTest() {
        init();
    }

    private function init():void {
      //  for (var x:int = 0; x < 6; x++) {
        //    for (var y:int = 0; y < 6; y++) {
                drawExample(2, 2);
        //    }
       // }
    }


    private function drawExample(x:int, y:int):void {
        const target:Point = new Point(3, -0.4);// getRandomPoint(1);
        const oppose:Point = new Point(-1, 0);//getRandomPoint(1);
        const modifier:Point = getModifier(target, oppose);
        const result:Point = target.add(modifier);


        var cell:Sprite = new Sprite();
        cell.x = (x + 1) * CELL_SIZE * 2;
        cell.y = (y + 1) * CELL_SIZE * 2;

        drawLine(cell.graphics, target, 0xFF00FF00);
        drawLine(cell.graphics, oppose, 0xFFFF0000);
        drawLine(cell.graphics, modifier, 0xFF0000FF);
        drawLine(cell.graphics, result, 0xFF000000);

        addChild(cell);
    }

    private static function drawLine(graphics:Graphics, target:Point, color:uint):void {
        graphics.lineStyle(1, color);
        graphics.moveTo(0, 0);
        graphics.lineTo(target.x * CELL_SIZE, target.y * CELL_SIZE);
    }

    static private function getRandomPoint(mulitplyer:Number):Point {
        return new Point(mulitplyer * 2 * (Math.random() - 0.5), mulitplyer * 2 * (Math.random() - 0.5));
    }

    static private function getModifier(target:Point, oppose:Point):Point {
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
}
}