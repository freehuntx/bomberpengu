var §\x01§ = 239;
var §\x0f§ = 1;
class ChatExitButton extends MovieClip
{
   function ChatExitButton()
   {
      super();
      _root.stop();
   }
   function onPress()
   {
      _root.chatExit._visible = false;
      _root.chatBox.dummyBox.setFocus();
      ChatBox.gotFocus = false;
   }
}
