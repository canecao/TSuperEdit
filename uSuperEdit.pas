unit uSuperEdit;

interface

   uses
      System.SysUtils, System.Classes, FMX.Types, FMX.Edit, uTipos, uFormatador;

   type
      TSuperEdit = class( TEdit )
      private
         FTipoDocumento: TTipoDoc;
         procedure SetTipoDocumento( const Value: TTipoDoc );
         { Private declarations }
      protected
         { Protected declarations }
      public
         { Public declarations }
         procedure KeyDown( var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState ); override;
      published
         { Published declarations }
         property TipoDocumento: TTipoDoc read FTipoDocumento write SetTipoDocumento;
      end;

   procedure Register;

implementation

uses
  System.UITypes;

   procedure Register;
   begin
      RegisterComponents( 'ricardo', [ TSuperEdit ] );
   end;

   { TSuperEdit }

   procedure TSuperEdit.KeyDown( var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState );
   var aux : Boolean;
   begin
      aux := CharInSet(KeyChar,['A'..'Z','a'..'z','0'..'9']);
      inherited KeyDown (Key, KeyChar, Shift);
      self.SetText( TFormatador.ColocaMascara( self.FTipoDocumento, self.GetText ) );
      if aux then
         self.GoToTextEnd;
   end;

   procedure TSuperEdit.SetTipoDocumento( const Value: TTipoDoc );
   begin
      FTipoDocumento := Value;
      self.Text      := TFormatador.ColocaMascara( self.FTipoDocumento, self.GetText );
      self.GoToTextEnd;
   end;

end.
