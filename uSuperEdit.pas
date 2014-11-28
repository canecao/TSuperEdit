unit uSuperEdit;

interface

   uses
      System.Classes, FMX.Types, FMX.Edit, uTipos, uFormatador;

   type
      TSuperEdit = class( TEdit )
      private
         FTipoDocumento: TTipoDoc;
         procedure SetTipoDocumento( const Value: TTipoDoc );
         function GetisTextMask: Boolean;
         { Private declarations }
      protected
         { Protected declarations }
         procedure KeyDown( var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState ); override;
         procedure DoExit; override;
         procedure Change;override;
         procedure DoEnter;override;

      public
         { Public declarations }
         procedure Tremer;
      published
         { Published declarations }
         property TipoDocumento: TTipoDoc read FTipoDocumento write SetTipoDocumento;
         property isTextMask   : Boolean read GetisTextMask;
      end;

   procedure Register;

implementation

   uses
      System.UITypes, uValidador, Math, System.SysUtils, System.StrUtils;

   procedure Register;
   begin
      RegisterComponents( 'ricardo', [ TSuperEdit ] );
   end;

   { TSuperEdit }


procedure TSuperEdit.Change;
begin
  inherited;
  FontColor := ifthen( isTextMask, TAlphaColorRec.Lightgray, TAlphaColorRec.Black );
end;

procedure TSuperEdit.DoEnter;
begin
  inherited;
  Text := ifthen( isTextMask, '', Text );
end;

procedure TSuperEdit.DoExit;
   begin
      inherited;
      if ( Trim( Text ) = EmptyStr ) then
         Text   := TFormatador.GetMascara( FTipoDocumento );
      FontColor := ifthen( isTextMask, TAlphaColorRec.Lightgray, TAlphaColorRec.Black );
   end;

   function TSuperEdit.GetisTextMask: Boolean;
   begin
      Result := ( Trim( Text ) = TFormatador.GetMascara( FTipoDocumento ) );
   end;

   procedure TSuperEdit.KeyDown( var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState );
   var
      aux: Boolean;
   begin
      aux := CharInSet( KeyChar, [ 'A' .. 'Z', 'a' .. 'z', '0' .. '9' ] );
      inherited KeyDown( Key, KeyChar, Shift );
      Self.Text := TFormatador.ColocaMascara( Self.FTipoDocumento, Self.GetText );
      if aux then
         Self.GoToTextEnd;
   end;

   procedure TSuperEdit.SetTipoDocumento( const Value: TTipoDoc );
   var
      aux: Boolean;
   begin
      aux            := isTextMask or ( Trim( Text ) = EmptyStr ) or ( Trim( Text ) = TFormatador.GetMascara( Value ) );
      Text           := ifthen( aux, TFormatador.GetMascara( Value ), TFormatador.ColocaMascara( Value, GetText ) );
      FontColor      := ifthen( aux, TAlphaColorRec.Lightgray, TAlphaColorRec.Black );
      FTipoDocumento := Value;
      GoToTextEnd;
   end;

   procedure TSuperEdit.Tremer;
   begin
      TFormatador.Tremer( Self );
   end;

end.
