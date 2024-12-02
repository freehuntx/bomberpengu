var §\x01§ = 276;
var §\x0f§ = 1;
class mx.core.ExternalContent
{
   var createObject;
   var numChildren;
   var prepList;
   var doLater;
   var loadList;
   var dispatchEvent;
   var loadedList;
   var childLoaded;
   static var classConstructed = mx.core.ExternalContent.classConstruct();
   static var ViewDependency = mx.core.View;
   function ExternalContent()
   {
   }
   function loadExternal(url, placeholderClassName, instanceName, depth, initProps)
   {
      var _loc2_ = undefined;
      _loc2_ = this.createObject(placeholderClassName,instanceName,depth,initProps);
      this[mx.core.View.childNameBase + this.numChildren] = _loc2_;
      if(this.prepList == undefined)
      {
         this.prepList = new Object();
      }
      this.prepList[instanceName] = {obj:_loc2_,url:url,complete:false,initProps:initProps};
      this.prepareToLoadMovie(_loc2_);
      return _loc2_;
   }
   function prepareToLoadMovie(obj)
   {
      obj.unloadMovie();
      this.doLater(this,"waitForUnload");
   }
   function waitForUnload()
   {
      var _loc3_ = undefined;
      for(_loc3_ in this.prepList)
      {
         var _loc2_ = this.prepList[_loc3_];
         if(_loc2_.obj.getBytesTotal() == 0)
         {
            if(this.loadList == undefined)
            {
               this.loadList = new Object();
            }
            this.loadList[_loc3_] = _loc2_;
            _loc2_.obj.loadMovie(_loc2_.url);
            delete this.prepList[_loc3_];
            this.doLater(this,"checkLoadProgress");
         }
         else
         {
            this.doLater(this,"waitForUnload");
         }
      }
   }
   function checkLoadProgress()
   {
      var _loc3_ = undefined;
      for(_loc3_ in this.loadList)
      {
         var _loc2_ = this.loadList[_loc3_];
         _loc2_.loaded = _loc2_.obj.getBytesLoaded();
         _loc2_.total = _loc2_.obj.getBytesTotal();
         if(_loc2_.total > 0)
         {
            _loc2_.obj._visible = false;
            this.dispatchEvent({type:"progress",target:_loc2_.obj,current:_loc2_.loaded,total:_loc2_.total});
            if(_loc2_.loaded == _loc2_.total)
            {
               if(this.loadedList == undefined)
               {
                  this.loadedList = new Object();
               }
               this.loadedList[_loc3_] = _loc2_;
               delete this.loadList[_loc3_];
               this.doLater(this,"contentLoaded");
            }
         }
         else if(_loc2_.total == -1)
         {
            if(_loc2_.failedOnce != undefined)
            {
               _loc2_.failedOnce++;
               if(_loc2_.failedOnce > 3)
               {
                  this.dispatchEvent({type:"complete",target:_loc2_.obj,current:_loc2_.loaded,total:_loc2_.total});
                  delete this.loadList[_loc3_];
                  false;
               }
            }
            else
            {
               _loc2_.failedOnce = 0;
            }
         }
         this.doLater(this,"checkLoadProgress");
      }
   }
   function contentLoaded()
   {
      var _loc4_ = undefined;
      for(_loc4_ in this.loadedList)
      {
         var _loc2_ = this.loadedList[_loc4_];
         _loc2_.obj._visible = true;
         _loc2_.obj._complete = true;
         var _loc3_ = undefined;
         for(_loc3_ in _loc2_.initProps)
         {
            _loc2_.obj[_loc3_] = _loc2_.initProps[_loc3_];
         }
         this.childLoaded(_loc2_.obj);
         this.dispatchEvent({type:"complete",target:_loc2_.obj,current:_loc2_.loaded,total:_loc2_.total});
         delete this.loadedList[_loc4_];
         false;
      }
   }
   function convertToUIObject(obj)
   {
      if(obj.setSize == undefined)
      {
         var _loc2_ = mx.core.UIObject.prototype;
         obj.addProperty("width",_loc2_.__get__width,null);
         obj.addProperty("height",_loc2_.__get__height,null);
         obj.addProperty("left",_loc2_.__get__left,null);
         obj.addProperty("x",_loc2_.__get__x,null);
         obj.addProperty("top",_loc2_.__get__top,null);
         obj.addProperty("y",_loc2_.__get__y,null);
         obj.addProperty("right",_loc2_.__get__right,null);
         obj.addProperty("bottom",_loc2_.__get__bottom,null);
         obj.addProperty("visible",_loc2_.__get__visible,_loc2_.__set__visible);
         obj.move = mx.core.UIObject.prototype.move;
         obj.setSize = mx.core.UIObject.prototype.setSize;
         obj.size = mx.core.UIObject.prototype.size;
         mx.events.UIEventDispatcher.initialize(obj);
      }
   }
   static function enableExternalContent()
   {
   }
   static function classConstruct()
   {
      var _loc1_ = mx.core.View.prototype;
      var _loc2_ = mx.core.ExternalContent.prototype;
      _loc1_.loadExternal = _loc2_.loadExternal;
      _loc1_.prepareToLoadMovie = _loc2_.prepareToLoadMovie;
      _loc1_.waitForUnload = _loc2_.waitForUnload;
      _loc1_.checkLoadProgress = _loc2_.checkLoadProgress;
      _loc1_.contentLoaded = _loc2_.contentLoaded;
      _loc1_.convertToUIObject = _loc2_.convertToUIObject;
      return true;
   }
}
