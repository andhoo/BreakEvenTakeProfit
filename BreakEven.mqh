//+------------------------------------------------------------------+
//|                                                    BreakEven.mqh |
//|                                Copyright 2022, André Hoogendoorn |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, André Hoogendoorn"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <stderror.mqh>
#include <stdlib.mqh>
//
input int BeTrigger = 15; //Break-Even Trigger [points]
input int BeLevel   =  5; //Break-Even Level [points]
//
class CBreakEven
  {
private:

public:
                     CBreakEven();
                    ~CBreakEven();
   void              OnTick();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CBreakEven::CBreakEven()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CBreakEven::~CBreakEven()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CBreakEven::OnTick()
  {
   double bid = Bid;
   double ask = Ask;
//
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol)
        {
         int ticket = OrderTicket();      //This selects the position as well
         double tp = OrderTakeProfit();
         double sl = OrderStopLoss();
         double open = OrderOpenPrice();
         double be = BeLevel * _Point;
         double betrigger = BeTrigger * _Point;
         switch(OrderType())
           {
            case OP_BUY:
               if(bid >= NormalizeDouble(open + betrigger, _Digits) && (sl < open || !sl))
                 {
                  sl = NormalizeDouble(open + be, _Digits);
                  if(OrderModify(ticket, open, sl, tp, 0))
                    {
                     PrintFormat("INFO: #%i breakeven set RESULT: %s", ticket, ErrorDescription(GetLastError()));
                    }
                  else
                    {
                     PrintFormat("ERROR: #%i breakeven set RESULT: %s", ticket, ErrorDescription(GetLastError()));
                    }
                 }
               break;
            case OP_SELL:
               if(ask <= NormalizeDouble(open - betrigger, _Digits) && (sl > open || !sl))
                 {
                  sl = NormalizeDouble(open - be, _Digits);
                  if(OrderModify(ticket, open, sl, tp, 0))
                    {
                     PrintFormat("INFO: #%i breakeven set RESULT: %s", ticket, ErrorDescription(GetLastError()));
                    }
                  else
                    {
                     PrintFormat("ERROR: #%i breakeven set RESULT: %s", ticket, ErrorDescription(GetLastError()));
                    }
                 }
               break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
