//+------------------------------------------------------------------+
//|                                                  ZigZagLevel.mqh |
//|                                                            AlexG |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "AlexG"
#property link      ""
#property version   "1.00"
#property strict

#define ZZ_NONE 0
#define ZZ_LOW 1
#define ZZ_HIGH 2
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ClassZigZagLevel
  {
   //-- Propertyes
    public:
      string symbol;
      
      int timeframe,
          index_bar;
           
      double level_high,
             level_low; 
             
      int type;

public:
                     ClassZigZagLevel();
                    ~ClassZigZagLevel();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ClassZigZagLevel::ClassZigZagLevel()
  {
    this.symbol     = NULL;
    this.timeframe  = NULL;
    this.index_bar  = NULL;
    this.level_high = 0;
    this.level_low  = 0;
    this.type       = ZZ_NONE;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ClassZigZagLevel::~ClassZigZagLevel()
  {
  }
//+------------------------------------------------------------------+
