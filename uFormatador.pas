unit uFormatador;

interface

uses uTipos, System.Classes, FMX.Forms, FMX.Edit;

type
  TThreadTremer = class(TThread)
  private
    FForm: TForm;
    FEdit: TEdit;
    procedure SetEdit(const Value: TEdit);
    procedure SetForm(const Value: TForm);
  protected
    procedure Execute; override;
  public
    constructor Create(Componente: TObject); overload;
    property Edit: TEdit read FEdit write SetEdit;
    property Form: TForm read FForm write SetForm;
  end;

  TFormatador = class
  public
    function Mascarar(texto, mascara: String): string;
    function Limpar(pTexto: String): String;
    function Pad(pCaracter: char; pTamanho: integer): String;
    function RPad(pTexto: String; pCaracter: char; pTamanho: integer): String;
    function LPad(pTexto: String; pCaracter: char; pTamanho: integer): String;
    function ArrayToStr(Vetor: array of String;
      Delimitador: char = ','): String;
    function Split(texto: String; Delimitador: char = ','): TStrings;
    class function ColocaMascara(pTipoDocumento: TTipoDoc;
      pString: String): String;
    class function RetiraMascara(pString: String): String;
    Class procedure Tremer(Sender: TEdit); overload;
    Class procedure Tremer(Sender: TForm); overload;
    class function GetMascara(TipoDoc: TTipoDoc): String;
    property mascara[TipoDoc: TTipoDoc]: String read GetMascara;
  end;

implementation

uses
  Math, System.SysUtils, System.StrUtils;

{ TFormatador }
function TFormatador.Split(texto: String; Delimitador: char = ','): TStrings;
begin
  Result := TStringList.Create;
  Result.Delimiter := Delimitador;
  Result.StrictDelimiter := True;
  Result.DelimitedText := texto;
end;

function TFormatador.ArrayToStr(Vetor: array of String;
  Delimitador: char = ','): String;
var
  I: integer;
begin
  Result := Vetor[Low(Vetor)];
  for I := Low(Vetor) + 1 to High(Vetor) do
    Result := Result + Delimitador + Vetor[I];
end;

function TFormatador.Pad(pCaracter: char; pTamanho: integer): String;
begin
  Result := StringOfChar(pCaracter, pTamanho);
end;

function TFormatador.LPad(pTexto: String; pCaracter: char;
  pTamanho: integer): String;
var
  Quantidade: integer;
begin
  Quantidade := pTamanho - Length(Trim(pTexto));
  Result := Pad(pCaracter, Quantidade) + Trim(pTexto);
end;

function TFormatador.RPad(pTexto: String; pCaracter: char;
  pTamanho: integer): String;
var
  Quantidade: integer;
begin
  Quantidade := pTamanho - Length(Trim(pTexto));
  Result := Trim(pTexto) + Pad(pCaracter, Quantidade);
end;

class function TFormatador.GetMascara(TipoDoc: TTipoDoc): String;
begin
  case TipoDoc of
    tpCPF:
      Result := '999.999.999-99';
    tpCNPJ:
      Result := '99.999.999/9999-99';
    tpData:
      Result := '99-99-9999';
    tpCep:
      Result := '99.999-999';
    tpCelular:
      Result := '99999-9999';
    tpTelefone:
      Result := '9999-9999';
    tpCelularDDD:
      Result := '(99)99999-9999';
    tpTelefoneDDD:
      Result := '(99)9999-9999';
    tpMascaraRede:
      Result := '999.999.999.999';
  end;
end;

function TFormatador.Limpar(pTexto: String): String;
var
  Aux: Boolean;
  C: char;
begin
  Result := '';
  for C in pTexto do
  begin
    Aux := CharInSet(C, ['0' .. '9']);
    Result := Result + ifthen(Aux, C, EmptyStr);
  end;
end;

function TFormatador.Mascarar(texto: String; mascara: String): string;
var
  I, J: integer;
  AuxEdt, AuxStr: Boolean;
  C: char;
begin
  Result := EmptyStr;
  if texto <> EmptyStr then
  begin
    // 1111111111111111
    // (99)99999-9999
    I := 0;
    for C in mascara do
    begin
      AuxEdt := CharInSet(texto[i], ['0' .. '9' ]);
      AuxStr := (c <> '9');
      if texto[i] = #0 then
         inc(i);
      if AuxStr then
      begin
        Result := Result + c;
      end else
      if AuxEdt then
      begin
        Result := Result + texto[i];
        inc(I);
      end;
    end;
  end;
end;

class procedure TFormatador.Tremer(Sender: TForm);
begin
  TThreadTremer.Create(Sender);
end;

class procedure TFormatador.Tremer(Sender: TEdit);
begin
  TThreadTremer.Create(Sender);
end;

class function TFormatador.ColocaMascara(pTipoDocumento: TTipoDoc;
  pString: String): String;
var
  Formatador: TFormatador;
begin
  Formatador := TFormatador.Create;
  Result := Formatador.Mascarar(pString, Formatador.mascara[pTipoDocumento]);
  FreeAndNil(Formatador);
end;

class function TFormatador.RetiraMascara(pString: String): String;
var
  Formatador: TFormatador;
begin
  Formatador := TFormatador.Create;
  Result := Formatador.Limpar(pString);
  FreeAndNil(Formatador);
end;

{ ObjetoTThread }

procedure TThreadTremer.Execute;
var
  X: Single;
  C: integer;
begin
  if Assigned(Edit) then
  begin
    X := Self.Edit.Position.X;
    for C := 1 to 9 do
    begin
      Self.Edit.Position.X := Self.Edit.Position.X +
        ifthen(Self.Edit.Position.X >= X, -15, 30);
      Sleep(50);
      Application.ProcessMessages;
    end;
  end;
  if Assigned(Form) then
  begin
    X := Self.Form.Left;
    for C := 1 to 9 do
    begin
      Self.Form.Left := Self.Form.Left + ifthen(Self.Form.Left >= X, -15, 30);
      Sleep(50);
      Application.ProcessMessages;
    end;
  end;
end;

procedure TThreadTremer.SetEdit(const Value: TEdit);
begin
  FEdit := Value;
end;

procedure TThreadTremer.SetForm(const Value: TForm);
begin
  FForm := Value;
end;

constructor TThreadTremer.Create(Componente: TObject);
begin
  // let thread free itself
  FreeOnTerminate := True;
  // do not create suspended, let it go as soon as it is created
  if Componente.ClassParent = TEdit then
    Self.Edit := TEdit(Componente)
  else
    Self.Form := TForm(Componente);
  inherited Create(False);
end;

end.
