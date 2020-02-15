//+------------------------------------------------------------------+
#property copyright "Alex G"
#property link      ""
#property version   "1.00"
#property strict

#include "../lib/Array.mqh"

#define TREND_UP 1
#define TREND_DOWN -1
#define TREND_NONE 0


//+------------------------------------------------------------------+
class ClassTrender
  {
    public:
     //----- Properties
      int period,
          bars,
          curr_trend,
          timeframe,
          type_trend[];
          
      string symbol;    
          
      double line[];
      
      bool newCandle;
      
      datetime dt_last,
               dt_curr;
      
     //----- Methods 
            ClassTrender();
           ~ClassTrender();
      void  SetLastValueIndicator( double value );
      void  SetLastValueTypeTrend( int value );
      void  Init( string symbol = NULL, int timeframe = 0, int period_ = 50 );
      int   GetCurrTrend();
  };
  
  
//+---------------------------------------------------------------------+
  void ClassTrender::ClassTrender()
    {
      this.symbol    = _Symbol;
      this.timeframe = PERIOD_CURRENT;
      this.bars      = 10;
      this.period    = 50;
      this.newCandle = false;
      this.dt_curr   = 0;
      this.dt_last   = 0;
      
      ArrayResize( this.line, this.bars );
      ArrayInitialize( this.line, 0 );
      
      ArrayResize( this.type_trend, this.bars );
      ArrayInitialize( this.type_trend, TREND_NONE );
      
      this.Init();
      
    }
  
  
//+---------------------------------------------------------------------+
  void ClassTrender::~ClassTrender()
    {
    }
  
  
//+------------- Добавляем значение индикатора в массив (Со смещением)-----------+
 void ClassTrender::SetLastValueIndicator( double value )
   {   
     double line_tmp[];
     ArrayCopy( line_tmp, this.line );
     
     this.line[0] = value;
     for( int i=1; i<ArraySize( this.line ); i++ )
       this.line[i] = line_tmp[i-1];  
       
   }
   
   
//+------------- Добавляем значение индикатора в массив (Со смещением)-----------+
 void ClassTrender::SetLastValueTypeTrend( int value )
   {   
     int type_trend_tmp[];
     ArrayCopy( type_trend_tmp, this.type_trend );
     
     this.type_trend[0] = value;
     for( int i=1; i<ArraySize( this.type_trend ); i++ )
       this.type_trend[i] = type_trend_tmp[i-1];  
       
   }   
   

//+------------- Инициализация индикатора ( последние несколько баров ) -----------+
 void ClassTrender::Init( string symbol_ = NULL, int timeframe_ = PERIOD_CURRENT, int period_ = 50 )   
  {
    if( symbol_ == NULL )
      this.symbol    = _Symbol;
      
    this.timeframe = timeframe_;
    this.period    = period_;
  
   
    double border_top,
           border_bottom;
    
   //--- Сбор первых нескольких значений индикатора        
    for( int i=0; i<ArraySize( this.line ); i++ )
      {
        border_top    = High[ iHighest( this.symbol, this.timeframe, MODE_HIGH, this.period, i ) ];
        border_bottom = Low[ iLowest( this.symbol, this.timeframe, MODE_LOW, this.period, i ) ];
        
        line[i] = ( border_top + border_bottom ) / 2;
      }
    
   //--- Инициализация текущего тренда   
    if( line[1] > line[ this.bars - 1 ] )
      this.curr_trend = TREND_UP;
      
    else if( line[1] < line[ this.bars - 1 ] )
      this.curr_trend = TREND_DOWN;    
    
    else 
      this.curr_trend = TREND_NONE;
      
    this.SetLastValueTypeTrend( this.curr_trend );  
  }
  
//-------------- Проверка изменения тренда ------------------
 int ClassTrender::GetCurrTrend() 
   {
     double border_top,
            border_bottom;
           
     this.dt_curr = iTime(this.symbol, this.timeframe, 0 );
   
     this.newCandle = this.dt_last != this.dt_curr; 
                     
     if( this.newCandle )
      {
       //-- Пересохраняем признак новой свечи
        this.dt_last = this.dt_curr;
        
       //-- Расчёт значения индикатора нового тренда 
        border_top    = High[ iHighest( this.symbol, this.timeframe, MODE_HIGH, this.period, 0 ) ];
        border_bottom = Low[ iLowest( this.symbol, this.timeframe, MODE_LOW, this.period, 0 ) ];
        
        this.SetLastValueIndicator( ( border_top + border_bottom ) / 2 );
      
       //-- Определяем тренд исходя из обновлённых данных массива значений индикатора 
        border_top    = High[ iHighest( this.symbol, this.timeframe, MODE_HIGH, this.period, 1 ) ];
        border_bottom = Low[ iLowest( this.symbol, this.timeframe, MODE_LOW, this.period, 1 ) ];
        
        if( Close[0] > border_top )
          this.curr_trend = TREND_UP;
          
        if( Close[0] < border_bottom )
          this.curr_trend = TREND_DOWN;  
          
        this.SetLastValueTypeTrend( this.curr_trend );  
      }                
                     
     return this.curr_trend;
   }
 
  
    