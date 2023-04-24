// объявление переменных
double lotSize; // размер лота
double startLotSize; // изначальный размер лота
double balance; // текущий баланс
double percent; // процент от текущего баланса для установки изначального размера лота
double upLevel; // уровень линии "UP"
double downLevel; // уровень линии "DOWN"
double lastUpLevel; // последний уровень линии "UP"
double lastDownLevel; // последний уровень линии "DOWN"
bool upOrderOpened = false; // флаг открытия ордера по линии "UP"
bool downOrderOpened = false; // флаг открытия ордера по линии "DOWN"
int upOrderTicket; // номер ордера по линии "UP"
int downOrderTicket; // номер ордера по линии "DOWN"

// функция для расчета размера лота
void calculateLotSize() {
    balance = AccountBalance();
    lotSize = NormalizeDouble(balance * percent / 100 / MarketInfo(Symbol(), MODE_TICKSIZE), 2);
}

// функция для открытия ордера BUY
void openBuyOrder() {
    double stopLoss = downLevel;
    double takeProfit = upLevel - downLevel;
    int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stopLoss, Ask + takeProfit, "Buy Order", MagicNumber, 0, Green);
    if (ticket > 0) {
        upOrderOpened = true;
        upOrderTicket = ticket;
    }
}

// функция для открытия ордера SELL
void openSellOrder() {
    double stopLoss = upLevel;
    double takeProfit = upLevel - downLevel;
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
        calculateLotSize();
    } else if (profit < 0) {
        OrderClose(ticket, lotSize, Ask, 3, Red);
        openSellOrder();
    }
}

// функция для обновления уровней линий
void updateLevels() {
    lastUpLevel = upLevel;
    lastDownLevel = downLevel;
    upLevel = ObjectGetDouble(0, "UP", OBJ_PRICE1);
    downLevel = ObjectGetDouble(0, "DOWN", OBJ_PRICE1);
}

// функция для проверки условий открытия ордера
void checkOpenOrderConditions() {
    if (!upOrderOpened && Bid > upLevel && (upLevel - lastUpLevel > 17 || downOrderOpened && OrderProfit(downOrderTicket) > 0)) {
        openBuyOrder();
    } else if (!downOrderOpened && Ask < downLevel && (lastDownLevel - downLevel > 17 || upOrderOpened && OrderProfit(upOrderTicket) > 0)) {
        openSellOrder();
    }
}

// функция для проверки условий закрытия ордера
void checkCloseOrderConditions() {
    if (upOrderOpened && Bid > upLevel + 17 && OrderProfit(upOrderTicket) > 0) {
        closeOrder(upOrderTicket);
        upOrderOpened = false;
    } else if (downOrderOpened && Ask < downLevel - 17 && OrderProfit(downOrderTicket) > 0) {
        closeOrder(downOrderTicket);
        downOrderOpened = false;
    }
}

// функция для обработки событий
void OnTick() {
    updateLevels();
    checkOpenOrderConditions();
    checkCloseOrderConditions();
}

// функция для инициализации советника/эксперта
void OnInit() {
    percent = 5; // установка процента от текущего баланса для установки изначального размера лота
    calculateLotSize();
    startLotSize = lotSize;
    upLevel = ObjectGetDouble(0, "UP", OBJ_PRICE1);
    downLevel = ObjectGetDouble(0, "DOWN", OBJ_PRICE1);
}
