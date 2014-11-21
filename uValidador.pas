unit uValidador;

interface

   uses uTipos;

   Type
      TDocumento = Class
      protected
         FTipoDoc           : TTipoDoc;
         FQuantidadeDigitos : Integer;
         FVetorMultiplicador: TVetorMultiplicador;
         FNumero            : String;
         procedure SetTipoDoc( const Value: TTipoDoc );
         procedure SetNumero( const Value: String );
         function  GetNumero: String;
         function  GetDigitoVericador: String;
      public
         function GeraDigito( idx: Integer ): Integer;
         function ValidaTotalDigitos: Boolean;
         function ValidaDigitosSequencias: Boolean;
         function ValidaDigitoVerificardo: Boolean;
         function Validar: Boolean;
         property TipoDoc: TTipoDoc read FTipoDoc write SetTipoDoc;
         property Numero: String read GetNumero write SetNumero;
         property DigitoVericador: String read GetDigitoVericador;
         property VetorMultiplicador: TVetorMultiplicador read FVetorMultiplicador;
      End;

      TFabricaDocumento = class
      public
         Class Function CriaDocumento( TipoDocumento: TTipoDoc; pNumero: String ): TDocumento;
      end;

      TCPF = Class( TDocumento )
      public
         Constructor Create;
      end;

      TCNPJ = Class( TDocumento )
      public
         Constructor Create;
      end;

      TValidador = Class
      public
         class function ValidarDocumento( pNumeroDocumento: String; TipoDocumento: TTipoDoc ): Boolean;
      End;

implementation

   { TDocumento }

   uses System.SysUtils, System.Math, StrUtils, uFormatador;

   function TDocumento.GetDigitoVericador: String;
   begin
      Result := IntToStr( GeraDigito( 1 ) ) + IntToStr( GeraDigito( 2 ) );
   end;

   function TDocumento.GetNumero: String;
   begin
      Result := TFormatador.RetiraMascara( Self.FNumero )
   end;

   function TDocumento.ValidaDigitosSequencias: Boolean;
   var
      Contador  : Integer;
      Sequencial: String;
   begin
      for Contador := 0 to 9 do
         begin
            Sequencial := StringOfChar( IntToStr( Contador )[ 1 ], Self.FQuantidadeDigitos );
            Result     := Self.Numero <> Sequencial;
            if Not Result then
               break
         end;
   end;

   function TDocumento.ValidaDigitoVerificardo: Boolean;
   var
      vDigito: String;
   begin
      vDigito := Copy( Self.Numero, Self.FQuantidadeDigitos - 1, 2 );
      Result  := SameText( vDigito, Self.GetDigitoVericador );
   end;

   function TDocumento.Validar: Boolean;
   begin
      Result := ValidaDigitosSequencias and ValidaDigitoVerificardo
   end;

   function TDocumento.ValidaTotalDigitos: Boolean;
   begin
      Result := Length( TFormatador.RetiraMascara( Self.Numero ) ) >= Self.FQuantidadeDigitos;
   end;

   function TDocumento.GeraDigito( idx: Integer ): Integer;
   var
      Contador, vLow, digito, multiplicador, index, Soma, Resto: Integer;
   begin
      Soma         := 0;
      vLow         := ifthen( idx = 1, 1, 0 );
      for Contador := vLow to high( FVetorMultiplicador ) do
         begin
            Index         := ifthen( idx = 2, Contador + 1, Contador );
            digito        := StrToInt( Numero[ index ] );
            multiplicador := FVetorMultiplicador[ Contador ];
            Soma          := Soma + digito * multiplicador;
         end;
      Resto  := Soma mod 11;
      Result := ifthen( Resto < 2, 0, 11 - Resto );
   end;

   procedure TDocumento.SetNumero( const Value: String );
   begin
      FNumero := Value;
   end;

   procedure TDocumento.SetTipoDoc( const Value: TTipoDoc );
   begin
      FTipoDoc := Value;
   end;

   { TFabricaDocumento }

   class function TFabricaDocumento.CriaDocumento( TipoDocumento: TTipoDoc; pNumero: String ): TDocumento;
   begin
      Result := nil;
      case TipoDocumento of
         tpCPF: Result  := TCPF.Create;
         tpCNPJ: Result := TCNPJ.Create;
      end;
      Result.Numero := pNumero;
   end;

   { TCPF }

   constructor TCPF.Create;
   begin
      FQuantidadeDigitos := 11;
      TipoDoc            := tpCPF;
      SetLength( FVetorMultiplicador, Length( VetorMultCPF ) );
      Move( VetorMultCPF[ Low( VetorMultCPF ) ], FVetorMultiplicador[ 0 ], SizeOf( VetorMultCPF ) )
   end;

   { TCNPJ }

   constructor TCNPJ.Create;
   begin
      FQuantidadeDigitos := 14;
      TipoDoc            := tpCNPJ;
      SetLength( FVetorMultiplicador, Length( VetorMultCNPJ ) );
      Move( VetorMultCNPJ[ Low( VetorMultCNPJ ) ], FVetorMultiplicador[ 0 ], SizeOf( VetorMultCNPJ ) )
   end;

   { TValidador }

   class function TValidador.ValidarDocumento( pNumeroDocumento: String; TipoDocumento: TTipoDoc ): Boolean;
   var
      vDocumento: TDocumento;
   begin
      vDocumento := TFabricaDocumento.CriaDocumento( TipoDocumento, pNumeroDocumento );
      Result     := vDocumento.Validar;
      FreeAndNil( vDocumento );
   end;

end.
