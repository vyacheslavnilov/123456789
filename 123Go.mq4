//+------------------------------------------------------------------+
//|                           Первый самостоятельный вместе с НС.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                            Автор:Вячеслав Нилов  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Forex Tester Software Inc."
#property link      "http://www.forextester.com"
#property version   "1.00"
#property strict

// Входные параметры
input color TextColor = clrWhite; // Цвет текста
input int FontSize = 12; // Размер шрифта
input string FontName = "Arial"; // Название шрифта

// Переменные
double Balance, Equity, Profit, Loss;

//+------------------------------------------------------------------+
//| Инициализация советника                                          |
//+------------------------------------------------------------------+
void OnInit()
{
   // Установка цвета фона графика
   SetChartBkColor(TextColor);
}

//+------------------------------------------------------------------+
//| Обновление информации на графике                                 |
//+------------------------------------------------------------------+
void OnTick()
{
   // Получение текущих значений баланса, эквити, прибыли и убытка
   Balance = AccountBalance();
   Equity = AccountEquity();
   Profit = Equity - Balance;
   Loss = Balance - Equity;

   // Формирование строки с информацией
   string info = "Balance: " + DoubleToStr(Balance, 2) + "\n" +
                 "Equity: " + DoubleToStr(Equity, 2) + "\n" +
                 "Profit: " + DoubleToStr(Profit, 2) + "\n" +
                 "Loss: " + DoubleToStr(Loss, 2);

   // Вывод информации на график
   Comment(info);
   ObjectCreate("InfoDisplay", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("InfoDisplay", info, FontSize, FontName, TextColor);
   ObjectSet("InfoDisplay", OBJPROP_CORNER, 0);
   ObjectSet("InfoDisplay", OBJPROP_XDISTANCE, 10);
   ObjectSet("InfoDisplay", OBJPROP_YDISTANCE, 10);
}

//+------------------------------------------------------------------+
//| Удаление объектов при закрытии советника                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectDelete("InfoDisplay");
}
