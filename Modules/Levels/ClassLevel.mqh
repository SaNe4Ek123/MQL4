//+------------------------------------------------------------------+
//|                                                   ClassLevel.mqh |
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
class ClassLevel
  {
  
    public:  
      double high,
             low,
             size;
      
      int size_to_point,
          ID,
          start_index,
          end_index;
             
      datetime time_begin,
               time_end;
               
      bool New_, Trade_, Close_;
               
         

    public:
                     ClassLevel();
                    ~ClassLevel();
               void SetLevel( double price1, double price2, datetime time1 = 0, datetime time2 = 0 );   //--- Для установки уровня используем номер бара, на котором он сформировался  
               void Clear();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClassLevel::ClassLevel()
  {
    this.New_   = false;
    this.Close_ = false;
    this.Trade_ = false;
  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClassLevel::~ClassLevel()
  {
  }
  
//+------------------------------------------------------------------+
void ClassLevel::SetLevel( double price1, double price2, datetime time1 = 0, datetime time2 = 0 )
 {
   if( price1 >= price2 )
     { 
       this.high = price1;
       this.low  = price2;
     }
              
   if( price1 < price2 )
     { 
       this.high = price2;
       this.low  = price1;
     }
   
   this.size = NormalizeDouble( high - low, Digits );
   this.size_to_point = (int)(this.size / Point);
   
   
   if( time1 >= time2 )
     { 
       this.time_begin = time1;
       this.time_end = time2;
     }
              
   if( time1 < time2 )
     { 
       this.time_begin = time2;
       this.time_end  = time1;
     }
 }
 
//+------------------------------------------------------------------------+
 void ClassLevel::Clear()
  {
    this.Close_ = false;
    this.New_   = false;
    this.Trade_ = false;
    
    this.ID            = -1;
    this.end_index     = -1;
    this.start_index   = -1;
    this.high          = 0;
    this.low           = 0;
    this.time_begin    = 0;
    this.time_end      = 0;
    this.size          = 0;
    this.size_to_point = 0;
  }