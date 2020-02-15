//+------------------------------------------------------------------+
//|                                                  ClassProfit.mqh |
//|                                                           Alex G |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alex G"
#property link      ""
#property version   "1.00"
#property strict

#define PROFIT_DAY 1
#define PROFIT_WEEK 7
#define PROFIT_MONTH 30
#define PROFIT_YEAR 365

//+------------------------------------------------------------------+
class ClassProfit
  {
    public:
      double profit_currency,
             profit_percent,
             begin_balance;
              
      int profit_pips;


    public:
                     ClassProfit();
                     ClassProfit( string symbol_, int magic_, int period_ );
                     
                    ~ClassProfit();
               void  Init( string symbol_, int magic_, int period_ );   
                    
    
  };
  
  
//+------------------------------------------------------------------+
void ClassProfit::ClassProfit()
  {
    this.begin_balance   = AccountBalance();
    this.profit_currency = 0;
    this.profit_percent  = 0;
    this.profit_pips     = 0;
  }
  

void ClassProfit::ClassProfit( string symbol_, int magic_, int period_ )
  {
    this.begin_balance   = AccountBalance();
    this.profit_currency = 0;
    this.profit_percent  = 0;
    this.profit_pips     = 0;
    
    this.Init( symbol_, magic_, period_ );
  }  
  
//+------------------------------------------------------------------+
void ClassProfit::~ClassProfit()
  {
  }
  
  
//+------------------------------------------------------------------+
void ClassProfit::Init( string symbol_ = NULL, int magic_ = 0, int period_ = PROFIT_DAY )
  {
    this.profit_currency = 0;
    this.profit_pips     = 0;
    this.begin_balance   = AccountBalance();
           
          
    if( OrdersHistoryTotal() == 0 )
      return;
      
    MqlDateTime dt_current;
    MqlDateTime dt_order;
      
    bool Symb_Filter = true;
    bool Type_Filter = false;
    double profit = 0;
   
    TimeToStruct( TimeCurrent(), dt_current );
        
    for( int i=0; i<OrdersHistoryTotal(); i++ )
      {
        if( OrderSelect( i, SELECT_BY_POS, MODE_HISTORY ) )
          {
            if( symbol_ != NULL && magic_ > 0 )
              Symb_Filter = ( OrderSymbol() == symbol_ && OrderMagicNumber() == magic_ );
              
            else if( symbol_ == NULL && magic_ > 0 )
              Symb_Filter = ( OrderMagicNumber() == magic_ ); 
              
            else if( symbol_ != NULL && magic_ == 0 )  
              Symb_Filter = ( OrderSymbol() == symbol_ );
              
            else if( symbol_ == NULL && magic_ > 0 )  
              Symb_Filter = ( OrderMagicNumber() == magic_ );
              
            else if( symbol_ == NULL && magic_ == 0 )  
              Symb_Filter = true;
              
            else 
              Symb_Filter = false;
            
            
                  
            TimeToStruct( OrderCloseTime(), dt_order);
            bool calc_profit = false;
            
            switch( period_ )
              {
                case PROFIT_DAY:
                  {
                    calc_profit =   dt_order.year == dt_current.year
                                 && dt_order.mon == dt_current.mon
                                 && dt_order.day == dt_current.day; 
                    break;
                  }
                             
                case PROFIT_WEEK:
                  {
                         
                    MqlDateTime dt;
                    TimeToStruct( TimeCurrent(), dt );
                              
                    dt.hour = 0;
                    dt.min  = 0;
                    dt.sec  = 0;
                               
                    dt.day         -= dt.day_of_week;
                    dt.day_of_year -= dt.day_of_week;
                    dt.day_of_week = 0;
                               
                    datetime begin_week = StructToTime( dt );
                            
                    calc_profit = OrderCloseTime() > begin_week;
                           
                    break;
                  }
                             
                case PROFIT_MONTH:
                  {
                    calc_profit =   dt_order.year == dt_current.year
                                 && dt_order.mon == dt_current.mon;
                    break;
                  }
                             
                case PROFIT_YEAR:
                  {
                    calc_profit =   dt_order.year == dt_current.year;
                    break;
                  }
              }
              
            
            Type_Filter = ( OrderType() == OP_BUY || OrderType() == OP_SELL );
                       
            if( calc_profit && Type_Filter ) 
              { 
                this.begin_balance -= ( OrderProfit() + OrderSwap() + OrderCommission() );
              }
                      
                     
            if( calc_profit && Symb_Filter && Type_Filter )
              {
                this.profit_currency += ( OrderProfit() + OrderSwap() + OrderCommission()) ;
                     
                int move_pips = (int) NormalizeDouble( MathAbs( OrderOpenPrice() - OrderClosePrice() ), 2 );
                       
                if( OrderProfit() > 0 )
                  this.profit_pips += move_pips;
                if( OrderProfit() < 0 )
                  this.profit_pips -= move_pips;
              }
          }
                     
      }
    if( this.begin_balance > 0 ) 
      this.profit_percent = NormalizeDouble(this.profit_currency / this.begin_balance * 100, 2);
          
  }