var §\x01§ = 218;
var §\x0f§ = 1;
class mx.controls.listclasses.DataProvider extends Object
{
   var __ID__;
   var length;
   var splice;
   var dispatchEvent;
   var sortOn;
   var reverse;
   var sort;
   static var mixinProps = ["addView","addItem","addItemAt","removeAll","removeItemAt","replaceItemAt","getItemAt","getItemID","sortItemsBy","sortItems","updateViews","addItemsAt","removeItemsAt","getEditingData","editField"];
   static var evtDipatcher = mx.events.EventDispatcher;
   static var mixins = new mx.controls.listclasses.DataProvider();
   function DataProvider(obj)
   {
      super();
   }
   static function Initialize(obj)
   {
      var _loc4_ = mx.controls.listclasses.DataProvider.mixinProps;
      var _loc6_ = _loc4_.length;
      obj = obj.prototype;
      var _loc3_ = 0;
      while(_loc3_ < _loc6_)
      {
         obj[_loc4_[_loc3_]] = mx.controls.listclasses.DataProvider.mixins[_loc4_[_loc3_]];
         _global.ASSetPropFlags(obj,_loc4_[_loc3_],1);
         _loc3_ = _loc3_ + 1;
      }
      mx.events.EventDispatcher.initialize(obj);
      _global.ASSetPropFlags(obj,"addEventListener",1);
      _global.ASSetPropFlags(obj,"removeEventListener",1);
      _global.ASSetPropFlags(obj,"dispatchEvent",1);
      _global.ASSetPropFlags(obj,"dispatchQueue",1);
      Object.prototype.LargestID = 0;
      Object.prototype.getID = function()
      {
         if(this.__ID__ == undefined)
         {
            this.__ID__ = Object.prototype.LargestID++;
            _global.ASSetPropFlags(this,"__ID__",1);
         }
         return this.__ID__;
      };
      _global.ASSetPropFlags(Object.prototype,"LargestID",1);
      _global.ASSetPropFlags(Object.prototype,"getID",1);
      return true;
   }
   function addItemAt(index, value)
   {
      if(index < this.length)
      {
         this.splice(index,0,value);
      }
      else if(index > this.length)
      {
         trace("Cannot add an item past the end of the DataProvider");
         return undefined;
      }
      this[index] = value;
      this.updateViews("addItems",index,index);
   }
   function addItem(value)
   {
      this.addItemAt(this.length,value);
   }
   function addItemsAt(index, newItems)
   {
      index = Math.min(this.length,index);
      newItems.unshift(index,0);
      this.splice.apply(this,newItems);
      newItems.splice(0,2);
      this.updateViews("addItems",index,index + newItems.length - 1);
   }
   function removeItemsAt(index, len)
   {
      var _loc3_ = new Array();
      var _loc2_ = 0;
      while(_loc2_ < len)
      {
         _loc3_.push(this.getItemID(index + _loc2_));
         _loc2_ = _loc2_ + 1;
      }
      var _loc6_ = this.splice(index,len);
      this.dispatchEvent({type:"modelChanged",eventName:"removeItems",firstItem:index,lastItem:index + len - 1,removedItems:_loc6_,removedIDs:_loc3_});
   }
   function removeItemAt(index)
   {
      var _loc2_ = this[index];
      this.removeItemsAt(index,1);
      return _loc2_;
   }
   function removeAll(Void)
   {
      this.splice(0);
      this.updateViews("removeItems",0,this.length - 1);
   }
   function replaceItemAt(index, itemObj)
   {
      if(index < 0 || index >= this.length)
      {
         return undefined;
      }
      var _loc3_ = this.getItemID(index);
      this[index] = itemObj;
      this[index].__ID__ = _loc3_;
      this.updateViews("updateItems",index,index);
   }
   function getItemAt(index)
   {
      return this[index];
   }
   function getItemID(index)
   {
      var _loc2_ = this[index];
      if(typeof _loc2_ != "object" && _loc2_ != undefined)
      {
         return index;
      }
      return _loc2_.getID();
   }
   function sortItemsBy(fieldName, order)
   {
      if(typeof order == "string")
      {
         this.sortOn(fieldName);
         if(order.toUpperCase() == "DESC")
         {
            this.reverse();
         }
      }
      else
      {
         this.sortOn(fieldName,order);
      }
      this.updateViews("sort");
   }
   function sortItems(compareFunc, optionFlags)
   {
      this.sort(compareFunc,optionFlags);
      this.updateViews("sort");
   }
   function editField(index, fieldName, newData)
   {
      this[index][fieldName] = newData;
      this.dispatchEvent({type:"modelChanged",eventName:"updateField",firstItem:index,lastItem:index,fieldName:fieldName});
   }
   function getEditingData(index, fieldName)
   {
      return this[index][fieldName];
   }
   function updateViews(event, first, last)
   {
      this.dispatchEvent({type:"modelChanged",eventName:event,firstItem:first,lastItem:last});
   }
}
