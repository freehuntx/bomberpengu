var §\x01§ = 727;
var §\x0f§ = 1;
class BombManager
{
   static var nextId;
   static var bombArray;
   function BombManager()
   {
   }
   static function remoteStopBomb(xx, yy, ii, tt)
   {
      var _loc1_ = BombManager.getBombById(ii);
      if(_loc1_.exploded == false)
      {
         Game.debugMsg(_loc1_ + " remoteStopBomb t:" + tt);
         _loc1_.startTime = getTimer() - _loc1_.TIME_TO_EXPLODE + tt;
         _loc1_.moving = false;
         _loc1_.remoteKicked = true;
         _loc1_._x = Grid.arrayPosToX(xx);
         _loc1_._y = Grid.arrayPosToY(yy);
         _loc1_.xPos = xx;
         _loc1_.yPos = yy;
      }
   }
   static function remoteExplode(xx, yy, ii)
   {
      var _loc1_ = BombManager.getBombById(ii);
      Game.debugMsg(_loc1_ + " remoteExplode ii:" + ii);
      if(_loc1_.exploded == false)
      {
         _loc1_._x = Grid.arrayPosToX(xx);
         _loc1_._y = Grid.arrayPosToY(yy);
         _loc1_.xPos = xx;
         _loc1_.yPos = yy;
         _loc1_.explode();
      }
   }
   static function setBombGetId(bomb)
   {
      bomb.moveId = BombManager.nextId;
      BombManager.nextId++;
      BombManager.bombArray.push(bomb);
   }
   static function setBomb(bomb)
   {
      if(bomb.moveId == null)
      {
         Game.debugMsg("setBomb no Id");
      }
      BombManager.bombArray.push(bomb);
   }
   static function getBombById(idd)
   {
      var _loc1_ = 0;
      while(_loc1_ < BombManager.bombArray.length)
      {
         if(BombManager.bombArray[_loc1_].moveId == idd)
         {
            return BombManager.bombArray[_loc1_];
         }
         _loc1_ = _loc1_ + 1;
      }
      Game.debugMsg("getBombById:" + idd + " not found *************************");
      return null;
   }
}
