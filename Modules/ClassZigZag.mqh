//+------------------------------------------------------------------+
#property copyright "AlexG"
#property link      ""
#property version   "1.00"
#property strict

#include "ZigZag/ClassZigZagLevel.mqh"
//+------------------------------------------------------------------+
class ClassZigZag
  {
   
    public:
     //------- PROPERTIES --------
      ClassZigZagLevel Levels[];

     //------- METHODS -------- 
            ClassZigZag();
           ~ClassZigZag();
      void  Init();
      void SetSymbol( string symbol_ );
      void SetTimeframe( int timeframe_ );
      void SetBars( int cnt_bars_ );
      void SetPeriodZZ( int period );  
               
   
               
    private:
     //------- PROPERTIES --------        
      string symbol;
      int timeframe;
      int cnt_bars;
      int period_zz;   
      
     //--------- METHODS ---------
        
  };
  
  
//+------------------------------------------------------------------+
void ClassZigZag::ClassZigZag()
  {
    this.symbol    = _Symbol;
    this.timeframe = PERIOD_CURRENT;
    this.cnt_bars  = 500;
    this.period_zz = 14;
  }
  
  
//+------------------------------------------------------------------+
void ClassZigZag::~ClassZigZag()
  {
  }
  
  
//+------------------------------------------------------------------+
//------------------- ZigZagLevels ----------
 void ClassZigZag::Init()
  {
    ArrayResize(this.Levels, 0);
    for(int i=0; i<=this.cnt_bars; i++)
      {
        int InpDepth=this.period_zz;  // Depth
        int InpDeviation=5;      // Deviation
        int InpBackstep=3;       // Backstep
        
        
        double zz_price;
      
        HideTestIndicators(true);
          zz_price = iCustom(this.symbol, this.timeframe, "ZigZag", InpDepth, InpDeviation, InpBackstep, 0, i);
        HideTestIndicators(false);
        if( zz_price > 0 )
          {
            int arr_size = ArraySize(this.Levels);
            ArrayResize(this.Levels, arr_size+1);
            
            this.Levels[arr_size].index_bar  = i;
            this.Levels[arr_size].level_high = iHigh(this.symbol, this.timeframe, i );
            this.Levels[arr_size].level_low  = iLow(this.symbol, this.timeframe, i );
            this.Levels[arr_size].timeframe  = this.timeframe;
            this.Levels[arr_size].symbol     = this.symbol;
            
            if( zz_price == this.Levels[arr_size].level_high )
              this.Levels[arr_size].type = ZZ_HIGH;
            
            if( zz_price == this.Levels[arr_size].level_low )
              this.Levels[arr_size].type = ZZ_LOW;
                           
          }          
      }
  }
  
//+--------------------------------------------------------------------------------+  
 void ClassZigZag::SetSymbol( string symbol_ )    { this.symbol = symbol_; }
 void ClassZigZag::SetTimeframe( int timeframe_ ) { this.timeframe = timeframe_; }
 void ClassZigZag::SetBars( int cnt_bars_ )       { this.cnt_bars = cnt_bars_; }
 void ClassZigZag::SetPeriodZZ( int period )      { this.period_zz = period; }