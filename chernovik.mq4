//+------------------------------------------------------------------+
//|                                                  chernovik.mq4 |
//|                        Copyright 2021, Vyacheslav Nilov         |
//|                                             https://github.com/vyacheslavnilov |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue

double VertexBuffer[];
double HollowBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    IndicatorShortName("Vertex and Hollow");
    SetIndexStyle(0, DRAW_LINE);
    SetIndexStyle(1, DRAW_LINE);
    SetIndexBuffer(0, VertexBuffer);
    SetIndexBuffer(1, HollowBuffer);
    SetIndexLabel(0, "Vertex");
    SetIndexLabel(1, "Hollow");
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[], const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[])
{
    int limit = rates_total - prev_calculated;
    if (limit <= 0) return(0);

    for (int i = 0; i < limit; i++)
    {
        double vertex = 0;
        double hollow = 0;
        int vertexCount = 0;
        int hollowCount = 0;

        for (int j = i; j < i + 7; j++)
        {
            if (high[j] > high[j + 1] && high[j] > high[j - 1])
            {
                vertex += high[j];
                vertexCount++;
            }
            if (low[j] < low[j + 1] && low[j] < low[j - 1])
            {
                hollow += low[j];
                hollowCount++;
            }
        }

        if (vertexCount > 0)
        {
            VertexBuffer[i] = vertex / vertexCount;
        }
        else
        {
            VertexBuffer[i] = 0;
        }

        if (hollowCount > 0)
        {
            HollowBuffer[i] = hollow / hollowCount;
        }
        else
        {
            HollowBuffer[i] = 0;
        }
    }

    return(rates_total);
}
