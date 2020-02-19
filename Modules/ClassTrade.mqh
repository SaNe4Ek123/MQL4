
#property copyright "AlexG"
#property link      ""
#property version   "1.00"
#property strict

#include  "Trade/ClassAccountingOrders.mqh"
#include  "Trade/ClassOrder.mqh"
#include  "Trade/ClassTargets.mqh"

class ClassTrade
  {
    private:
    
     //------- Properties -------
      string symbol;
      int magic;
    
      ClassAccountingOrders AccountOrders;
      ClassOrder Orders[];
      ClassTargets Targets;
      
     //------- Methods ------- 
      int CreateOrder();
      
    public:
    
     //------- Properties -------
      ClassOrder Order;
     
     //------- Methods -------
            ClassTrade();
           ~ClassTrade();
      void  Create( string symbol_, int magic_ );
      bool  OpenOrder();
      void  CloseAllOrders();
      void  Init();
  };
  
  
//+------------------------------------------------------------------+
void ClassTrade::ClassTrade()
  {
  }
  
  
//+------------------------------------------------------------------+
void ClassTrade::~ClassTrade()
  {
  }
  
  
  
void ClassTrade::Create( string symbol_ = NULL, int magic_ = NULL )
   {
      this.symbol = symbol_;
      this.magic  = magic_;
   }    
   
//+---------------------------------------------------+   
 void ClassTrade::Init()
   {
      this.AccountOrders.Init( this.symbol, this.magic );
      
      this.Targets.SetSymbol(this.symbol);
      this.Targets.SetMagic(this.magic);
      this.Targets.SetType(OP_MARKET);
      
      int tickets[];
      this.AccountOrders.GetTickets( tickets, OP_ALL );
      for( int i=0; i<ArraySize( tickets ); i++ )
         {
            int x = this.CreateOrder();
            this.Orders[x].Init( tickets[i] );
         }
      
   }


//+------------------------------------------------------------------+  
 int ClassTrade::CreateOrder()
   {
      int size = ArraySize( this.Orders );
      ArrayResize( this.Orders, size + 1 );
      
      return size;
   }  
   
   
   
//+------------------------------------------------------------------+
 bool ClassTrade::OpenOrder()
  {
    bool res = false;
    res = this.Order.Send();
    
    if( res )
      {
        int i = ArraySize( this.Orders ) - 1;
        
        this.Orders[i].Init( this.Order.Ticket );
        this.Order.Clear();
      }
    
    return res;
  }
  
  
  
//+------------------------------------------------------------------+
 void ClassTrade::CloseAllOrders()
  {
    for( int i=0; i<ArraySize( this.Orders ); i++ )
      this.Orders[i].Close();
  }  