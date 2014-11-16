unit uFormatador;

interface

uses uTipos;

type
  TFormatador = class
  private
    function Cpf(pNumero: String): String;
    function Cnpj(pNumero: String): String;
    function Limpar(pTexto: String): String;
    function RPad(pTexto: String; pCaracter : char; pTamanho: Integer): String;
  public
    class function ColocaMascara(pTipoDocumento: TTipoDoc; pString: String): String;
    class function RetiraMascara(pString: String): String;
  end;

implementation

uses
  System.SysUtils, System.StrUtils;

{ TFormatador }

function TFormatador.Limpar(pTexto: String): String;
var
  Contador: Integer;
  Aux: Boolean;
begin
  Result := '';
  for Contador := 1 to Length(pTexto) do
  begin
    Aux := CharInSet(pTexto[Contador], ['0' .. '9']);
    Result := Result + ifthen(Aux, pTexto[Contador], '');
  end;
end;

function TFormatador.RPad(pTexto: String; pCaracter : char; pTamanho: Integer): String;
begin
  Result := Trim(pTexto);
  Result := StringOfChar(pCaracter, pTamanho - Length(Result));
  Result := Trim(pTexto) + Result;
end;

function TFormatador.Cnpj(pNumero: String): String;
var
  a, b, c, d, e: String;
begin
  //#32 = ' '
  a := Copy(pNumero, 1, 2);
  a := RPad(a, #32, 2) + '.';

  b := Copy(pNumero, 3, 3);
  b := RPad(b, #32, 3) + '.';

  c := Copy(pNumero, 6, 3);
  c := RPad(c, #32, 3) + '/';

  d := Copy(pNumero, 9, 4);
  d := RPad(d, #32, 4) + '-';

  e := Copy(pNumero, 13, 2);
  e := RPad(e, #32, 2);

  Result := a + b + c + d + e
end;

function TFormatador.Cpf(pNumero: String): String;
var
  a, b, c, d: String;
begin
  a := Copy(pNumero, 1, 3);
  a := RPad(a, #32, 3) + '.';

  b := Copy(pNumero, 4, 3);
  b := RPad(b, #32, 3) + '.';

  c := Copy(pNumero, 7, 3);
  c := RPad(c, #32, 3) + '-';

  d := Copy(pNumero, 10, 2);
  d := RPad(d, #32, 2);

  Result := a + b + c + d
end;

class function TFormatador.ColocaMascara(pTipoDocumento: TTipoDoc; pString: String): String;
var
  Formatador: TFormatador;
begin
  Formatador := TFormatador.Create;
  Result := Formatador.Limpar(pString);
  case pTipoDocumento of
    tpCPF:  Result := Formatador.Cpf(Result);
    tpCNPJ: Result := Formatador.Cnpj(Result);
  end;
  FreeAndNil(Formatador);
end;

class function TFormatador.RetiraMascara( pString: String): String;
var
  Formatador: TFormatador;
begin
  Formatador := TFormatador.Create;
  Result := Formatador.Limpar(pString);
  FreeAndNil(Formatador);
end;

end.
