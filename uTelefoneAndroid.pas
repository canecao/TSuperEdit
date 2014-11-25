unit uTelefoneAndroid;

interface

procedure EnviarSMS(pNumero, pMensagem: string);
function PegaNumeroTelefone: String;

implementation

uses
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Telephony,
  Androidapi.Helpers,

  Androidapi.JNIBridge,
  Androidapi.JNI.GraphicsContentViewText;

procedure EnviarSMS(pNumero, pMensagem: string);
var
  GerenciadorSMS: JSmsManager;
begin
  GerenciadorSMS := TJSmsManager.JavaClass.getDefault;
  GerenciadorSMS.sendTextMessage(StringToJString(pNumero), nil, StringToJString(pMensagem), nil, nil)
end;

function PegaNumeroTelefone: String;
var
  TTelMgr: JTelephonyManager;
begin
  TTelMgr := TJTelephonyManager.Wrap ((SharedActivityContext.getSystemService(TJContext.JavaClass.TELEPHONY_SERVICE) as ILocalObject).GetObjectID);
  Result := JStringToString(TTelMgr.getLine1Number);
end;

end.
