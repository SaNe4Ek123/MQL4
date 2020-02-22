
#property copyright "AlexG"
#property link      ""
#property version   "1.00"
#property strict

#include "IncHeader.mqh"
#include "Settings.mqh"

#include "..\..\Modules\ClassTrade.mqh"
#include "..\..\Modules\ClassZigZag.mqh"




class Main
  {
     private:
      ClassTrade Trade;
      ClassZigZag ZigZag;
      ClassSettings Settings;
      
      
      bool newCandle;
      datetime dt_last,          
               dt_curr;   
               
                           
      
      //+--------------------------------------------
         bool AllowedTrade( int type );    
         bool NewCandleInit(); 
         bool OpenOrder( int type );



     public:
                     Main();
                    ~Main();
                    
                  void Init();
                  void Deinit();
                  void Start();
  };
//+------------------------------------------------------------------+
Main::Main()
  {
    SettingsInit( this.Settings );
    this.Trade.Create( this.Settings.Symbol, this.Settings.Input.Magic );
    
    this.ZigZag.SetSymbol( this.Settings.Symbol );
    this.ZigZag.SetTimeframe( this.Settings.Input.Magic );
    this.ZigZag.SetPeriodZZ( 14 );
    this.ZigZag.SetBars( 500 );
    
    
    
    this.newCandle = false;
    this.dt_last = 0;          
    this.dt_curr = 0; 
    
    
  }
  
  
//+------------------------------------------------------------------+
 void Main::~Main()
  {
  }
  
  
//+------------------------------------------------------------------+
 void Main::Init()
   {
      
   }
   
   

//+------------------------------------------------------------------+
 void Main::Deinit()
   {
   
   }
   


//+------------------------------------------------------------------+
 void Main::Start()
   {
     this.NewCandleInit();
     
     
     if( this.newCandle )
       this.ZigZag.Init();
      
      
      
     this.Trade.Init();
     if( this.Trade.AccountOrders.all == 0 )
      {
         if( this.AllowedTrade( OP_BUY ) )
            this.OpenOrder( OP_BUY );
            
         if( this.AllowedTrade( OP_SELL ) )
            this.OpenOrder( OP_SELL );
      }  
      
     
     this.Trade.TrackOrders(); 
   }
   
   
   
//+=============== SERVICE FUNCTION ===================+   
bool Main::AllowedTrade( int type )
   {
      switch( type )
        {
         case OP_BUY:
           {
            return(
               false
            );
           }
           
           
         case OP_SELL:
           {
            return(
               false
            );
           }
        }
        
      return false;  
   }   
   
   
//+------------------------------------------------+
 bool Main::OpenOrder( int type )
   {
      this.Trade.SetOrder()
         .Symbol( this.Settings.Symbol )
         .Magic( this.Settings.Input.Magic )
         .Type( OP_BUY )
         .OpenPrice( Ask )
         .StopLoss( Ask - 20*_Point )
         .TakeProfit( Ask + 150*_Point )
         .Slippage( this.Settings.Input.Slippage )
         .Lot( 0.1 )
      .Send();
      
      
      return false;
   }  
  
   
//+------------------------------------------------+
 bool Main::NewCandleInit(void)
   {
      this.dt_curr = iTime( this.Settings.Symbol, this.Settings.Timeframe, 0 );
      this.newCandle = this.dt_last != this.dt_curr;
   
      return this.newCandle;
   }