unit uFormatador;

interface

   uses uTipos;

   type
      TFormatador = class
      private
         function Limpar( pTexto: String ): String;
         function Pad(  pCaracter: char; pTamanho: Integer ): String;
         function RPad( pTexto: String; pCaracter: char; pTamanho: Integer ): String;
         function LPad( pTexto: String; pCaracter: char; pTamanho: Integer ): String;
         function Mascarar( texto, mascara: String ): string;
         function GetMascara( TipoDco: TTipoDoc ): String;
      public
         property mascara[ TipoDco: TTipoDoc ]: String read GetMascara;
         class function ColocaMascara( pTipoDocumento: TTipoDoc; pString: String ): String;
         class function RetiraMascara( pString: String ): String;
      end;

implementation

   uses
      System.SysUtils, System.StrUtils;

   { TFormatador }

   function TFormatador.Pad( pCaracter: char; pTamanho: Integer ): String;
   begin
      Result := StringOfChar( pCaracter, pTamanho  );
   end;

   function TFormatador.LPad( pTexto: String; pCaracter: char; pTamanho: Integer ): String;
   var Quantidade : Integer;
   begin
      Quantidade := pTamanho - Length( Trim( pTexto ) );
      Result := Pad( pCaracter, Quantidade ) + Trim( pTexto );
   end;

   function TFormatador.RPad( pTexto: String; pCaracter: char; pTamanho: Integer ): String;
   var Quantidade : Integer;
   begin
      Quantidade := pTamanho - Length( Trim( pTexto ) );
      Result := Trim( pTexto ) + Pad( pCaracter, Quantidade );
   end;

   function TFormatador.GetMascara( TipoDco: TTipoDoc ): String;
   begin
      case TipoDco of
         tpCPF: Result         := '999.999.999-99';
         tpCNPJ: Result        := '99.999.999/9999-99';
         tpData: Result        := '99-99-9999';
         tpCep: Result         := '99.999-999';
         tpCelular: Result     := '99999-9999';
         tpTelefone: Result    := '9999-9999';
         tpCelularDDD: Result  := '(0xx99) 99999-9999';
         tpTelefoneDDD: Result := '(0xx99) 9999-9999';
      end;
   end;

   function TFormatador.Limpar( pTexto: String ): String;
   var
      Aux: Boolean;
      C  : char;
   begin
      Result := '';
      for C in pTexto do
         begin
            Aux    := CharInSet( C, [ '0' .. '9' ] );
            Result := Result + ifthen( Aux, C, EmptyStr );
         end;
   end;

   function TFormatador.Mascarar( texto: String; mascara: String ): string;
   var
      i             : Integer;
      AuxEdt, AuxStr: Boolean;
      C             : char;
   begin
      i := 1;
      for C in texto do
         begin
            AuxEdt := CharInSet( C, [ '0' .. '9' ] );
            AuxStr := mascara[ i ] = '9';
            if AuxStr and not AuxEdt then
               delete( texto, i, 1 );
            if not AuxStr and AuxEdt then
               insert( mascara[ i ], texto, i );
            Inc( i, 1 );
         end;
      Result := ifthen( Length( texto ) <= Length( mascara ), texto, Copy( texto, 1, Length( mascara ) ) );
   end;

   class function TFormatador.ColocaMascara( pTipoDocumento: TTipoDoc; pString: String ): String;
   var
      Formatador: TFormatador;
   begin
      Formatador := TFormatador.Create;
      Result     := Formatador.Mascarar( pString, Formatador.mascara[ pTipoDocumento ] );
      FreeAndNil( Formatador );
   end;

   class function TFormatador.RetiraMascara( pString: String ): String;
   var
      Formatador: TFormatador;
   begin
      Formatador := TFormatador.Create;
      Result     := Formatador.Limpar( pString );
      FreeAndNil( Formatador );
   end;

end.
