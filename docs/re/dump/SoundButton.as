var §\x01§ = 947;
var §\x0f§ = 1;
class SoundButton extends MovieClip
{
   var soundOn = true;
   function SoundButton()
   {
      super();
      SoundPlayer.init();
      this.update();
      this.stop();
   }
   function onPress()
   {
      SoundPlayer.onOff();
      this.update();
   }
   function update()
   {
      SoundPlayer.soundOn == true ? this.gotoAndStop(1) : this.gotoAndStop(2);
   }
}
