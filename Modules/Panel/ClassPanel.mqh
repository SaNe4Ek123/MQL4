//+------------------------------------------------------------------+
//|                                                   ClassPanel.mqh |
//|                                                           Alex G |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alex G"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ClassPanel
  {
private:
  int x_begin,
      y_begin,
      x_size,
      y_size;
  
  string name_panel;

public:
                     ClassPanel();
                    ~ClassPanel();
              void   SetLable( double x_per, double y_per, string name, string text, color ColorText = NULL );      
              void   ClassPanel::SetButton( double x_per, double y_per, double width_per, double height_per, string name, string text, color ColorText = NULL );
              void   Create( string name = "Panel", int x_b = 0, int y_b = 0, int x_s = 300, int y_s = 500 );
              void   ClassPanel::UpdateLableText( string name, string text );
              void   ClassPanel::UpdateLableTextColor( string name, color Color );
              void   ClassPanel::CreateWriper( color clr = clrBlack );
  };
  
  
//+------------------------------------------------------------------+
ClassPanel::ClassPanel()
  {
  }
  
  
//+------------------------------------------------------------------+
ClassPanel::~ClassPanel()
  {
  }
  
  
//+------------------------------------------------------------------+
 void ClassPanel::Create( string name = "Panel", int x_b = 0, int y_b = 0, int x_s = 300, int y_s = 500 )
   {
     this.name_panel = name;
     this.x_begin = x_b;
     this.y_begin = y_b;
     this.x_size = x_s;
     this.y_size = y_s;
   }

//+-------------------------------------------------------------------+
 void ClassPanel::SetLable( double x_per, double y_per,string name, string text, color ColorText = NULL )
   {
      int x      = (int)( this.x_size /100  * x_per ),
          y      = (int)( this.y_size / 100 * y_per );
          
   
      ObjectCreate(0,name,OBJ_LABEL,0,0,0);
          
     //--- установим координаты кнопки
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE, this.x_begin + x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE, this.y_begin + y);
          
     //--- установим текст
      ObjectSetString(0,name,OBJPROP_TEXT, text);
          
     //--- установим шрифт текста
      ObjectSetString(0,name,OBJPROP_FONT,"Arial");
          
     //--- установим размер шрифта
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
          
     //--- установим цвет текста
      ObjectSetInteger(0,name,OBJPROP_COLOR,ColorText);
          
     //--- установим цвет фона
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrNONE);
          
     //--- установим цвет границы
      ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrNONE);
          
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,name,OBJPROP_SELECTED,false); 
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_ZORDER,20);

   }
   
//+---------------------------------------------------------------------+
void ClassPanel::UpdateLableText( string name, string text )
  {
    ObjectSetString(0,name,OBJPROP_TEXT, text);
    ChartRedraw();
  }
   
   
//+---------------------------------------------------------------------+
void ClassPanel::UpdateLableTextColor( string name, color Color )
  {
    ObjectSetInteger(0,name,OBJPROP_COLOR, Color);
    ChartRedraw();
  }
   
//+--------------------------------------------------------------------+
 void ClassPanel::CreateWriper( color clr = clrBlack )
   {
     //----- Create Wriper -----
     ObjectCreate( 0, this.name_panel, OBJ_RECTANGLE_LABEL, 0, 0, 0 ); 
     ObjectSetInteger(0,this.name_panel,OBJPROP_XDISTANCE, this.x_begin);
     ObjectSetInteger(0,this.name_panel,OBJPROP_YDISTANCE, this.y_begin); 
     ObjectSetInteger(0,this.name_panel,OBJPROP_XSIZE,this.x_size);
     ObjectSetInteger(0,this.name_panel,OBJPROP_YSIZE,this.y_size);
     ObjectSetInteger(0,this.name_panel,OBJPROP_CORNER,4);
     ObjectSetInteger(0,this.name_panel,OBJPROP_BGCOLOR,clr);
     ObjectSetInteger(0,this.name_panel,OBJPROP_BORDER_COLOR,clrNONE);
     ObjectSetInteger(0,this.name_panel,OBJPROP_WIDTH,0);
     ObjectSetInteger(0,this.name_panel,OBJPROP_SELECTABLE,false); 
     ObjectSetInteger(0,this.name_panel,OBJPROP_SELECTED,false); 
     ObjectSetInteger(0,this.name_panel,OBJPROP_HIDDEN,true);
     ObjectSetInteger(0,this.name_panel,OBJPROP_ZORDER,10);
     
   }
   
   
//+--------------------------------------------------------------------+   
 void ClassPanel::SetButton( double x_per, double y_per, double width_per, double height_per, string name, string text, color ColorText = NULL )
   {
      int x      = (int)( this.x_size /100  * x_per ),
          y      = (int)( this.y_size / 100 * y_per ),
          width  = (int)( this.x_size / 100 * width_per ), 
          height = (int)( this.y_size / 100 * height_per );
   
      ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
          
     //--- установим координаты кнопки
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE, this.x_begin + x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE, this.y_begin + y);
          
     //--- установим размер кнопки
      ObjectSetInteger(0,name,OBJPROP_XSIZE, width);
      ObjectSetInteger(0,name,OBJPROP_YSIZE, height);
          
     //--- установим текст
      ObjectSetString(0,name,OBJPROP_TEXT, text);
          
     //--- установим шрифт текста
      ObjectSetString(0,name,OBJPROP_FONT,"Arial");
          
     //--- установим размер шрифта
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
          
     //--- установим цвет текста
      ObjectSetInteger(0,name,OBJPROP_COLOR,ColorText);
          
     //--- установим цвет фона
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrNONE);
          
     //--- установим цвет границы
      ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrNONE);
          
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,name,OBJPROP_SELECTED,false); 
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_ZORDER,20);
      

   }
   