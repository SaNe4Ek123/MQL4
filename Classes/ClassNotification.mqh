//+------------------------------------------------------------------+
//|                                            ClassNotification.mqh |
//|                                                           Alex G |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alex G"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
class ClassNotification
  {
    public:
      bool push,
           mail,
           alert;
           
      string subject,
             message;
  
    public:
                     ClassNotification();
                    ~ClassNotification();
                bool ClassNotification::Send();
                bool ClassNotification::Send( string text );
                    
    private:  bool ClassNotification::MailSend();
              bool ClassNotification::PushSend();
              bool ClassNotification::AlertSend();
  };
  
  
//+------------------------------------------------------------------+
void ClassNotification::ClassNotification()
  {
    this.push = false;
    this.mail = false;
    this.alert = false;
    this.subject = "";
    this.message = "";
  }
  
  
//+------------------------------------------------------------------+
void ClassNotification::~ClassNotification()
  {
  }
  
  
//+------------------------------------------------------------------+
 bool ClassNotification::MailSend()
  {
    if( SendMail( this.subject, this.message ) )
      return true;
      
    return false; 
  }
  
 bool ClassNotification::PushSend()
  {
    if( SendNotification( this.message ) )
      return true;  
      
    return false; 
  }
  
bool ClassNotification::AlertSend()
  {
    Alert( this.message );
    return true;
      
  }
  
bool ClassNotification::Send()
  {
    if( !this.MailSend() )
      return false;
    if( !this.PushSend() )
      return false;
    if( !this.AlertSend() )
      return false;
      
    return true; 
  }
  
bool ClassNotification::Send( string text )
  {
    this.message = text;
    if( !this.MailSend() )
      return false;
    if( !this.PushSend() )
      return false;
    if( !this.AlertSend() )
      return false;
      
    return true; 
  }  