var §\x01§ = 142;
var §\x0f§ = 1;
class CensorManager
{
   static var badWords;
   static var active = true;
   static var badWordsUrl = "";
   static var replacementChar = "";
   static var deleteLine = false;
   static var floodLimit = 0;
   static var badWordsLoaded = false;
   static var lastSend = 0;
   static var prevMsg = "";
   static var prevPrevMsg = "";
   function CensorManager()
   {
   }
   static function setConfig(tbadWordsUrl, treplacementChar, tdeleteLine, tfloodLimit)
   {
      if(CensorManager.active)
      {
         if(tbadWordsUrl != undefined && tbadWordsUrl != null)
         {
            CensorManager.badWordsUrl = tbadWordsUrl;
            if(CensorManager.badWordsUrl != "")
            {
               CensorManager.loadBadWords();
            }
         }
         CensorManager.replacementChar = treplacementChar;
         if(tdeleteLine == "false")
         {
            CensorManager.deleteLine = false;
         }
         else
         {
            CensorManager.deleteLine = true;
         }
         if(tfloodLimit != undefined && tfloodLimit != null)
         {
            CensorManager.floodLimit = tfloodLimit;
         }
      }
      else
      {
         CensorManager.badWordsLoaded = false;
         CensorManager.floodLimit = 0;
      }
   }
   static function loadBadWords()
   {
      var _loc1_ = new LoadVars();
      var resultlist = new LoadVars();
      resultlist.onLoad = function(data)
      {
         CensorManager.badWords = new Array();
         var _loc1_ = resultlist.badwords;
         CensorManager.badWords = _loc1_.split(",");
         if(CensorManager.badWords.length > 0)
         {
            CensorManager.badWordsLoaded = true;
         }
      };
      _loc1_.sendAndLoad("http://" + CensorManager.badWordsUrl,resultlist,"GET");
   }
   static function checkBadWords(msg)
   {
      if(CensorManager.badWordsLoaded)
      {
         var _loc3_ = false;
         var _loc2_ = new Array();
         msg = " " + msg + " ";
         for(var _loc5_ in CensorManager.badWords)
         {
            if(msg.indexOf(" " + CensorManager.badWords[_loc5_] + " ") != -1)
            {
               _loc3_ = true;
               break;
            }
         }
         if(_loc3_ == true)
         {
            return true;
         }
         _loc2_ = ["1","2","3","4","5","6","7","8","9","0","!","\"","§","$","%","&","/","(",")","=","?","ß","´","`","+","*","~","\\","\'",",",";",".",":","-","_","²","³","{","[","]","}",">","<","|","µ","@","^","°","€"];
         for(_loc5_ in CensorManager.badWords)
         {
            for(var _loc4_ in _loc2_)
            {
               msg = msg.split(_loc2_[_loc4_]).join(" ");
            }
         }
         for(_loc5_ in CensorManager.badWords)
         {
            if(msg.indexOf(" " + CensorManager.badWords[_loc5_] + " ") != -1)
            {
               _loc3_ = true;
               break;
            }
         }
         if(_loc3_ == true)
         {
            return true;
         }
         return false;
      }
      return false;
   }
   static function censorMsg(msg)
   {
      for(var _loc2_ in CensorManager.badWords)
      {
         msg = msg.split(CensorManager.badWords[_loc2_]).join(CensorManager.replacementChar);
      }
      return msg;
   }
   static function checkFlooding(msg)
   {
      if(CensorManager.prevPrevMsg == CensorManager.prevMsg && CensorManager.prevMsg == msg)
      {
         return true;
      }
      if(CensorManager.lastSend + CensorManager.floodLimit <= getTimer())
      {
         CensorManager.lastSend = getTimer();
         CensorManager.prevPrevMsg = CensorManager.prevMsg;
         CensorManager.prevMsg = msg;
         return false;
      }
      CensorManager.lastSend = getTimer();
      CensorManager.prevPrevMsg = CensorManager.prevMsg;
      CensorManager.prevMsg = msg;
      return true;
   }
}
