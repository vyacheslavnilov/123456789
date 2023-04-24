// объявление переменных
double lotSize; // размер лота
double bal; // баланс
double startLotSize; // изначальный размер лота
double upLine; // уровень линии "UP"
double downLine; // уровень линии "DOWN"
bool upOrderOpened = false; // флаг открытия ордера по линии "UP"
bool downOrderOpened = false; // флаг открытия ордера по линии "DOWN"
int upOrderTicket; // номер ордера по линии "UP"
int downOrderTicket; // номер ордера по линии "DOWN"

// функция для расчета размера лота
void calculateLotSize() {
    balance = AccountBalance();
    lotSize = NormalizeDouble(balance * startLotSize / 100 / MarketInfo(Symbol(), MODE_TICKSIZE), 2);
}

// функция для открытия ордера BUY
void openBuyOrder() {
    double stopLoss = downLine;
    double takeProfit = upLine - downLine;
    int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stopLoss, Ask + takeProfit, "Buy Order", MagicNumber, 0, Green);
    if (ticket > 0) {
        upOrderOpened = true;
        upOrderTicket = ticket;
    }
}

// функция для открытия ордера SELL
void openSellOrder() {
    double stopLoss = upLine;
    double takeProfit = upLine - downLine;
    int ticket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, 3, stopLoss, Bid - takeProfit, "Sell Order", MagicNumber, 0, Red);
    if (ticket > 0) {
        downOrderOpened = true;
        downOrderTicket = ticket;
    }
}

// функция для закрытия ордера
void closeOrder(int ticket) {
    double profit = OrderProfit();
    if (profit > 0) {
        OrderClose(ticket, lotSize, Bid, 3, Green);
        upOrderOpened = false;
        downOrderOpened = false;
        lotSize = startLotSize;
    }
}

// функция для обработки сигналов
void OnTick() {
    double currentPrice = MarketInfo(Symbol(), MODE_BID);
    double upLineDistance = MathAbs(upLine - OrderOpenPrice(upOrderTicket));
    double downLineDistance = MathAbs(downLine - OrderOpenPrice(downOrderTicket));
    if (!upOrderOpened && currentPrice > upLine) {
        openBuyOrder();
    } else if (!downOrderOpened && currentPrice < downLine) {
        openSellOrder();
    } else if (upOrderOpened && upLineDistance > 17 && OrderProfit(upOrderTicket) > 0) {
        closeOrder(upOrderTicket);
    } else if (downOrderOpened && downLineDistance > 17 && OrderProfit(downOrderTicket) > 0) {
        closeOrder(downOrderTicket);
    } else if (upOrderOpened && currentPrice < downLine) {
        OrderClose(upOrderTicket, lotSize, Bid, 3, Red);
        openSellOrder();
        lotSize *= 2;
    } else if (downOrderOpened && currentPrice > upLine) {
        OrderClose(downOrderTicket, lotSize, Ask, 3, Green);
        openBuyOrder();
        lotSize *= 2;
    }
}

// функция для инициализации
void OnInit() {
    startLotSize = 0.01; // изначальный размер лота в процентах от текущего баланса
    calculateLotSize();
    upLine = ObjectGet("UP", OBJ_PRICE1);
    downLine = ObjectGet("DOWN", OBJ_PRICE1);
}
