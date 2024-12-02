var §\x01§ = 29;
var §\x0f§ = 1;
class mx.effects.Tween extends Object
{
   var arrayMode;
   var listener;
   var initVal;
   var endVal;
   var startTime;
   var updateFunc;
   var endFunc;
   var ID;
   static var IntervalToken;
   static var ActiveTweens = new Array();
   static var Interval = 10;
   static var Dispatcher = new Object();
   var duration = 3000;
   function Tween(listenerObj, init, end, dur)
   {
      super();
      if(listenerObj == undefined)
      {
         return undefined;
      }
      if(typeof init != "number")
      {
         this.arrayMode = true;
      }
      this.listener = listenerObj;
      this.initVal = init;
      this.endVal = end;
      if(dur != undefined)
      {
         this.duration = dur;
      }
      this.startTime = getTimer();
      if(this.duration == 0)
      {
         this.endTween();
      }
      else
      {
         mx.effects.Tween.AddTween(this);
      }
   }
   static function AddTween(tween)
   {
      tween.ID = mx.effects.Tween.ActiveTweens.length;
      mx.effects.Tween.ActiveTweens.push(tween);
      if(mx.effects.Tween.IntervalToken == undefined)
      {
         mx.effects.Tween.Dispatcher.DispatchTweens = mx.effects.Tween.DispatchTweens;
         mx.effects.Tween.IntervalToken = setInterval(mx.effects.Tween.Dispatcher,"DispatchTweens",mx.effects.Tween.Interval);
      }
   }
   static function RemoveTweenAt(index)
   {
      var _loc2_ = mx.effects.Tween.ActiveTweens;
      if(index >= _loc2_.length || index < 0 || index == undefined)
      {
         return undefined;
      }
      _loc2_.splice(index,1);
      var _loc4_ = _loc2_.length;
      var _loc1_ = index;
      while(_loc1_ < _loc4_)
      {
         _loc2_[_loc1_].ID--;
         _loc1_ = _loc1_ + 1;
      }
      if(_loc4_ == 0)
      {
         clearInterval(mx.effects.Tween.IntervalToken);
         delete mx.effects.Tween.IntervalToken;
      }
   }
   static function DispatchTweens(Void)
   {
      var _loc2_ = mx.effects.Tween.ActiveTweens;
      var _loc3_ = _loc2_.length;
      var _loc1_ = 0;
      while(_loc1_ < _loc3_)
      {
         _loc2_[_loc1_].doInterval();
         _loc1_ = _loc1_ + 1;
      }
      updateAfterEvent();
   }
   function doInterval()
   {
      var _loc2_ = getTimer() - this.startTime;
      var _loc3_ = this.getCurVal(_loc2_);
      if(_loc2_ >= this.duration)
      {
         this.endTween();
      }
      else if(this.updateFunc != undefined)
      {
         this.listener[this.updateFunc](_loc3_);
      }
      else
      {
         this.listener.onTweenUpdate(_loc3_);
      }
   }
   function getCurVal(curTime)
   {
      if(this.arrayMode)
      {
         var _loc3_ = new Array();
         var _loc2_ = 0;
         while(_loc2_ < this.initVal.length)
         {
            _loc3_[_loc2_] = this.easingEquation(curTime,this.initVal[_loc2_],this.endVal[_loc2_] - this.initVal[_loc2_],this.duration);
            _loc2_ = _loc2_ + 1;
         }
         return _loc3_;
      }
      return this.easingEquation(curTime,this.initVal,this.endVal - this.initVal,this.duration);
   }
   function endTween()
   {
      if(this.endFunc != undefined)
      {
         this.listener[this.endFunc](this.endVal);
      }
      else
      {
         this.listener.onTweenEnd(this.endVal);
      }
      mx.effects.Tween.RemoveTweenAt(this.ID);
   }
   function setTweenHandlers(update, end)
   {
      this.updateFunc = update;
      this.endFunc = end;
   }
   function easingEquation(t, b, c, d)
   {
      return c / 2 * (Math.sin(3.141592653589793 * (t / d - 0.5)) + 1) + b;
   }
}
