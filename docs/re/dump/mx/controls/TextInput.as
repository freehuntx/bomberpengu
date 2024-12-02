var §\x01§ = 918;
var §\x0f§ = 1;
class mx.controls.TextInput extends mx.core.UIComponent
{
   var owner;
   var enterListener;
   var label;
   var focusTextField;
   var _color;
   var border_mc;
   var tfx;
   var tfy;
   var tfw;
   var tfh;
   var bind;
   var updateModel;
   static var symbolName = "TextInput";
   static var symbolOwner = mx.controls.TextInput;
   static var version = "2.0.1.78";
   var className = "TextInput";
   var initializing = true;
   var clipParameters = {text:1,editable:1,password:1,maxChars:1,restrict:1};
   static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.controls.TextInput.prototype.clipParameters,mx.core.UIComponent.prototype.clipParameters);
   var _maxWidth = mx.core.UIComponent.kStretch;
   var __editable = true;
   var initText = "";
   function TextInput()
   {
      super();
   }
   function addEventListener(event, handler)
   {
      if(event == "enter")
      {
         this.addEnterEvents();
      }
      super.addEventListener(event,handler);
   }
   function enterOnKeyDown()
   {
      if(Key.getAscii() == 13)
      {
         this.owner.dispatchEvent({type:"enter"});
      }
   }
   function addEnterEvents()
   {
      if(this.enterListener == undefined)
      {
         this.enterListener = new Object();
         this.enterListener.owner = this;
         this.enterListener.onKeyDown = this.enterOnKeyDown;
      }
   }
   function init(Void)
   {
      super.init();
      this.label.styleName = this;
      this.tabChildren = true;
      this.tabEnabled = false;
      this.focusTextField = this.label;
      this._color = mx.core.UIObject.textColorList;
      this.label.onSetFocus = function()
      {
         this._parent.onSetFocus();
      };
      this.label.onKillFocus = function(n)
      {
         this._parent.onKillFocus(n);
      };
      this.label.drawFocus = function(b)
      {
         this._parent.drawFocus(b);
      };
      this.label.onChanged = this.onLabelChanged;
   }
   function setFocus()
   {
      Selection.setFocus(this.label);
   }
   function onLabelChanged(Void)
   {
      this._parent.dispatchEvent({type:"change"});
      this._parent.dispatchValueChangedEvent(this.text);
   }
   function createChildren(Void)
   {
      super.createChildren();
      if(this.border_mc == undefined)
      {
         this.createClassObject(_global.styles.rectBorderClass,"border_mc",0,{styleName:this});
      }
      this.border_mc.swapDepths(this.label);
      this.label.autoSize = "none";
   }
   function get html()
   {
      return this.getHtml();
   }
   function set html(value)
   {
      this.setHtml(value);
   }
   function getHtml()
   {
      return this.label.html;
   }
   function setHtml(value)
   {
      if(value != this.label.html)
      {
         this.label.html = value;
      }
   }
   function get text()
   {
      return this.getText();
   }
   function set text(t)
   {
      this.setText(t);
   }
   function getText()
   {
      if(this.initializing)
      {
         return this.initText;
      }
      if(this.label.html == true)
      {
         return this.label.htmlText;
      }
      return this.label.text;
   }
   function setText(t)
   {
      if(this.initializing)
      {
         this.initText = t;
      }
      else
      {
         var _loc2_ = this.label;
         if(_loc2_.html == true)
         {
            _loc2_.htmlText = t;
         }
         else
         {
            _loc2_.text = t;
         }
      }
      this.dispatchValueChangedEvent(t);
   }
   function size(Void)
   {
      this.border_mc.setSize(this.width,this.height);
      var _loc2_ = this.border_mc.borderMetrics;
      var _loc6_ = _loc2_.left + _loc2_.right;
      var _loc3_ = _loc2_.top + _loc2_.bottom;
      var _loc5_ = _loc2_.left;
      var _loc4_ = _loc2_.top;
      this.tfx = _loc5_;
      this.tfy = _loc4_;
      this.tfw = this.width - _loc6_;
      this.tfh = this.height - _loc3_;
      this.label.move(this.tfx,this.tfy);
      this.label.setSize(this.tfw,this.tfh + 1);
   }
   function setEnabled(enable)
   {
      this.label.type = !(this.__editable == true || enable == false) ? "dynamic" : "input";
      this.label.selectable = enable;
      var _loc2_ = this.getStyle(!enable ? "disabledColor" : "color");
      if(_loc2_ == undefined)
      {
         _loc2_ = !enable ? 8947848 : 0;
      }
      this.setColor(_loc2_);
   }
   function setColor(col)
   {
      this.label.textColor = col;
   }
   function onKillFocus(newFocus)
   {
      if(this.enterListener != undefined)
      {
         Key.removeListener(this.enterListener);
      }
      if(this.bind != undefined)
      {
         this.updateModel(this.text);
      }
      super.onKillFocus(newFocus);
   }
   function onSetFocus(oldFocus)
   {
      var f = Selection.getFocus();
      var o = eval(f);
      if(o != this.label)
      {
         Selection.setFocus(this.label);
         return undefined;
      }
      if(this.enterListener != undefined)
      {
         Key.addListener(this.enterListener);
      }
      super.onSetFocus(oldFocus);
   }
   function draw(Void)
   {
      var _loc2_ = this.label;
      var _loc4_ = this.getText();
      if(this.initializing)
      {
         this.initializing = false;
         delete this.initText;
      }
      var _loc3_ = this._getTextFormat();
      _loc2_.embedFonts = _loc3_.embedFonts == true;
      if(_loc3_ != undefined)
      {
         _loc2_.setTextFormat(_loc3_);
         _loc2_.setNewTextFormat(_loc3_);
      }
      _loc2_.multiline = false;
      _loc2_.wordWrap = false;
      if(_loc2_.html == true)
      {
         _loc2_.setTextFormat(_loc3_);
         _loc2_.htmlText = _loc4_;
      }
      else
      {
         _loc2_.text = _loc4_;
      }
      _loc2_.type = !(this.__editable == true || this.enabled == false) ? "dynamic" : "input";
      this.size();
   }
   function setEditable(s)
   {
      this.__editable = s;
      this.label.type = !s ? "dynamic" : "input";
   }
   function get maxChars()
   {
      return this.label.maxChars;
   }
   function set maxChars(w)
   {
      this.label.maxChars = w;
   }
   function get length()
   {
      return this.label.length;
   }
   function get restrict()
   {
      return this.label.restrict;
   }
   function set restrict(w)
   {
      this.label.restrict = w != "" ? w : null;
   }
   function get hPosition()
   {
      return this.label.hscroll;
   }
   function set hPosition(w)
   {
      this.label.hscroll = w;
   }
   function get maxHPosition()
   {
      return this.label.maxhscroll;
   }
   function get editable()
   {
      return this.__editable;
   }
   function set editable(w)
   {
      this.setEditable(w);
   }
   function get password()
   {
      return this.label.password;
   }
   function set password(w)
   {
      this.label.password = w;
   }
   function get tabIndex()
   {
      return this.label.tabIndex;
   }
   function set tabIndex(w)
   {
      this.label.tabIndex = w;
   }
   function set _accProps(val)
   {
      this.label._accProps = val;
   }
   function get _accProps()
   {
      return this.label._accProps;
   }
}
