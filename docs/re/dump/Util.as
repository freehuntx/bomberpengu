var §\x01§ = 434;
var §\x0f§ = 1;
class Util
{
   function Util()
   {
   }
   static function randomMinMax(minVal, maxVal)
   {
      return minVal + Math.floor(Math.random() * (maxVal + 1 - minVal));
   }
   static function calcDx(rot, speed)
   {
      return Math.sin(0.017453292519943295 * rot) * speed;
   }
   static function calcDy(rot, speed)
   {
      return (- Math.cos(0.017453292519943295 * rot)) * speed;
   }
   static function calcSpeed(myDx, myDy)
   {
      return Math.sqrt(myDx * myDx + myDy * myDy);
   }
   static function calcAbstand(x1, y1, x2, y2)
   {
      var _loc2_ = x1 - x2;
      var _loc1_ = y1 - y2;
      return Math.sqrt(_loc2_ * _loc2_ + _loc1_ * _loc1_);
   }
   static function getPoint(p, radius, winkel)
   {
      var _loc2_ = p.x + radius * Math.cos(0.017453292519943295 * (-90 + winkel));
      var _loc1_ = p.y + radius * Math.sin(0.017453292519943295 * (-90 + winkel));
      return new Point(_loc2_,_loc1_);
   }
   static function calcRot(myDx, myDy)
   {
      if(myDx > 0)
      {
         return 90 + Math.atan(myDy / myDx) / 0.017453292519943295;
      }
      return -90 + Math.atan(myDy / myDx) / 0.017453292519943295;
   }
   static function calcAngelAbs(dirAngle, hitAngle)
   {
      var _loc1_ = hitAngle - dirAngle;
      return Util.calcAngelRel(dirAngle,_loc1_);
   }
   static function calcAngelRel(dirAngle, hitAngle)
   {
      var _loc1_ = dirAngle + 180 + hitAngle + hitAngle;
      if(_loc1_ > 180)
      {
         _loc1_ -= 360;
      }
      return _loc1_;
   }
   static function testCalcAngelAbs()
   {
      trace("testCalcAngelAbs()");
      trace(Util.calcAngelAbs(0,0) + " must be " + 180);
      trace(Util.calcAngelAbs(0,75) + " must be " + -30);
      trace(Util.calcAngelAbs(-45,0) + " must be " + -135);
      trace(Util.calcAngelAbs(-165,-130) + " must be " + 85);
      trace(Util.calcAngelAbs(140,115) + " must be " + -90);
   }
   static function testCalcAngelRel()
   {
      trace("testCalcAngelRel()");
      trace(Util.calcAngelRel(0,0) + " must be " + 180);
      trace(Util.calcAngelRel(0,75) + " must be " + -30);
      trace(Util.calcAngelRel(90,0) + " must be " + -90);
      trace(Util.calcAngelRel(-45,45) + " must be " + -135);
      trace(Util.calcAngelRel(-165,35) + " must be " + 85);
      trace(Util.calcAngelRel(140,-25) + " must be " + -90);
   }
   static function cleanMsg(msg)
   {
      msg = msg.split("\"").join("\'");
      msg = msg.split("&").join("+");
      msg = msg.split("<").join("(");
      msg = msg.split(">").join(")");
      msg = msg.split("[").join("(");
      msg = msg.split("]").join(")");
      return msg;
   }
}
