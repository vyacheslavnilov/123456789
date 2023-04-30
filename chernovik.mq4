void OnTick()
{
    // Получаем информацию об открытых ордерах
    int ordersTotal = OrdersTotal();
    for (int i = 0; i < ordersTotal; i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            // Проверяем, является ли ордер открытым и имеет ли он уровень тейк профита
            if (OrderType() == OP_BUY && OrderProfit() == 0 && OrderTakeProfit() > 0)
            {
                // Вычисляем количество пунктов от цены открытия до уровня тейк профита
                double pips = (OrderTakeProfit() - OrderOpenPrice()) / Point;
                // Записываем информацию в журнал
                Print("Открыт ордер на покупку. Количество пунктов до TP: ", pips);
            }
            else if (OrderType() == OP_SELL && OrderProfit() == 0 && OrderTakeProfit() > 0)
            {
                // Вычисляем количество пунктов от цены открытия до уровня тейк профита
                double pips1 = (OrderOpenPrice() - OrderTakeProfit()) / Point;
                // Записываем информацию в журнал
                Print("Открыт ордер на продажу. Количество пунктов до TP: ", pips1);
            }
        }
    }
}
