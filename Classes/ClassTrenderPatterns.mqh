//+------------------------------------------------------------------+
//|                                         ClassTrenderPatterns.mqh |
//|                                                           Alex G |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alex G"
#property link      ""
#property version   "1.00"
#property strict

#include "../Classes/ClassTrender.mqh"
#include "../Classes/ClassCandle.mqh"

 struct ORDERS_PARAMS
  {
    int type;
    double open_price;
    double stoploss;
  };


class ClassTrenderPatterns
  {
    public:
      ORDERS_PARAMS order_params;
      
    private:
    
      ClassCandle Candle[];
      ClassTrender Trender;
      
      string symbol;
      int timeframe,
          period;
    
    public:
               void   ClassTrenderPatterns();
               void  ~ClassTrenderPatterns();
               void   Init( int period = 50, string symbol_ = NULL, int timeframe_ = PERIOD_CURRENT ); 
               bool   isSignalTrade( int type );
  };

//+------------------------------------------------------------------+
void ClassTrenderPatterns::ClassTrenderPatterns()
  {
  }

//+------------------------------------------------------------------+
void ClassTrenderPatterns::~ClassTrenderPatterns()
  {
  }
  
//+------------------------------------------------------------------+
void ClassTrenderPatterns::Init( int period_ = 50, string symbol_ = NULL, int timeframe_ = PERIOD_CURRENT )
  {
    this.symbol    = symbol_;
    this.timeframe = timeframe_;
    this.period    = period_;
    
    this.Trender.Init( symbol_, timeframe_, period_ );
    
    ArrayResize( this.Candle, 10 );
  }
  
  
//+-------------------------------------------------------------------+  
  bool ClassTrenderPatterns::isSignalTrade( int type )
    {
      bool onTrade = false;
      
      for( int i=0; i<ArraySize( this.Candle ); i++ )
        this.Candle[i].Init( this.symbol, this.timeframe, i );
        
      switch(type)
        {
          case OP_BUY:  
            {
              onTrade = (
              
                (
                     this.Trender.GetCurrTrend() == TREND_UP
                  && this.Candle[1].direction == CANDLE_UP
                  && this.Candle[1].close > this.Trender.line[1]
                  && this.Candle[1].open  < this.Trender.line[1]
                  
                  && this.Candle[2].direction == CANDLE_DOWN
                  && this.Candle[2].close < this.Trender.line[2]
                  && this.Candle[2].open  > this.Trender.line[2]
                )
               ||
                /*(
                     this.Trender.GetCurrTrend() == TREND_UP
                  && this.Candle[1].direction == CANDLE_UP
                  && this.Candle[1].close > this.Trender.line[1]
                  && this.Candle[1].low < this.Trender.line[1]
                )
               ||*/
                (
                     this.Trender.GetCurrTrend() == TREND_DOWN
                  && this.Candle[1].direction == CANDLE_UP
                  && this.Candle[2].direction == CANDLE_UP
                )
                 
              );
              
              
              if( onTrade )
                {
                  this.order_params.type = OP_BUY;
                  this.order_params.open_price = iHigh( this.symbol, this.timeframe, iHighest( this.symbol, this.timeframe, MODE_HIGH, 3, 1) );
                  this.order_params.stoploss   = iLow( this.symbol, this.timeframe, iLowest( this.symbol, this.timeframe, MODE_LOW, 3, 1) );
                  return onTrade;
                }
            }
          
          case OP_SELL: 
            {
              onTrade = (
              
                (
                     this.Trender.GetCurrTrend() == TREND_DOWN
                  && this.Candle[1].direction == CANDLE_DOWN
                  && this.Candle[1].close < this.Trender.line[1]
                  && this.Candle[1].open  > this.Trender.line[1]
                  
                  && this.Candle[2].direction == CANDLE_UP  
                  && this.Candle[2].close > this.Trender.line[2]
                  && this.Candle[2].open  < this.Trender.line[2]
                )
               ||
               /* (
                     this.Trender.GetCurrTrend() == TREND_DOWN
                  && this.Candle[1].direction == CANDLE_DOWN   
                  && this.Candle[1].close < this.Trender.line[1]
                  && this.Candle[1].high > this.Trender.line[1]
                ) 
               ||*/
                (
                     this.Trender.GetCurrTrend() == TREND_UP
                  && this.Candle[1].direction == CANDLE_DOWN
                  && this.Candle[2].direction == CANDLE_DOWN
                )
                
              );
              
              
              if( onTrade )
                {
                  this.order_params.type = OP_SELL;
                  this.order_params.open_price = iLow( this.symbol, this.timeframe, iLowest( this.symbol, this.timeframe, MODE_LOW, 3, 1) );
                  this.order_params.stoploss   = iHigh( this.symbol, this.timeframe, iHighest( this.symbol, this.timeframe, MODE_HIGH, 3, 1) );
                  return onTrade;
                }
            }
        }  
        
      return onTrade;  
    }