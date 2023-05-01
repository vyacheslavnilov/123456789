//+------------------------------------------------------------------+
//|                                             Линия стремления.mq4 |
//|                                        Написано в MetaEditor 5.0 |
//|                                            Автор: Вячеслав Нилов |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Forex Tester Software Inc."
#property link      "vyacheslavnilov@gmail.com"
#property version   "1.00"
#property strict
//______________________________________________________________________//
//                                                                      //
extern string lineName = "Линия Стремления"; // имя горизонтальной линии
extern int distance = 1000; // дистанция от цены до линии в пунктах
input double   LotsPercent = 0.01;        //процент от депозита (-1 отключено)

void ModifyTakeProfit() {
    double line = iCustom(NULL, 0, "lineName", 0, 0);
    double tp, sl;
    int ticket;
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderType() == OP_SELL) {
                tp = OrderTakeProfit();
                if (tp != 0 && line - tp > 101) {
                    sl = OrderStopLoss();
                    ticket = OrderTicket();
                    if (OrderModify(ticket, OrderOpenPrice(), NormalizeDouble(line, Digits), sl, 0, Green)) {
                        Print("Modified SELL order ", ticket, " TP to ", line);
                    }
                }
            } else if (OrderType() == OP_BUY) {
                tp = OrderTakeProfit();
                if (tp != 0 && tp - line > 101) {
                    sl = OrderStopLoss();
                    ticket = OrderTicket();
                    if (OrderModify(ticket, OrderOpenPrice(), NormalizeDouble(line, Digits), sl, 0, Green)) {
                        Print("Modified BUY order ", ticket, " TP to ", line);
                    }
                }
            }
        }
    }
}

void OnTick()
{
    double currentPrice = MarketInfo(Symbol(), MODE_BID); // текущая цена
    double linePrice = ObjectGetDouble(0, lineName, OBJPROP_PRICE1); // цена линии
    if (linePrice != 0) // если линия найдена
    {
        bool buyFound = false;
    bool sellFound = false;
    for (int i = 0; i < OrdersTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if (OrderType() == OP_BUY)
            {
                buyFound = true;
            }
            else if (OrderType() == OP_SELL)
            {
                sellFound = true;
            }
        }
    }
    if (buyFound)
    {
        Print("Найден BUY");
    }
    else
    {
        Print("BUY не найден");
    }

    if (sellFound)
    {
        Print("Найден SELL");
    }
    else
    {
        Print("SELL не найден");
    }
        double distanceToLine = MathAbs(currentPrice - linePrice) / Point; // расстояние до линии в пунктах
        if (distanceToLine >= distance) // если расстояние больше или равно заданной дистанции
        {
            if (linePrice < currentPrice) // если линия ниже цены
            {
                Print("Линия Ниже Цены");
                if (!sellFound) // если SELL не найден
{
    int ticket = OrderSend(Symbol(), OP_SELL, LotsPercent * AccountBalance() / 10000, currentPrice, 30, 0, linePrice, "Sell order", 0, 0, Red);
    if (ticket > 0) // проверка успешного открытия ордера
    {
        Print("Ордер на Продажу открыт. Номер ордера: ", ticket);
    }
    else // если открытие ордера не удалось
    {
        Print("Ошибка открытия ордера на покупку. Код ошибки: ", GetLastError());
    }
}
else
{
    Print("SELL уже открыт");
}
            }
            else // если линия выше цены
            {
                Print("Линия Выше Цены");
                if (!buyFound) // если BUY не найден
{
    int ticket = OrderSend(Symbol(), OP_BUY, LotsPercent * AccountBalance() / 10000, currentPrice, 30, 0, linePrice, "Buy order", 0, 0, Green);
    if (ticket > 0) // проверка успешного открытия ордера
    {
        Print("Ордер на покупку открыт. Номер ордера: ", ticket);
    }
    else // если открытие ордера не удалось
    {
        Print("Ошибка открытия ордера на покупку. Код ошибки: ", GetLastError());
    }
}
else
{
    Print("BUY уже открыт");
}
            }
            Comment("Дистанция: ", distanceToLine);
        }
    }
    else // если линия не найдена
    {
        Print("Линия не найдена");
    }
}

//Советник работает следующим образом:

//1. В начале функции OnTick() получаем текущую цену и ищем линию по заданному имени с помощью функции ObjectFind().
//2. Если линия найдена, получаем её цену с помощью функции ObjectGetDouble() и вычисляем расстояние до неё в пунктах.
//3. Если расстояние больше или равно заданной дистанции, определяем положение линии относительно текущей цены и делаем соответствующую запись с помощью функции Comment().
//4. Если линия не найдена, делаем запись в журнал "Линия не найдена"
//5. Выставляет ордер в рынок, SELL если линия ние цены, BUY если линия выше цены, на заданное расстояние
//6. Устанавливает Тэйк Профит на ордер по значению линии
//7. Устанавливает запрет на работу функций OrderSend() если ордер данного типа уже есть в рынке
