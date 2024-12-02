var §\x01§ = 550;
var §\x0f§ = 1;
class Grid extends MovieClip
{
   var counter;
   var grid;
   var bGrid;
   var NUM_KISTEN = 65;
   var NUM_BOMBEN = 10;
   var NUM_SPEEDUP = 6;
   var NUM_BLIZE = 6;
   var NUM_KICK_BOMB = 6;
   function Grid()
   {
      super();
      trace("Grid()");
   }
   function init()
   {
      this.counter = 100;
      this.grid = [[9,9,9,0,0,0,0,0,0,0,0,0,0],[9,1,0,1,0,1,0,1,0,1,0,1,0],[9,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,1,0,1,0,1,0,1,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,1,0,1,0,1,0,1,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,1,0,1,0,1,0,1,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,9],[0,1,0,1,0,1,0,1,0,1,0,1,9],[0,0,0,0,0,0,0,0,0,0,9,9,9]];
      this.bGrid = [[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0]];
      this.setSolidStones();
      this.setStones();
      this.deleteBanned();
   }
   function onMouseDown()
   {
      var _loc3_ = this.getStone(Grid.xToArrayPos(_root._xmouse - 100),Grid.yToArrayPos(_root._ymouse - 20));
      Game.debugMsg(_loc3_ + " type:" + _loc3_.sType + " x:" + _loc3_.xPos + " y:" + _loc3_.yPos);
   }
   function setSolidStones()
   {
      var _loc3_ = 0;
      while(_loc3_ < 11)
      {
         var _loc2_ = 0;
         while(_loc2_ < 13)
         {
            if(this.grid[_loc3_][_loc2_] == BaseStone.STONE)
            {
               this.attachMovie("Stein","Stein" + this.counter,this.counter);
               this.grid[_loc3_][_loc2_] = this["Stein" + this.counter];
               this.grid[_loc3_][_loc2_]._x = 40 * _loc2_ + 20;
               this.grid[_loc3_][_loc2_]._y = 40 * _loc3_ + 20;
               this.grid[_loc3_][_loc2_].sType = BaseStone.STONE;
            }
            this.counter++;
            _loc2_ = _loc2_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function setStones()
   {
      var _loc6_ = 0;
      var _loc9_ = 0;
      var _loc7_ = 0;
      var _loc8_ = 0;
      var _loc5_ = 0;
      var _loc4_ = BaseStone.KISTE;
      while(_loc6_ < this.NUM_KISTEN)
      {
         var _loc3_ = MyMath.randomMinMax(0,12);
         var _loc2_ = MyMath.randomMinMax(0,10);
         if(this.grid[_loc2_][_loc3_] == 0)
         {
            if(_loc9_ < this.NUM_BOMBEN)
            {
               _loc4_ = BaseStone.BOMBE;
               _loc9_ = _loc9_ + 1;
            }
            else if(_loc7_ < this.NUM_SPEEDUP)
            {
               _loc4_ = BaseStone.SPEEDUP;
               _loc7_ = _loc7_ + 1;
            }
            else if(_loc8_ < this.NUM_BLIZE)
            {
               _loc4_ = BaseStone.BLIZ;
               _loc8_ = _loc8_ + 1;
            }
            else if(_loc5_ < this.NUM_KICK_BOMB)
            {
               _loc4_ = BaseStone.KICK_BOMB;
               _loc5_ = _loc5_ + 1;
            }
            else
            {
               _loc4_ = BaseStone.KISTE;
            }
            _loc6_ = _loc6_ + 1;
            this.counter++;
            this.attachMovie("Box","Box" + this.counter,this.counter);
            this.grid[_loc2_][_loc3_] = this["Box" + this.counter];
            this.grid[_loc2_][_loc3_]._x = 40 * _loc3_ + 20;
            this.grid[_loc2_][_loc3_]._y = 40 * _loc2_ + 20;
            this.grid[_loc2_][_loc3_].xPos = _loc3_;
            this.grid[_loc2_][_loc3_].yPos = _loc2_;
            this.grid[_loc2_][_loc3_].sType = _loc4_;
         }
      }
   }
   function getStone(x, y)
   {
      if(x >= 0 && y >= 0 && x < 13 && y < 11)
      {
         return this.grid[y][x];
      }
      var _loc2_ = new BaseStone();
      _loc2_.sType = BaseStone.STONE;
      return _loc2_;
   }
   function remoteKickBomb(xx, yy, dx, dy, t, ii)
   {
      var _loc2_ = this.getStone(xx,yy);
      var _loc3_ = Bomb(_loc2_);
      _loc3_.remoteKick(dx,dy,t,ii);
   }
   function getBomb(nr)
   {
      this.counter++;
      var _loc2_ = "Bomb" + nr;
      this.attachMovie(_loc2_,_loc2_ + this.counter,this.counter);
      return this[_loc2_ + this.counter];
   }
   function setBomb(x, y, player)
   {
      var _loc2_ = this.getBomb(player.playerNr);
      _loc2_._x = Grid.arrayPosToX(x);
      _loc2_._y = Grid.arrayPosToY(y);
      _loc2_.xPos = x;
      _loc2_.yPos = y;
      _loc2_.player = player;
      _loc2_.sType = BaseStone.ARMED_BOMB;
      this.grid[y][x] = _loc2_;
   }
   function getStoneBlizArray(x, y)
   {
      if(x >= 0 && y >= 0 && x < 13 && y < 11)
      {
         return this.bGrid[y][x];
      }
      var _loc2_ = new BaseStone();
      _loc2_.sType = BaseStone.STONE;
      return _loc2_;
   }
   function setStoneBlizArray(x, y, st)
   {
      this.bGrid[y][x] = st;
   }
   function getBliz(nr, typ)
   {
      this.counter++;
      var _loc2_ = "Explosion" + nr;
      if(typ == 2)
      {
         _loc2_ += "Mitte";
      }
      this.attachMovie(_loc2_,_loc2_ + this.counter,this.counter);
      return this[_loc2_ + this.counter];
   }
   function setBliz(x, y, player, rot, typ)
   {
      var _loc2_ = this.getBliz(player.playerNr,typ);
      _loc2_._x = Grid.arrayPosToX(x);
      _loc2_._y = Grid.arrayPosToY(y);
      _loc2_.xPos = x;
      _loc2_.yPos = y;
      _loc2_.player = player;
      _loc2_.sType = BaseStone.ARMED_BLIZ;
      _loc2_._rotation = rot;
      Game.testPlayerHit(x,y);
      var _loc3_ = this.grid[y][x];
      if(_loc3_.sType == BaseStone.BOMBE || _loc3_.sType == BaseStone.SPEEDUP || _loc3_.sType == BaseStone.BLIZ || _loc3_.sType == BaseStone.KICK_BOMB)
      {
         if(_loc3_.isOpen == false)
         {
         }
      }
      this.bGrid[y][x] = _loc2_;
   }
   static function arrayPosToX(x)
   {
      return x * 40 + 20;
   }
   static function arrayPosToY(y)
   {
      return y * 40 + 20;
   }
   static function xToArrayPos(x)
   {
      if(x <= 40)
      {
         return 0;
      }
      if(x <= 0)
      {
         return -1;
      }
      var _loc2_ = x % 40;
      return (x + 40 - _loc2_) / 40 - 1;
   }
   static function yToArrayPos(y)
   {
      if(y <= 40)
      {
         return 0;
      }
      if(y <= 0)
      {
         return -1;
      }
      var _loc2_ = y % 40;
      return (y + 40 - _loc2_) / 40 - 1;
   }
   function deleteBanned()
   {
      var _loc3_ = 0;
      while(_loc3_ < 11)
      {
         var _loc2_ = 0;
         while(_loc2_ < 13)
         {
            if(this.grid[_loc3_][_loc2_] == BaseStone.BANNED || this.grid[_loc3_][_loc2_] == BaseStone.FREE)
            {
               var _loc5_ = new BaseStone();
               _loc5_.sType = BaseStone.FREE;
               _loc5_.xPos = _loc2_;
               _loc5_.yPos = _loc3_;
               this.grid[_loc3_][_loc2_] = _loc5_;
            }
            var _loc4_ = new BaseStone();
            _loc4_.sType = BaseStone.FREE;
            _loc4_.xPos = _loc2_;
            _loc4_.yPos = _loc3_;
            this.bGrid[_loc3_][_loc2_] = _loc4_;
            _loc2_ = _loc2_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
}
