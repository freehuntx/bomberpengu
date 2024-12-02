var §\x01§ = 845;
var §\x0f§ = 1;
class mx.controls.List extends mx.controls.listclasses.ScrollSelectList
{
   var border_mc;
   var __labels;
   var setDataProvider;
   var __dataProvider;
   var __maxHPosition;
   var invScrollProps;
   var __width;
   var totalWidth;
   var totalHeight;
   var displayWidth;
   var vScroller;
   var listContent;
   var labels;
   var data;
   var mask_mc;
   var __height;
   var invRowHeight;
   var invLayoutContent;
   var oldVWidth;
   static var symbolOwner = mx.controls.List;
   static var symbolName = "List";
   var className = "List";
   static var version = "2.0.1.78";
   var clipParameters = {rowHeight:1,enabled:1,visible:1,labels:1};
   var scrollDepth = 1;
   var __vScrollPolicy = "on";
   var autoHScrollAble = false;
   function List()
   {
      super();
   }
   function setEnabled(v)
   {
      super.setEnabled(v);
      this.border_mc.backgroundColorName = !v ? "backgroundDisabledColor" : "backgroundColor";
      this.border_mc.invalidate();
   }
   function get labels()
   {
      return this.__labels;
   }
   function set labels(lbls)
   {
      this.__labels = lbls;
      this.setDataProvider(lbls);
   }
   function setVPosition(pos)
   {
      pos = Math.min(this.__dataProvider.length - this.rowCount + this.roundUp,pos);
      pos = Math.max(0,pos);
      super.setVPosition(pos);
   }
   function setHPosition(pos)
   {
      pos = Math.max(Math.min(this.__maxHPosition,pos),0);
      super.setHPosition(pos);
      this.hScroll(pos);
   }
   function setMaxHPosition(pos)
   {
      this.__maxHPosition = pos;
      this.invScrollProps = true;
      this.invalidate();
   }
   function setHScrollPolicy(policy)
   {
      if(policy.toLowerCase() == "auto" && !this.autoHScrollAble)
      {
         return undefined;
      }
      super.setHScrollPolicy(policy);
      if(policy == "off")
      {
         this.setHPosition(0);
         this.setVPosition(Math.min(this.__dataProvider.length - this.rowCount + this.roundUp,this.__vPosition));
      }
   }
   function setRowCount(rC)
   {
      if(isNaN(rC))
      {
         return undefined;
      }
      var _loc2_ = this.getViewMetrics();
      this.setSize(this.__width,this.__rowHeight * rC + _loc2_.top + _loc2_.bottom);
   }
   function layoutContent(x, y, tW, tH, dW, dH)
   {
      this.totalWidth = tW;
      this.totalHeight = tH;
      this.displayWidth = dW;
      var _loc4_ = !(this.__hScrollPolicy == "on" || this.__hScrollPolicy == "auto") ? dW : Math.max(tW,dW);
      super.layoutContent(x,y,_loc4_,dH);
   }
   function modelChanged(eventObj)
   {
      super.modelChanged(eventObj);
      var _loc3_ = eventObj.eventName;
      if(_loc3_ == "addItems" || _loc3_ == "removeItems" || _loc3_ == "updateAll" || _loc3_ == "filterModel")
      {
         this.invScrollProps = true;
         this.invalidate("invScrollProps");
      }
   }
   function onScroll(eventObj)
   {
      var _loc3_ = eventObj.target;
      if(_loc3_ == this.vScroller)
      {
         this.setVPosition(_loc3_.scrollPosition);
      }
      else
      {
         this.hScroll(_loc3_.scrollPosition);
      }
      super.onScroll(eventObj);
   }
   function hScroll(pos)
   {
      this.__hPosition = pos;
      this.listContent._x = - pos;
   }
   function init(Void)
   {
      super.init();
      if(this.labels.length > 0)
      {
         var _loc6_ = new Array();
         var _loc3_ = 0;
         while(_loc3_ < this.labels.length)
         {
            _loc6_.addItem({label:this.labels[_loc3_],data:this.data[_loc3_]});
            _loc3_ = _loc3_ + 1;
         }
         this.setDataProvider(_loc6_);
      }
      this.__maxHPosition = 0;
   }
   function createChildren(Void)
   {
      super.createChildren();
      this.listContent.setMask(this.mask_mc);
      this.border_mc.move(0,0);
      this.border_mc.setSize(this.__width,this.__height);
   }
   function getRowCount(Void)
   {
      var _loc2_ = this.getViewMetrics();
      return this.__rowCount != 0 ? this.__rowCount : Math.ceil((this.__height - _loc2_.top - _loc2_.bottom) / this.__rowHeight);
   }
   function size(Void)
   {
      super.size();
      this.configureScrolling();
      var _loc3_ = this.getViewMetrics();
      this.layoutContent(_loc3_.left,_loc3_.top,this.__width + this.__maxHPosition,this.totalHeight,this.__width - _loc3_.left - _loc3_.right,this.__height - _loc3_.top - _loc3_.bottom);
   }
   function draw(Void)
   {
      if(this.invRowHeight)
      {
         this.invScrollProps = true;
         super.draw();
         this.listContent.setMask(this.mask_mc);
         this.invLayoutContent = true;
      }
      if(this.invScrollProps)
      {
         this.configureScrolling();
         delete this.invScrollProps;
      }
      if(this.invLayoutContent)
      {
         var _loc3_ = this.getViewMetrics();
         this.layoutContent(_loc3_.left,_loc3_.top,this.__width + this.__maxHPosition,this.totalHeight,this.__width - _loc3_.left - _loc3_.right,this.__height - _loc3_.top - _loc3_.bottom);
      }
      super.draw();
   }
   function configureScrolling(Void)
   {
      var _loc2_ = this.__dataProvider.length;
      if(this.__vPosition > Math.max(0,_loc2_ - this.getRowCount() + this.roundUp))
      {
         this.setVPosition(Math.max(0,Math.min(_loc2_ - this.getRowCount() + this.roundUp,this.__vPosition)));
      }
      var _loc3_ = this.getViewMetrics();
      var _loc4_ = this.__hScrollPolicy == "off" ? this.__width - _loc3_.left - _loc3_.right : this.__maxHPosition + this.__width - _loc3_.left - _loc3_.right;
      if(_loc2_ == undefined)
      {
         _loc2_ = 0;
      }
      this.setScrollProperties(_loc4_,1,_loc2_,this.__rowHeight);
      if(this.oldVWidth != _loc4_)
      {
         this.invLayoutContent = true;
      }
      this.oldVWidth = _loc4_;
   }
}
