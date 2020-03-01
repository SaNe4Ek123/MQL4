
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
    
      ClassOrder Orders[];
      ClassOrder Order;
      
     //------- Methods ------- 
      int  CreateOrder();
      bool TrackOrder( ClassOrder &order );
      
      ClassTrade *trade;
      
    public:
    
     //------- Properties -------
      ClassTargets Targets;
      ClassAccountingOrders AccountOrders;
     
     //------- Methods -------
            ClassTrade();
           ~ClassTrade();
      void  Create( string symbol_, int magic_ );
      bool  OpenOrder();
      void  CloseAllOrders();
      void  TrackOrders();
      void  TrackOrder();
      void  Init();
      
      ClassOrder *SetOrder();
      void Send();
      
      
  };
  
  
//+------------------------------------------------------------------+
void ClassTrade::ClassTrade()
  {
  }
  
  
  
//+------------------------------------------------------------------+
void ClassTrade::~ClassTrade()
  {
  }
  
  

//+-----------------------------------------------------------------+     
void ClassTrade::Create( string symbol_ = NULL, int magic_ = NULL )
   {
      this.symbol = symbol_;
      this.magic  = magic_;
   }    
   
   
   
//+-----------------------------------------------------------------+   
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
    int i = -1;
    this.Order.Send();
    
    if( this.Order.Ticket > 0 )
      { 
        i = this.CreateOrder();
        this.Orders[i].Init( this.Order.Ticket );
        this.Order.Clear();
      }
    return this.Orders[i].Ticket > 0;
  }
  
  
  
//+------------------------------------------------------------------+
 void ClassTrade::CloseAllOrders()
  {
    for( int i=0; i<ArraySize( this.Orders ); i++ )
      this.Orders[i].Close();
  }
  
  
//+------------------------------------------------------------------+
 bool ClassTrade::TrackOrder( ClassOrder &order )
   {
     switch( order.Type )
      {
        case OP_BUY:
         {
           if( order.Virtual )
            {
              if( order.TakeProfit > 0 && Bid >= order.TakeProfit )
               order.Close();
               
              if( order.StopLoss > 0 && Bid <= order.StopLoss )
               order.Close();
               
              return true;  
            }
         }
         
        case OP_SELL:
         {
           if( order.Virtual )
            {
              if( order.TakeProfit > 0 && Ask <= order.TakeProfit )
               order.Close();
               
              if( order.StopLoss > 0 && Ask >= order.StopLoss )
               order.Close();
               
              return true;
            }
         }
         
         
        case OP_BUYSTOP:
         {
           if( order.Ticket == 0 )
            {
               if( Ask >= order.OpenPrice )
                  {
                    order.Type = OP_BUY;
                    order.Send();
                    
                    
                    return true;
                  }
            } 
         }
         
         
        case OP_SELLSTOP:
         {
           if( order.Ticket == 0 )
            {
               if( Bid <= order.OpenPrice )
                  {
                    order.Type = OP_SELL;
                    order.Send();
                    
                    return true;
                  }
            } 
         }
         
         
        case OP_BUYLIMIT:
         {
           if( order.Ticket == 0 )
            {
               if( Ask <= order.OpenPrice )
                  {
                    order.Type = OP_BUY;
                    order.Send();
                    
                    return true;
                  }
            } 
         }
         
        case OP_SELLLIMIT:
         {
           if( order.Ticket == 0 )
            {
               if( Ask >= order.OpenPrice )
                  {
                    order.Type = OP_SELL;
                    order.Send();
                    
                    return true;
                  }
            } 
         }
         
         
      }
      
     return false;
   }  


//+------------------------------------------------------------------+
 void ClassTrade::TrackOrders()
   {
     for( int i=0; i<ArraySize( this.Orders ); i++ )
       this.TrackOrder( this.Orders[i] );
   }   
   
   
   
//+------------------------------------------------------------------+
 void ClassTrade::TrackOrder()
   {
      this.TrackOrder( this.Order );
   }    
   
     
//+------------------------------------------------------------------+     
 ClassOrder *ClassTrade::SetOrder()
   {
      this.Order.Clear(); 
      return ( GetPointer( this.Order ) );
   }
   

//+------------------------------------------------------------------+   
 void ClassTrade::Send()
   {
      this.OpenOrder();
   }
   