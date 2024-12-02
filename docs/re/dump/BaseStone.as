var §\x01§ = 559;
var §\x0f§ = 1;
class BaseStone extends MovieClip
{
   static var FREE = 0;
   static var STONE = 1;
   static var KISTE = 2;
   static var BOMBE = 3;
   static var SPEEDUP = 4;
   static var BLIZ = 5;
   static var KICK_BOMB = 6;
   static var ARMED_BOMB = 7;
   static var ARMED_BLIZ = 8;
   static var BANNED = 9;
   var sType = 0;
   var xPos = null;
   var yPos = null;
   var isOpen = false;
   var frame = 0;
   var oldStone = null;
   function BaseStone()
   {
      super();
   }
   function setArrayPos(x, y)
   {
      this.xPos = x;
      this.yPos = y;
   }
   function canEnter()
   {
      if(this.sType == BaseStone.FREE || this.sType == BaseStone.ARMED_BLIZ)
      {
         return true;
      }
      if(this.isOpen)
      {
         if(this.sType == BaseStone.FREE || this.sType == BaseStone.BOMBE || this.sType == BaseStone.SPEEDUP || this.sType == BaseStone.BLIZ || this.sType == BaseStone.KICK_BOMB)
         {
            return true;
         }
      }
      return false;
   }
   function dispose()
   {
      this._visible = false;
      var _loc2_ = new BaseStone();
      _loc2_.sType = BaseStone.FREE;
      _loc2_.xPos = this.xPos;
      _loc2_.yPos = this.yPos;
      if(this.xPos != null && this.yPos != null)
      {
         Game.grid.grid[this.yPos][this.xPos] = _loc2_;
      }
      else
      {
         Game.debugMsg("ERROR  xPos or yPos == null BaseStone.dispose()");
      }
      this.removeMovieClip();
   }
   function hitByBliz()
   {
      if(this.isOpen == false)
      {
         this.gotoAndStop(this.sType);
         this.isOpen = true;
      }
      else
      {
         Game.debugMsg("dispose " + this);
         this.dispose();
      }
   }
}
