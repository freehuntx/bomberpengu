var §\x01§ = 933;
var §\x0f§ = 1;
class Connector extends MovieClip
{
   static var matchResult;
   static var myName;
   static var players;
   static var xmlSocket;
   static var versionNr = "1.1.0.spika";
   static var server = "";
   static var port = "";
   static var connected = false;
   static var disConTxt = "";
   static var challengedAll = false;
   static var oppName = "0";
   static var myTurn = false;
   static var gameStarted = false;
   static var playAgainReq = false;
   static var startPlayer = false;
   static var lastMsg = 0;
   static var msgInt = 15000;
   function Connector()
   {
      super();
      Connector.doConnect();
   }
   static function doConnect()
   {
      trace("Connector.doConnect()");
      var _loc2_ = new ContextMenu();
      _loc2_.hideBuiltInItems();
      _loc2_.builtInItems.quality = true;
      _root.menu = _loc2_;
      if(_root.user == undefined)
      {
         Connector.myName = "Gast" + Math.round(Math.random() * 100000);
      }
      else
      {
         Connector.myName = _root.user;
      }
      if(_root.surl != undefined)
      {
         Connector.server = _root.surl;
      }
      if(_root.sport != undefined)
      {
         Connector.port = _root.sport;
      }
      Connector.players = new Array();
      Connector.xmlSocket = new XMLSocket();
      Connector.xmlSocket.connect(Connector.server,Connector.port);
      Connector.xmlSocket.onConnect = Connector.onSockConnect;
      Connector.xmlSocket.onClose = Connector.onSockClose;
      Connector.xmlSocket.onXML = Connector.onSockXML;
   }
   function onEnterFrame()
   {
      if(getTimer() > Connector.lastMsg + Connector.msgInt)
      {
         Connector.xmlSocket.send("<beat/>\n");
         Connector.lastMsg = getTimer();
      }
   }
   static function addPlayer(pName, pSkill, pStatus)
   {
      if(pName == Connector.myName)
      {
         pStatus = "5";
      }
      var _loc2_ = new Player(pName,pSkill,pStatus);
      Connector.players.push(_loc2_);
      if(_root.playerRoom.active)
      {
         _root.playerRoom.addPlayer(_loc2_);
      }
   }
   static function updatePlayer(pName, pSkill, pStatus)
   {
      var _loc2_ = 0;
      while(_loc2_ < Connector.players.length)
      {
         if(Connector.players[_loc2_].pName == pName)
         {
            if(Connector.challengedAll)
            {
               switch(Connector.players[_loc2_].pStatus)
               {
                  case "0":
                     Connector.players[_loc2_].pStatus = "2";
                     break;
                  case "3":
                     Connector.players[_loc2_].pStatus = "23";
               }
            }
            if(pStatus == "0")
            {
               switch(Connector.players[_loc2_].pStatus)
               {
                  case "23":
                     Connector.players[_loc2_].pStatus = "2";
                     break;
                  case "13":
                     Connector.players[_loc2_].pStatus = "1";
                     break;
                  case "1":
                     Connector.players[_loc2_].pStatus = "1";
                     break;
                  case "2":
                     Connector.players[_loc2_].pStatus = "2";
                     break;
                  default:
                     Connector.players[_loc2_].pStatus = pStatus;
               }
            }
            else if(pStatus == "3")
            {
               switch(Connector.players[_loc2_].pStatus)
               {
                  case "1":
                     Connector.players[_loc2_].pStatus = "13";
                     break;
                  case "2":
                     Connector.players[_loc2_].pStatus = "23";
                     break;
                  case "13":
                     Connector.players[_loc2_].pStatus = "13";
                     break;
                  case "23":
                     Connector.players[_loc2_].pStatus = "23";
                     break;
                  default:
                     Connector.players[_loc2_].pStatus = pStatus;
               }
            }
            else
            {
               Connector.players[_loc2_].pStatus = pStatus;
            }
            Connector.players[_loc2_].pSkill = pSkill;
            Connector.players[_loc2_].update();
            break;
         }
         _loc2_ = _loc2_ + 1;
      }
      if(_root.playerRoom.active)
      {
         _root.playerRoom.updatePlayer(Connector.players[_loc2_]);
      }
   }
   static function updatePlayer2(pName, pStatus)
   {
      var _loc2_ = 0;
      while(_loc2_ < Connector.players.length)
      {
         if(Connector.players[_loc2_].pName == pName)
         {
            Connector.players[_loc2_].pStatus = pStatus;
            if(_root.playerRoom.active)
            {
               _root.playerRoom.updatePlayer(Connector.players[_loc2_]);
            }
            break;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   static function removePlayer(pName)
   {
      var _loc3_ = undefined;
      _loc3_ = new Array();
      var _loc2_ = 0;
      while(_loc2_ < Connector.players.length)
      {
         if(Connector.players[_loc2_].pName != pName)
         {
            _loc3_.push(Connector.players[_loc2_]);
         }
         _loc2_ = _loc2_ + 1;
      }
      Connector.players = _loc3_;
      if(_root.playerRoom.active)
      {
         _root.playerRoom.removePlayer(pName);
      }
   }
   static function getPlayerStatus(pName)
   {
      var _loc1_ = 0;
      while(_loc1_ < Connector.players.length)
      {
         if(Connector.players[_loc1_].pName == pName)
         {
            return Connector.players[_loc1_].pStatus;
         }
         _loc1_ = _loc1_ + 1;
      }
      return "-1";
   }
   static function getPlayerId(pName)
   {
      var _loc1_ = 0;
      while(_loc1_ < Connector.players.length)
      {
         if(Connector.players[_loc1_].pName == pName)
         {
            return _loc1_;
         }
         _loc1_ = _loc1_ + 1;
      }
      return -1;
   }
   static function onSockClose()
   {
      trace("onSockClose()");
      Connector.connected = false;
      _root.gotoAndStop("ConnLost");
   }
   static function onSockXML(input)
   {
      var _loc2_ = input.lastChild;
      var _loc7_ = _loc2_.nodeName;
      switch(_loc7_)
      {
         case "12":
            var _loc26_ = _loc2_.attributes.x;
            var _loc25_ = _loc2_.attributes.y;
            var _loc11_ = _loc2_.attributes.c;
            Game.remotePlayer.remoteCommand(_loc11_,_loc26_,_loc25_);
            break;
         case "14":
            var _loc18_ = Number(_loc2_.attributes.p);
            var _loc27_ = Number(_loc2_.attributes.f);
            Game.setPingRemotePlayer(_loc18_,_loc27_);
            break;
         case "16":
            var _loc13_ = Number(_loc2_.attributes.s);
            Game.receiveRandomSeed(_loc13_);
            break;
         case "17":
            var _loc20_ = Number(_loc2_.attributes.xp);
            var _loc19_ = Number(_loc2_.attributes.yp);
            Game.grid.setBomb(_loc20_,_loc19_,Game.remotePlayer);
            _loc26_ = _loc2_.attributes.x;
            _loc25_ = _loc2_.attributes.y;
            _loc11_ = _loc2_.attributes.c;
            Game.remotePlayer.remoteCommand(_loc11_,_loc26_,_loc25_);
            SoundPlayer.playV("Donk.wav",80);
            break;
         case "18":
            _loc20_ = Number(_loc2_.attributes.xp);
            _loc19_ = Number(_loc2_.attributes.yp);
            _loc13_ = Number(_loc2_.attributes.s);
            var _loc14_ = Number(_loc2_.attributes.b);
            Game.remotePlayer.removePowerUp(_loc20_,_loc19_,_loc13_,_loc14_);
            _loc26_ = _loc2_.attributes.x;
            _loc25_ = _loc2_.attributes.y;
            _loc11_ = _loc2_.attributes.c;
            Game.remotePlayer.remoteCommand(_loc11_,_loc26_,_loc25_);
            break;
         case "19":
            _loc20_ = Number(_loc2_.attributes.xp);
            _loc19_ = Number(_loc2_.attributes.yp);
            var _loc16_ = Number(_loc2_.attributes.dx);
            var _loc15_ = Number(_loc2_.attributes.dy);
            var _loc12_ = Number(_loc2_.attributes.t);
            var _loc3_ = Number(_loc2_.attributes.i);
            Game.grid.remoteKickBomb(_loc20_,_loc19_,_loc16_,_loc15_,_loc12_,_loc3_);
            _loc26_ = _loc2_.attributes.x;
            _loc25_ = _loc2_.attributes.y;
            _loc11_ = _loc2_.attributes.c;
            Game.remotePlayer.remoteCommand(_loc11_,_loc26_,_loc25_);
            break;
         case "11":
            _loc20_ = Number(_loc2_.attributes.xp);
            _loc19_ = Number(_loc2_.attributes.yp);
            var _loc28_ = Number(_loc2_.attributes.i);
            _loc12_ = Number(_loc2_.attributes.t);
            BombManager.remoteStopBomb(_loc20_,_loc19_,_loc28_,_loc12_);
            _loc26_ = _loc2_.attributes.x;
            _loc25_ = _loc2_.attributes.y;
            _loc11_ = _loc2_.attributes.c;
            Game.remotePlayer.remoteCommand(_loc11_,_loc26_,_loc25_);
            break;
         case "10":
            _loc20_ = Number(_loc2_.attributes.xp);
            _loc19_ = Number(_loc2_.attributes.yp);
            _loc28_ = Number(_loc2_.attributes.i);
            BombManager.remoteExplode(_loc20_,_loc19_,_loc28_);
            _loc26_ = _loc2_.attributes.x;
            _loc25_ = _loc2_.attributes.y;
            _loc11_ = _loc2_.attributes.c;
            Game.remotePlayer.remoteCommand(_loc11_,_loc26_,_loc25_);
            break;
         case "die":
            _loc26_ = Number(_loc2_.attributes.x);
            _loc25_ = Number(_loc2_.attributes.y);
            Game.remotePlayerDie(_loc26_,_loc25_);
            break;
         case "draw":
            Game.drawn = true;
            Game.thisPlayer.die();
            Game.remotePlayer.die();
            break;
         case "pong":
            Game.pingReturn();
            break;
         case "errorMsg":
            trace("case: errorMsg");
            Connector.disConTxt = _loc2_.lastChild.nodeValue;
            _root.gotoAndStop("ConnLost");
            break;
         case "userList":
            trace("case: userList");
            var _loc4_ = _loc2_.childNodes;
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               var _loc8_ = _loc4_[_loc3_].attributes.name;
               var _loc6_ = _loc4_[_loc3_].attributes.skill;
               var _loc9_ = _loc4_[_loc3_].attributes.state;
               Connector.addPlayer(_loc8_,_loc6_,_loc9_);
               trace(_loc8_);
               trace(_loc6_);
               trace(_loc9_);
               _loc3_ = _loc3_ + 1;
            }
            _root.playerRoom.sortPlayerList();
            break;
         case "playerUpdate":
            trace("case: playerUpdate");
            _loc8_ = _loc2_.attributes.name;
            _loc6_ = _loc2_.attributes.skill;
            _loc9_ = _loc2_.attributes.state;
            trace(_loc8_);
            trace(_loc6_);
            trace(_loc9_);
            Connector.updatePlayer(_loc8_,_loc6_,_loc9_);
            break;
         case "newPlayer":
            trace("case: newPlayer");
            _loc8_ = _loc2_.attributes.name;
            _loc6_ = _loc2_.attributes.skill;
            _loc9_ = _loc2_.attributes.state;
            if(Connector.challengedAll)
            {
               Connector.addPlayer(_loc8_,_loc6_,"2");
            }
            else
            {
               Connector.addPlayer(_loc8_,_loc6_,_loc9_);
            }
            _root.playerRoom.sortPlayerList();
            trace(_loc8_);
            trace(_loc6_);
            trace(_loc9_);
            break;
         case "playerLeft":
            trace("case: playerLeft");
            _loc8_ = _loc2_.attributes.name;
            trace(_loc8_);
            Connector.removePlayer(_loc8_);
            if(Connector.gameStarted && _loc8_ == Connector.oppName)
            {
               trace("lost opponent");
               _root.game.win();
            }
            break;
         case "request":
            trace("case: request");
            _loc8_ = _loc2_.attributes.name;
            Connector.updatePlayer2(_loc8_,"1");
            if(!Connector.gameStarted)
            {
               SoundPlayer.play("Request.wav");
            }
            trace(_loc8_);
            break;
         case "remRequest":
            trace("case: remRequest");
            _loc8_ = _loc2_.attributes.name;
            var _loc29_ = Connector.getPlayerId(_loc8_);
            switch(Connector.getPlayerStatus(_loc8_))
            {
               case "0":
               case "1":
                  Connector.updatePlayer2(_loc8_,"0");
                  break;
               case "3":
               case "13":
                  Connector.updatePlayer2(_loc8_,"3");
                  break;
               default:
                  Connector.updatePlayer2(_loc8_,"0");
            }
            trace(_loc8_);
            break;
         case "startGame":
            trace("case: startGame");
            Game.playerNr = 2;
            _loc8_ = _loc2_.attributes.name;
            trace(_loc8_);
            Connector.oppName = _loc8_;
            Connector.updatePlayer2(Connector.oppName,"3");
            if(Connector.challengedAll)
            {
               Connector.sendRemChallengeAll();
               _loc3_ = 0;
               while(_loc3_ < Connector.players.length)
               {
                  if(Connector.players[_loc3_].pStatus == "2")
                  {
                     Connector.updatePlayer2(Connector.players[_loc3_].pName,"0");
                  }
                  else if(Connector.players[_loc3_].pStatus == "23")
                  {
                     Connector.updatePlayer2(Connector.players[_loc3_].pName,"3");
                  }
                  _loc3_ = _loc3_ + 1;
               }
            }
            if(!Connector.gameStarted)
            {
               _root.chatBox.clearChatList();
            }
            Connector.myTurn = false;
            Connector.gameStarted = true;
            Connector.playAgainReq = false;
            Connector.challengedAll = false;
            Connector.startPlayer = false;
            _root.gotoAndStop("gameFrame");
            break;
         case "endGame":
            trace("case: endGame");
            var _loc5_ = _loc2_.attributes.winner;
            trace("winner: " + _loc5_);
            break;
         case "timeout":
            trace("case: timeout");
            _loc5_ = _loc2_.attributes.winner;
            trace("winner: " + _loc5_);
            _root.game.doGameOver(_loc5_);
            break;
         case "surrender":
            trace("case: surrender");
            _loc5_ = _loc2_.attributes.winner;
            trace("winner: " + _loc5_ + "; " + Connector.oppName + " surrendered");
            if(_loc5_ == Connector.myName)
            {
               _root.game.win();
            }
            else if(_loc5_ == Connector.oppName)
            {
               _root.game.loose();
            }
            else
            {
               _root.game.drawn();
            }
            break;
         case "turn":
            trace("case: turn");
            break;
         case "playAgain":
            trace("case: playAgain");
            Connector.playAgainReq = true;
            break;
         case "msgPlayer":
            trace("case: msgPlayer");
            var _loc10_ = _loc2_.attributes.name;
            var _loc21_ = _loc2_.attributes.msg;
            if(Connector.gameStarted)
            {
               _root.chatBox.addMsg(_loc10_,_loc21_);
            }
            break;
         case "msgAll":
            trace("case: msgAll");
            _loc10_ = _loc2_.attributes.name;
            _loc21_ = _loc2_.attributes.msg;
            if(!Connector.gameStarted)
            {
               _root.chatBox.addMsg(_loc10_,_loc21_);
            }
            break;
         case "config":
            trace("case: config");
            var _loc22_ = _loc2_.attributes.badWordsUrl;
            var _loc17_ = _loc2_.attributes.replacementChar;
            var _loc24_ = _loc2_.attributes.deleteLine;
            var _loc23_ = Number(_loc2_.attributes.floodLimit);
            CensorManager.setConfig(_loc22_,_loc17_,_loc24_,_loc23_);
            break;
         default:
            trace("error unknown command: " + _loc7_);
      }
   }
   static function onSockConnect(success)
   {
      trace("onSockConnect()");
      if(success)
      {
         trace("sockConnect success");
         Connector.connected = true;
         Connector.xmlSocket.send("<auth name=\"" + Connector.myName + "\" version=\"" + Connector.versionNr + "\" hash=\"" + _root.hash + "\"/>\n");
         Connector.lastMsg = getTimer();
      }
      else
      {
         trace("sockConnect failed");
         Connector.connected = false;
         _root.gotoAndStop("ConnLost");
      }
   }
   static function sendChallenge(targetPlayer)
   {
      trace("send challenge to " + targetPlayer);
      Connector.xmlSocket.send("<challenge name=\"" + targetPlayer + "\" hash=\"xxxxxx\"/>\n");
      Connector.lastMsg = getTimer();
   }
   static function sendRemChallenge(targetPlayer)
   {
      trace("send remChallenge to " + targetPlayer);
      Connector.xmlSocket.send("<remChallenge name=\"" + targetPlayer + "\" hash=\"xxxxxx\"/>\n");
      Connector.lastMsg = getTimer();
   }
   static function sendStartGame(targetPlayer)
   {
      trace("send startGame to " + targetPlayer);
      Connector.oppName = targetPlayer;
      Connector.updatePlayer2(Connector.oppName,"3");
      if(!Connector.gameStarted)
      {
         _root.chatBox.clearChatList();
      }
      Connector.myTurn = true;
      Connector.gameStarted = true;
      Connector.playAgainReq = false;
      Connector.challengedAll = false;
      Connector.startPlayer = true;
      Game.playerNr = 1;
      Connector.xmlSocket.send("<startGame name=\"" + targetPlayer + "\" hash=\"xxxxxx\"/>\n");
      Connector.lastMsg = getTimer();
      _root.gotoAndStop("gameFrame");
   }
   static function sendGameMsg(command)
   {
      Connector.xmlSocket.send(command);
      Connector.lastMsg = getTimer();
   }
   static function sendChallengeAll()
   {
      trace("send challengeAll");
      Connector.xmlSocket.send("<challengeAll/>\n");
      Connector.lastMsg = getTimer();
   }
   static function sendRemChallengeAll()
   {
      trace("send RemChallengeAll");
      Connector.xmlSocket.send("<remChallengeAll/>\n");
      Connector.lastMsg = getTimer();
   }
   static function sendChatMsg(msg)
   {
      var _loc2_ = false;
      msg = Util.cleanMsg(msg);
      if(CensorManager.checkBadWords(msg))
      {
         if(CensorManager.deleteLine)
         {
            _loc2_ = true;
         }
         else
         {
            msg = CensorManager.censorMsg(msg);
         }
      }
      if(!_loc2_ && !CensorManager.checkFlooding(msg))
      {
         if(Connector.gameStarted)
         {
            trace("send msgPlayer");
            Connector.xmlSocket.send("<msgPlayer name=\"" + Connector.myName + "\" msg=\"" + msg + "\"/>\n");
            Connector.lastMsg = getTimer();
         }
         else
         {
            trace("send msgAll");
            Connector.xmlSocket.send("<msgAll name=\"" + Connector.myName + "\" msg=\"" + msg + "\"/>\n");
            Connector.lastMsg = getTimer();
         }
      }
   }
}
