var §\x01§ = 759;
var §\x0f§ = 1;
class Bliz extends BaseStone
{
   var startTime;
   var now;
   static var TIME_TO_HIDE = 500;
   function Bliz()
   {
      super();
      this.startTime = getTimer();
   }
   function onEnterFrame()
   {
      if(this._visible)
      {
         this.now = getTimer();
         if(this.now > Bliz.TIME_TO_HIDE + this.startTime)
         {
            this.dispose();
            return undefined;
         }
      }
   }
   function dispose()
   {
      this._visible = false;
      var _loc3_ = Game.grid.getStoneBlizArray(this.xPos,this.yPos);
      if(_loc3_ == this)
      {
         var _loc2_ = new BaseStone();
         _loc2_.sType = BaseStone.FREE;
         _loc2_.xPos = this.xPos;
         _loc2_.yPos = this.yPos;
         if(this.xPos != null && this.yPos != null)
         {
            Game.grid.setStoneBlizArray(this.xPos,this.yPos,_loc2_);
         }
         else
         {
            Game.debugMsg("ERROR  xPos or yPos == null Bliz.dispose()");
         }
      }
      this.removeMovieClip();
   }
}
