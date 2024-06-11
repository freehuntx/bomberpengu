var §\x01§ = 991;
var §\x0f§ = 1;
class AfterMatch_class extends MovieClip
{
   var oppStillHere = true;
   function AfterMatch_class()
   {
      super();
      _root.afterMatch.oppStatus.gotoAndStop(1);
      switch(Connector.matchResult)
      {
         case 0:
            _root.afterMatch.matchResult.gotoAndStop(1);
            break;
         case 1:
            _root.afterMatch.matchResult.gotoAndStop(2);
            break;
         case 2:
            _root.afterMatch.matchResult.gotoAndStop(3);
      }
      var _loc3_ = -1;
      _loc3_ = Connector.getPlayerId(Connector.myName);
      switch(Connector.matchResult)
      {
         case 0:
            Connector.players[_loc3_].drawn++;
            Connector.players[_loc3_].recalc();
            break;
         case 1:
            Connector.players[_loc3_].won++;
            Connector.players[_loc3_].recalc();
            break;
         case 2:
            Connector.players[_loc3_].lost++;
            Connector.players[_loc3_].recalc();
      }
   }
   function onEnterFrame()
   {
      if(this.oppStillHere)
      {
         switch(Connector.getPlayerStatus(Connector.oppName))
         {
            case "0":
               this.oppStillHere = false;
               _root.afterMatch.oppStatus.gotoAndStop(3);
               _root.afterMatch.oppStatus.oppName_txt.text = Connector.oppName;
               break;
            case "3":
               _root.afterMatch.oppStatus.oppName_txt.text = Connector.oppName;
               break;
            default:
               this.oppStillHere = false;
               _root.afterMatch.oppStatus.gotoAndStop(3);
               _root.afterMatch.oppStatus.oppName_txt.text = Connector.oppName;
         }
      }
      if(this.oppStillHere && Connector.playAgainReq)
      {
         _root.afterMatch.oppStatus.gotoAndStop(2);
         _root.afterMatch.oppStatus.oppName_txt.text = Connector.oppName;
      }
   }
   function playAgain()
   {
   }
}
