//+------------------------------------------------------------------+
//|                                  Мой Первый Код_Аккаунт инфо.mq4 |
//|                                         Написано в MetaEditor 5.0|
//|                                            Автор: Вячеслав Нилов |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Forex Tester Software Inc."
#property link      "vyacheslavnilov@gmail.com"
#property version   "1.00"
#property strict

// Входные параметры
input color TextColor = clrGold; // Цвет текста
input int FontSize = 30; // Размер шрифта
input string FontName = "Monotype Corsiva"; // Название шрифта

// Переменные
double Balance, Equity, Profit;

//+------------------------------------------------------------------+
//| Инициализация советника                                          |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Обновление информации на графике                                 |
//+------------------------------------------------------------------+
void OnTick()
{
   // Получение текущих значений баланса, эквити, прибыли и убытка
   Balance = AccountBalance();
   Equity = AccountEquity();
   Profit = Equity - Balance;
   

   // Формирование строки с информацией
   string info = "Balance: " + DoubleToStr(Balance, 2) + "\n" +
                 "Equity: " + DoubleToStr(Equity, 2) + "\n" +
                 "Profit: " + DoubleToStr(Profit, 2);

   // Вывод информации на график
   Comment(info);
   ObjectCreate("InfoDisplay", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("InfoDisplay", info, FontSize, FontName, TextColor);
   ObjectSet("InfoDisplay", OBJPROP_CORNER, 0);
   ObjectSet("InfoDisplay", OBJPROP_XDISTANCE, 600);
   ObjectSet("InfoDisplay", OBJPROP_YDISTANCE, 0);
}

//+------------------------------------------------------------------+
//| Удаление объектов при закрытии советника                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectDelete("InfoDisplay");
}
