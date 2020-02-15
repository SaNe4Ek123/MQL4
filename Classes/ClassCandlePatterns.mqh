//+------------------------------------------------------------------+
//|                                          ClassCandlePatterns.mqh |
//|                                                           Alex G |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alex G"
#property link      ""
#property version   "1.00"
#property strict

#include "ClassCandle.mqh"

//+------------------------------------------------------------------+
class ClassCandlePatterns
  {
    private:
      ClassCandle candle[11];
      
      int begin_position,
          timeframe;
          
      string symbol;

    public:
                     ClassCandlePatterns();
                    ~ClassCandlePatterns();
               void  Init( string symbol_, int timeframe_, int begin_position_ );
               bool  IsPinBarUp();
               bool  IsPinBarDown();
               bool  IsBoolAbsorption();
               bool  IsBearAbsorption();
               bool  IsBoolCross();
               bool  IsBearCross();
               bool  IsBoolThreeCandleOneDirection();
               bool  IsBearThreeCandleOneDirection();
  };
  
  
//+------------------------------------------------------------------+
ClassCandlePatterns::ClassCandlePatterns()
  {
    this.Init( Symbol(), PERIOD_CURRENT, 1 );
  }
  
//+------------------------------------------------------------------+
 void ClassCandlePatterns::Init( string symbol_, int timeframe_, int begin_position_ )
   {
     this.begin_position = begin_position_;
     this.symbol         = symbol_;
     this.timeframe      = timeframe_;
     
     for( int i=1; i<ArraySize( this.candle ); i++ )
      {
        this.candle[i].Init( this.symbol, this.timeframe, i + this.begin_position-1 );
      }
   }

//+------------------------------------------------------------------+
 ClassCandlePatterns::~ClassCandlePatterns()
   {
      
   }
  
  
//+------------------------------------------------------------------+
 bool ClassCandlePatterns::IsPinBarUp()
   { 
     return (
          this.candle[1].body_percent < 20
       && this.candle[1].shadow_bottom_percent > 70
       
       && this.candle[1].low < this.candle[2].low
       && this.candle[1].low < this.candle[3].low
       && this.candle[1].low < this.candle[4].low
       && this.candle[1].low < this.candle[5].low
       && this.candle[1].low < this.candle[6].low
       
       && this.candle[1].size > this.candle[2].size
       && this.candle[1].size > this.candle[3].size
       && this.candle[1].size > this.candle[4].size
     );
   }
   
   
//+------------------------------------------------------------------+
 bool ClassCandlePatterns::IsPinBarDown()
   {
     return (
          this.candle[1].body_percent < 20
       && this.candle[1].shadow_top_percent > 70
       
       && this.candle[1].high > this.candle[2].high
       && this.candle[1].high > this.candle[3].high
       && this.candle[1].high > this.candle[4].high
       && this.candle[1].high > this.candle[5].high
       && this.candle[1].high > this.candle[6].high
       
       && this.candle[1].size > this.candle[2].size
       && this.candle[1].size > this.candle[3].size
       && this.candle[1].size > this.candle[4].size
     );
   }
 
   
//+------------------------------------------------------------------+
 bool ClassCandlePatterns::IsBoolAbsorption()
   {
     return (
          this.candle[1].size > this.candle[2].size
       && this.candle[1].direction == CANDLE_UP
       && this.candle[2].direction == CANDLE_DOWN
       && this.candle[1].low <= this.candle[2].low + 2*Point   
       && this.candle[1].high >= this.candle[2].high + 2*Point
       && this.candle[1].body_percent > 80
       &&
         (
           (
                this.candle[1].high >= this.candle[2].high
             && this.candle[1].high > this.candle[3].high
             && this.candle[1].high > this.candle[4].high
             && this.candle[1].high > this.candle[5].high
             && this.candle[1].high > this.candle[6].high
           )
           ||
           (
                this.candle[2].high >= this.candle[1].high
             && this.candle[2].high > this.candle[3].high
             && this.candle[2].high > this.candle[4].high
             && this.candle[2].high > this.candle[5].high
             && this.candle[2].high > this.candle[6].high
           )
         )
     );
   }
   
   
//+------------------------------------------------------------------+
 bool ClassCandlePatterns::IsBearAbsorption()
   {
     return (
          this.candle[1].size > this.candle[2].size
       && this.candle[1].direction == CANDLE_DOWN
       && this.candle[2].direction == CANDLE_UP
       && this.candle[1].high >= this.candle[2].high + 2*Point   
       && this.candle[1].low <= this.candle[2].low + 2*Point
       && this.candle[1].body_percent > 80
       &&
         (
           (
                this.candle[1].low <= this.candle[2].low
             && this.candle[1].low < this.candle[3].low
             && this.candle[1].low < this.candle[4].low
             && this.candle[1].low < this.candle[5].low
             && this.candle[1].low < this.candle[6].low
           )
           ||
           (
                this.candle[2].low <= this.candle[1].low
             && this.candle[2].low < this.candle[3].low
             && this.candle[2].low < this.candle[4].low
             && this.candle[2].low < this.candle[5].low
             && this.candle[2].low < this.candle[6].low
           )
         )
     );
   }
   
   
//+------------------------------------------------------------------+
 bool ClassCandlePatterns::IsBearCross()
   {
     return (
          this.candle[1].direction == CANDLE_NONE
       && this.candle[2].direction == CANDLE_UP
       && this.candle[2].body_percent > 70
       && this.candle[1].open <= this.candle[2].close
     );
   }
   
   
//+------------------------------------------------------------------+
 bool ClassCandlePatterns::IsBoolCross()
   {
     return (
          this.candle[1].direction == CANDLE_NONE
       && this.candle[2].direction == CANDLE_DOWN
       && this.candle[2].body_percent > 70
       && this.candle[1].open >= this.candle[2].close
     );
   }
   
   
//+------------------------------------------------------------------+
bool ClassCandlePatterns::IsBoolThreeCandleOneDirection()
   {
     return (
          this.candle[1].direction == CANDLE_UP
       && this.candle[2].direction == CANDLE_UP
       //&& this.candle[3].direction == CANDLE_UP
       
       //&& this.candle[1].body_percent > 70
       //&& this.candle[2].body_percent > 70
       //&& this.candle[3].body_percent > 70
     );
   }
   
//+------------------------------------------------------------------+
bool ClassCandlePatterns::IsBearThreeCandleOneDirection()
   {
     return (
          this.candle[1].direction == CANDLE_DOWN
       && this.candle[2].direction == CANDLE_DOWN
       //&& this.candle[3].direction == CANDLE_DOWN
       
       //&& this.candle[1].body_percent > 70
       //&& this.candle[2].body_percent > 70
       //&& this.candle[3].body_percent > 70
     );
   }
   
 