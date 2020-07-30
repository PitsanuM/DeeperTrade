//+------------------------------------------------------------------+
//|                                                   CSV Writer.mq4 |
//|                                                      DeeperTrade |
//|                                      https://www.deepertrade.com |
//+------------------------------------------------------------------+
#property copyright "DeeperTrade"
#property link      "https://www.deepertrade.com"
#property version   "1.00"
#property strict

input string Filename = "S50IF.csv";
input string Folder = "Data";
input int Lenght = 500;

datetime          time[];
double            open[];
double            high[];
double            low[];
double            close[];
long               volume[];

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

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   write_to_file();
  }
//+------------------------------------------------------------------+
void write_to_file()
  {
//---
   ResetLastError();
//Copy time,open,high,low,close
   if(CopyTime(NULL,PERIOD_CURRENT,0,Lenght,time)<=0)
     {
      PrintFormat("Failed to copy time values. Error code = %d",GetLastError());
      return;
     }
   if(CopyOpen(NULL,PERIOD_CURRENT,0,Lenght,open)<=0)
     {
      PrintFormat("Failed to copy open values. Error code = %d",GetLastError());
      return;
     }
   if(CopyHigh(NULL,PERIOD_CURRENT,0,Lenght,high)<=0)
     {
      PrintFormat("Failed to copy high values. Error code = %d",GetLastError());
      return;
     }
   if(CopyLow(NULL,PERIOD_CURRENT,0,Lenght,low)<=0)
     {
      PrintFormat("Failed to copy low values. Error code = %d",GetLastError());
      return;
     }
   if(CopyClose(NULL,PERIOD_CURRENT,0,Lenght,close)<=0)
     {
      PrintFormat("Failed to copy close values. Error code = %d",GetLastError());
      return;
     }
   if(CopyTickVolume(NULL,PERIOD_CURRENT,0,Lenght,volume)<=0)
     {
      PrintFormat("Failed to copy close values. Error code = %d",GetLastError());
      return;
     }
//Write to file
   int file_handle=FileOpen(Folder+"//"+Filename,FILE_WRITE|FILE_CSV);
   if(file_handle!=INVALID_HANDLE)
     {
      PrintFormat("%s file is available for writing",Filename);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- first, write the number of signals
      FileWrite(file_handle,"time,open,high,low,close,volume");
      //--- write the time and values of signals to the file
      for(int i=0; i<ArraySize(time); i++)
         FileWrite(file_handle,TimeToStr(time[i],TIME_DATE|TIME_MINUTES)+","+DoubleToStr(open[i],Digits)+","+DoubleToStr(high[i],Digits)+","+DoubleToStr(low[i],Digits)+","+DoubleToStr(close[i],Digits)+","+IntegerToString(volume[i],Digits));
      //--- close the file
      FileClose(file_handle);
     }
   else
      PrintFormat("Failed to open %s file, Error code = %d",Filename,GetLastError());
  }
//+------------------------------------------------------------------+
