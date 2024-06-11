var §\x01§ = 612;
var §\x0f§ = 1;
class StartButton extends MovieClip
{
   function StartButton()
   {
      super();
      _root.stop();
   }
   function onPress()
   {
      _root.gotoAndStop(5);
   }
}
