var §\x01§ = 920;
var §\x0f§ = 1;
class SoundPlayer
{
   static var soundOn = null;
   static var sound = new Sound();
   function SoundPlayer()
   {
   }
   static function init()
   {
      if(SoundPlayer.soundOn == null)
      {
         if(_root.sound == 0)
         {
            SoundPlayer.sound.setVolume(0);
            SoundPlayer.soundOn = false;
         }
         else
         {
            SoundPlayer.sound.setVolume(100);
            SoundPlayer.soundOn = true;
         }
      }
   }
   static function play(name)
   {
      if(SoundPlayer.soundOn)
      {
         SoundPlayer.sound.setVolume(100);
         trace("play:" + name);
         SoundPlayer.sound.attachSound(name);
         SoundPlayer.sound.start();
      }
   }
   static function playLoop(name, times)
   {
      if(SoundPlayer.soundOn)
      {
         SoundPlayer.sound.setVolume(100);
         trace("playLoop:" + name);
         SoundPlayer.sound.attachSound(name);
         SoundPlayer.sound.start(0,times);
      }
   }
   static function stop(name)
   {
      trace("stop:" + name);
      SoundPlayer.sound.stop(name);
   }
   static function playV(name, vol)
   {
      if(SoundPlayer.soundOn)
      {
         SoundPlayer.sound.setVolume(vol);
         trace("play:" + name);
         SoundPlayer.sound.attachSound(name);
         SoundPlayer.sound.start();
      }
   }
   static function playVLoop(name, vol, times)
   {
      if(SoundPlayer.soundOn)
      {
         SoundPlayer.sound.setVolume(vol);
         trace("playVLoop:" + name);
         SoundPlayer.sound.attachSound(name);
         SoundPlayer.sound.start(0,times);
      }
   }
   static function onOff()
   {
      SoundPlayer.soundOn = !SoundPlayer.soundOn;
      if(SoundPlayer.soundOn == false)
      {
         SoundPlayer.sound.setVolume(0);
      }
      else
      {
         SoundPlayer.sound.setVolume(100);
      }
   }
}
