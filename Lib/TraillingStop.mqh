//+---------------------------------------------------------------------------+
void TraillingStop( string symbol_, int magic_, string comment_ = NULL, int step_ = 0, int dist_ = 0, bool breakeven_ = false )
  {
    if(OrdersTotal() == 0)
      return;
    
    bool result, find; 
    double spr = Ask-Bid,
           step_loc = NormalizeDouble(step_*Point, Digits),
           dist = NormalizeDouble(dist_*Point, Digits),
           sl = 0;
           
    for(int i=0; i<OrdersTotal(); i++)
      {
        if( OrderSelect( i, SELECT_BY_POS ) )
          {
            if( comment_ == NULL )
              find = OrderSymbol() == symbol_ && OrderMagicNumber() == magic_;
            else
              find = OrderSymbol() == symbol_ && OrderMagicNumber() == magic_ && OrderComment() == comment_;
              
            if(find)
              { 
                sl = MathAbs(OrderOpenPrice() - OrderStopLoss());  
                  
                if(OrderType() == OP_BUY)
                  {
                    if(breakeven_ && OrderStopLoss()>=OrderOpenPrice())
                      return;
                  
                    if(OrderStopLoss() <= Bid - sl - step_loc - dist)
                      result = OrderModify(OrderTicket(), 0, Bid - sl, OrderTakeProfit(), 0, clrNONE);
                  }
                  
                if(OrderType() == OP_SELL)
                  {
                    if(breakeven_ && OrderStopLoss()<=OrderOpenPrice())
                      return;
                      
                    if(OrderStopLoss() >= Ask + sl + step_loc + dist)
                      result = OrderModify(OrderTicket(), 0, Ask + sl, OrderTakeProfit(), 0, clrNONE);
                  }
              }
          }
      }
  }       