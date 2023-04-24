//+------------------------------------------------------------------+
//|                           Первый самостоятельный вместе с НС.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                            Автор:Вячеслав Нилов  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
double balance, equity, profit;
int text_handle;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Create text object for displaying balance, equity and profit
   text_handle = ObjectsCreate(0, "BalanceInfo", OBJ_LABEL, 0, 0, 0);
   ObjectSetString(text_handle, OBJPROP_FONT, "Arial");
   ObjectSetInteger(text_handle, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(text_handle, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSetInteger(text_handle, OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(text_handle, OBJPROP_YDISTANCE, 10);
   ObjectSetInteger(text_handle, OBJPROP_BACK, true);
   ObjectSetInteger(text_handle, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(text_handle, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(text_handle, OBJPROP_BORDER_COLOR, clrBlack);
   ObjectSetInteger(text_handle, OBJPROP_BORDER_WIDTH, 1);
   ObjectSetInteger(text_handle, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(text_handle, OBJPROP_HIDDEN, false);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Delete text object
   ObjectsDelete(text_handle);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Get account information
   balance = AccountBalance();
   equity = AccountEquity();
   profit = equity - balance;

   // Update text object with account information
   string text = "Balance: " + DoubleToStr(balance, 2) + "\nEquity: " + DoubleToStr(equity, 2) + "\nProfit: " + DoubleToStr(profit, 2);
   ObjectSetString(text_handle, OBJPROP_TEXT, text);
}
