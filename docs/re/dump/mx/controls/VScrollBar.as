var §\x01§ = 981;
var §\x0f§ = 1;
class mx.controls.VScrollBar extends mx.controls.scrollClasses.ScrollBar
{
   static var symbolName = "VScrollBar";
   static var symbolOwner = mx.core.UIComponent;
   static var version = "2.0.1.78";
   var className = "VScrollBar";
   var minusMode = "Up";
   var plusMode = "Down";
   var minMode = "AtTop";
   var maxMode = "AtBottom";
   function VScrollBar()
   {
      super();
   }
   function init(Void)
   {
      super.init();
   }
   function isScrollBarKey(k)
   {
      if(k == 38)
      {
         this.scrollIt("Line",-1);
         return true;
      }
      if(k == 40)
      {
         this.scrollIt("Line",1);
         return true;
      }
      if(k == 33)
      {
         this.scrollIt("Page",-1);
         return true;
      }
      if(k == 34)
      {
         this.scrollIt("Page",1);
         return true;
      }
      return super.isScrollBarKey(k);
   }
}
