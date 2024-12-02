var §\x01§ = 425;
var §\x0f§ = 1;
class Bomb extends BaseStone
{
   var startTime;
   var now;
   var player;
   static var TIME_TO_EXPLODE = 3500;
   var exploded = false;
   var kicked = false;
   var kickedBy = null;
   var remoteKicked = false;
   var moving = false;
   var dx = 0;
   var dy = 0;
   var moveId = null;
   function Bomb()
   {
      super();
      this.startTime = getTimer();
   }
   function onEnterFrame()
   {
      if(this._visible)
      {
         this.now = getTimer();
         if(this.now > Bomb.TIME_TO_EXPLODE + this.startTime)
         {
            if(this.exploded == false && this.remoteKicked == false)
            {
               this.explode();
            }
         }
         if(this.moving)
         {
            this._x += this.dx * Game.diffUpdate;
            this._y += this.dy * Game.diffUpdate;
            if(this._x < 20)
            {
               this._x = 20;
            }
            if(this._y < 20)
            {
               this._y = 20;
            }
            if(this._x > 500)
            {
               this._x = 500;
            }
            if(this._y > 420)
            {
               this._y = 420;
            }
            var _loc6_ = 20;
            var _loc2_ = 0;
            var _loc3_ = 0;
            if(this.dx > 0)
            {
               _loc2_ = _loc6_;
            }
            if(this.dx < 0)
            {
               _loc2_ = - _loc6_;
            }
            if(this.dy > 0)
            {
               _loc3_ = _loc6_;
            }
            if(this.dy < 0)
            {
               _loc3_ = - _loc6_;
            }
            if(this.kickedBy != Game.thisPlayer && Game.thisPlayer.hitTest(this._x + _loc2_ + 100,this._y + _loc3_ + 20,false))
            {
               Game.debugMsg("thisPlayerHit ");
               this._x = Grid.arrayPosToX(this.xPos);
               this._y = Grid.arrayPosToY(this.yPos);
               Game.thisPlayer._x = this._x + _loc2_ * 2 + 100;
               Game.thisPlayer._y = this._y + _loc3_ * 2 + 20;
               this.stopBomb();
               return undefined;
            }
            var _loc10_ = Grid.xToArrayPos(this._x + _loc2_);
            var _loc9_ = Grid.yToArrayPos(this._y + _loc3_);
            var _loc8_ = Game.grid.getStone(_loc10_,_loc9_);
            if(_loc8_ != this && !_loc8_.canEnter())
            {
               Game.debugMsg("can\'t enter " + _loc8_ + " sType:" + _loc8_.sType + " nX:" + _loc10_ + " xY:" + _loc9_);
               this.moving = false;
               this._x = Grid.arrayPosToX(this.xPos);
               this._y = Grid.arrayPosToY(this.yPos);
               return undefined;
            }
            var _loc5_ = Grid.xToArrayPos(this._x + _loc2_);
            var _loc4_ = Grid.yToArrayPos(this._y + _loc3_);
            if(this.xPos != _loc5_ || this.yPos != _loc4_)
            {
               var _loc11_ = Game.grid.getStone(_loc5_,_loc4_);
               Game.debugMsg("can enter" + _loc11_ + " sType:" + _loc11_.sType);
               if(this.oldStone != null)
               {
                  if(this.oldStone.sType == undefined)
                  {
                     var _loc7_ = new BaseStone();
                     _loc7_.xPos = this.xPos;
                     _loc7_.yPos = this.yPos;
                     _loc7_.sType = BaseStone.FREE;
                     this.oldStone = _loc7_;
                     Game.debugMsg("undefined");
                  }
                  Game.grid.grid[this.yPos][this.xPos] = this.oldStone;
               }
               else
               {
                  _loc7_ = new BaseStone();
                  _loc7_.xPos = this.xPos;
                  _loc7_.yPos = this.yPos;
                  _loc7_.sType = BaseStone.FREE;
                  Game.grid.grid[this.yPos][this.xPos] = _loc7_;
               }
               this.oldStone = Game.grid.grid[_loc4_][_loc5_];
               Game.grid.grid[_loc4_][_loc5_] = this;
               this.xPos = _loc5_;
               this.yPos = _loc4_;
            }
         }
      }
   }
   function kick(dxx, dyy)
   {
      if(dxx < 0 && this.xPos <= 0)
      {
         return undefined;
      }
      if(dyy < 0 && this.yPos <= 0)
      {
         return undefined;
      }
      if(dxx > 0 && this.xPos >= 12)
      {
         return undefined;
      }
      if(dyy > 0 && this.yPos >= 10)
      {
         return undefined;
      }
      if(this.kickedBy != Game.thisPlayer)
      {
         SoundPlayer.playV("Landing.wav",80);
         this.remoteKicked = false;
         this.kickedBy = Game.thisPlayer;
         this.moving = true;
         this.kicked = true;
         this.dx = dxx;
         this.dy = dyy;
         if(this.moveId == null)
         {
            BombManager.setBombGetId(this);
         }
         Game.debugMsg(this + " kick id:" + this.moveId);
         Game.sendPrio1Msg("<19 c=\"" + Game.newKeyCode + "\" x=\"" + Math.round(Game.thisPlayer._x) + "\"  y=\"" + Math.round(Game.thisPlayer._y) + "\" xp=\"" + this.xPos + "\" yp=\"" + this.yPos + "\" i=\"" + this.moveId + "\" dx=\"" + dxx + "\" dy=\"" + dyy + "\" t=\"" + (this.startTime + Bomb.TIME_TO_EXPLODE - this.now) + "\"/>\n");
         Game.oldKeyCode = Game.newKeyCode;
      }
   }
   function remoteKick(dxx, dyy, tt, ii)
   {
      Game.debugMsg(this + " remoteKick id:" + ii);
      SoundPlayer.playV("Landing.wav",80);
      this.kickedBy = Game.remotePlayer;
      this.remoteKicked = true;
      this.startTime = getTimer() - Bomb.TIME_TO_EXPLODE + tt;
      this.moving = true;
      this.kicked = true;
      this.dx = dxx;
      this.dy = dyy;
      if(this.moveId == null)
      {
         this.moveId = ii;
         BombManager.setBomb(this);
      }
   }
   function stopBomb()
   {
      if(this.moving)
      {
         Game.debugMsg("stopBomb");
         this.remoteKicked = false;
         this.moving = false;
         this._x = Grid.arrayPosToX(this.xPos);
         this._y = Grid.arrayPosToY(this.yPos);
         Game.sendPrio1Msg("<11 c=\"" + Game.newKeyCode + "\" x=\"" + Math.round(Game.thisPlayer._x) + "\"  y=\"" + Math.round(Game.thisPlayer._y) + "\" i=\"" + this.moveId + "\" xp=\"" + this.xPos + "\" yp=\"" + this.yPos + "\" t=\"" + (this.startTime + Bomb.TIME_TO_EXPLODE - this.now) + "\"/>\n");
         Game.oldKeyCode = Game.newKeyCode;
      }
   }
   function explode()
   {
      if(this.exploded == false)
      {
         SoundPlayer.playV("Explode1.wav",80);
         if(this.kicked && this.remoteKicked == false)
         {
            Game.sendPrio1Msg("<10 c=\"" + Game.newKeyCode + "\" x=\"" + Math.round(Game.thisPlayer._x) + "\"  y=\"" + Math.round(Game.thisPlayer._y) + "\" i=\"" + this.moveId + "\" xp=\"" + this.xPos + "\" yp=\"" + this.yPos + "\"/>\n");
            Game.oldKeyCode = Game.newKeyCode;
         }
         if(this.kicked)
         {
            this.kicked = false;
            this.moving = false;
            this._x = Grid.arrayPosToX(this.xPos);
            this._y = Grid.arrayPosToY(this.yPos);
         }
         this.startTime = 0;
         this.exploded = true;
         this.oldStone.dispose();
         this.oldStone = null;
         Game.grid.setBliz(this.xPos,this.yPos,this.player,newRot,2);
         var _loc5_ = 0;
         while(_loc5_ < this.player.numBliz)
         {
            var _loc4_ = this.xPos + _loc5_ + 1;
            var _loc3_ = this.yPos;
            var newRot = 90;
            var _loc2_ = Game.grid.grid[_loc3_][_loc4_];
            if(_loc2_.sType == BaseStone.FREE)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
            }
            if(_loc2_.sType == BaseStone.BOMBE || _loc2_.sType == BaseStone.SPEEDUP || _loc2_.sType == BaseStone.BLIZ || _loc2_.sType == BaseStone.KICK_BOMB)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
               _loc2_.hitByBliz();
               break;
            }
            if(_loc2_.sType == BaseStone.KISTE)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
               _loc2_.dispose();
               trace("kiste hit");
               break;
            }
            if(_loc2_.sType == BaseStone.STONE)
            {
               break;
            }
            if(_loc2_.sType == BaseStone.ARMED_BOMB)
            {
               var _loc6_ = Bomb(_loc2_);
               _loc6_.explode();
               break;
            }
            _loc5_ = _loc5_ + 1;
         }
         _loc5_ = 0;
         while(_loc5_ < this.player.numBliz)
         {
            _loc4_ = this.xPos - (_loc5_ + 1);
            _loc3_ = this.yPos;
            var newRot = 90;
            _loc2_ = Game.grid.grid[_loc3_][_loc4_];
            if(_loc2_.sType == BaseStone.FREE)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
            }
            if(_loc2_.sType == BaseStone.BOMBE || _loc2_.sType == BaseStone.SPEEDUP || _loc2_.sType == BaseStone.BLIZ || _loc2_.sType == BaseStone.KICK_BOMB)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
               _loc2_.hitByBliz();
               trace("extra hit");
               break;
            }
            if(_loc2_.sType == BaseStone.KISTE)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
               _loc2_.dispose();
               trace("kiste hit");
               break;
            }
            if(_loc2_.sType == BaseStone.STONE)
            {
               trace("Stone hit");
               break;
            }
            if(_loc2_.sType == BaseStone.ARMED_BOMB)
            {
               _loc6_ = Bomb(_loc2_);
               _loc6_.explode();
               break;
            }
            _loc5_ = _loc5_ + 1;
         }
         _loc5_ = 0;
         while(_loc5_ < this.player.numBliz)
         {
            _loc4_ = this.xPos;
            _loc3_ = this.yPos + _loc5_ + 1;
            var newRot = 0;
            _loc2_ = Game.grid.grid[_loc3_][_loc4_];
            if(_loc2_.sType == BaseStone.FREE)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
            }
            if(_loc2_.sType == BaseStone.BOMBE || _loc2_.sType == BaseStone.SPEEDUP || _loc2_.sType == BaseStone.BLIZ || _loc2_.sType == BaseStone.KICK_BOMB)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
               _loc2_.hitByBliz();
               trace("extra hit");
               break;
            }
            if(_loc2_.sType == BaseStone.KISTE)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
               _loc2_.dispose();
               trace("kiste hit");
               break;
            }
            if(_loc2_.sType == BaseStone.STONE)
            {
               trace("Stone hit");
               break;
            }
            if(_loc2_.sType == BaseStone.ARMED_BOMB)
            {
               _loc6_ = Bomb(_loc2_);
               _loc6_.explode();
               break;
            }
            _loc5_ = _loc5_ + 1;
         }
         _loc5_ = 0;
         while(_loc5_ < this.player.numBliz)
         {
            _loc4_ = this.xPos;
            _loc3_ = this.yPos - (_loc5_ + 1);
            var newRot = 0;
            _loc2_ = Game.grid.grid[_loc3_][_loc4_];
            if(_loc2_.sType == BaseStone.FREE)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
            }
            if(_loc2_.sType == BaseStone.BOMBE || _loc2_.sType == BaseStone.SPEEDUP || _loc2_.sType == BaseStone.BLIZ || _loc2_.sType == BaseStone.KICK_BOMB)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
               _loc2_.hitByBliz();
               trace("extra hit");
               break;
            }
            if(_loc2_.sType == BaseStone.KISTE)
            {
               Game.grid.setBliz(_loc4_,_loc3_,this.player,newRot,1);
               _loc2_.dispose();
               trace("kiste hit");
               break;
            }
            if(_loc2_.sType == BaseStone.STONE)
            {
               trace("Stone hit");
               break;
            }
            if(_loc2_.sType == BaseStone.ARMED_BOMB)
            {
               _loc6_ = Bomb(_loc2_);
               _loc6_.explode();
               break;
            }
            _loc5_ = _loc5_ + 1;
         }
         this.player.bombsSet--;
         this.dispose();
      }
   }
}
