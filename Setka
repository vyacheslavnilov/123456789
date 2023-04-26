//+------------------------------------------------------------------+
//|                                  Мой Первый Код_Аккаунт инфо.mq4 |
//|                                         Написано в MetaEditor 5.0|
//|                                            Автор: Вячеслав Нилов |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Forex Tester Software Inc."
#property link      "vyacheslavnilov@gmail.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectsDeleteAll(ChartID(), panel_prefix);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

double last_price = 0;

void OnTick()
  {
//---
   
   
   if(!special_line_fun&&(AccountEquity()-AccountBalance())/AccountBalance()*100>=TPinPercents&&(magics_to_work_on_profit==0||magics_to_work_on_profit<=ArraySize(magics_now))){
      close_all_ords();
   }
   else{
      set_magics_now();
      set_lines();
      main_fun();
      panel();
   }
   
   last_price = Close[0];
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      
      for(int i = 0; i<ArraySize(magics_panel); i++){
         if(sparam==panel_prefix+"button "+IntegerToString(magics_panel[i])){
            close_all_ords(magics_panel[i]);
         }
      }
      if(sparam==panel_prefix+"button "+"Все"){
            close_all_ords(-1);
         }
      
      
      
     }
  }
//+------------------------------------------------------------------+

void close_all_ords(int magic = -1){
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||OrderSymbol()!=_Symbol||(magic!=-1&&OrderMagicNumber()!=magic)) continue;
      int k = 0;
      if(OrderType()>1){
         while(!OrderDelete(OrderTicket())&&k<5){
            Sleep(100);
            k++;
         }
      }
      else{
         closeord(OrderTicket());
      }
   }
   if(magic>0)
      total_ords_of_mag[magic] = 0;
   else
      ArrayResize(total_ords_of_mag, 0);
}

void closeord(int ticket){
   if(ticket==-1)
      return;
   if(!OrderSelect(ticket,SELECT_BY_TICKET)||OrderSymbol()!=_Symbol) return;
   double pr = 0;
   color cl_cl = clrNONE;
   if(OrderType()==OP_BUY){
    pr = MarketInfo(OrderSymbol(), MODE_BID);
    cl_cl = clrDarkBlue;
   }
   else{
    pr = MarketInfo(OrderSymbol(), MODE_ASK);
    cl_cl = clrDarkRed;
   }
   int k=0;
   while(!OrderClose(OrderTicket(), OrderLots(), pr, 10, cl_cl)&&k<5){
    Sleep(100);
    k++;
   }
}

extern string prefix = ""; //Префикс

extern bool special_line_fun = false;//Открытие только по специальной линии
extern string special_line_prefix = "";//Префикс специальной линии
extern int special_line_dist = 100;//Отступ для специальной линии

extern double Lot = 0.001; //Процент от депо для лота

extern double TPinPercentsOfDepo = 1; //Тейкпрофит в процентах для магика
extern double TPinPercents = 5; //Тейкпрофит в процентах на аккаунт

extern int magics_to_work_on_profit = 3;//Кол-во магиков для работы от общего профита

extern int WebExtender = 2;//Увеличение сетки за ордер
extern int OrdersStep = 30; //Шаг сетки

extern int ExternalStep = 5;//Увеличение шага сетки

extern int BarsAfterLastMagic = 10; //Бары после последнего магика

datetime last_magic_time = 0;

int total_ords_of_mag[];

int total_ords = 0;

void main_fun(){
   
   
   if(ArraySize(magics_now)>0)
      ArrayResize(total_ords_of_mag, magics_now[ArraySize(magics_now)-1]+1);
   else{
      last_magic_time=0;
   }
   
   for(int i = 0; i<ArraySize(magics_now); i++){
      datetime first_time = get_first_order_open_time(magics_now[i]);
      if(last_magic_time<first_time)
         last_magic_time=first_time;
      
      //web part
      int orders_buy = get_number_of_orders(magics_now[i], OP_BUY);
      int orders_sell = get_number_of_orders(magics_now[i], OP_SELL);
      
      int orders_buy_stop = get_number_of_orders(magics_now[i], OP_BUYSTOP);
      int orders_sell_stop = get_number_of_orders(magics_now[i], OP_SELLSTOP);
      
      
      if(orders_buy>0||orders_sell>0){
         if(orders_buy*WebExtender>orders_sell_stop+orders_sell){
            int ords_to_set = orders_buy*WebExtender-orders_sell_stop-orders_sell;
            double edge_price = get_price_edge_order(magics_now[i], OP_SELLSTOP, -1);
            if(edge_price==0)
               edge_price = get_price_edge_order(magics_now[i], OP_SELL, -1);
            if(edge_price==0)
               edge_price = get_price_edge_order(magics_now[i], OP_BUY, -1);
            for(int j = 0; j<ords_to_set; j++){
               double lot  = get_order_lot(magics_now[i]);
               //Print(orders_sell_stop+orders_sell+j);
               edge_price = edge_price-OrdersStep*Point()-ExternalStep*Point()*(orders_sell_stop+orders_sell+j);
               ordsendSTOP(-1, magics_now[i], "", edge_price, lot);
               
            }
         }
         
         if(orders_sell*WebExtender>orders_buy_stop+orders_buy){
            int ords_to_set = orders_sell*WebExtender-orders_buy_stop-orders_buy;
            double edge_price = get_price_edge_order(magics_now[i], OP_BUYSTOP, 1);
            if(edge_price==0)
               edge_price = get_price_edge_order(magics_now[i], OP_BUY, 1);
            if(edge_price==0)
               edge_price = get_price_edge_order(magics_now[i], OP_SELL, 1);
            for(int j = 0; j<ords_to_set; j++){
               double lot  = get_order_lot(magics_now[i]);
               //Print(orders_buy_stop+orders_buy+j);
               edge_price = edge_price+OrdersStep*Point()+ExternalStep*Point()*(orders_buy_stop+orders_buy+j);
               ordsendSTOP(1, magics_now[i], "", edge_price, lot);
            }
         }
         double BE_price = get_breakeven_price(magics_now[i]);
         //Print(BE_price);
         if(orders_buy+orders_sell>1&&(special_line_fun||magics_to_work_on_profit==0||ArraySize(magics_now)<magics_to_work_on_profit)){
            //Print("1");
            if(BE_price!=0){
               if(total_ords_of_mag[magics_now[i]]<=orders_buy+orders_sell){
                  //Print("2");
                  if(total_size>0){
                     BE_price = get_price_edge_order(magics_now[i], OP_BUYSTOP, 1);
                     if(BE_price==0)
                        BE_price = get_price_edge_order(magics_now[i], OP_BUY, 1);
                     
                     double final_price = BE_price+OrdersStep*Point();
                     set_final_price(magics_now[i], final_price, 1);
                  }
                  else{
                     BE_price = get_price_edge_order(magics_now[i], OP_SELLSTOP, -1);
                     if(BE_price==0)
                        BE_price = get_price_edge_order(magics_now[i], OP_SELL, -1);
                     
                     double final_price = BE_price-OrdersStep*Point();
                     set_final_price(magics_now[i], final_price, -1);
                     
                  }
                  total_ords_of_mag[magics_now[i]]=orders_buy+orders_sell;
                  
               }
            }
            else{
               set_zero_tp_sl(magics_now[i]);
            }
         }
         
      }
   }
   
   if(magics_to_work_on_profit!=0&&!special_line_fun){
      if(ArraySize(magics_now)>=magics_to_work_on_profit){
         if(OrdersTotal()>=total_ords){
            double BE_price = get_breakeven_price(-1);
            if(BE_price!=0){
               double tp = AccountBalance() * TPinPercents / 100 / MathAbs(total_size) / MarketInfo(_Symbol, MODE_TICKVALUE)+10;
               double napr = total_size/MathAbs(total_size);
               BE_price = BE_price + napr * tp * Point();
               set_final_price(-1, BE_price, int(napr));
            }
            else{
               set_zero_tp_sl(-1);
            }
            total_ords=OrdersTotal();
         }
      }
      else{
         total_ords=0;
      }
   }
   
   
   int l_to_check = ArraySize(line_prices);
   if(special_line_fun)
      l_to_check = ArraySize(special_line_prices);
   
   for(int i = 0; i<l_to_check; i++){
      
      
      double l_pr = 0;
      if(!special_line_fun){
         l_pr = line_prices[i];
      }
      else{
         l_pr = special_line_prices[i];
      }
      
      double dist = l_pr - last_price;
      if(dist==0)
         continue;
      int napr = int(dist/MathAbs(dist));
      
      int napr_ord = napr;
      if(special_line_fun){
         napr_ord = get_napr_for_spec_line(l_pr);
         if(napr_ord!=0)
            close_all_ords_with_opposite_first_diraction(napr_ord);
      }
      
      if(Close[0]*napr>=l_pr*napr
      &&(
      (!special_line_fun&&iBarShift(_Symbol, _Period, last_magic_time)>BarsAfterLastMagic)||
      (special_line_fun&&check_price_for_open_new_web())
      )){
         double lot = NormalizeDouble(AccountBalance() * Lot / 100, 2);
         lot = MathMax(lot , 0.01);
         double tp = AccountEquity() * TPinPercentsOfDepo / 100 / lot / MarketInfo(_Symbol, MODE_TICKVALUE);
         int mag = 1;
         if(ArraySize(magics_now)>0){
            mag = magics_now[ArraySize(magics_now)-1]+1;
         }
         
         if(ordsend(napr_ord, mag, "", lot, 0, int(tp))!=-1){
            ArrayResize(magics_now, ArraySize(magics_now)+1);
            magics_now[ArraySize(magics_now)-1] = mag;
            
            
         }
      }
      
   }
   
   
   for(int i = OrdersTotal()-1; i>=0; i--){
      if(!OrderSelect(i, SELECT_BY_POS)||OrderSymbol()!=_Symbol||OrderType()<=1) continue;
      if(!check_magic_in_array(magics_now, OrderMagicNumber())){
         if(ArraySize(total_ords_of_mag)>OrderMagicNumber())
            total_ords_of_mag[OrderMagicNumber()]=0;
         
         int k = 0;
         while(!OrderDelete(OrderTicket())&&k<5){
            Sleep(100);
            k++;
         }
      }
   }

}




double line_prices[];
double special_line_prices[];

void set_lines(){
   ArrayResize(line_prices, 0);
   ArrayResize(special_line_prices, 0);
   for(int i = ObjectsTotal()-1; i>=0; i--){
      string name = ObjectName(ChartID(),i);
      if(ObjectType(name)!=OBJ_HLINE) continue;
      if(StringFind(name, prefix)==0){
         ArrayResize(line_prices, ArraySize(line_prices)+1);
         line_prices[ArraySize(line_prices)-1]=get_line_price(name);
      }
      if(special_line_fun&&StringFind(name, special_line_prefix)==0){
         ArrayResize(special_line_prices, ArraySize(special_line_prices)+1);
         special_line_prices[ArraySize(special_line_prices)-1]=get_line_price(name);
      }
      
   }
}

int get_napr_for_spec_line(double l_pr){
   if(ArraySize(line_prices)==0) return 0;
   
   bool dn = true;
   bool up = true;
   
   for(int i = 0; i<ArraySize(line_prices); i++){
      if(line_prices[i]>l_pr)
         up = false;
      if(line_prices[i]<l_pr)
         dn = false;
   }
   if(up)
      return -1;
   if(dn)
      return 1;
   return 0;
}


void close_all_ords_with_opposite_first_diraction(int diraction){
   for(int i = ArraySize(magics_now)-1; i>=0; i--){
      if(diraction!=get_first_order_open_diraction(magics_now[i])){
         close_all_ords(magics_now[i]);
         
         
      }   
   }
}


bool check_price_for_open_new_web(){
   
   bool can_open = true;
   for(int i = ArraySize(magics_now)-1; i>=0; i--){
      
      double first_price = get_first_order_open_price(magics_now[i]);
      
      double edge_up = first_price+special_line_dist*Point();
      
      double edge_down = first_price-special_line_dist*Point();
      
      
      if(Close[0]>=edge_down&&Close[0]<=edge_up){
         can_open=false;
         break;
      }
      
   }
   
   
   return can_open;
}


int get_first_order_open_diraction(int magic){
   datetime first_time = 0;
   int first_dir = 0;
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||OrderMagicNumber()!=magic||OrderSymbol()!=_Symbol||OrderType()>1) continue;
      if(first_time==0||first_time>OrderOpenTime()){
         first_time=OrderOpenTime();
         if(OrderType()==OP_BUY)
            first_dir = 1;
         if(OrderType()==OP_SELL)
            first_dir = -1;
      }
   }
   return first_dir;
}

double get_first_order_open_price(int magic){
   datetime first_time = 0;
   double first_price = 0;
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||OrderMagicNumber()!=magic||OrderSymbol()!=_Symbol||OrderType()>1) continue;
      if(first_time==0||first_time>OrderOpenTime()){
         first_time=OrderOpenTime();
         first_price = OrderOpenPrice();
      }
   }
   return first_price;
}


datetime get_first_order_open_time(int magic){
   datetime first_time = 0;
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||OrderMagicNumber()!=magic||OrderSymbol()!=_Symbol||OrderType()>1) continue;
      if(first_time==0||first_time>OrderOpenTime()){
         first_time=OrderOpenTime();
      }
   }
   return first_time;
}

void set_zero_tp_sl(int magic){
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||(OrderMagicNumber()!=magic&&magic!=-1)||OrderSymbol()!=_Symbol) continue;
      if(OrderStopLoss()!=0||OrderTakeProfit()!=0)
         OrderModify(OrderTicket(), OrderOpenPrice(), 0, 0, 0);
   }
}

void set_final_price(int magic, double final_price, int napr){
   double accuracy = 3;
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||(OrderMagicNumber()!=magic&&magic!=-1)||OrderSymbol()!=_Symbol) continue;
      double spread = (MarketInfo(_Symbol, MODE_SPREAD)+2)*Point();
      
      if(napr==-1){
         if(OrderType()==OP_BUY||OrderType()==OP_BUYSTOP){
            if(OrderStopLoss()<final_price-spread-accuracy*Point()||OrderStopLoss()>final_price-spread+accuracy*Point()){
               //Print(OrderTicket(), " ",Close[0], " ", final_price);
               OrderModify(OrderTicket(), OrderOpenPrice(), final_price-spread, 0, 0);
            }
         }
         else if(OrderTakeProfit()<final_price-accuracy*Point()||OrderTakeProfit()>final_price+accuracy*Point()){
            OrderModify(OrderTicket(), OrderOpenPrice(), 0, final_price, 0);
         }   
      }
      else{
         if(OrderType()==OP_BUY||OrderType()==OP_BUYSTOP){
            if(OrderTakeProfit()<final_price-accuracy*Point()||OrderTakeProfit()>final_price+accuracy*Point()){
               OrderModify(OrderTicket(), OrderOpenPrice(), 0, final_price, 0);
            }   
         }
         else if(OrderStopLoss()<final_price+spread-accuracy*Point()||OrderStopLoss()>final_price+spread+accuracy*Point()){
            OrderModify(OrderTicket(), OrderOpenPrice(), final_price+spread, 0, 0);
         }   
      }
      
   }
}

double total_size = 0;
double get_breakeven_price(int magic, int pendings=0){

   double BE_Price = 0;
   double Total_Size = 0;
   
   for (int i = 0; i < OrdersTotal(); i++)
      {
       if (OrderSelect (i, SELECT_BY_POS, MODE_TRADES)&&OrderSymbol() == Symbol() && (magic==-1 || OrderMagicNumber() == magic))
         {
          if(pendings==1 && OrderType() == OP_BUYSTOP){
            BE_Price += OrderOpenPrice()*OrderLots();
            Total_Size += OrderLots();
          }
          
          if(pendings==-1 && OrderType() == OP_SELLSTOP){
            BE_Price -= OrderOpenPrice()*OrderLots();
            Total_Size -= OrderLots();
          }
          
          if (OrderType() == OP_BUY)
            {
             BE_Price += OrderOpenPrice()*OrderLots();
             Total_Size += OrderLots();
            }
          if (OrderType() == OP_SELL)
            {
             BE_Price -= OrderOpenPrice()*OrderLots();
             Total_Size -= OrderLots();
            }
        }
   }
   
   total_size=Total_Size;
   if(Total_Size==0)
      return 0;
   BE_Price/=Total_Size;
   return BE_Price;
}

double get_price_edge_order(int magic, int order_type, int napr_of_edge){
   double edge_price =0;
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||OrderMagicNumber()!=magic||OrderSymbol()!=_Symbol||OrderType()!=order_type) continue;
      if(edge_price==0||(edge_price*napr_of_edge<OrderOpenPrice()*napr_of_edge)){
         edge_price=OrderOpenPrice();
      }
   }
   return edge_price;
}

int get_number_of_orders(int magic, int order_type){
   int k =0;
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||OrderMagicNumber()!=magic||OrderSymbol()!=_Symbol||OrderType()!=order_type) continue;
      k++;
   }
   return k;
}

double get_order_lot(int magic){
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||OrderMagicNumber()!=magic||OrderSymbol()!=_Symbol) continue;
      return OrderLots();
   }
   return 0.01;
}

int get_order_ticket(int magic){
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||OrderMagicNumber()!=magic||OrderSymbol()!=_Symbol) continue;
      return OrderTicket();
   }
   return -1;
}

double get_line_price(string line_name){
   if(ObjectFind(ChartID(), line_name)>-1){
      return ObjectGetDouble(ChartID(), line_name, OBJPROP_PRICE1);
   }
   return 0;
}

int ordsend(int b_or_s, int magic, string comment, double lot_=0.01, int sl =0,int tp = 0){
   
   int ticket=-1;
   
   if(b_or_s==1){
      double stl =0,tap=0;
      if(sl!=0)
         stl=Ask-sl*_Point;
      if(tp!=0)
         tap=Ask+tp*_Point;
      ticket = OrderSend(_Symbol, OP_BUY, NormalizeDouble(lot_, 2), Ask, 5, stl, tap, comment, magic, 0, clrBlue);
      if(ticket == -1) Print("Ошибка открытия ордера:", GetLastError());
   }
   else{
      double stl =0,tap=0;
      if(sl!=0)
         stl=Bid+sl*_Point;
      if(tp!=0)
         tap=Bid-tp*_Point;
      ticket=OrderSend(_Symbol, OP_SELL, NormalizeDouble(lot_, 2), Bid, 5, stl, tap, comment, magic, 0, clrRed);
      if(ticket == -1) Print("Ошибка открытия ордера:", GetLastError());
   }
   return ticket;
}

void kill_all_stops(int magic){
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||OrderMagicNumber()!=magic||OrderSymbol()!=_Symbol||OrderType()<=1) continue;
      int k = 0;
      while(!OrderDelete(OrderTicket())&&k<5){
         Sleep(100);
         k++;
      }
   }
}

int ordsendSTOP(int b_or_s, int magic, string comment, double price, double lot_=0.01, int sl =0,int tp = 0){
   
   int ticket=-1;
   
   if(b_or_s==1){
      double stl =0,tap=0;
      if(sl!=0)
         stl=price-sl*_Point;
      if(tp!=0)
         tap=price+tp*_Point;
      ticket = OrderSend(_Symbol, OP_BUYSTOP, NormalizeDouble(lot_, 2), price, 5, stl, tap, comment, magic, 0, clrBlue);
      if(ticket == -1) Print("Ошибка открытия ордера:", GetLastError());
   }
   else{
      double stl =0,tap=0;
      if(sl!=0)
         stl=price+sl*_Point;
      if(tp!=0)
         tap=price-tp*_Point;
      ticket=OrderSend(_Symbol, OP_SELLSTOP, NormalizeDouble(lot_, 2), price, 5, stl, tap, comment, magic, 0, clrRed);
      if(ticket == -1) Print("Ошибка открытия ордера:", GetLastError());
   }
   return ticket;
}
int max_size = 0;
int magics_panel[];
int magics_now[];
string panel_prefix = "WebOfOrdExp ";

bool check_magic_in_array(int &array[], int magic){
   for(int i = ArraySize(array)-1; i>=0; i--){
      if(array[i]==magic)
         return true;
   }
   return false;
}


void set_magics_now(){
   ArrayResize(magics_now, 0);
   for(int i = OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS)||OrderSymbol()!=_Symbol||OrderType()>1) continue;
      if(!check_magic_in_array(magics_now, OrderMagicNumber())){
         ArrayResize(magics_now, ArraySize(magics_now)+1);
         magics_now[ArraySize(magics_now)-1]=OrderMagicNumber();
      }
   }
   if(ArraySize(magics_now)>0)
      ArraySort(magics_now);
}

void del_el_in_array(int &array[], int el){
   for(int i = el; i<ArraySize(array)-1; i++){
      array[i]=array[i+1];
   }
   ArrayResize(array, ArraySize(array)-1);
}

void panel(){
   
   
   for(int i = ArraySize(magics_panel)-1; i>=0; i--){
      if(!check_magic_in_array(magics_now, magics_panel[i])){
         ObjectsDeleteAll(ChartID(), panel_prefix);
         ArrayResize(magics_panel, ArraySize(magics_now));
         ArrayCopy(magics_panel, magics_now);
         break;
      }
   }
   for(int i = ArraySize(magics_now)-1; i>=0; i--){
      if(!check_magic_in_array(magics_panel, magics_now[i])){
         ObjectsDeleteAll(ChartID(), panel_prefix);
         ArrayResize(magics_panel, ArraySize(magics_now));
         ArrayCopy(magics_panel, magics_now);
         break;
      }
   }
   if(ArraySize(magics_panel)>0)
      ArraySort(magics_panel);
   for(int i =0; i<ArraySize(magics_panel); i++){
      /*set_rectangle(panel_prefix+"rect "+IntegerToString(new_magics[i]), 10, 120+22*i, 120, 20, clrBlack);
      set_text();*/
      
      ButtonCreate(panel_prefix+"button "+IntegerToString(magics_panel[i]), 10, 120+22*i, 120, 20, 0,
       IntegerToString(magics_panel[i])+" "+DoubleToStr(prof_by_mag(magics_panel[i]), 2), 10, clrBlack, clrWhite);
      
   }
   
   ButtonCreate(panel_prefix+"button "+"Все", 10, 120+22*ArraySize(magics_panel), 120, 20, 0,
       "Все"+" "+DoubleToStr(AccountEquity()-AccountBalance(), 2), 10, clrBlack, clrWhite);
}

double prof_by_mag(int magic1, int b_s_=0){
    double sum=0;
    for(int i = OrdersTotal()-1; i>=0; i--){
     if(OrderSelect(i, SELECT_BY_POS)&&OrderMagicNumber()==magic1){
        if(b_s_==0){
         sum+=OrderProfit()+OrderSwap()+OrderCommission();
        }
        if(b_s_==1&&OrderType()==OP_BUY){
         sum+=OrderProfit()+OrderSwap()+OrderCommission();
        }
        if(b_s_==-1&&OrderType()==OP_SELL){
         sum+=OrderProfit()+OrderSwap()+OrderCommission();
        }
        
     }
    }
    return sum;
}

void ButtonCreate(
                  const string            name1_="Button",            // имя кнопки 
                  const int               x=0,                      // координата по оси X 
                  const int               y=0,                      // координата по оси Y 
                  const int               width=50,                 // ширина кнопки 
                  const int               height0=18,                // высота кнопки 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                  const string            text="Button",            // текст 
                  const int               font_size=10,             // размер шрифта 
                  const color             clr=clrBlack,             // цвет текста 
                  const color             back_clr=C'236,233,216',  // цвет фона 
                  const color             border_clr=clrNONE,       // цвет границы 
                  const bool              state=false,              // нажата/отжата 
                  const bool              back=false,               // на заднем плане 
                  const bool              selection=false,          // выделить для перемещений 
                  const bool              hidden=true,              // скрыт в списке объектов 
                  const string            font="Arial",             // шрифт 
                  const long              z_order=0)                // приоритет на нажатие мышью 
  { 
//--- создадим кнопку 
   ObjectCreate(ChartID(),name1_,OBJ_BUTTON,0,0,0);
//--- установим координаты кнопки 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_YDISTANCE,y); 
//--- установим размер кнопки 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_XSIZE,width); 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_YSIZE,height0); 
//--- установим угол графика, относительно которого будут определяться координаты точки 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_CORNER,corner); 
//--- установим текст 
   ObjectSetString(ChartID(),name1_,OBJPROP_TEXT,text); 
//--- установим шрифт текста 
   ObjectSetString(ChartID(),name1_,OBJPROP_FONT,font); 
//--- установим размер шрифта 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_FONTSIZE,font_size); 
//--- установим цвет текста 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_COLOR,clr); 
//--- установим цвет фона 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_BGCOLOR,back_clr); 
//--- установим цвет границы 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_BORDER_COLOR,border_clr); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_BACK,back); 
//--- переведем кнопку в заданное состояние 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_STATE,state); 
//--- включим (true) или отключим (false) режим перемещения кнопки мышью 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(ChartID(),name1_,OBJPROP_ZORDER,z_order); 
  } 

void set_rectangle(string name1_,int x_,int y_,int xs_,int ys_,color clr_, int zord=0)
  {
   if(ObjectFind(ChartID(), name1_)<0){
   ObjectCreate(ChartID(),name1_,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_XDISTANCE,x_);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_YDISTANCE,y_);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_XSIZE,xs_);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_YSIZE,ys_);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_WIDTH,1);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_BGCOLOR,clr_);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_HIDDEN,true);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_BACK,false);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_ZORDER,zord);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_COLOR,clrCadetBlue);
   }
  }

void set_text(string name1_,int x_,int y_,string text_,int font_size_=9,color clr_=clrCadetBlue, ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT, string shrift_="Arial Black")
  {
   if(ObjectFind(ChartID(), name1_)<0){
   ObjectCreate(ChartID(),name1_,OBJ_LABEL,0,0,0);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_XDISTANCE,x_);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_YDISTANCE,y_);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_FONTSIZE,font_size_);
   ObjectSetString(ChartID(),name1_,OBJPROP_FONT,shrift_);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_HIDDEN,true);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_ZORDER,0);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_SELECTED,false);
   ObjectSetInteger(ChartID(),name1_,OBJPROP_ANCHOR,anchor); 
   }
   ObjectSetInteger(ChartID(),name1_,OBJPROP_COLOR,clr_);
   ObjectSetString(ChartID(),name1_,OBJPROP_TEXT,text_);
  }
