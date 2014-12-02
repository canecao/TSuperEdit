unit uTelefoneAndroid;

interface


procedure EnviarSMS(pNumero, pMensagem: string);
function PegaNumeroTelefone: String;
procedure EnviarNotificacao(pNome, pCorpo : String; pHora : TTime);
implementation
 {$IFDEF ANDROID}
uses

  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Telephony,
  Androidapi.Helpers,

  Androidapi.JNIBridge,
  Androidapi.JNI.GraphicsContentViewText, FMX.Notification;
 {$ENDIF}
procedure EnviarSMS(pNumero, pMensagem: string);
 {$IFDEF ANDROID}
var
  GerenciadorSMS: JSmsManager; {$ENDIF}
begin
 {$IFDEF ANDROID}
  GerenciadorSMS := TJSmsManager.JavaClass.getDefault;
  GerenciadorSMS.sendTextMessage(StringToJString(pNumero), nil, StringToJString(pMensagem), nil, nil)
{$ENDIF}
end;

function PegaNumeroTelefone: String;
 {$IFDEF ANDROID}
var
  TTelMgr: JTelephonyManager;   {$ENDIF}
begin
 {$IFDEF ANDROID}
  TTelMgr := TJTelephonyManager.Wrap ((SharedActivityContext.getSystemService(TJContext.JavaClass.TELEPHONY_SERVICE) as ILocalObject).GetObjectID);
  Result := JStringToString(TTelMgr.getLine1Number);
 {$ENDIF}
 end;

procedure EnviarNotificacao(pNome, pCorpo : String; pHora : TTime);
 {$IFDEF ANDROID}
var   Notification: TNotification;
      NotificationC : TNotificationCenter;  {$ENDIF}
begin
  {$IFDEF ANDROID}
  { verify if the service is actually supported }
  NotificationC := TNotificationCenter.Create(nil);
  if NotificationC.Supported then
  begin
    Notification := NotificationC.CreateNotification;
    try
      Notification.Name := pNome;
      Notification.AlertBody := pCorpo;
      Notification.FireDate := pHora;

      { Send notification in Notification Center }
      NotificationC.ScheduleNotification(Notification);
      { also this method is equivalent }
      // NotificationService.PresentNotification(Notification);
    finally
      Notification.DisposeOf;
      NotificationC.DisposeOf;
    end;
  end;               {$ENDIF}
end;

end.

