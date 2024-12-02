var §\x01§ = 429;
var §\x0f§ = 1;
class mx.events.UIEventDispatcher extends mx.events.EventDispatcher
{
   var owner;
   var __sentLoadEvent;
   var __origAddEventListener;
   static var keyEvents = {keyDown:1,keyUp:1};
   static var loadEvents = {load:1,unload:1};
   static var lowLevelEvents = {keyEvents:["addKeyEvents","removeKeyEvents"],loadEvents:["addLoadEvents","removeLoadEvents"]};
   static var _fEventDispatcher = undefined;
   function UIEventDispatcher()
   {
      super();
   }
   static function addKeyEvents(obj)
   {
      if(obj.keyHandler == undefined)
      {
         var _loc0_ = null;
         var _loc1_ = obj.keyHandler = new Object();
         _loc1_.owner = obj;
         _loc1_.onKeyDown = mx.events.UIEventDispatcher._fEventDispatcher.onKeyDown;
         _loc1_.onKeyUp = mx.events.UIEventDispatcher._fEventDispatcher.onKeyUp;
      }
      Key.addListener(obj.keyHandler);
   }
   static function removeKeyEvents(obj)
   {
      Key.removeListener(obj.keyHandler);
   }
   static function addLoadEvents(obj)
   {
      if(obj.onLoad == undefined)
      {
         obj.onLoad = mx.events.UIEventDispatcher._fEventDispatcher.onLoad;
         obj.onUnload = mx.events.UIEventDispatcher._fEventDispatcher.onUnload;
         if(obj.getBytesTotal() == obj.getBytesLoaded())
         {
            obj.doLater(obj,"onLoad");
         }
      }
   }
   static function removeLoadEvents(obj)
   {
      delete obj.onLoad;
      delete obj.onUnload;
   }
   static function initialize(obj)
   {
      if(mx.events.UIEventDispatcher._fEventDispatcher == undefined)
      {
         mx.events.UIEventDispatcher._fEventDispatcher = new mx.events.UIEventDispatcher();
      }
      obj.addEventListener = mx.events.UIEventDispatcher._fEventDispatcher.__addEventListener;
      obj.__origAddEventListener = mx.events.UIEventDispatcher._fEventDispatcher.addEventListener;
      obj.removeEventListener = mx.events.UIEventDispatcher._fEventDispatcher.removeEventListener;
      obj.dispatchEvent = mx.events.UIEventDispatcher._fEventDispatcher.dispatchEvent;
      obj.dispatchQueue = mx.events.UIEventDispatcher._fEventDispatcher.dispatchQueue;
   }
   function dispatchEvent(eventObj)
   {
      if(eventObj.target == undefined)
      {
         eventObj.target = this;
      }
      this[eventObj.type + "Handler"](eventObj);
      this.dispatchQueue(mx.events.EventDispatcher,eventObj);
      this.dispatchQueue(this,eventObj);
   }
   function onKeyDown(Void)
   {
      this.owner.dispatchEvent({type:"keyDown",code:Key.getCode(),ascii:Key.getAscii(),shiftKey:Key.isDown(16),ctrlKey:Key.isDown(17)});
   }
   function onKeyUp(Void)
   {
      this.owner.dispatchEvent({type:"keyUp",code:Key.getCode(),ascii:Key.getAscii(),shiftKey:Key.isDown(16),ctrlKey:Key.isDown(17)});
   }
   function onLoad(Void)
   {
      if(this.__sentLoadEvent != true)
      {
         this.dispatchEvent({type:"load"});
      }
      this.__sentLoadEvent = true;
   }
   function onUnload(Void)
   {
      this.dispatchEvent({type:"unload"});
   }
   function __addEventListener(event, handler)
   {
      this.__origAddEventListener(event,handler);
      var _loc3_ = mx.events.UIEventDispatcher.lowLevelEvents;
      for(var _loc5_ in _loc3_)
      {
         if(mx.events.UIEventDispatcher[_loc5_][event] != undefined)
         {
            var _loc2_ = _loc3_[_loc5_][0];
            mx.events.UIEventDispatcher[_loc2_](this);
         }
      }
   }
   function removeEventListener(event, handler)
   {
      var _loc6_ = "__q_" + event;
      mx.events.EventDispatcher._removeEventListener(this[_loc6_],event,handler);
      if(this[_loc6_].length == 0)
      {
         var _loc2_ = mx.events.UIEventDispatcher.lowLevelEvents;
         for(var _loc5_ in _loc2_)
         {
            if(mx.events.UIEventDispatcher[_loc5_][event] != undefined)
            {
               var _loc3_ = _loc2_[_loc5_][1];
               mx.events.UIEventDispatcher[_loc2_[_loc5_][1]](this);
            }
         }
      }
   }
}
