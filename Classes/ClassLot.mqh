//+------------------------------------------------------------------+
//|                                                     ClassLot.mqh |
//|                                                           Alex G |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alex G"
#property link      ""
#property version   "1.00"
#property strict

#define TYPE_RISK 1
#define TYPE_LOT_FOR_BALANCE 2
#define TYPE_FIXED 3


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ClassLot
  {
  
  //--- Properties
      private:
        double Lot,
               Balance,
               Risk,
               MaxLot,
               SL_Size;
        
        int Type;
        bool UseMaxLot;
        
        
  //--- Methods      
      public:
                     ClassLot();
                    ~ClassLot();
              double GetLot();
              double GetLot( double sl_size );
              void   SetType_LotForBalance( double lot, double balance, bool use_max_lot = false );
              void   SetType_Risk( double risk );
              void   SetType_Fixed( double lot );
              void   InitMaxLot( int magic );
                    
      private:
              double GetLotForBalance( bool return_max_lot = false );
              double GetLotRisk();
              bool   CheckMoneyForTrade( double lot, int type );
  };
  
//+------------------------------------------------------------------+
void ClassLot::ClassLot()
  {
  }
  
//+------------------------------------------------------------------+
void ClassLot::~ClassLot()
  {
  }
  
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
  double ClassLot::GetLotForBalance( bool return_max_lot = false )
    {
      double min_lot = MarketInfo(Symbol(),MODE_MINLOT),
             max_lot = MarketInfo(Symbol(),MODE_MAXLOT);
             
      double new_lot;
    
      if( this.Balance > 0 && this.Lot > 0 )
        new_lot = NormalizeDouble( AccountBalance()/this.Balance*this.Lot, 2 );
      else
        new_lot = this.Lot;
    
      if( new_lot  < min_lot )
        new_lot = min_lot;
      
      if( new_lot > max_lot)
       new_lot = max_lot;
      
      if( return_max_lot )
        if( new_lot < this.MaxLot )
          return this.MaxLot;
          
      this.MaxLot = new_lot;
      
      if( this.CheckMoneyForTrade( this.MaxLot, OP_BUY ) || this.CheckMoneyForTrade( this.MaxLot, OP_SELL ) )
        return this.MaxLot;
        
      return 0;
    }
    
    
//+------------ Лот по размеру стоплосса ( % от баланса на сделку ) ----------------+
 double ClassLot::GetLotRisk()
   {
      double free    =AccountFreeMargin();
      double lot_val  =MarketInfo(Symbol(),MODE_TICKVALUE);//стоимость 1 пункта для 1 лота
      double min_lot =MarketInfo(Symbol(),MODE_MINLOT);
      double max_lot =MarketInfo(Symbol(),MODE_MAXLOT);
      double step    =MarketInfo(Symbol(),MODE_LOTSTEP);
      double lot     =MathFloor((free*this.Risk/100)/(this.SL_Size*lot_val)/step)*step;
      
      Print( "Lot = ", lot );
      if(lot<min_lot)
        return 0;
      
      if(lot>max_lot) lot=max_lot;
      
      if( this.CheckMoneyForTrade( lot, OP_BUY ) || this.CheckMoneyForTrade( lot, OP_SELL ) )
        return lot;
        
      return 0;
   }   
   
//+---------------------------------------------------------------------------+
bool ClassLot::CheckMoneyForTrade( double lot, int type )
  {
    if(AccountFreeMarginCheck(_Symbol, type, lot) <= 0)
      return(false);
      
   //-- проверка прошла успешно
    return(true);
   }    
   
   
//+-----------------------------------------------------------------------------+
 double ClassLot::GetLot()
  {
    switch( this.Type )
      {
        case TYPE_FIXED:          {return this.Lot; break;}
        case TYPE_LOT_FOR_BALANCE:{return this.GetLotForBalance( this.UseMaxLot ); break;}
        case TYPE_RISK:           {return this.GetLotRisk(); break;}
        default: return 0;
      }
  }
  
//+-----------------------------------------------------------------------------+
 double ClassLot::GetLot( double sl_size )
  {
    if( this.Type == TYPE_RISK )
      {
        this.SL_Size = sl_size;
        return GetLotRisk();
      }
      
    return 0;  
  }  
  
  
//+-----------------------------------------------------------------------------+
  void ClassLot::SetType_Risk( double risk )
    {
      this.Type    = TYPE_RISK;
      this.Risk    = risk;
    }
    
//+-----------------------------------------------------------------------------+
  void ClassLot::SetType_LotForBalance( double lot, double balance, bool use_max_lot = false )
    {
      this.Type      = TYPE_LOT_FOR_BALANCE;
      this.Balance   = balance;
      this.Lot       = lot;
      this.UseMaxLot = use_max_lot;
    }
    
    
//+-----------------------------------------------------------------------------+
  void ClassLot::SetType_Fixed( double lot )
    {
      this.Type      = TYPE_FIXED;
      this.Lot       = lot;
    }
    
//+-----------------------------------------------------------------------------+
 void ClassLot::InitMaxLot( int magic )
  {
    this.MaxLot = 0;
    if( OrdersHistoryTotal() == 0 )
      return;
      
    for( int i=0; i<OrdersHistoryTotal(); i++ )
      {
        if( !OrderSelect( i, SELECT_BY_POS, MODE_HISTORY ) )
          continue;
          
        if( OrderMagicNumber() != magic )
          continue;
          
        if( OrderLots() > this.MaxLot )
          this.MaxLot = OrderLots();
      }
  }    