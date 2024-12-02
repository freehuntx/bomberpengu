var §\x01§ = 199;
var §\x0f§ = 1;
class ChatBoxPR extends MovieClip
{
   var chatList;
   var chatInput;
   var dummyBox;
   static var xmlSocket;
   var server = "85.214.40.91";
   var port = "6900";
   static var ext = "";
   static var defaultRoom = "";
   static var connected = false;
   static var lastMsg = 0;
   static var msgInt = 15000;
   var firstEnter = true;
   function ChatBoxPR()
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
   }
   function initChatBox()
   {
      this.chatList = _root.chatBox.chatList;
      this.chatInput = _root.chatBox.chatInput;
      this.chatInput.maxChars = 200;
      this.chatInput.addEventListener("enter",this);
      this.chatInput.addEventListener("focusIn",this);
      if(_root.csurl != undefined)
      {
         this.server = _root.csurl;
      }
      if(_root.csport != undefined)
      {
         this.port = _root.csport;
      }
      if(_root.ext != undefined)
      {
         ChatBoxPR.ext = _root.ext;
      }
      if(_root.defaultRoom != undefined)
      {
         ChatBoxPR.defaultRoom = _root.defaultRoom;
      }
      ChatBoxPR.xmlSocket = new XMLSocket();
      ChatBoxPR.xmlSocket.connect(this.server,this.port);
      ChatBoxPR.xmlSocket.onConnect = ChatBoxPR.onSockConnect;
      ChatBoxPR.xmlSocket.onClose = this.onSockClose;
      ChatBoxPR.xmlSocket.onXML = this.onSockXML;
   }
   function onEnterFrame()
   {
      if(this.firstEnter)
      {
         this.firstEnter = false;
         this.initChatBox();
      }
      if(getTimer() > ChatBoxPR.lastMsg + ChatBoxPR.msgInt)
      {
         ChatBoxPR.xmlSocket.send("<beat/>\n");
         ChatBoxPR.lastMsg = getTimer();
      }
   }
   function enter()
   {
      if(this.chatInput.text != "")
      {
         var _loc2_ = this.chatInput.text;
         this.chatInput.text = "";
         if(ChatBoxPR.connected)
         {
            if(this.addMsg(Connector.myName,_loc2_))
            {
               this.sendChatMsg(_loc2_);
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
      if(msgText.substr(0,4) != "#gs ")
      {
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
      }
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
   static function onSockConnect(success)
   {
      trace("onSockConnect()");
      if(success)
      {
         trace("sockConnect success Chat");
         ChatBoxPR.connected = true;
         ChatBoxPR.xmlSocket.send("<auth name=\"" + Connector.myName + "\" version=\"" + Connector.versionNr + "\" hash=\"" + _root.hash + "\" ext=\"" + ChatBoxPR.ext + "\" extauth=\"" + _root.extauth + "\" defaultRoom=\"" + ChatBoxPR.defaultRoom + "\"/>\n");
         ChatBoxPR.lastMsg = getTimer();
      }
      else
      {
         trace("sockConnect failed Chat");
         ChatBoxPR.connected = false;
         _root.chatBox.addMsg("System","Chatten im Playerroom zurzeit nicht möglich.");
      }
   }
   function onSockClose()
   {
      trace("onSockClose()Chat");
      ChatBoxPR.connected = false;
      this.addMsg("Server","Chatten im Playerroom zurzeit nicht möglich.");
   }
   static function disconnect()
   {
      ChatBoxPR.xmlSocket.close();
   }
   function onSockXML(input)
   {
      var _loc3_ = input.lastChild;
      var _loc5_ = _loc3_.nodeName;
      switch(_loc5_)
      {
         case "errorMsg":
            trace("case: errorMsg");
            this.addMsg("System",_loc3_.lastChild.nodeValue + ".");
            break;
         case "msgAll":
            trace("case: msgAll");
            var _loc4_ = _loc3_.attributes.name;
            var _loc6_ = _loc3_.attributes.msg;
            _root.chatBox.addMsg(_loc4_,_loc6_);
      }
   }
   function sendChatMsg(msg)
   {
      msg = Util.cleanMsg(msg);
      trace("send msgAll");
      if(msg.substr(0,4) != "#gs ")
      {
         ChatBoxPR.xmlSocket.send("<msgAll name=\"" + Connector.myName + ChatBoxPR.ext + "\" msg=\"" + msg + "\"/>\n");
         ChatBoxPR.lastMsg = getTimer();
      }
      else
      {
         msg = msg.slice(4);
         Connector.sendChatMsg(msg);
      }
   }
}
