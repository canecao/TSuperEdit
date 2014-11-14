unit uValidador;

interface

   Type
      TTipoDoc = ( tpCPF, tpCNPJ );

      TVetorMultiplicador = array of Integer;

      TDocumento = Class
      protected
         FQuantidadeDigitos : Integer;
         FVetorMultiplicador: TVetorMultiplicador;
         FNumero            : String;
         procedure SetNumero( const Value: String );
         function GetVetorMultiplicador: TVetorMultiplicador; virtual; abstract;
         function GetDigitoVericador: String;
         function GeraDigito( idx: Integer ): Integer;
      public
         function ValidaDigitosSequencias: Boolean;
         function ValidaDigitoVerificardo: Boolean;
         function Validar: Boolean;
         property Numero: String read FNumero write SetNumero;
         property DigitoVericador: String read GetDigitoVericador;
         property VetorMultiplicador: TVetorMultiplicador read GetVetorMultiplicador;
      End;

      TFabricaDocumento = class
      public
         Class Function CriaDocumento( TipoDocumento: TTipoDoc; pNumero: String ): TDocumento;
      end;

      TCPF = Class( TDocumento )
      protected
         function GetVetorMultiplicador: TVetorMultiplicador; override;
      public
         Constructor Create;
      end;

      TCNPJ = Class( TDocumento )
      protected
         function GetVetorMultiplicador: TVetorMultiplicador; override;
      public
         Constructor Create;
      end;

      TValidador = Class
      public
         class function ValidarDocumento( pNumeroDocumento: String; TipoDocumento: TTipoDoc ): Boolean;
      End;

implementation

   { TDocumento }

   uses System.SysUtils, System.Math;

   function TDocumento.GetDigitoVericador: String;
   begin
      Result := IntToStr( GeraDigito( 1 ) ) + IntToStr( GeraDigito( 2 ) );
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
      vDigito := Copy( Self.Numero, FQuantidadeDigitos - 1, 2 );
      Result  := CompareStr( vDigito, Self.GetDigitoVericador ) = 0;
   end;

   function TDocumento.Validar: Boolean;
   begin
      Result := ValidaDigitosSequencias and ValidaDigitoVerificardo
   end;

   function TDocumento.GeraDigito( idx: Integer ): Integer;
   var
      Contador, vLow, digito, multiplicador, index, Soma, Resto: Integer;
      vVetorMultiplicador                                      : TVetorMultiplicador;
   begin
      Soma                := 0;
      vLow                := ifthen( idx = 1, 1, 0 );
      vVetorMultiplicador := VetorMultiplicador;
      for Contador        := vLow to high( vVetorMultiplicador ) do
         begin
            Index         := ifthen( idx = 2, Contador + 1, Contador );
            digito        := StrToInt( Numero[ index ] );
            multiplicador := vVetorMultiplicador[ Contador ];
            Soma          := Soma + digito * multiplicador;
         end;
      Resto  := Soma mod 11;
      Result := ifthen( Resto < 2, 0, 11 - Resto );
      FillChar( vVetorMultiplicador[ 0 ], Length( vVetorMultiplicador ) * SizeOf( vVetorMultiplicador[ 0 ] ), 0 );
   end;

   procedure TDocumento.SetNumero( const Value: String );
   begin
      FNumero := Value;
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
   end;

   function TCPF.GetVetorMultiplicador: TVetorMultiplicador;
   const
      VetorMultCPF: array [ 1 .. 10 ] of Integer = ( 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 );
   begin
      SetLength( Result, Length( VetorMultCPF ) );
      Move( VetorMultCPF[ Low( VetorMultCPF ) ], Result[ 0 ], SizeOf( VetorMultCPF ) )
   end;

   { TCNPJ }

   constructor TCNPJ.Create;
   begin
      FQuantidadeDigitos := 14;
   end;

   function TCNPJ.GetVetorMultiplicador: TVetorMultiplicador;
   const
      VetorMultCNPJ: array [ 1 .. 13 ] of Integer = ( 6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 );
   begin
      SetLength( Result, Length( VetorMultCNPJ ) );
      Move( VetorMultCNPJ[ Low( VetorMultCNPJ ) ], Result[ 0 ], SizeOf( VetorMultCNPJ ) )
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
