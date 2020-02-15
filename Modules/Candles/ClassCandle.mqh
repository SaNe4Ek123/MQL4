//+------------------------------------------------------------------+
//|                                                  ClassCandle.mqh |
//|                                                           Alex G |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alex G"
#property link      ""
#property version   "1.00"
#property strict

#define CANDLE_UP 1
#define CANDLE_DOWN -1
#define CANDLE_NONE 0

//+------------------------------------------------------------------+
class ClassCandle
  {
    public:
      string name;
      int ID;
      
      int size_point,
          shadow_top_point,
          shadow_bottom_point,
          body_point,
          direction;
          
      long volume;
          
      double size,
             shadow_top,
             shadow_bottom,
             body,
             shadow_top_percent,
             shadow_bottom_percent,
             body_percent,
             open,
             close,
             high,
             low;
      
      datetime time;
      
      string symbol;
      int timeframe;
      int shift;


    public:
                     ClassCandle();
                     ClassCandle( string symbol_, int timeframe_, int shift_ );
                     
                    ~ClassCandle();
                    
                    
               void  Init( string symbol_, int timeframe_, int shift_ );
  };
  
  
//+------------------------------------------------------------------+
ClassCandle::ClassCandle()
  {
    this.Init( Symbol(), PERIOD_CURRENT, 0 );
  }
  
ClassCandle::ClassCandle( string symbol_, int timeframe_, int shift_ )
  {
    this.Init( symbol_, timeframe_, shift_ );
  }
  
//+------------------------------------------------------------------+
ClassCandle::~ClassCandle()
  {
  }
  
  
//+------------------------------------------------------------------+
void ClassCandle::Init(string symbol_, int timeframe_, int shift_)
  {
   //-------
    this.symbol    = symbol_;
    this.timeframe = timeframe_;
    this.shift     = shift_;
          
   //------- General data
    this.open   = iOpen(symbol_, timeframe_, shift_);
    this.close  = iClose(symbol_, timeframe_, shift_);
    this.high   = iHigh(symbol_, timeframe_, shift_);
    this.low    = iLow(symbol_, timeframe_, shift_);
    this.volume = iVolume(symbol_, timeframe_, shift_);
    this.time   = iTime(symbol_, timeframe_, shift_);
         
   //-------- Double data 
    this.size  = MathAbs(this.high - this.low);
              
    this.body = MathAbs(this.close - this.open);
           
    if(this.open > this.close)
      {
        this.shadow_top    = this.high - this.open;
        this.shadow_bottom = this.close - this.low;
      }
    else if(this.open < this.close)
      {
        this.shadow_top    = this.high - this.close;
        this.shadow_bottom = this.open - this.low;
      }
    else
      {
        this.shadow_top    = this.high - this.open;
        this.shadow_bottom = this.open - this.low;
      }
    //-------- Point data 
    this.body_point          = (int) (this.body/Point);
    this.size_point          = (int) (this.size/Point);
    this.shadow_top_point    = (int) (this.shadow_top/Point);
    this.shadow_bottom_point = (int) (this.shadow_bottom/Point);
       
   //-------- Relation elements candle 
    if(this.size !=0)
      {      
        this.body_percent           = this.body/this.size*100;
        this.shadow_top_percent     = this.shadow_top/this.size*100;
        this.shadow_bottom_percent  = this.shadow_bottom/this.size*100;
      }
          
   //--------- Direction 
    if(this.open > this.close)
      this.direction = CANDLE_DOWN;
          
    else if(this.open < this.close)
      this.direction = CANDLE_UP;
          
    else
      this.direction = CANDLE_NONE;
  }
