unit TestuValidador;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, uValidador, uTipos;

type
  // Test methods for class TDocumento

  TestTDocumento = class(TTestCase)
  published
    procedure TestGeraDigito;
    procedure TestValidaTotalDigitos;
    procedure TestValidaDigitosSequencias;
    procedure TestValidaDigitoVerificardo;
    procedure TestValidar;
  end;
  // Test methods for class TFabricaDocumento

  TestTFabricaDocumento = class(TTestCase)
  strict private
    FFabricaDocumento: TFabricaDocumento;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCriaDocumento;
  end;
  // Test methods for class TCPF

  TestTCPF = class(TTestCase)
  strict private
    FCPF: TCPF;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGetVetorMultiplicador;
  end;
  // Test methods for class TCNPJ

  TestTCNPJ = class(TTestCase)
  strict private
    FCNPJ: TCNPJ;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGetVetorMultiplicador;
  end;
  // Test methods for class TValidador

  TestTValidador = class(TTestCase)
  strict private
    FValidador: TValidador;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestValidarDocumento;
  end;

implementation

uses
  System.SysUtils, System.StrUtils, uFormatador, Math, System.Classes;

procedure TestTDocumento.TestGeraDigito;
var
  TipoDoc: TTipoDoc;
  Digito: String;
  Dig1, Dig2: Integer;
  aux: Boolean;
  DocumentoAux: TDocumento;
begin
  for TipoDoc := tpCPF to tpCNPJ do
  begin
    DocumentoAux := TFabricaDocumento.CriaDocumento(TipoDoc,
      ExemploDocumento(TipoDoc));
    Digito := Copy(DocumentoAux.Numero, length(DocumentoAux.Numero) - 1, 2);
    Dig1 := DocumentoAux.GeraDigito(1);
    Dig2 := DocumentoAux.GeraDigito(2);
    aux := SameText(IntToStr(Dig1) + IntToStr(Dig2), Digito);
    if not aux then
      break;
  end;
  Assert(aux, 'Digito Verificador Inv�lido');
end;

procedure TestTDocumento.TestValidaTotalDigitos;
var
  ReturnValue: Boolean;
  TipoDoc: TTipoDoc;
  DocumentoAux: TDocumento;
begin
  ReturnValue := True;
  // TODO: Setup method call parameters
  for TipoDoc := tpCPF to tpCNPJ do
  begin
    DocumentoAux := TFabricaDocumento.CriaDocumento(TipoDoc,
      ExemploDocumento(TipoDoc));
    ReturnValue := ReturnValue and DocumentoAux.ValidaTotalDigitos;;
    if not ReturnValue then
      break;
    FreeAndNil(DocumentoAux);
  end;
  // TODO: Validate method results
  Assert(ReturnValue, 'O Teste do ' + ifthen(TipoDoc = tpCPF, 'CPF', 'CNPJ') +
    ' n�o passou!');
end;

procedure TestTDocumento.TestValidaDigitosSequencias;
var
  TipoDoc: TTipoDoc;
  DocumentoAux: TDocumento;
  ExemploDocumento: String;
  Contador: Integer;
  TamanhoDocumento : Integer;
begin
  // TODO: Setup method call parameters
  for TipoDoc := tpCPF to tpCNPJ do
    for Contador := 0 to 9 do
    begin
      TamanhoDocumento := ifthen(TipoDoc = tpCPF, 11, 14);
      ExemploDocumento := Contador.ToString.PadLeft(TamanhoDocumento, Contador.ToString[1]);
      try
        DocumentoAux := TFabricaDocumento.CriaDocumento(TipoDoc, ExemploDocumento);
        if DocumentoAux.ValidaDigitosSequencias then
        begin
          Assert(False, 'O Teste do ' + ifthen(TipoDoc = tpCPF, 'CPF', 'CNPJ') + ' n�o passou!');
          break;
        end;
      finally
        FreeAndNil(DocumentoAux);
      end;
    end;
end;

procedure TestTDocumento.TestValidaDigitoVerificardo;
var
  ReturnValue: Boolean;
  TipoDoc: TTipoDoc;
  DocumentoAux: TDocumento;
begin
  ReturnValue := True;
  // TODO: Setup method call parameters
  for TipoDoc := tpCPF to tpCNPJ do
  begin
    DocumentoAux := TFabricaDocumento.CriaDocumento(TipoDoc, ExemploDocumento(TipoDoc));
    ReturnValue := ReturnValue and DocumentoAux.ValidaDigitoVerificardo;;
    if not ReturnValue then
      break;
    FreeAndNil(DocumentoAux);
  end;
  // TODO: Validate method results
  Assert(ReturnValue, 'O Teste do ' + ifthen(TipoDoc = tpCPF, 'CPF', 'CNPJ') +
    ' n�o passou!');
end;

procedure TestTDocumento.TestValidar;
var
  ReturnValue: Boolean;
  TipoDoc: TTipoDoc;
  DocumentoAux: TDocumento;
begin
  ReturnValue := True;
  // TODO: Setup method call parameters
  for TipoDoc := tpCPF to tpCNPJ do
  begin
    DocumentoAux := TFabricaDocumento.CriaDocumento(TipoDoc,
      ExemploDocumento(TipoDoc));
    ReturnValue := ReturnValue and DocumentoAux.Validar;
    if not ReturnValue then
      break;
    FreeAndNil(DocumentoAux);
  end;
  // TODO: Validate method results
  Assert(ReturnValue, 'O Teste do ' + ifthen(TipoDoc = tpCPF, 'CPF', 'CNPJ') +
    ' n�o passou!');
end;

procedure TestTFabricaDocumento.SetUp;
begin
  FFabricaDocumento := TFabricaDocumento.Create;
end;

procedure TestTFabricaDocumento.TearDown;
begin
  FFabricaDocumento.Free;
  FFabricaDocumento := nil;
end;

procedure TestTFabricaDocumento.TestCriaDocumento;
var
  ReturnValue: TDocumento;
  TipoDoc: TTipoDoc;
  aux: Boolean;
begin
  // TODO: Setup method call parameters
  for TipoDoc := tpCPF to tpCNPJ do
  begin
    ReturnValue := FFabricaDocumento.CriaDocumento(TipoDoc,
      ExemploDocumento(TipoDoc));
    if TipoDoc = tpCPF then
      aux := Assigned(ReturnValue) and (ReturnValue.ClassType = TCPF)
    else
      aux := Assigned(ReturnValue) and (ReturnValue.ClassType = TCNPJ);
    if not aux then
      break;
  end;
  // TODO: Validate method results
  Assert(aux, 'N�o foi poss�vel criar o objeto' + ifthen(TipoDoc = tpCPF,
    'CPF', 'CNPJ'));
end;

procedure TestTCPF.SetUp;
begin
  FCPF := TCPF.Create;
end;

procedure TestTCPF.TearDown;
begin
  FCPF.Free;
  FCPF := nil;
end;

procedure TestTCPF.TestGetVetorMultiplicador;
var
  Contador: System.Integer;
  aux: Boolean;
begin
  for Contador := low(VetorMultCPF) to high(VetorMultCPF) do
  begin
    aux := VetorMultCPF[Contador] = FCPF.VetorMultiplicador[Contador - 1];
    if not aux then
      break;
  end;
  // TODO: Validate method results
  Assert(aux, 'Digito de ordem ' + IntToStr(Contador) + ' est� diferente!');
end;

procedure TestTCNPJ.SetUp;
begin
  FCNPJ := TCNPJ.Create;
end;

procedure TestTCNPJ.TearDown;
begin
  FCNPJ.Free;
  FCNPJ := nil;
end;

procedure TestTCNPJ.TestGetVetorMultiplicador;
var
  Contador: System.Integer;
  aux: Boolean;
begin
  for Contador := low(VetorMultCNPJ) to high(VetorMultCNPJ) do
  begin
    aux := VetorMultCNPJ[Contador] = FCNPJ.VetorMultiplicador[Contador - 1];
    if not aux then
      break;
  end;
  // TODO: Validate method results
  Assert(aux, 'Digito de ordem ' + IntToStr(Contador) + ' est� diferente!');
end;

procedure TestTValidador.SetUp;
begin
  FValidador := TValidador.Create;
end;

procedure TestTValidador.TearDown;
begin
  FValidador.Free;
  FValidador := nil;
end;

procedure TestTValidador.TestValidarDocumento;
var
  ReturnValue: Boolean;
  TipoDoc: TTipoDoc;
begin
  ReturnValue := True;
  // TODO: Setup method call parameters
  for TipoDoc := tpCPF to tpCNPJ do
  begin
    ReturnValue := ReturnValue and TValidador.ValidarDocumento
      (ExemploDocumento(TipoDoc), TipoDoc);
    if not ReturnValue then
      break;
  end;
  // TODO: Validate method results
  Assert(ReturnValue, 'O Teste do ' + ifthen(TipoDoc = tpCPF, 'CPF', 'CNPJ') +
    ' n�o passou!');
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTDocumento.Suite);
RegisterTest(TestTFabricaDocumento.Suite);
RegisterTest(TestTCPF.Suite);
RegisterTest(TestTCNPJ.Suite);
RegisterTest(TestTValidador.Suite);

end.
