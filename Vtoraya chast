// объявление переменных
double lotSize;
double startLotSize;
double balance;
double percentRisk;
double upLine;
double downLine;
double lastUpLine;
double lastDownLine;
double lastOrderPrice;
double lastOrderType;
double lastOrderProfit;
bool orderOpened;

// инициализация переменных
void OnInit()
{
    // установка размера стартового лота в процентах от текущего баланса
    percentRisk = 2;
    balance = AccountBalance();
    startLotSize = NormalizeDouble(balance * percentRisk / 100 / MarketInfo(Symbol(), MODE_TICKSIZE), 2);
    lotSize = startLotSize;
    // установка значений линий
    upLine = ObjectGet("UP", OBJ_PRICE1);
    downLine = ObjectGet("DOWN", OBJ_PRICE1);
    lastUpLine = upLine;
    lastDownLine = downLine;
    // инициализация переменных
    lastOrderPrice = 0;
    lastOrderType = 0;
    lastOrderProfit = 0;
    orderOpened = false;
}

// функция для выставления ордера
void OpenOrder(int type, double price, double stopLoss)
{
    // выставление ордера
    int ticket = OrderSend(Symbol(), type, lotSize, price, 0, stopLoss, 0, "", 0, 0, Green);
    if(ticket > 0)
    {
        // сохранение информации о последнем ордере
        lastOrderPrice = price;
        lastOrderType = type;
        lastOrderProfit = 0;
        orderOpened = true;
    }
}

// функция для закрытия ордера
void CloseOrder()
{
    // закрытие ордера
    bool result = OrderClose(OrderTicket(), OrderLots(), Bid, 0, Red);
    if(result)
    {
        // обнуление переменных
        lastOrderPrice = 0;
        lastOrderType = 0;
        lastOrderProfit = 0;
        orderOpened = false;
        // установка размера лота в исходное состояние
        lotSize = startLotSize;
    }
}

// функция для установки stop loss и take profit
void SetStopLossTakeProfit(double stopLoss, double takeProfit)
{
    // установка stop loss и take profit
    bool result = OrderModify(OrderTicket(), OrderOpenPrice(), stopLoss, takeProfit, 0, Green);
    if(result)
    {
        // сохранение информации о последнем ордере
        lastOrderProfit = takeProfit - OrderOpenPrice();
    }
}

// основная функция
void OnTick()
{
    // получение значений линий
    upLine = ObjectGet("UP", OBJ_PRICE1);
    downLine = ObjectGet("DOWN", OBJ_PRICE1);
    // проверка на изменение значений линий
    if(MathAbs(upLine - lastUpLine) > 17 || MathAbs(downLine - lastDownLine) > 17)
    {
        // закрытие ордера, если он открыт
        if(orderOpened)
        {
            CloseOrder();
        }
    }
    // проверка на пересечение линии "UP"
    if(Bid > upLine && lastOrderType != OP_BUY && !orderOpened)
    {
        // выставление ордера BUY
        double stopLoss = downLine;
        OpenOrder(OP_BUY, Ask, stopLoss);
    }
    // проверка на пересечение линии "DOWN"
    if(Bid < downLine && lastOrderType != OP_SELL && !orderOpened)
    {
        // выставление ордера SELL
        double stopLoss = upLine;
        OpenOrder(OP_SELL, Bid, stopLoss);
    }
    // проверка на закрытие ордера по take profit
    if(orderOpened && lastOrderProfit > 0)
    {
        double takeProfit = lastOrderPrice + (upLine - downLine);
        SetStopLossTakeProfit(lastOrderPrice, takeProfit);
        CloseOrder();
        // увеличение размера лота в 2 раза
        lotSize *= 2;
    }
    // сохранение значений линий
    lastUpLine = upLine;
    lastDownLine = downLine;
}
double stopLoss;
double takeProfit;
int magicNumber = 12345;

// функция инициализации
int init()
{
    // установка размера лота
    lotSize = NormalizeDouble(AccountBalance() * 0.01 / 1000, 2);
    startLotSize = lotSize;
    
    // установка параметров стоп-лосса и тейк-профита
    stopLoss = 100;
    takeProfit = 200;
    
    return(0);
}

// функция для открытия ордера
void openOrder(int type)
{
    // расчет цены открытия ордера
    double price = 0;
    if(type == OP_BUY)
    {
        price = Ask;
    }
    else if(type == OP_SELL)
    {
        price = Bid;
    }
    
    // расчет размера лота
    lotSize = NormalizeDouble(startLotSize * (AccountBalance() / 1000), 2);
    
    // открытие ордера
    int ticket = OrderSend(Symbol(), type, lotSize, price, 0, stopLoss, takeProfit, "Expert Advisor", magicNumber, 0, Blue);
    
    // проверка на успешное открытие ордера
    if(ticket > 0)
    {
        Print("Order opened successfully");
    }
    else
    {
        Print("Error opening order: ", GetLastError());
    }
}

// функция для закрытия ордера
void closeOrder(int ticket)
{
    // закрытие ордера
    bool result = OrderClose(ticket, lotSize, Bid, 0, Red);
    
    // проверка на успешное закрытие ордера
    if(result)
    {
        Print("Order closed successfully");
    }
    else
    {
        Print("Error closing order: ", GetLastError());
    }
}

// функция для обработки событий
void OnTick()
{
    // проверка на наличие открытых ордеров
    int orders = OrdersTotal();
    if(orders == 0)
    {
        // открытие ордера на покупку
        openOrder(OP_BUY);
    }
    else
    {
        // проверка на наличие открытых ордеров с магическим номером
        for(int i = 0; i < orders; i++)
        {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
                if(OrderMagicNumber() == magicNumber)
                {
                    // закрытие ордера на продажу
                    closeOrder(OrderTicket());
                    
                    // открытие ордера на покупку
                    openOrder(OP_BUY);
                }
            }
        }
    }
}
