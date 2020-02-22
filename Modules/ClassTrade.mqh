
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
      
     //------- Methods ------- 
      int  CreateOrder();
      bool TrackOrder( ClassOrder &order );
      
      ClassTrade *trade;
      
    public:
    
     //------- Properties -------
      ClassOrder Order;
      ClassTargets Targets;
      ClassAccountingOrders AccountOrders;
     
     //------- Methods -------
            ClassTrade();
           ~ClassTrade();
      void  Create( string symbol_, int magic_ );
      bool  OpenOrder();
      void  CloseAllOrders();
      void  TrackOrders();
      void  Init();
      
      ClassTrade *SetOrder();
      ClassTrade *Symbol( string symb );
      ClassTrade *Magic( int magic );
      ClassTrade *Lot( double lot );
      ClassTrade *Type( int type );
      ClassTrade *OpenPrice( double open_price );
      ClassTrade *StopLoss( double stoploss );
      ClassTrade *TakeProfit( double takeprofit );
      ClassTrade *Slippage( int slippage );
      ClassTrade *Comment( string comment );
      ClassTrade * Expiration( datetime expiration );
      ClassTrade *Virtual( bool virtual_ );
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
        
        this.CreateOrder();
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
              if( order.TakeProfit > 0 && Bid <= order.TakeProfit )
               order.Close();
               
              if( order.StopLoss > 0 && Bid >= order.StopLoss )
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
   
   
   
 ClassTrade *ClassTrade::SetOrder()                        {this.Order.Clear();                 return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::Symbol( string symb )             {this.Order.Symbol = symb;           return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::Magic( int magic_ )               {this.Order.MagicNumber = magic_;    return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::Lot( double lot )                 {this.Order.Lot = lot;               return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::Type( int type )                  {this.Order.Type = type;             return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::OpenPrice( double open_price )    {this.Order.OpenPrice = open_price;  return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::StopLoss( double stoploss )       {this.Order.StopLoss = stoploss;     return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::TakeProfit( double takeprofit )   {this.Order.TakeProfit = takeprofit; return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::Slippage( int slippage )          {this.Order.Slippage = slippage;     return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::Comment( string comment )         {this.Order.Comment = comment;       return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::Expiration( datetime expiration)  {this.Order.Experation = expiration; return ( GetPointer( this ) );}
 ClassTrade *ClassTrade::Virtual( bool virtual_ )          {this.Order.Virtual = virtual_;      return ( GetPointer( this ) );}
 void ClassTrade::Send()                                   {this.OpenOrder();}
   