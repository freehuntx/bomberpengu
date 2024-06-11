var §\x01§ = 944;
var §\x0f§ = 1;
class ChallengeAllButton extends MovieClip
{
   function ChallengeAllButton()
   {
      super();
      this.stop();
   }
   function onPress()
   {
      var _loc4_ = true;
      var _loc3_ = 0;
      while(_loc3_ < Connector.players.length)
      {
         if(Connector.players[_loc3_].pStatus == "1")
         {
            _loc4_ = false;
            break;
         }
         _loc3_ = _loc3_ + 1;
      }
      if(_loc4_)
      {
         if(Connector.challengedAll)
         {
            Connector.challengedAll = false;
            Connector.sendRemChallengeAll();
            _loc3_ = 0;
            §§push(this.gotoAndStop(1));
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
         else
         {
            Connector.challengedAll = true;
            Connector.sendChallengeAll();
            _loc3_ = 0;
            §§push(this.gotoAndStop(2));
            while(_loc3_ < Connector.players.length)
            {
               if(Connector.players[_loc3_].pStatus == "0")
               {
                  Connector.updatePlayer2(Connector.players[_loc3_].pName,"2");
               }
               else if(Connector.players[_loc3_].pStatus == "3")
               {
                  Connector.updatePlayer2(Connector.players[_loc3_].pName,"23");
               }
               _loc3_ = _loc3_ + 1;
            }
         }
      }
      else
      {
         _root.chatBox.addMsg("Server","Sie können nicht alle fordern, weil Sie bereits gefordert werden!");
      }
   }
}
