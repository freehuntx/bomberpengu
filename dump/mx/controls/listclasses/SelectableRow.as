var §\x01§ = 30;
var §\x0f§ = 1;
class mx.controls.listclasses.SelectableRow extends mx.core.UIComponent
{
   var __height;
   var cell;
   var owner;
   var rowIndex;
   var icon_mc;
   var __width;
   var backGround;
   var highlight;
   var highlightColor;
   var listOwner;
   var item;
   var isChangedToSelected;
   var bGTween;
   var grandOwner;
   static var LOWEST_DEPTH = -16384;
   var state = "normal";
   var disabledColor = 15263976;
   var normalColor = 16777215;
   function SelectableRow()
   {
      super();
   }
   function setValue(itmObj, state)
   {
      var _loc7_ = this.__height;
      var _loc2_ = this.cell;
      var _loc5_ = this.owner;
      var _loc8_ = this.itemToString(itmObj);
      if(_loc2_.getValue() != _loc8_)
      {
         _loc2_.setValue(_loc8_,itmObj,state);
      }
      var _loc4_ = _loc5_.getPropertiesAt(this.rowIndex + _loc5_.__vPosition).icon;
      if(_loc4_ == undefined)
      {
         _loc4_ = _loc5_.__iconFunction(itmObj);
         if(_loc4_ == undefined)
         {
            _loc4_ = itmObj[_loc5_.__iconField];
            if(_loc4_ == undefined)
            {
               _loc4_ = _loc5_.getStyle("defaultIcon");
            }
         }
      }
      var _loc3_ = this.icon_mc;
      if(_loc4_ != undefined && itmObj != undefined)
      {
         _loc3_ = this.createObject(_loc4_,"icon_mc",20);
         _loc3_._x = 2;
         _loc3_._y = (_loc7_ - _loc3_._height) / 2;
         _loc2_._x = 4 + _loc3_._width;
      }
      else
      {
         _loc3_.removeMovieClip();
         _loc2_._x = 2;
      }
      var _loc9_ = _loc3_ != undefined ? _loc3_._width : 0;
      _loc2_.setSize(this.__width - _loc9_,Math.min(_loc7_,_loc2_.getPreferredHeight()));
      _loc2_._y = (_loc7_ - _loc2_._height) / 2;
   }
   function size(Void)
   {
      var _loc3_ = this.backGround;
      var _loc2_ = this.cell;
      var _loc4_ = this.__height;
      var _loc5_ = this.__width;
      var _loc6_ = this.icon_mc != undefined ? this.icon_mc._width : 0;
      _loc2_.setSize(_loc5_ - _loc6_,Math.min(_loc4_,_loc2_.getPreferredHeight()));
      _loc2_._y = (_loc4_ - _loc2_._height) / 2;
      this.icon_mc._y = (_loc4_ - this.icon_mc._height) / 2;
      _loc3_._x = 0;
      _loc3_._width = _loc5_;
      _loc3_._height = _loc4_;
      this.drawRowFill(_loc3_,this.normalColor);
      this.drawRowFill(this.highlight,this.highlightColor);
   }
   function setCellRenderer(forceSizing)
   {
      var _loc3_ = this.owner.__cellRenderer;
      var _loc4_ = undefined;
      if(this.cell != undefined)
      {
         _loc4_ = this.cell._x;
         this.cell.removeMovieClip();
         this.cell.removeTextField();
      }
      var _loc2_ = undefined;
      if(_loc3_ == undefined)
      {
         var _loc0_ = null;
         _loc2_ = this.cell = this.createLabel("cll",0,{styleName:this});
         _loc2_.styleName = this.owner;
         _loc2_.selectable = false;
         _loc2_.tabEnabled = false;
         _loc2_.background = false;
         _loc2_.border = false;
      }
      else if(typeof _loc3_ == "string")
      {
         var _loc0_ = null;
         _loc2_ = this.cell = this.createObject(_loc3_,"cll",0,{styleName:this});
      }
      else
      {
         var _loc0_ = null;
         _loc2_ = this.cell = this.createClassObject(_loc3_,"cll",0,{styleName:this});
      }
      _loc2_.owner = this;
      _loc2_.listOwner = this.owner;
      _loc2_.getCellIndex = this.getCellIndex;
      _loc2_.getDataLabel = this.getDataLabel;
      if(_loc4_ != undefined)
      {
         _loc2_._x = _loc4_;
      }
      if(forceSizing)
      {
         this.size();
      }
   }
   function getCellIndex(Void)
   {
      return {columnIndex:0,itemIndex:this.owner.rowIndex + this.listOwner.__vPosition};
   }
   function getDataLabel()
   {
      return this.listOwner.labelField;
   }
   function init(Void)
   {
      super.init();
      this.tabEnabled = false;
   }
   function createChildren(Void)
   {
      this.setCellRenderer(false);
      this.setupBG();
      this.setState(this.state,false);
   }
   function drawRow(itmObj, state, transition)
   {
      this.item = itmObj;
      this.setState(state,transition);
      this.setValue(itmObj,state,transition);
   }
   function itemToString(itmObj)
   {
      if(itmObj == undefined)
      {
         return " ";
      }
      var _loc2_ = this.owner.__labelFunction(itmObj);
      if(_loc2_ == undefined)
      {
         _loc2_ = !(itmObj instanceof XMLNode) ? itmObj[this.owner.__labelField] : itmObj.attributes[this.owner.__labelField];
         if(_loc2_ == undefined)
         {
            _loc2_ = " ";
            if(typeof itmObj == "object")
            {
               for(var _loc4_ in itmObj)
               {
                  if(_loc4_ != "__ID__")
                  {
                     _loc2_ = itmObj[_loc4_] + ", " + _loc2_;
                  }
               }
               _loc2_ = _loc2_.substring(0,_loc2_.length - 2);
            }
            else
            {
               _loc2_ = itmObj;
            }
         }
      }
      return _loc2_;
   }
   function setupBG(Void)
   {
      var _loc0_ = null;
      var _loc2_ = this.backGround = this.createEmptyMovieClip("bG_mc",mx.controls.listclasses.SelectableRow.LOWEST_DEPTH);
      this.drawRowFill(_loc2_,this.normalColor);
      this.highlight = this.createEmptyMovieClip("tran_mc",mx.controls.listclasses.SelectableRow.LOWEST_DEPTH + 10);
      _loc2_.owner = this;
      _loc2_.grandOwner = this.owner;
      _loc2_.onPress = this.bGOnPress;
      _loc2_.onRelease = this.bGOnRelease;
      _loc2_.onRollOver = this.bGOnRollOver;
      _loc2_.onRollOut = this.bGOnRollOut;
      _loc2_.onDragOver = this.bGOnDragOver;
      _loc2_.onDragOut = this.bGOnDragOut;
      _loc2_.useHandCursor = false;
      _loc2_.trackAsMenu = true;
      _loc2_.drawRect = this.drawRect;
      this.highlight.drawRect = this.drawRect;
   }
   function drawRowFill(mc, newClr)
   {
      mc.clear();
      mc.beginFill(newClr);
      mc.drawRect(1,0,this.__width,this.__height);
      mc.endFill();
      mc._width = this.__width;
      mc._height = this.__height;
   }
   function setState(newState, transition)
   {
      var _loc2_ = this.highlight;
      var _loc8_ = this.backGround;
      var _loc4_ = this.__height;
      var _loc3_ = this.owner;
      if(!_loc3_.enabled)
      {
         if(newState == "selected" || this.state == "selected")
         {
            this.highlightColor = _loc3_.getStyle("selectionDisabledColor");
            this.drawRowFill(_loc2_,this.highlightColor);
            _loc2_._visible = true;
            _loc2_._y = 0;
            _loc2_._height = _loc4_;
         }
         else
         {
            _loc2_._visible = false;
            this.normalColor = _loc3_.getStyle("backgroundDisabledColor");
            this.drawRowFill(_loc8_,this.normalColor);
         }
         this.cell.__enabled = false;
         this.cell.setColor(_loc3_.getStyle("disabledColor"));
      }
      else
      {
         this.cell.__enabled = true;
         if(transition && (newState == this.state || newState == "highlighted" && this.state == "selected"))
         {
            this.isChangedToSelected = true;
            return undefined;
         }
         var _loc6_ = _loc3_.getStyle("selectionDuration");
         var _loc7_ = 0;
         if(this.isChangedToSelected && newState == "selected")
         {
            transition = false;
         }
         var _loc10_ = transition && _loc6_ != 0;
         if(newState == "normal")
         {
            _loc7_ = _loc3_.getStyle("color");
            this.normalColor = this.getNormalColor();
            this.drawRowFill(_loc8_,this.normalColor);
            if(_loc10_)
            {
               _loc6_ /= 2;
               _loc2_._height = _loc4_;
               _loc2_._width = this.__width;
               _loc2_._y = 0;
               this.bGTween = new mx.effects.Tween(this,_loc4_ + 2,_loc4_ * 0.2,_loc6_,5);
            }
            else
            {
               _loc2_._visible = false;
            }
            delete this.isChangedToSelected;
         }
         else
         {
            this.highlightColor = _loc3_.getStyle(newState != "highlighted" ? "selectionColor" : "rollOverColor");
            this.drawRowFill(_loc2_,this.highlightColor);
            _loc2_._visible = true;
            _loc7_ = _loc3_.getStyle(newState != "highlighted" ? "textSelectedColor" : "textRollOverColor");
            if(_loc10_)
            {
               _loc2_._height = _loc4_ * 0.5;
               _loc2_._y = (_loc4_ - _loc2_._height) / 2;
               this.bGTween = new mx.effects.Tween(this,_loc2_._height,_loc4_ + 2,_loc6_,5);
               var _loc9_ = _loc3_.getStyle("selectionEasing");
               if(_loc9_ != undefined)
               {
                  this.bGTween.easingEquation = _loc9_;
               }
            }
            else
            {
               _loc2_._y = 0;
               _loc2_._height = _loc4_;
            }
         }
         this.cell.setColor(_loc7_);
      }
      this.state = newState;
   }
   function onTweenUpdate(val)
   {
      this.highlight._height = val;
      this.highlight._y = (this.__height - val) / 2;
   }
   function onTweenEnd(val)
   {
      this.onTweenUpdate(val);
      this.highlight._visible = this.state != "normal";
   }
   function getNormalColor(Void)
   {
      var _loc3_ = undefined;
      var _loc2_ = this.owner;
      if(!this.owner.enabled)
      {
         _loc3_ = _loc2_.getStyle("backgroundDisabledColor");
      }
      else
      {
         var _loc5_ = this.rowIndex + _loc2_.__vPosition;
         if(this.rowIndex == undefined)
         {
            _loc3_ = _loc2_.getPropertiesOf(this.item).backgroundColor;
         }
         else
         {
            _loc3_ = _loc2_.getPropertiesAt(_loc5_).backgroundColor;
         }
         if(_loc3_ == undefined)
         {
            var _loc4_ = _loc2_.getStyle("alternatingRowColors");
            if(_loc4_ == undefined)
            {
               _loc3_ = _loc2_.getStyle("backgroundColor");
            }
            else
            {
               _loc3_ = _loc4_[_loc5_ % _loc4_.length];
            }
         }
      }
      return _loc3_;
   }
   function invalidateStyle(propName)
   {
      this.cell.invalidateStyle(propName);
      super.invalidateStyle(propName);
   }
   function bGOnPress(Void)
   {
      this.grandOwner.pressFocus();
      this.grandOwner.onRowPress(this.owner.rowIndex);
   }
   function bGOnRelease(Void)
   {
      this.grandOwner.releaseFocus();
      this.grandOwner.onRowRelease(this.owner.rowIndex);
   }
   function bGOnRollOver(Void)
   {
      this.grandOwner.onRowRollOver(this.owner.rowIndex);
   }
   function bGOnRollOut(Void)
   {
      this.grandOwner.onRowRollOut(this.owner.rowIndex);
   }
   function bGOnDragOver(Void)
   {
      this.grandOwner.onRowDragOver(this.owner.rowIndex);
   }
   function bGOnDragOut(Void)
   {
      this.grandOwner.onRowDragOut(this.owner.rowIndex);
   }
}
