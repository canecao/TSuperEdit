unit uFormatador;

interface

   uses uTipos, Classes, FMX.Forms, FMX.Edit;

   type
      TFormatador = class
      public
         function Mascarar( texto, mascara: String ): string;
         function Limpar( pTexto: String ): String;
         function Pad( pCaracter: char; pTamanho: Integer ): String;
         function RPad( pTexto: String; pCaracter: char; pTamanho: Integer ): String;
         function LPad( pTexto: String; pCaracter: char; pTamanho: Integer ): String;
         function ArrayToStr( Vetor: array of String; Delimitador: char = ',' ): String;
         function Split( texto: String; Delimitador: char = ',' ): TStrings;
         class function ColocaMascara( pTipoDocumento: TTipoDoc; pString: String ): String;
         class function RetiraMascara( pString: String ): String;
         Class procedure Tremer( Sender: TEdit ); overload;
         Class procedure Tremer( Sender: TForm ); overload;
         class function GetMascara( TipoDoc: TTipoDoc ): String;
         property mascara[ TipoDoc: TTipoDoc ]: String read GetMascara;
      end;

implementation

   uses
      System.SysUtils, System.StrUtils, Math;

   { TFormatador }
   function TFormatador.Split( texto: String; Delimitador: char = ',' ): TStrings;
   begin
      Result                 := TStringList.Create;
      Result.Delimiter       := Delimitador;
      Result.StrictDelimiter := True;
      Result.DelimitedText   := texto;
   end;

   function TFormatador.ArrayToStr( Vetor: array of String; Delimitador: char = ',' ): String;
   var
      I: Integer;
   begin
      Result    := Vetor[ Low( Vetor ) ];
      for I     := Low( Vetor ) + 1 to High( Vetor ) do
         Result := Result + Delimitador + Vetor[ I ];
   end;

   function TFormatador.Pad( pCaracter: char; pTamanho: Integer ): String;
   begin
      Result := StringOfChar( pCaracter, pTamanho );
   end;

   function TFormatador.LPad( pTexto: String; pCaracter: char; pTamanho: Integer ): String;
   var
      Quantidade: Integer;
   begin
      Quantidade := pTamanho - Length( Trim( pTexto ) );
      Result     := Pad( pCaracter, Quantidade ) + Trim( pTexto );
   end;

   function TFormatador.RPad( pTexto: String; pCaracter: char; pTamanho: Integer ): String;
   var
      Quantidade: Integer;
   begin
      Quantidade := pTamanho - Length( Trim( pTexto ) );
      Result     := Trim( pTexto ) + Pad( pCaracter, Quantidade );
   end;

   class function TFormatador.GetMascara( TipoDoc: TTipoDoc ): String;
   begin
      case TipoDoc of
         tpCPF: Result         := '999.999.999-99';
         tpCNPJ: Result        := '99.999.999/9999-99';
         tpData: Result        := '99-99-9999';
         tpCep: Result         := '99.999-999';
         tpCelular: Result     := '99999-9999';
         tpTelefone: Result    := '9999-9999';
         tpCelularDDD: Result  := '(99) 99999-9999';
         tpTelefoneDDD: Result := '(99) 9999-9999';
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
      I             : Integer;
      AuxEdt, AuxStr: Boolean;
   begin
      if texto <> EmptyStr then
         begin
            I := 1;
            Repeat
               AuxEdt := CharInSet( texto[ I ], [ '0' .. '9' ] );
               AuxStr := mascara[ I ] = '9';
               if AuxStr and not AuxEdt then
                  delete( texto, I, 1 );
               if not AuxStr and AuxEdt then
                  insert( mascara[ I ], texto, I );
               inc( I );
            until ( I > Length( texto ) ) or ( I > Length( mascara ) );
         end;
      Result := ifthen( Length( texto ) <= Length( mascara ), texto, Copy( texto, 1, Length( mascara ) ) );
   end;

   class procedure TFormatador.Tremer( Sender: TForm );
   var
      X: Single;
      C: Integer;
   begin
      X     := Sender.Left;
      for C := 1 to 9 do
         begin
            Sender.Left := Sender.Left + ifthen( Sender.Left >= X, - 15, 30 );
            Sleep( 50 );
            Application.ProcessMessages;
         end;
   end;

   class procedure TFormatador.Tremer( Sender: TEdit );
   var
      X: Single;
      C: Integer;
   begin
      X     := Sender.Position.X;
      for C := 1 to 9 do
         begin
            Sender.Position.X := Sender.Position.X + ifthen( Sender.Position.X >= X, - 15, 30 );
            Sleep( 50 );
            Application.ProcessMessages;
         end;

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
