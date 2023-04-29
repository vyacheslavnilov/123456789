//+------------------------------------------------------------------+
//|                                             Линия стремления.mq4 |
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

//+------------------------------------------------------------------+
//| Глобальные переменные                                           |
//+------------------------------------------------------------------+

double price; // цена ask
double distance; // расстояние от линии "Подъём" до значения цены ask
int magic = 1230; // magic number для ордера
double takeProfit; // уровень тейк профита
double Balance, Equity, Profit;

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

//+------------------------------------------------------------------+
//| Основная функция start()                                         |
//+------------------------------------------------------------------+

void start()
{
   // ищем горизонтальную линию на графике с именем "Подъём"
   int line = ObjectFind("Подъём");

   // если линия не найдена, повторяем поиск
   if(line == -1)
   {
      Print("Линия не найдена");
      return;
   }

   // если линия найдена, записываем округленное значение до 0.0000 в журнал
   double level = ObjectGetDouble(0, "Подъём", OBJPROP_PRICE1);
   Print("Уровень линии: ", DoubleToString(level, 4));

   // измеряем расстояние от линии "Подъём" до значения цены ask
   price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   distance = MathAbs(price - level);

   // записываем полученное значение в журнал
   Print("Расстояние от линии до цены ask: ", DoubleToString(distance*10000, 4));

   // определяем положение линии относительно цены ask и записываем в журнал
   if(level > price)
   {
      Print("Линия находится выше цены ask");
   }
   else if(level < price)
   {
      Print("Линия находится ниже цены ask");
   }
   else
   {
      Print("Линия находится на уровне цены ask");
   }

   // устанавливаем уровень тейк профита на значение линии "Подъём"
   takeProfit = level;

   // проверяем условие для открытия ордера BUY
   if(distance*10000 >= 100)
   {
      // отправляем ордер BUY лотом 0.1 в рынок и присваиваем magic 1230
      double stopLoss = price - distance*100; // СТОП ЛОСС
      int ticket = OrderSend(_Symbol, OP_BUY, 0.1, price, 3, stopLoss, takeProfit, "Линия стремления", magic, 0, Green);
      
      // проверяем, был ли приказ выполнен
      if(ticket > 0)
      {
         Print("Ордер BUY успешно отправлен. Номер ордера: ", ticket);
      }
      else
      {
         Print("Ошибка при отправке ордера BUY. Код ошибки: ", GetLastError());
         return;
      }
   }
 }
