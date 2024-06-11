var §\x01§ = 543;
var §\x0f§ = 1;
class MyPlayer extends MovieClip
{
   var targetX;
   var lastSend;
   var pointsTxt;
   var pengu;
   var MAX_SPEED = 0.18;
   var SPEED_STEP = 0.01;
   var DIST_TO_DIE = 18;
   var KICK_SPEED = 0.1;
   var speed = 0.15;
   var numBombs = 1;
   var numBliz = 2;
   var kickBomb = false;
   var bombsSet = 0;
   var leftBorder = 120;
   var rightBorder = 600;
   var upperBorder = 40;
   var lowerBorder = 440;
   var right = false;
   var left = false;
   var up = false;
   var down = false;
   var space = false;
   var spaceReleased = true;
   var dx = 0;
   var dy = 0;
   var points = 0;
   var xxPos = 0;
   var yyPos = 0;
   function MyPlayer()
   {
      super();
      trace("Player() " + this);
      this.targetX = this._x;
      this.lastSend = this._x;
   }
   function addPoint()
   {
      this.points++;
      this.pointsTxt.text = String(this.points);
   }
   static function xToArrayPos(x)
   {
      var _loc1_ = (x - 20) % 40;
      return (x - 20 - _loc1_) / 40 - 2;
   }
   static function yToArrayPos(y)
   {
      var _loc1_ = (y + 20) % 40;
      return (y + 20 - _loc1_) / 40 - 1;
   }
   function setMitArrayY()
   {
      var _loc2_ = MyPlayer.yToArrayPos(this._y);
      this._y = Grid.arrayPosToY(_loc2_) + 20;
   }
   function setMitArrayX()
   {
      var _loc2_ = MyPlayer.yToArrayPos(this._x);
      this._x = Grid.arrayPosToY(_loc2_) + 20;
   }
   function getStone(x, y)
   {
      var _loc1_ = MyPlayer.xToArrayPos(x);
      var _loc2_ = MyPlayer.yToArrayPos(y);
      if(_loc1_ < 0 || _loc2_ < 0 || _loc1_ > 12 || _loc2_ > 10)
      {
         return BaseStone.BANNED;
      }
      return Game.grid.grid[_loc2_][_loc1_];
   }
   function removePowerUp(x, y, s, b)
   {
      this.speed = s;
      this.numBliz = b;
      var _loc2_ = Game.grid.grid[y][x];
      _loc2_.dispose();
   }
   function printDebugInfo()
   {
      var _loc2_ = this.getStone(this._x,this._y);
      Game.debugMsg(_loc2_ + " type:" + _loc2_.sType + " x:" + _loc2_.xPos + " y:" + _loc2_.yPos + " xPos:" + this.xxPos);
   }
   function update()
   {
      this.xxPos = MyPlayer.xToArrayPos(this._x);
      this.yyPos = MyPlayer.yToArrayPos(this._y);
      if(this == Game.thisPlayer)
      {
         var _loc4_ = this.getStone(this._x,this._y);
         if(_loc4_.sType == BaseStone.BOMBE || _loc4_.sType == BaseStone.SPEEDUP || _loc4_.sType == BaseStone.BLIZ || _loc4_.sType == BaseStone.KICK_BOMB)
         {
            SoundPlayer.playV("pling2.wav",80);
            if(_loc4_.sType == BaseStone.BOMBE)
            {
               this.numBombs++;
            }
            if(_loc4_.sType == BaseStone.SPEEDUP)
            {
               if(this.speed < this.MAX_SPEED)
               {
                  this.speed += this.SPEED_STEP;
               }
               else
               {
                  this.speed = this.MAX_SPEED;
               }
            }
            if(_loc4_.sType == BaseStone.BLIZ)
            {
               this.numBliz++;
            }
            if(_loc4_.sType == BaseStone.KICK_BOMB)
            {
               this.kickBomb = true;
            }
            Game.sendPrio1Msg("<18 c=\"" + Game.newKeyCode + "\" x=\"" + Math.round(Game.thisPlayer._x) + "\"  y=\"" + Math.round(Game.thisPlayer._y) + "\" xp=\"" + this.xxPos + "\" yp=\"" + this.yyPos + "\" s=\"" + this.speed + "\" b=\"" + this.numBliz + "\" />\n");
            Game.oldKeyCode = Game.newKeyCode;
            _loc4_.dispose();
         }
      }
      if(this.space && this.spaceReleased)
      {
         this.spaceReleased = false;
         var _loc6_ = this.getStone(this._x,this._y);
         if(_loc6_.sType == BaseStone.FREE)
         {
            if(this.bombsSet < this.numBombs)
            {
               if(this.getStone(this._x,this._y).canEnter())
               {
                  SoundPlayer.playV("Donk.wav",80);
                  this.bombsSet++;
                  Game.grid.setBomb(this.xxPos,this.yyPos,this);
                  Game.sendPrio1Msg("<17 c=\"" + Game.newKeyCode + "\" x=\"" + Math.round(Game.thisPlayer._x) + "\"  y=\"" + Math.round(Game.thisPlayer._y) + "\" xp=\"" + this.xxPos + "\" yp=\"" + this.yyPos + "\"/>\n");
                  Game.oldKeyCode = Game.newKeyCode;
               }
            }
         }
      }
      if(this.right)
      {
         _loc4_ = this.getStone(this._x + 21,this._y);
         if(_loc4_.canEnter())
         {
            if(this == Game.thisPlayer)
            {
               var _loc7_ = Game.grid.getStoneBlizArray(MyPlayer.xToArrayPos(this._x + this.DIST_TO_DIE),MyPlayer.yToArrayPos(this._y));
               if(_loc7_.sType == BaseStone.ARMED_BLIZ)
               {
                  Game.thisPlayerDie();
               }
            }
            this.dx = this.getDxDy();
            var _loc3_ = this._y % 40;
            if(_loc3_ < 20)
            {
               if(_loc3_ > this.dx)
               {
                  this._y -= this.dx;
                  this.dx = 0;
               }
               else
               {
                  this._y -= _loc3_;
                  this.dx -= _loc3_;
               }
            }
            else if(40 - _loc3_ > this.dx)
            {
               this._y += this.dx;
               this.dx = 0;
            }
            else
            {
               this._y += 40 - _loc3_;
               this.dx -= 40 - _loc3_;
            }
            this._x += this.dx;
            if(this._x > this.rightBorder)
            {
               this._x = this.rightBorder;
            }
         }
         else
         {
            this.setMitArrayX();
            if(this == Game.thisPlayer)
            {
               if(_loc4_.sType == BaseStone.ARMED_BOMB)
               {
                  var _loc5_ = this.getStone(this._x,this._y);
                  if(_loc5_.sType != BaseStone.ARMED_BOMB)
                  {
                     var _loc8_ = Bomb(_loc4_);
                     if(this.kickBomb)
                     {
                        _loc8_.kick(this.KICK_SPEED,0);
                     }
                  }
               }
            }
         }
      }
      else if(this.left)
      {
         _loc4_ = this.getStone(this._x - 21,this._y);
         if(_loc4_.canEnter())
         {
            if(this == Game.thisPlayer)
            {
               _loc7_ = Game.grid.getStoneBlizArray(MyPlayer.xToArrayPos(this._x - this.DIST_TO_DIE),MyPlayer.yToArrayPos(this._y));
               if(_loc7_.sType == BaseStone.ARMED_BLIZ)
               {
                  Game.thisPlayerDie();
               }
            }
            this.dx = this.getDxDy();
            _loc3_ = this._y % 40;
            if(_loc3_ < 20)
            {
               if(_loc3_ > this.dx)
               {
                  this._y -= this.dx;
                  this.dx = 0;
               }
               else
               {
                  this._y -= _loc3_;
                  this.dx -= _loc3_;
               }
            }
            else if(40 - _loc3_ > this.dx)
            {
               this._y += this.dx;
               this.dx = 0;
            }
            else
            {
               this._y += 40 - _loc3_;
               this.dx -= 40 - _loc3_;
            }
            this._x -= this.dx;
            if(this._x < this.leftBorder)
            {
               this._x = this.leftBorder;
            }
         }
         else
         {
            this.setMitArrayX();
            if(this == Game.thisPlayer)
            {
               if(_loc4_.sType == BaseStone.ARMED_BOMB)
               {
                  _loc5_ = this.getStone(this._x,this._y);
                  if(_loc5_.sType != BaseStone.ARMED_BOMB)
                  {
                     _loc8_ = Bomb(_loc4_);
                     if(this.kickBomb)
                     {
                        _loc8_.kick(- this.KICK_SPEED,0);
                     }
                  }
               }
            }
         }
      }
      else
      {
         this.dx = 0;
      }
      if(this.up)
      {
         _loc4_ = this.getStone(this._x,this._y - 21);
         if(_loc4_.canEnter())
         {
            if(this == Game.thisPlayer)
            {
               _loc7_ = Game.grid.getStoneBlizArray(MyPlayer.xToArrayPos(this._x),MyPlayer.yToArrayPos(this._y - this.DIST_TO_DIE));
               if(_loc7_.sType == BaseStone.ARMED_BLIZ)
               {
                  Game.thisPlayerDie();
               }
            }
            var _loc2_ = this._x % 40;
            this.dy = this.getDxDy();
            if(_loc2_ < 20)
            {
               if(_loc2_ > this.dy)
               {
                  this._x -= this.dy;
                  this.dy = 0;
               }
               else
               {
                  this._x -= _loc2_;
                  this.dy -= _loc2_;
               }
            }
            else if(40 - _loc2_ > this.dy)
            {
               this._x += this.dy;
               this.dy = 0;
            }
            else
            {
               this._x += 40 - _loc2_;
               this.dy -= 40 - _loc2_;
            }
            this._y -= this.dy;
            if(this._y < this.upperBorder)
            {
               this._y = this.upperBorder;
            }
         }
         else
         {
            this.setMitArrayY();
            if(this == Game.thisPlayer)
            {
               if(_loc4_.sType == BaseStone.ARMED_BOMB)
               {
                  _loc5_ = this.getStone(this._x,this._y);
                  if(_loc5_.sType != BaseStone.ARMED_BOMB)
                  {
                     _loc8_ = Bomb(_loc4_);
                     if(this.kickBomb)
                     {
                        _loc8_.kick(0,- this.KICK_SPEED);
                     }
                  }
               }
            }
         }
      }
      else if(this.down)
      {
         _loc4_ = this.getStone(this._x,this._y + 21);
         if(_loc4_.canEnter())
         {
            if(this == Game.thisPlayer)
            {
               _loc7_ = Game.grid.getStoneBlizArray(MyPlayer.xToArrayPos(this._x),MyPlayer.yToArrayPos(this._y + this.DIST_TO_DIE));
               if(_loc7_.sType == BaseStone.ARMED_BLIZ)
               {
                  Game.thisPlayerDie();
               }
            }
            this.dy = this.getDxDy();
            _loc2_ = this._x % 40;
            if(_loc2_ < 20)
            {
               if(_loc2_ > this.dy)
               {
                  this._x -= this.dy;
                  this.dy = 0;
               }
               else
               {
                  this._x -= _loc2_;
                  this.dy -= _loc2_;
               }
            }
            else if(40 - _loc2_ > this.dy)
            {
               this._x += this.dy;
               this.dy = 0;
            }
            else
            {
               this._x += 40 - _loc2_;
               this.dy -= 40 - _loc2_;
            }
            this.dy = this.getDxDy();
            this._y += this.dy;
            if(this._y > this.lowerBorder)
            {
               this._y = this.lowerBorder;
            }
         }
         else
         {
            this.setMitArrayY();
            if(this == Game.thisPlayer)
            {
               if(_loc4_.sType == BaseStone.ARMED_BOMB)
               {
                  _loc5_ = this.getStone(this._x,this._y);
                  if(_loc5_.sType != BaseStone.ARMED_BOMB)
                  {
                     _loc8_ = Bomb(_loc4_);
                     if(this.kickBomb)
                     {
                        _loc8_.kick(0,this.KICK_SPEED);
                     }
                  }
               }
            }
         }
      }
      else
      {
         this.dy = 0;
      }
   }
   function getDxDy()
   {
      var _loc2_ = this.speed * Game.diffUpdate;
      if(_loc2_ > 20)
      {
         _loc2_ = 20;
      }
      return _loc2_;
   }
   function die()
   {
      this.pengu.gotoAndStop("tot");
   }
   function go()
   {
      this.pengu.gotoAndPlay("go");
   }
   function oben()
   {
      this.pengu.gotoAndPlay("oben");
   }
   function unten()
   {
      this.pengu.gotoAndPlay("unten");
   }
   function stand()
   {
      this.pengu.gotoAndStop("stand");
   }
   function remoteCommand(c, x, y)
   {
      this._x = x;
      this._y = y;
      var _loc3_ = c.charAt(0);
      if(c.charAt(0) == "1")
      {
         this.left = true;
         if(this._xscale > 0)
         {
            this._xscale *= -1;
         }
      }
      else
      {
         this.left = false;
      }
      if(c.charAt(1) == "1")
      {
         this.up = true;
      }
      else
      {
         this.up = false;
      }
      if(c.charAt(2) == "1")
      {
         this.right = true;
         if(this._xscale < 0)
         {
            this._xscale *= -1;
         }
      }
      else
      {
         this.right = false;
      }
      if(c.charAt(3) == "1")
      {
         this.down = true;
      }
      else
      {
         this.down = false;
      }
      if(!this.left && !this.right)
      {
         this.stand();
      }
      else
      {
         this.go();
      }
      if(this.up)
      {
         this.oben();
      }
      else if(this.down)
      {
         this.unten();
      }
      else if(!this.left && !this.right)
      {
         this.stand();
      }
   }
}
