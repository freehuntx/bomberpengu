var §\x01§ = 594;
var §\x0f§ = 1;
class mx.controls.listclasses.ScrollSelectList extends mx.core.ScrollView
{
   var invLayoutContent;
   var rows;
   var topRowZ;
   var listContent;
   var __dataProvider;
   var tW;
   var layoutX;
   var layoutY;
   var tH;
   var invRowHeight;
   var __height;
   var invUpdateControl;
   var __cellRenderer;
   var __labelFunction;
   var __iconField;
   var __iconFunction;
   var getLength;
   var baseRowZ;
   var lastPosition;
   var propertyTable;
   var isSelected;
   var wasKeySelected;
   var changeFlag;
   var clearSelected;
   var selectItem;
   var lastSelected;
   var dispatchEvent;
   var dragScrolling;
   var scrollInterval;
   var isPressed;
   var onMouseUp;
   var getSelectedIndex;
   var border_mc;
   static var mixIt1 = mx.controls.listclasses.DataSelector.Initialize(mx.controls.listclasses.ScrollSelectList);
   static var mixIt2 = mx.controls.listclasses.DataProvider.Initialize(Array);
   var CONTENTDEPTH = 100;
   var __hPosition = 0;
   var __rowRenderer = "SelectableRow";
   var __rowHeight = 22;
   var __rowCount = 0;
   var __labelField = "label";
   var minScrollInterval = 30;
   var dropEnabled = false;
   var dragEnabled = false;
   var className = "ScrollSelectList";
   var isRowStyle = {styleName:true,backgroundColor:true,selectionColor:true,rollOverColor:true,selectionDisabledColor:true,backgroundDisabledColor:true,textColor:true,textSelectedColor:true,textRollOverColor:true,textDisabledColor:true,alternatingRowColors:true,defaultIcon:true};
   var roundUp = 0;
   var selectable = true;
   var multipleSelection = false;
   function ScrollSelectList()
   {
      super();
   }
   function layoutContent(x, y, w, h)
   {
      delete this.invLayoutContent;
      var _loc4_ = Math.ceil(h / this.__rowHeight);
      this.roundUp = h % this.__rowHeight != 0;
      var _loc12_ = _loc4_ - this.__rowCount;
      if(_loc12_ < 0)
      {
         var _loc3_ = _loc4_;
         while(_loc3_ < this.__rowCount)
         {
            this.rows[_loc3_].removeMovieClip();
            delete this.rows[_loc3_];
            _loc3_ = _loc3_ + 1;
         }
         this.topRowZ += _loc12_;
      }
      else if(_loc12_ > 0)
      {
         if(this.rows == undefined)
         {
            this.rows = new Array();
         }
         _loc3_ = this.__rowCount;
         while(_loc3_ < _loc4_)
         {
            var _loc0_ = null;
            var _loc2_ = this.rows[_loc3_] = this.listContent.createObject(this.__rowRenderer,"listRow" + this.topRowZ++,this.topRowZ,{owner:this,styleName:this,rowIndex:_loc3_});
            _loc2_._x = x;
            _loc2_._y = Math.round(_loc3_ * this.__rowHeight + y);
            _loc2_.setSize(w,this.__rowHeight);
            _loc2_.drawRow(this.__dataProvider.getItemAt(this.__vPosition + _loc3_),this.getStateAt(this.__vPosition + _loc3_));
            _loc2_.lastY = _loc2_._y;
            _loc3_ = _loc3_ + 1;
         }
      }
      if(w != this.tW)
      {
         var _loc11_ = _loc12_ <= 0 ? _loc4_ : this.__rowCount;
         _loc3_ = 0;
         while(_loc3_ < _loc11_)
         {
            this.rows[_loc3_].setSize(w,this.__rowHeight);
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.layoutX != x || this.layoutY != y)
      {
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.rows[_loc3_]._x = x;
            this.rows[_loc3_]._y = Math.round(_loc3_ * this.__rowHeight + y);
            _loc3_ = _loc3_ + 1;
         }
      }
      this.__rowCount = _loc4_;
      this.layoutX = x;
      this.layoutY = y;
      this.tW = w;
      this.tH = h;
   }
   function getRowHeight(Void)
   {
      return this.__rowHeight;
   }
   function setRowHeight(v)
   {
      this.__rowHeight = v;
      this.invRowHeight = true;
      this.invalidate();
   }
   function get rowHeight()
   {
      return this.getRowHeight();
   }
   function set rowHeight(w)
   {
      this.setRowHeight(w);
   }
   function setRowCount(v)
   {
      this.__rowCount = v;
   }
   function getRowCount(Void)
   {
      var _loc2_ = this.__rowCount != 0 ? this.__rowCount : Math.ceil(this.__height / this.__rowHeight);
      return _loc2_;
   }
   function get rowCount()
   {
      return this.getRowCount();
   }
   function set rowCount(w)
   {
      this.setRowCount(w);
   }
   function setEnabled(v)
   {
      super.setEnabled(v);
      this.invUpdateControl = true;
      this.invalidate();
   }
   function setCellRenderer(cR)
   {
      this.__cellRenderer = cR;
      var _loc2_ = 0;
      while(_loc2_ < this.rows.length)
      {
         this.rows[_loc2_].setCellRenderer(true);
         _loc2_ = _loc2_ + 1;
      }
      this.invUpdateControl = true;
      this.invalidate();
   }
   function set cellRenderer(cR)
   {
      this.setCellRenderer(cR);
   }
   function get cellRenderer()
   {
      return this.__cellRenderer;
   }
   function set labelField(field)
   {
      this.setLabelField(field);
   }
   function setLabelField(field)
   {
      this.__labelField = field;
      this.invUpdateControl = true;
      this.invalidate();
   }
   function get labelField()
   {
      return this.__labelField;
   }
   function set labelFunction(func)
   {
      this.setLabelFunction(func);
   }
   function setLabelFunction(func)
   {
      this.__labelFunction = func;
      this.invUpdateControl = true;
      this.invalidate();
   }
   function get labelFunction()
   {
      return this.__labelFunction;
   }
   function set iconField(field)
   {
      this.setIconField(field);
   }
   function setIconField(field)
   {
      this.__iconField = field;
      this.invUpdateControl = true;
      this.invalidate();
   }
   function get iconField()
   {
      return this.__iconField;
   }
   function set iconFunction(func)
   {
      this.setIconFunction(func);
   }
   function setIconFunction(func)
   {
      this.__iconFunction = func;
      this.invUpdateControl = true;
      this.invalidate();
   }
   function get iconFunction()
   {
      return this.__iconFunction;
   }
   function setVPosition(pos)
   {
      if(pos < 0)
      {
         return undefined;
      }
      if(pos > 0 && pos > this.getLength() - this.__rowCount + this.roundUp)
      {
         return undefined;
      }
      var _loc8_ = pos - this.__vPosition;
      if(_loc8_ == 0)
      {
         return undefined;
      }
      this.__vPosition = pos;
      var _loc10_ = _loc8_ > 0;
      _loc8_ = Math.abs(_loc8_);
      if(_loc8_ >= this.__rowCount)
      {
         this.updateControl();
      }
      else
      {
         var _loc4_ = new Array();
         var _loc9_ = this.__rowCount - _loc8_;
         var _loc12_ = _loc8_ * this.__rowHeight;
         var _loc11_ = _loc9_ * this.__rowHeight;
         var _loc6_ = !_loc10_ ? -1 : 1;
         var _loc3_ = 0;
         while(_loc3_ < this.__rowCount)
         {
            if(_loc3_ < _loc8_ && _loc10_ || _loc3_ >= _loc9_ && !_loc10_)
            {
               this.rows[_loc3_]._y += Math.round(_loc6_ * _loc11_);
               var _loc5_ = _loc3_ + _loc6_ * _loc9_;
               var _loc7_ = this.__vPosition + _loc5_;
               _loc4_[_loc5_] = this.rows[_loc3_];
               _loc4_[_loc5_].rowIndex = _loc5_;
               _loc4_[_loc5_].drawRow(this.__dataProvider.getItemAt(_loc7_),this.getStateAt(_loc7_),false);
            }
            else
            {
               this.rows[_loc3_]._y -= Math.round(_loc6_ * _loc12_);
               _loc5_ = _loc3_ - _loc6_ * _loc8_;
               _loc4_[_loc5_] = this.rows[_loc3_];
               _loc4_[_loc5_].rowIndex = _loc5_;
            }
            _loc3_ = _loc3_ + 1;
         }
         this.rows = _loc4_;
         _loc3_ = 0;
         while(_loc3_ < this.__rowCount)
         {
            this.rows[_loc3_].swapDepths(this.baseRowZ + _loc3_);
            _loc3_ = _loc3_ + 1;
         }
      }
      this.lastPosition = pos;
      super.setVPosition(pos);
   }
   function setPropertiesAt(index, obj)
   {
      var _loc2_ = this.__dataProvider.getItemID(index);
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      if(this.propertyTable == undefined)
      {
         this.propertyTable = new Object();
      }
      this.propertyTable[_loc2_] = obj;
      this.rows[index - this.__vPosition].drawRow(this.__dataProvider.getItemAt(index),this.getStateAt(index));
   }
   function getPropertiesAt(index)
   {
      var _loc2_ = this.__dataProvider.getItemID(index);
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      return this.propertyTable[_loc2_];
   }
   function getPropertiesOf(obj)
   {
      var _loc2_ = obj.getID();
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      return this.propertyTable[_loc2_];
   }
   function getStyle(styleProp)
   {
      var _loc2_ = super.getStyle(styleProp);
      var _loc3_ = mx.styles.StyleManager.colorNames[_loc2_];
      if(_loc3_ != undefined)
      {
         _loc2_ = _loc3_;
      }
      return _loc2_;
   }
   function updateControl(Void)
   {
      var _loc2_ = 0;
      while(_loc2_ < this.__rowCount)
      {
         this.rows[_loc2_].drawRow(this.__dataProvider.getItemAt(_loc2_ + this.__vPosition),this.getStateAt(_loc2_ + this.__vPosition));
         _loc2_ = _loc2_ + 1;
      }
      delete this.invUpdateControl;
   }
   function getStateAt(index)
   {
      return !this.isSelected(index) ? "normal" : "selected";
   }
   function selectRow(rowIndex, transition, allowChangeEvent)
   {
      if(!this.selectable)
      {
         return undefined;
      }
      var _loc3_ = this.__vPosition + rowIndex;
      var _loc8_ = this.__dataProvider.getItemAt(_loc3_);
      var _loc5_ = this.rows[rowIndex];
      if(_loc8_ == undefined)
      {
         return undefined;
      }
      if(transition == undefined)
      {
         transition = true;
      }
      if(allowChangeEvent == undefined)
      {
         allowChangeEvent = this.wasKeySelected;
      }
      this.changeFlag = true;
      if(!this.multipleSelection && !Key.isDown(17) || !Key.isDown(16) && !Key.isDown(17))
      {
         this.clearSelected(transition);
         this.selectItem(_loc3_,true);
         this.lastSelected = _loc3_;
         _loc5_.drawRow(_loc5_.item,this.getStateAt(_loc3_),transition);
      }
      else if(Key.isDown(16) && this.multipleSelection)
      {
         if(this.lastSelected == undefined)
         {
            this.lastSelected = _loc3_;
         }
         var _loc4_ = this.lastSelected >= _loc3_ ? -1 : 1;
         this.clearSelected(false);
         var _loc2_ = this.lastSelected;
         while(_loc2_ != _loc3_)
         {
            this.selectItem(_loc2_,true);
            if(_loc2_ >= this.__vPosition && _loc2_ < this.__vPosition + this.__rowCount)
            {
               this.rows[_loc2_ - this.__vPosition].drawRow(this.rows[_loc2_ - this.__vPosition].item,"selected",false);
            }
            _loc2_ += _loc4_;
         }
         this.selectItem(_loc3_,true);
         _loc5_.drawRow(_loc5_.item,"selected",transition);
      }
      else if(Key.isDown(17))
      {
         var _loc7_ = this.isSelected(_loc3_);
         if(!this.multipleSelection || this.wasKeySelected)
         {
            this.clearSelected(transition);
         }
         if(!(!this.multipleSelection && _loc7_))
         {
            this.selectItem(_loc3_,!_loc7_);
            var _loc9_ = !!_loc7_ ? "normal" : "selected";
            _loc5_.drawRow(_loc5_.item,_loc9_,transition);
         }
         this.lastSelected = _loc3_;
      }
      if(allowChangeEvent)
      {
         this.dispatchEvent({type:"change"});
      }
      delete this.wasKeySelected;
   }
   function dragScroll(Void)
   {
      clearInterval(this.dragScrolling);
      if(this._ymouse < 0)
      {
         this.setVPosition(this.__vPosition - 1);
         this.selectRow(0,false);
         var _loc2_ = Math.min(- this._ymouse - 30,0);
         this.scrollInterval = 0.593 * _loc2_ * _loc2_ + 1 + this.minScrollInterval;
         this.dragScrolling = setInterval(this,"dragScroll",this.scrollInterval);
         this.dispatchEvent({type:"scroll",direction:"vertical",position:this.__vPosition});
      }
      else if(this._ymouse > this.__height)
      {
         var _loc3_ = this.__vPosition;
         this.setVPosition(this.__vPosition + 1);
         if(_loc3_ != this.__vPosition)
         {
            this.selectRow(this.__rowCount - 1 - this.roundUp,false);
         }
         _loc2_ = Math.min(this._ymouse - this.__height - 30,0);
         this.scrollInterval = 0.593 * _loc2_ * _loc2_ + 1 + this.minScrollInterval;
         this.dragScrolling = setInterval(this,"dragScroll",this.scrollInterval);
         this.dispatchEvent({type:"scroll",direction:"vertical",position:this.__vPosition});
      }
      else
      {
         this.dragScrolling = setInterval(this,"dragScroll",15);
      }
      updateAfterEvent();
   }
   function __onMouseUp(Void)
   {
      clearInterval(this.dragScrolling);
      delete this.dragScrolling;
      delete this.dragScrolling;
      delete this.isPressed;
      delete this.onMouseUp;
      if(!this.selectable)
      {
         return undefined;
      }
      if(this.changeFlag)
      {
         this.dispatchEvent({type:"change"});
      }
      delete this.changeFlag;
   }
   function moveSelBy(incr)
   {
      if(!this.selectable)
      {
         this.setVPosition(this.__vPosition + incr);
         return undefined;
      }
      var _loc3_ = this.getSelectedIndex();
      if(_loc3_ == undefined)
      {
         _loc3_ = -1;
      }
      var _loc2_ = _loc3_ + incr;
      _loc2_ = Math.max(0,_loc2_);
      _loc2_ = Math.min(this.getLength() - 1,_loc2_);
      if(_loc2_ == _loc3_)
      {
         return undefined;
      }
      if(_loc3_ < this.__vPosition || _loc3_ >= this.__vPosition + this.__rowCount)
      {
         this.setVPosition(_loc3_);
      }
      if(_loc2_ >= this.__vPosition + this.__rowCount - this.roundUp || _loc2_ < this.__vPosition)
      {
         this.setVPosition(this.__vPosition + incr);
      }
      this.wasKeySelected = true;
      this.selectRow(_loc2_ - this.__vPosition,false);
   }
   function keyDown(e)
   {
      if(this.selectable)
      {
         if(this.findInputText())
         {
            return undefined;
         }
      }
      if(e.code == 40)
      {
         this.moveSelBy(1);
      }
      else if(e.code == 38)
      {
         this.moveSelBy(-1);
      }
      else if(e.code == 34)
      {
         if(this.selectable)
         {
            var _loc3_ = this.getSelectedIndex();
            if(_loc3_ == undefined)
            {
               _loc3_ = 0;
            }
            this.setVPosition(_loc3_);
         }
         this.moveSelBy(this.__rowCount - 1 - this.roundUp);
      }
      else if(e.code == 33)
      {
         if(this.selectable)
         {
            _loc3_ = this.getSelectedIndex();
            if(_loc3_ == undefined)
            {
               _loc3_ = 0;
            }
            this.setVPosition(_loc3_);
         }
         this.moveSelBy(1 - this.__rowCount + this.roundUp);
      }
      else if(e.code == 36)
      {
         this.moveSelBy(- this.__dataProvider.length);
      }
      else if(e.code == 35)
      {
         this.moveSelBy(this.__dataProvider.length);
      }
   }
   function findInputText(Void)
   {
      var _loc2_ = Key.getAscii();
      if(_loc2_ >= 33 && _loc2_ <= 126)
      {
         this.findString(String.fromCharCode(_loc2_));
         return true;
      }
   }
   function findString(str)
   {
      if(this.__dataProvider.length == 0)
      {
         return undefined;
      }
      var _loc4_ = this.getSelectedIndex();
      if(_loc4_ == undefined)
      {
         _loc4_ = 0;
      }
      var _loc6_ = 0;
      var _loc3_ = _loc4_ + 1;
      while(_loc3_ != _loc4_)
      {
         var _loc2_ = this.__dataProvider.getItemAt(_loc3_);
         if(_loc2_ instanceof XMLNode)
         {
            _loc2_ = _loc2_.attributes[this.__labelField];
         }
         else if(typeof _loc2_ != "string")
         {
            _loc2_ = String(_loc2_[this.__labelField]);
         }
         _loc2_ = _loc2_.substring(0,str.length);
         if(str == _loc2_ || str.toUpperCase() == _loc2_.toUpperCase())
         {
            _loc6_ = _loc3_ - _loc4_;
            break;
         }
         if(_loc3_ >= this.getLength() - 1)
         {
            _loc3_ = -1;
         }
         _loc3_ = _loc3_ + 1;
      }
      if(_loc6_ != 0)
      {
         this.moveSelBy(_loc6_);
      }
   }
   function onRowPress(rowIndex)
   {
      if(!this.enabled)
      {
         return undefined;
      }
      this.isPressed = true;
      this.dragScrolling = setInterval(this,"dragScroll",15);
      this.onMouseUp = this.__onMouseUp;
      if(!this.selectable)
      {
         return undefined;
      }
      this.selectRow(rowIndex);
   }
   function onRowRelease(rowIndex)
   {
   }
   function onRowRollOver(rowIndex)
   {
      if(!this.enabled)
      {
         return undefined;
      }
      var _loc2_ = this.rows[rowIndex].item;
      if(this.getStyle("useRollOver") && _loc2_ != undefined)
      {
         this.rows[rowIndex].drawRow(_loc2_,"highlighted",false);
      }
      this.dispatchEvent({type:"itemRollOver",index:rowIndex + this.__vPosition});
   }
   function onRowRollOut(rowIndex)
   {
      if(!this.enabled)
      {
         return undefined;
      }
      if(this.getStyle("useRollOver"))
      {
         this.rows[rowIndex].drawRow(this.rows[rowIndex].item,this.getStateAt(rowIndex + this.__vPosition),false);
      }
      this.dispatchEvent({type:"itemRollOut",index:rowIndex + this.__vPosition});
   }
   function onRowDragOver(rowIndex)
   {
      if(!this.enabled || this.isPressed != true || !this.selectable)
      {
         return undefined;
      }
      if(!this.dropEnabled)
      {
         if(this.dragScrolling)
         {
            this.selectRow(rowIndex,false);
         }
         else
         {
            this.onMouseUp = this.__onMouseUp;
            this.onRowPress(rowIndex);
         }
      }
   }
   function onRowDragOut(rowIndex)
   {
      if(!this.enabled)
      {
         return undefined;
      }
      if(!this.dragEnabled)
      {
         this.onRowRollOut(rowIndex);
      }
   }
   function init(Void)
   {
      super.init();
      this.tabEnabled = true;
      this.tabChildren = false;
      if(this.__dataProvider == undefined)
      {
         this.__dataProvider = new Array();
         this.__dataProvider.addEventListener("modelChanged",this);
      }
      this.baseRowZ = this.topRowZ = 10;
   }
   function createChildren(Void)
   {
      super.createChildren();
      this.listContent = this.createEmptyMovieClip("content_mc",this.CONTENTDEPTH);
      this.invLayoutContent = true;
      this.invalidate();
   }
   function draw(Void)
   {
      if(this.invRowHeight)
      {
         delete this.invRowHeight;
         this.__rowCount = 0;
         this.listContent.removeMovieClip();
         this.listContent = this.createEmptyMovieClip("content_mc",this.CONTENTDEPTH);
      }
      if(this.invUpdateControl)
      {
         this.updateControl();
      }
      this.border_mc.draw();
   }
   function invalidateStyle(propName)
   {
      if(this.isRowStyle[propName])
      {
         this.invUpdateControl = true;
         this.invalidate();
      }
      else
      {
         var _loc3_ = 0;
         while(_loc3_ < this.__rowCount)
         {
            this.rows[_loc3_].invalidateStyle(propName);
            _loc3_ = _loc3_ + 1;
         }
      }
      super.invalidateStyle(propName);
   }
}
