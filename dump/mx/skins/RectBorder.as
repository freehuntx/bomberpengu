var §\x01§ = 550;
var §\x0f§ = 1;
class mx.skins.RectBorder extends mx.skins.Border
{
   var __width;
   var __height;
   var offset;
   var __borderMetrics;
   static var symbolName = "RectBorder";
   static var symbolOwner = mx.skins.RectBorder;
   static var version = "2.0.1.78";
   var className = "RectBorder";
   var borderStyleName = "borderStyle";
   var borderColorName = "borderColor";
   var shadowColorName = "shadowColor";
   var highlightColorName = "highlightColor";
   var buttonColorName = "buttonColor";
   var backgroundColorName = "backgroundColor";
   function RectBorder()
   {
      super();
   }
   function get width()
   {
      return this.__width;
   }
   function get height()
   {
      return this.__height;
   }
   function init(Void)
   {
      super.init();
   }
   function draw(Void)
   {
      this.size();
   }
   function getBorderMetrics(Void)
   {
      var _loc2_ = this.offset;
      if(this.__borderMetrics == undefined)
      {
         this.__borderMetrics = {left:_loc2_,top:_loc2_,right:_loc2_,bottom:_loc2_};
      }
      else
      {
         this.__borderMetrics.left = _loc2_;
         this.__borderMetrics.top = _loc2_;
         this.__borderMetrics.right = _loc2_;
         this.__borderMetrics.bottom = _loc2_;
      }
      return this.__borderMetrics;
   }
   function get borderMetrics()
   {
      return this.getBorderMetrics();
   }
   function drawBorder(Void)
   {
   }
   function size(Void)
   {
      this.drawBorder();
   }
   function setColor(Void)
   {
      this.drawBorder();
   }
}
