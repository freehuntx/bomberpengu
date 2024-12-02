var §\x01§ = 106;
var §\x0f§ = 1;
class Game extends MovieClip
{
   static var grid;
   static var diffUpdate;
   static var thisPlayer;
   static var newKeyCode;
   static var oldKeyCode;
   static var remotePlayer;
   static var drawn;
   static var playerNr;
   static var pingSentTime;
   static var msgPrio1;
   static var startTime;
   static var state;
   static var player1;
   static var player2;
   static var hasWon;
   static var locked;
   static var gOCounter;
   static var gOBound;
   static var thisUpdate;
   static var lastUpdate;
   static var myFps;
   static var remoteFps;
   static var DEBUG = false;
   static var frame = 0;
   static var myPing = 100;
   static var pingIntervall = 10000;
   static var pingResultToOther = false;
   static var remotePing = 100;
   static var PLAYING = 0;
   static var INIT = 1;
   static var GAME_OVER = 2;
   static var WAITING = 3;
   function Game()
   {
      super();
      trace("Game()");
      Game.drawn = false;
      Game.pingSentTime = getTimer() - Game.pingIntervall + 1000;
      Game.msgPrio1 = false;
      Game.oldKeyCode = "0000";
      Game.frame = 0;
      Game.startTime = getTimer();
      Game.state = Game.INIT;
      Key.addListener(this);
      Game.player1 = _root.player1;
      Game.player2 = _root.player2;
      Game.player1.pointsTxt = _root.punkteP1;
      Game.player2.pointsTxt = _root.punkteP2;
      Game.player1.fpsTxt = _root.fpsP1;
      Game.player2.fpsTxt = _root.fpsP2;
      Game.player1.pingTxt = _root.pingP1;
      Game.player2.pingTxt = _root.pingP2;
      Game.player1._x = 120;
      Game.player1._y = 40;
      Game.player2._x = 600;
      Game.player2._y = 440;
      Game.player2._xscale *= -1;
      Game.hasWon = false;
      Game.locked = false;
      Game.gOCounter = 0;
      Game.gOBound = 120;
   }
   function onEnterFrame()
   {
      Game.msgPrio1 = false;
      Game.frame++;
      Game.thisUpdate = getTimer();
      Game.diffUpdate = Game.thisUpdate - Game.lastUpdate;
      if(Game.state == Game.PLAYING)
      {
         Game.thisPlayer.update();
         Game.remotePlayer.update();
         Game.sendKeyMsg();
      }
      else if(Game.state != Game.WAITING)
      {
         if(Game.state == Game.GAME_OVER)
         {
            Game.gOCounter++;
            if(Game.gOCounter > Game.gOBound)
            {
               if(Game.drawn)
               {
                  if(Game.hasWon)
                  {
                     Connector.sendGameMsg("<drawGame/>\n");
                  }
                  this.drawnGame();
                  return undefined;
               }
               if(Game.hasWon)
               {
                  Game.winGame();
               }
               else
               {
                  Game.loseGame();
               }
            }
         }
         else if(Game.state == Game.INIT)
         {
            if(Game.frame == 20)
            {
               if(Game.playerNr == 1)
               {
                  Game.reset();
                  Game.sendRandomSeed();
                  Game.state = Game.PLAYING;
               }
               else
               {
                  Game.state = Game.WAITING;
               }
            }
         }
      }
      Game.lastUpdate = Game.thisUpdate;
   }
   static function sendRandomSeed()
   {
      var _loc2_ = Util.randomMinMax(0,20000);
      Game.sendPrio1Msg("<16 s=\"" + _loc2_ + "\"/>\n");
      MyMath.setSeed(_loc2_);
      Game.grid = _root.grid;
      Game.grid.init();
   }
   static function testPlayerHit(x, y)
   {
      if(Game.thisPlayer.xxPos == x && Game.thisPlayer.yyPos == y)
      {
         Game.thisPlayerDie();
      }
   }
   static function thisPlayerDie()
   {
      if(Game.locked == false)
      {
         Game.sendPrio1Msg("<die x=\"" + Math.round(Game.thisPlayer._x) + "\"  y=\"" + Math.round(Game.thisPlayer._y) + "\"/>\n");
         Game.state = Game.GAME_OVER;
         Game.thisPlayer.die();
         Game.hasWon = false;
         Game.locked = true;
      }
   }
   static function remotePlayerDie(x, y)
   {
      Game.state = Game.GAME_OVER;
      Game.remotePlayer._x = x;
      Game.remotePlayer._y = y;
      Game.remotePlayer.die();
      Game.hasWon = true;
      Game.locked = true;
   }
   static function receiveRandomSeed(seed)
   {
      MyMath.setSeed(seed);
      Game.grid = _root.grid;
      Game.grid.init();
      Game.reset();
      Game.state = Game.PLAYING;
   }
   static function debugMsg(msg)
   {
      if(Game.DEBUG)
      {
         _root.chatBox.addMsg("DEBUG",msg);
      }
   }
   static function sendPrio1Msg(msg)
   {
      Connector.sendGameMsg(msg);
      Game.msgPrio1 = true;
   }
   static function sendKeyMsg()
   {
      if(Game.msgPrio1 == false)
      {
         if(Game.oldKeyCode != Game.newKeyCode)
         {
            Connector.sendGameMsg("<12 x=\"" + Math.round(Game.thisPlayer._x) + "\"  y=\"" + Math.round(Game.thisPlayer._y) + "\" c=\"" + Game.newKeyCode + "\"/>\n");
            Game.oldKeyCode = Game.newKeyCode;
         }
         else if(Game.pingSentTime < getTimer() - Game.pingIntervall)
         {
            Game.ping();
         }
         else if(Game.pingResultToOther)
         {
            Connector.sendGameMsg("<14 p=\"" + Game.myPing + "\" f=\"" + Game.myFps + "\" />\n");
            Game.pingResultToOther = false;
         }
      }
   }
   static function setPingRemotePlayer(p, f)
   {
      Game.remotePing = p;
      Game.remotePlayer.pingTxt.text = String(Game.remotePing);
      Game.remoteFps = f;
      Game.remotePlayer.fpsTxt.text = String(Game.remoteFps);
   }
   static function winGame()
   {
      trace("winGame");
      Game.state = Game.GAME_OVER;
      Game.sendPrio1Msg("<winGame/>\n");
      Connector.matchResult = 1;
      _root.nextFrame();
   }
   static function loseGame()
   {
      trace("loseGame");
      Game.state = Game.GAME_OVER;
      Connector.matchResult = 2;
      _root.nextFrame();
   }
   function drawnGame()
   {
      trace("draw");
      Connector.matchResult = 0;
      _root.nextFrame();
   }
   static function ping()
   {
      Game.pingSentTime = getTimer();
      Game.sendPrio1Msg("<ping/>\n");
   }
   static function pingReturn()
   {
      Game.myPing = getTimer() - Game.pingSentTime;
      Game.thisPlayer.pingTxt.text = String(Game.myPing);
      Game.myFps = Math.round(Game.frame / ((getTimer() - Game.startTime) / 1000));
      Game.thisPlayer.fpsTxt.text = String(Game.myFps);
      Game.pingResultToOther = true;
   }
   static function reset()
   {
      trace("game.reset()");
      BombManager.bombArray = new Array();
      if(Game.playerNr == 1)
      {
         _root.p1_txt.text = Connector.myName;
         _root.p2_txt.text = Connector.oppName;
         Game.thisPlayer = Game.player1;
         Game.remotePlayer = Game.player2;
         BombManager.nextId = 5000;
      }
      else
      {
         _root.p2_txt.text = Connector.myName;
         _root.p1_txt.text = Connector.oppName;
         Game.thisPlayer = Game.player2;
         Game.remotePlayer = Game.player1;
         BombManager.nextId = 10000;
      }
      Game.player1._x = 120;
      Game.player1._y = 40;
      Game.player2._x = 600;
      Game.player2._y = 440;
      Game.player1.playerNr = 1;
      Game.player2.playerNr = 2;
      Game.remotePlayer.isRemote = true;
      Game.thisPlayer.isRemote = false;
      Game.lastUpdate = getTimer();
   }
   function gameOver()
   {
      Game.state = Game.GAME_OVER;
   }
   function onKeyDown()
   {
      if(Game.state != Game.GAME_OVER && !ChatBox.gotFocus)
      {
         if(!Key.isDown(27))
         {
         }
         if(Key.getCode() == 39)
         {
            if(Game.thisPlayer.right != true)
            {
               Game.thisPlayer.go();
               if(Game.thisPlayer._xscale < 0)
               {
                  Game.thisPlayer._xscale *= -1;
               }
               Game.thisPlayer.right = true;
               Game.thisPlayer.left = false;
               Game.thisPlayer.up = false;
               Game.thisPlayer.down = false;
            }
         }
         else if(Key.getCode() == 37)
         {
            if(Game.thisPlayer.left != true)
            {
               Game.thisPlayer.go();
               if(Game.thisPlayer._xscale > 0)
               {
                  Game.thisPlayer._xscale *= -1;
               }
               Game.thisPlayer.right = false;
               Game.thisPlayer.left = true;
               Game.thisPlayer.up = false;
               Game.thisPlayer.down = false;
            }
         }
         else if(Key.getCode() == 38)
         {
            if(Game.thisPlayer.up != true)
            {
               Game.thisPlayer.oben();
               Game.thisPlayer.right = false;
               Game.thisPlayer.left = false;
               Game.thisPlayer.up = true;
               Game.thisPlayer.down = false;
            }
         }
         else if(Key.getCode() == 40)
         {
            if(Game.thisPlayer.up != true)
            {
               Game.thisPlayer.unten();
               Game.thisPlayer.right = false;
               Game.thisPlayer.left = false;
               Game.thisPlayer.up = false;
               Game.thisPlayer.down = true;
            }
         }
         if(Key.isDown(32))
         {
            if(Game.thisPlayer.space != true)
            {
               Game.thisPlayer.space = true;
            }
         }
         Game.buildNewKeyCode();
      }
   }
   function onKeyUp()
   {
      if(Game.state != Game.GAME_OVER && !ChatBox.gotFocus)
      {
         if(!Key.isDown(39))
         {
            Game.thisPlayer.right = false;
         }
         if(!Key.isDown(37))
         {
            Game.thisPlayer.left = false;
         }
         if(!Key.isDown(38))
         {
            Game.thisPlayer.up = false;
         }
         if(!Key.isDown(40))
         {
            Game.thisPlayer.down = false;
         }
         if(!Key.isDown(32))
         {
            Game.thisPlayer.space = false;
            Game.thisPlayer.spaceReleased = true;
         }
         if(!Key.isDown(39) && !Key.isDown(37) && !Key.isDown(38) && !Key.isDown(40))
         {
            Game.thisPlayer.stand();
         }
         Game.buildNewKeyCode();
      }
   }
   static function buildNewKeyCode()
   {
      Game.newKeyCode = "";
      if(Game.thisPlayer.left)
      {
         Game.newKeyCode += "1";
      }
      else
      {
         Game.newKeyCode += "0";
      }
      if(Game.thisPlayer.up)
      {
         Game.newKeyCode += "1";
      }
      else
      {
         Game.newKeyCode += "0";
      }
      if(Game.thisPlayer.right)
      {
         Game.newKeyCode += "1";
      }
      else
      {
         Game.newKeyCode += "0";
      }
      if(Game.thisPlayer.down)
      {
         Game.newKeyCode += "1";
      }
      else
      {
         Game.newKeyCode += "0";
      }
   }
   function sendIWin(winType)
   {
   }
   function sendIDraw()
   {
   }
   function sendISurr()
   {
      Connector.sendGameMsg("<surrender/>\n");
   }
   function win()
   {
      trace("win");
      Connector.matchResult = 1;
      _root.nextFrame();
   }
   function loose()
   {
      trace("loose");
      Connector.matchResult = 2;
      _root.nextFrame();
   }
   function doGameOver(winner)
   {
   }
   function checkWin()
   {
      return false;
   }
   function checkDraw()
   {
      return false;
   }
}
