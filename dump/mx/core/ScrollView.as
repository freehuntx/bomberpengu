var §\x01§ = 401;
var §\x0f§ = 1;
class mx.core.ScrollView extends mx.core.View
{
   var __width;
   var hScroller;
   var vScroller;
   var __maxHPosition;
   var propsInited;
   var scrollAreaChanged;
   var specialHScrollCase;
   var viewableColumns;
   var __height;
   var viewableRows;
   var oldRndUp;
   var __viewMetrics;
   var owner;
   var border_mc;
   var invLayout;
   var mask_mc;
   var dispatchEvent;
   static var symbolName = "ScrollView";
   static var symbolOwner = mx.core.ScrollView;
   static var version = "2.0.1.78";
   var className = "ScrollView";
   var __vScrollPolicy = "auto";
   var __hScrollPolicy = "off";
   var __vPosition = 0;
   var __hPosition = 0;
   var numberOfCols = 0;
   var rowC = 0;
   var columnWidth = 1;
   var rowH = 0;
   var heightPadding = 0;
   var widthPadding = 0;
   var MASK_DEPTH = 10000;
   function ScrollView()
   {
      super();
   }
   function getHScrollPolicy(Void)
   {
      return this.__hScrollPolicy;
   }
   function setHScrollPolicy(policy)
   {
      this.__hScrollPolicy = policy.toLowerCase();
      if(this.__width == undefined)
      {
         return undefined;
      }
      this.setScrollProperties(this.numberOfCols,this.columnWidth,this.rowC,this.rowH,this.heightPadding,this.widthPadding);
   }
   function get hScrollPolicy()
   {
      return this.getHScrollPolicy();
   }
   function set hScrollPolicy(policy)
   {
      this.setHScrollPolicy(policy);
   }
   function getVScrollPolicy(Void)
   {
      return this.__vScrollPolicy;
   }
   function setVScrollPolicy(policy)
   {
      this.__vScrollPolicy = policy.toLowerCase();
      if(this.__width == undefined)
      {
         return undefined;
      }
      this.setScrollProperties(this.numberOfCols,this.columnWidth,this.rowC,this.rowH,this.heightPadding,this.widthPadding);
   }
   function get vScrollPolicy()
   {
      return this.getVScrollPolicy();
   }
   function set vScrollPolicy(policy)
   {
      this.setVScrollPolicy(policy);
   }
   function get hPosition()
   {
      return this.getHPosition();
   }
   function set hPosition(pos)
   {
      this.setHPosition(pos);
   }
   function getHPosition(Void)
   {
      return this.__hPosition;
   }
   function setHPosition(pos)
   {
      this.hScroller.scrollPosition = pos;
      this.__hPosition = pos;
   }
   function get vPosition()
   {
      return this.getVPosition();
   }
   function set vPosition(pos)
   {
      this.setVPosition(pos);
   }
   function getVPosition(Void)
   {
      return this.__vPosition;
   }
   function setVPosition(pos)
   {
      this.vScroller.scrollPosition = pos;
      this.__vPosition = pos;
   }
   function get maxVPosition()
   {
      var _loc2_ = this.vScroller.maxPos;
      return _loc2_ != undefined ? _loc2_ : 0;
   }
   function get maxHPosition()
   {
      return this.getMaxHPosition();
   }
   function set maxHPosition(pos)
   {
      this.setMaxHPosition(pos);
   }
   function getMaxHPosition(Void)
   {
      if(this.__maxHPosition != undefined)
      {
         return this.__maxHPosition;
      }
      var _loc2_ = this.hScroller.maxPos;
      return _loc2_ != undefined ? _loc2_ : 0;
   }
   function setMaxHPosition(pos)
   {
      this.__maxHPosition = pos;
   }
   function setScrollProperties(colCount, colWidth, rwCount, rwHeight, hPadding, wPadding)
   {
      var _loc3_ = this.getViewMetrics();
      if(hPadding == undefined)
      {
         hPadding = 0;
      }
      if(wPadding == undefined)
      {
         wPadding = 0;
      }
      this.propsInited = true;
      delete this.scrollAreaChanged;
      this.heightPadding = hPadding;
      this.widthPadding = wPadding;
      if(colWidth == 0)
      {
         colWidth = 1;
      }
      if(rwHeight == 0)
      {
         rwHeight = 1;
      }
      var _loc5_ = Math.ceil((this.__width - _loc3_.left - _loc3_.right - this.widthPadding) / colWidth);
      if(this.__hScrollPolicy == "on" || _loc5_ < colCount && this.__hScrollPolicy == "auto")
      {
         if(this.hScroller == undefined || this.specialHScrollCase)
         {
            delete this.specialHScrollCase;
            this.hScroller = this.createObject("HScrollBar","hSB",1001);
            this.hScroller.lineScrollSize = 20;
            this.hScroller.scrollHandler = this.scrollProxy;
            this.hScroller.scrollPosition = this.__hPosition;
            this.scrollAreaChanged = true;
         }
         if(this.numberOfCols != colCount || this.columnWidth != colWidth || this.viewableColumns != _loc5_ || this.scrollAreaChanged)
         {
            this.hScroller.setScrollProperties(_loc5_,0,colCount - _loc5_);
            this.viewableColumns = _loc5_;
            this.numberOfCols = colCount;
            this.columnWidth = colWidth;
         }
      }
      else if((this.__hScrollPolicy == "auto" || this.__hScrollPolicy == "off") && this.hScroller != undefined)
      {
         this.hScroller.removeMovieClip();
         delete this.hScroller;
         this.scrollAreaChanged = true;
      }
      if(this.heightPadding == undefined)
      {
         this.heightPadding = 0;
      }
      var _loc4_ = Math.ceil((this.__height - _loc3_.top - _loc3_.bottom - this.heightPadding) / rwHeight);
      var _loc8_ = (this.__height - _loc3_.top - _loc3_.bottom) % rwHeight != 0;
      if(this.__vScrollPolicy == "on" || _loc4_ < rwCount + _loc8_ && this.__vScrollPolicy == "auto")
      {
         if(this.vScroller == undefined)
         {
            this.vScroller = this.createObject("VScrollBar","vSB",1002);
            this.vScroller.scrollHandler = this.scrollProxy;
            this.vScroller.scrollPosition = this.__vPosition;
            this.scrollAreaChanged = true;
            this.rowH = 0;
         }
         if(this.rowC != rwCount || this.rowH != rwHeight || this.viewableRows + _loc8_ != _loc4_ + this.oldRndUp || this.scrollAreaChanged)
         {
            this.vScroller.setScrollProperties(_loc4_,0,rwCount - _loc4_ + _loc8_);
            this.viewableRows = _loc4_;
            this.rowC = rwCount;
            this.rowH = rwHeight;
            this.oldRndUp = _loc8_;
         }
      }
      else if((this.__vScrollPolicy == "auto" || this.__vScrollPolicy == "off") && this.vScroller != undefined)
      {
         this.vScroller.removeMovieClip();
         delete this.vScroller;
         this.scrollAreaChanged = true;
      }
      this.numberOfCols = colCount;
      this.columnWidth = colWidth;
      if(this.scrollAreaChanged)
      {
         this.doLayout();
         var _loc2_ = this.__viewMetrics;
         var _loc12_ = this.owner == undefined ? this : this.owner;
         _loc12_.layoutContent(_loc2_.left,_loc2_.top,this.columnWidth * this.numberOfCols - _loc2_.left - _loc2_.right,this.rowC * this.rowH,this.__width - _loc2_.left - _loc2_.right,this.__height - _loc2_.top - _loc2_.bottom);
      }
      if(!this.enabled)
      {
         this.setEnabled(false);
      }
   }
   function getViewMetrics(Void)
   {
      var _loc2_ = this.__viewMetrics;
      var _loc3_ = this.border_mc.borderMetrics;
      _loc2_.left = _loc3_.left;
      _loc2_.right = _loc3_.right;
      if(this.vScroller != undefined)
      {
         _loc2_.right += this.vScroller.minWidth;
      }
      _loc2_.top = _loc3_.top;
      if(this.hScroller == undefined && (this.__hScrollPolicy == "on" || this.__hScrollPolicy == true))
      {
         this.hScroller = this.createObject("FHScrollBar","hSB",1001);
         this.specialHScrollCase = true;
      }
      _loc2_.bottom = _loc3_.bottom;
      if(this.hScroller != undefined)
      {
         _loc2_.bottom += this.hScroller.minHeight;
      }
      return _loc2_;
   }
   function doLayout(Void)
   {
      var _loc10_ = this.width;
      var _loc8_ = this.height;
      delete this.invLayout;
      var _loc0_ = null;
      var _loc3_ = this.__viewMetrics = this.getViewMetrics();
      var _loc2_ = _loc3_.left;
      var _loc9_ = _loc3_.right;
      var _loc5_ = _loc3_.top;
      var _loc11_ = _loc3_.bottom;
      var _loc7_ = this.hScroller;
      var _loc6_ = this.vScroller;
      _loc7_.setSize(_loc10_ - _loc2_ - _loc9_,_loc7_.minHeight + 0);
      _loc7_.move(_loc2_,_loc8_ - _loc11_);
      _loc6_.setSize(_loc6_.minWidth + 0,_loc8_ - _loc5_ - _loc11_);
      _loc6_.move(_loc10_ - _loc9_,_loc5_);
      var _loc4_ = this.mask_mc;
      _loc4_._width = _loc10_ - _loc2_ - _loc9_;
      _loc4_._height = _loc8_ - _loc5_ - _loc11_;
      _loc4_._x = _loc2_;
      _loc4_._y = _loc5_;
   }
   function createChild(id, name, props)
   {
      var _loc2_ = super.createChild(id,name,props);
      return _loc2_;
   }
   function init(Void)
   {
      super.init();
      this.__viewMetrics = new Object();
      if(_global.__SVMouseWheelManager == undefined)
      {
         var _loc0_ = null;
         var _loc4_ = _global.__SVMouseWheelManager = new Object();
         _loc4_.onMouseWheel = this.__onMouseWheel;
         Mouse.addListener(_loc4_);
      }
   }
   function __onMouseWheel(delta, scrollTarget)
   {
      var _loc4_ = scrollTarget;
      var _loc1_ = undefined;
      while(_loc4_ != undefined)
      {
         if(_loc4_ instanceof mx.core.ScrollView)
         {
            _loc1_ = _loc4_;
            false;
         }
         _loc4_ = _loc4_._parent;
      }
      if(_loc1_ != undefined)
      {
         _loc4_ = delta > 0 ? -1 : 1;
         var _loc2_ = _loc1_.vScroller.lineScrollSize;
         if(_loc2_ == undefined)
         {
            _loc2_ = 0;
         }
         _loc2_ = Math.max(Math.abs(delta),_loc2_);
         var _loc3_ = _loc1_.vPosition + _loc2_ * _loc4_;
         _loc1_.vPosition = Math.max(0,Math.min(_loc3_,_loc1_.maxVPosition));
         _loc1_.dispatchEvent({type:"scroll",direction:"vertical",position:_loc1_.vPosition});
      }
   }
   function createChildren(Void)
   {
      super.createChildren();
      if(this.mask_mc == undefined)
      {
         this.mask_mc = this.createObject("BoundingBox","mask_mc",this.MASK_DEPTH);
      }
      this.mask_mc._visible = false;
   }
   function invalidate(Void)
   {
      super.invalidate();
   }
   function draw(Void)
   {
      this.size();
   }
   function size(Void)
   {
      super.size();
   }
   function scrollProxy(docObj)
   {
      this._parent.onScroll(docObj);
   }
   function onScroll(docObj)
   {
      var _loc3_ = docObj.target;
      var _loc2_ = _loc3_.scrollPosition;
      if(_loc3_ == this.vScroller)
      {
         var _loc4_ = "vertical";
         var _loc5_ = "__vPosition";
      }
      else
      {
         _loc4_ = "horizontal";
         _loc5_ = "__hPosition";
      }
      this.dispatchEvent({type:"scroll",direction:_loc4_,position:_loc2_});
      this[_loc5_] = _loc2_;
   }
   function setEnabled(v)
   {
      this.vScroller.enabled = this.hScroller.enabled = v;
   }
   function childLoaded(obj)
   {
      super.childLoaded(obj);
      obj.setMask(this.mask_mc);
   }
}
