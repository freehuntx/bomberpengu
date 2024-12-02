var §\x01§ = 643;
var §\x0f§ = 1;
class ChatBox extends MovieClip
{
   var chatList;
   var chatInput;
   var dummyBox;
   static var gotFocus = false;
   var firstEnter = true;
   function ChatBox()
   {
      super();
      this.chatList.backgroundColor = 16777215;
      this.chatList.borderColor = 16777215;
      this.chatList.rollOverColor = 16777215;
      this.chatList.selectionColor = 16777215;
      this.chatList.textSelectedColor = 0;
      this.chatList.textRollOverColor = 0;
      this.chatList.fontFamily = "arial";
      this.chatList.fontSize = 12;
      this.chatList.fontWeight = "bold";
      this.chatList.fontStyle = "italic";
      this.chatList.selectable = false;
      this.chatList.color = 0;
      this.chatInput.fontFamily = "arial";
      this.chatInput.fontSize = 12;
      this.chatInput.fontWeight = "bold";
      this.chatInput.fontStyle = "italic";
      this.dummyBox._visible = false;
      ChatBoxPR.disconnect();
   }
   function initChatBox()
   {
      this.chatList = _root.chatBox.chatList;
      this.chatInput = _root.chatBox.chatInput;
      this.chatInput.maxChars = 200;
      this.chatInput.addEventListener("enter",this);
      this.chatInput.addEventListener("focusIn",this);
   }
   function onEnterFrame()
   {
      if(this.firstEnter)
      {
         this.firstEnter = false;
         this.initChatBox();
      }
   }
   function enter()
   {
      if(this.chatInput.text != "")
      {
         var _loc2_ = this.chatInput.text;
         this.chatInput.text = "";
         if(Connector.connected)
         {
            if(this.addMsg(Connector.myName,_loc2_))
            {
               Connector.sendChatMsg(_loc2_);
            }
         }
         else
         {
            this.addMsg("System","Chat inaktiv / Chat not active");
         }
      }
   }
   function addMsg(userName, msgText)
   {
      var _loc5_ = true;
      var _loc6_ = msgText.length;
      var _loc2_ = "";
      msgText += " ";
      var _loc4_ = 0;
      while(_loc4_ < _loc6_)
      {
         if(msgText.indexOf(" ") == -1)
         {
            this.chatList.addItem({label:userName + ": " + msgText});
            _loc4_ += _loc6_;
         }
         else
         {
            _loc2_ = "";
            while(msgText.indexOf(" ") != -1 && _loc2_.length < 65 && msgText.length > 0)
            {
               _loc2_ += msgText.slice(0,msgText.indexOf(" ") + 1);
               msgText = msgText.slice(msgText.indexOf(" ") + 1);
            }
            while(_loc2_.length > 65 && _loc2_.indexOf(" ") != -1 && !_loc2_.lastIndexOf(" ") == 0)
            {
               msgText = _loc2_.slice(_loc2_.lastIndexOf(" ")) + msgText;
               _loc2_ = _loc2_.slice(0,_loc2_.lastIndexOf(" "));
            }
            _loc4_ += _loc2_.length;
            if(_loc5_)
            {
               _loc5_ = false;
               this.chatList.addItem({label:userName + ": " + _loc2_});
            }
            else
            {
               this.chatList.addItem({label:"                       " + _loc2_});
            }
         }
         if(this.chatList.length > this.chatList.rowCount && this.chatList.vPosition == this.chatList.length - this.chatList.rowCount || this.chatList.length == this.chatList.rowCount)
         {
            this.chatList.vPosition = this.chatList.length;
         }
         if(this.chatList.length > 500)
         {
            this.chatList.removeItemAt(0);
            this.chatList.vPosition -= 1;
         }
      }
      SoundPlayer.play("Message.wav");
      return true;
   }
   function clearChatList()
   {
      this.chatList.removeAll();
   }
   function focusIn()
   {
      ChatBox.gotFocus = true;
      _root.chatExit._visible = true;
   }
}
