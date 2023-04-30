//+------------------------------------------------------------------+
//|                                             Линия стремления.mq4 |
//|                                        Написано в MetaEditor 5.0 |
//|                                            Автор: Вячеслав Нилов |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Forex Tester Software Inc."
#property link      "vyacheslavnilov@gmail.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Глобальные переменные                                           |
//+------------------------------------------------------------------+

double price; // цена ask
double distance; // расстояние от линии "Подъём" до значения цены ask
int magic = 1230; // magic number для ордера
double takeProfit; // уровень тейк профита

//+------------------------------------------------------------------+
//| Основная функция start()                                         |
//+------------------------------------------------------------------+

void start()
{
   // проверяем наличие открытых ордеров с magic number
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderMagicNumber() == magic)
         {
            Print("Есть открытый ордер с magic number ", magic);
            return;
         }
      }
   }

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
   Print("Расстояние от линии до цены ask: ", DoubleToString(distance, 4));

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
   if(distance >= 0.0100)
   {
      // отправляем ордер BUY лотом 0.1 в рынок и присваиваем magic 1230
      double stopLoss = false; // СТОП ЛОСС
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
