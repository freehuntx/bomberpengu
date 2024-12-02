var §\x01§ = 943;
var §\x0f§ = 1;
class mx.controls.listclasses.DataSelector extends Object
{
   var __vPosition;
   var setVPosition;
   var __dataProvider;
   var enabled;
   var lastSelID;
   var lastSelected;
   var selected;
   var invUpdateControl;
   var invalidate;
   var multipleSelection;
   var updateControl;
   var __rowCount;
   var rows;
   static var mixins = new mx.controls.listclasses.DataSelector();
   static var mixinProps = ["setDataProvider","getDataProvider","addItem","addItemAt","removeAll","removeItemAt","replaceItemAt","sortItemsBy","sortItems","getLength","getItemAt","modelChanged","calcPreferredWidthFromData","calcPreferredHeightFromData","getValue","getSelectedIndex","getSelectedItem","getSelectedIndices","getSelectedItems","selectItem","isSelected","clearSelected","setSelectedIndex","setSelectedIndices"];
   function DataSelector()
   {
      super();
   }
   static function Initialize(obj)
   {
      var _loc3_ = mx.controls.listclasses.DataSelector.mixinProps;
      var _loc4_ = _loc3_.length;
      obj = obj.prototype;
      var _loc1_ = 0;
      while(_loc1_ < _loc4_)
      {
         obj[_loc3_[_loc1_]] = mx.controls.listclasses.DataSelector.mixins[_loc3_[_loc1_]];
         _loc1_ = _loc1_ + 1;
      }
      mx.controls.listclasses.DataSelector.mixins.createProp(obj,"dataProvider",true);
      mx.controls.listclasses.DataSelector.mixins.createProp(obj,"length",false);
      mx.controls.listclasses.DataSelector.mixins.createProp(obj,"value",false);
      mx.controls.listclasses.DataSelector.mixins.createProp(obj,"selectedIndex",true);
      mx.controls.listclasses.DataSelector.mixins.createProp(obj,"selectedIndices",true);
      mx.controls.listclasses.DataSelector.mixins.createProp(obj,"selectedItems",false);
      mx.controls.listclasses.DataSelector.mixins.createProp(obj,"selectedItem",true);
      return true;
   }
   function createProp(obj, propName, setter)
   {
      var p = propName.charAt(0).toUpperCase() + propName.substr(1);
      var _loc2_ = null;
      var _loc4_ = function(Void)
      {
         return this["get" + p]();
      };
      if(setter)
      {
         _loc2_ = function(val)
         {
            this["set" + p](val);
         };
      }
      obj.addProperty(propName,_loc4_,_loc2_);
   }
   function setDataProvider(dP)
   {
      if(this.__vPosition != 0)
      {
         this.setVPosition(0);
      }
      this.clearSelected();
      this.__dataProvider.removeEventListener(this);
      this.__dataProvider = dP;
      dP.addEventListener("modelChanged",this);
      dP.addView(this);
      this.modelChanged({eventName:"updateAll"});
   }
   function getDataProvider(Void)
   {
      return this.__dataProvider;
   }
   function addItemAt(index, label, data)
   {
      if(index < 0 || !this.enabled)
      {
         return undefined;
      }
      var _loc2_ = this.__dataProvider;
      if(_loc2_ == undefined)
      {
         var _loc0_ = null;
         _loc2_ = this.__dataProvider = new Array();
         _loc2_.addEventListener("modelChanged",this);
         index = 0;
      }
      if(typeof label == "object" || typeof _loc2_.getItemAt(0) == "string")
      {
         _loc2_.addItemAt(index,label);
      }
      else
      {
         _loc2_.addItemAt(index,{label:label,data:data});
      }
   }
   function addItem(label, data)
   {
      this.addItemAt(this.__dataProvider.length,label,data);
   }
   function removeItemAt(index)
   {
      return this.__dataProvider.removeItemAt(index);
   }
   function removeAll(Void)
   {
      this.__dataProvider.removeAll();
   }
   function replaceItemAt(index, newLabel, newData)
   {
      if(typeof newLabel == "object")
      {
         this.__dataProvider.replaceItemAt(index,newLabel);
      }
      else
      {
         this.__dataProvider.replaceItemAt(index,{label:newLabel,data:newData});
      }
   }
   function sortItemsBy(fieldName, order)
   {
      this.lastSelID = this.__dataProvider.getItemID(this.lastSelected);
      this.__dataProvider.sortItemsBy(fieldName,order);
   }
   function sortItems(compareFunc, order)
   {
      this.lastSelID = this.__dataProvider.getItemID(this.lastSelected);
      this.__dataProvider.sortItems(compareFunc,order);
   }
   function getLength(Void)
   {
      return this.__dataProvider.length;
   }
   function getItemAt(index)
   {
      return this.__dataProvider.getItemAt(index);
   }
   function modelChanged(eventObj)
   {
      var _loc3_ = eventObj.firstItem;
      var _loc6_ = eventObj.lastItem;
      var _loc7_ = eventObj.eventName;
      if(_loc7_ == undefined)
      {
         _loc7_ = eventObj.event;
         _loc3_ = eventObj.firstRow;
         _loc6_ = eventObj.lastRow;
         if(_loc7_ == "addRows")
         {
            var _loc0_ = null;
            _loc7_ = eventObj.eventName = "addItems";
         }
         else if(_loc7_ == "deleteRows")
         {
            var _loc0_ = null;
            _loc7_ = eventObj.eventName = "removeItems";
         }
         else if(_loc7_ == "updateRows")
         {
            var _loc0_ = null;
            _loc7_ = eventObj.eventName = "updateItems";
         }
      }
      if(_loc7_ == "addItems")
      {
         for(var _loc2_ in this.selected)
         {
            var _loc5_ = this.selected[_loc2_];
            if(_loc5_ != undefined && _loc5_ >= _loc3_)
            {
               this.selected[_loc2_] += _loc6_ - _loc3_ + 1;
            }
         }
      }
      else if(_loc7_ == "removeItems")
      {
         if(this.__dataProvider.length == 0)
         {
            delete this.selected;
         }
         else
         {
            var _loc9_ = eventObj.removedIDs;
            var _loc10_ = _loc9_.length;
            _loc2_ = 0;
            while(_loc2_ < _loc10_)
            {
               var _loc4_ = _loc9_[_loc2_];
               if(this.selected[_loc4_] != undefined)
               {
                  delete this.selected[_loc4_];
               }
               _loc2_ = _loc2_ + 1;
            }
            for(_loc2_ in this.selected)
            {
               if(this.selected[_loc2_] >= _loc3_)
               {
                  this.selected[_loc2_] -= _loc6_ - _loc3_ + 1;
               }
            }
         }
      }
      else if(_loc7_ == "sort")
      {
         if(typeof this.__dataProvider.getItemAt(0) != "object")
         {
            delete this.selected;
         }
         else
         {
            _loc10_ = this.__dataProvider.length;
            _loc2_ = 0;
            while(_loc2_ < _loc10_)
            {
               if(this.isSelected(_loc2_))
               {
                  _loc4_ = this.__dataProvider.getItemID(_loc2_);
                  if(_loc4_ == this.lastSelID)
                  {
                     this.lastSelected = _loc2_;
                  }
                  this.selected[_loc4_] = _loc2_;
               }
               _loc2_ = _loc2_ + 1;
            }
         }
      }
      else if(_loc7_ == "filterModel")
      {
         this.setVPosition(0);
      }
      this.invUpdateControl = true;
      this.invalidate();
   }
   function getValue(Void)
   {
      var _loc2_ = this.getSelectedItem();
      if(typeof _loc2_ != "object")
      {
         return _loc2_;
      }
      return _loc2_.data != undefined ? _loc2_.data : _loc2_.label;
   }
   function getSelectedIndex(Void)
   {
      for(var _loc3_ in this.selected)
      {
         var _loc2_ = this.selected[_loc3_];
         if(_loc2_ != undefined)
         {
            return _loc2_;
         }
      }
   }
   function setSelectedIndex(index)
   {
      if(index >= 0 && index < this.__dataProvider.length && this.enabled)
      {
         delete this.selected;
         this.selectItem(index,true);
         this.lastSelected = index;
         this.invUpdateControl = true;
         this.invalidate();
      }
      else if(index == undefined)
      {
         this.clearSelected();
      }
   }
   function getSelectedIndices(Void)
   {
      var _loc2_ = new Array();
      for(var _loc3_ in this.selected)
      {
         _loc2_.push(this.selected[_loc3_]);
      }
      _loc2_.reverse();
      return _loc2_.length <= 0 ? undefined : _loc2_;
   }
   function setSelectedIndices(indexArray)
   {
      if(this.multipleSelection != true)
      {
         return undefined;
      }
      delete this.selected;
      var _loc3_ = 0;
      while(_loc3_ < indexArray.length)
      {
         var _loc2_ = indexArray[_loc3_];
         if(_loc2_ >= 0 && _loc2_ < this.__dataProvider.length)
         {
            this.selectItem(_loc2_,true);
         }
         _loc3_ = _loc3_ + 1;
      }
      this.invUpdateControl = true;
      this.updateControl();
   }
   function getSelectedItems(Void)
   {
      var _loc3_ = this.getSelectedIndices();
      var _loc4_ = new Array();
      var _loc2_ = 0;
      while(_loc2_ < _loc3_.length)
      {
         _loc4_.push(this.getItemAt(_loc3_[_loc2_]));
         _loc2_ = _loc2_ + 1;
      }
      return _loc4_.length <= 0 ? undefined : _loc4_;
   }
   function getSelectedItem(Void)
   {
      return this.__dataProvider.getItemAt(this.getSelectedIndex());
   }
   function selectItem(index, selectedFlag)
   {
      if(this.selected == undefined)
      {
         this.selected = new Object();
      }
      var _loc2_ = this.__dataProvider.getItemID(index);
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      if(selectedFlag && !this.isSelected(index))
      {
         this.selected[_loc2_] = index;
      }
      else if(!selectedFlag)
      {
         delete this.selected[_loc2_];
      }
   }
   function isSelected(index)
   {
      var _loc2_ = this.__dataProvider.getItemID(index);
      if(_loc2_ == undefined)
      {
         return false;
      }
      return this.selected[_loc2_] != undefined;
   }
   function clearSelected(transition)
   {
      var _loc3_ = 0;
      for(var _loc4_ in this.selected)
      {
         var _loc2_ = this.selected[_loc4_];
         if(_loc2_ != undefined && this.__vPosition <= _loc2_ && _loc2_ < this.__vPosition + this.__rowCount)
         {
            this.rows[_loc2_ - this.__vPosition].drawRow(this.rows[_loc2_ - this.__vPosition].item,"normal",transition && _loc3_ % 3 == 0);
         }
         _loc3_ = _loc3_ + 1;
      }
      delete this.selected;
   }
}
