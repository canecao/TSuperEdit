unit uTipos;

interface

   uses FMX.Forms, FMX.Edit;

   type
      TTipoDoc            = ( tpCPF, tpCNPJ, tpCep, tpData, tpCelular, tpTelefone, tpCelularDDD, tpTelefoneDDD );
      TVetorMultiplicador = array of Integer;

   const
      VetorMultCNPJ: array [ 1 .. 13 ] of Integer = ( 6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 );
      VetorMultCPF: array [ 1 .. 10 ] of Integer  = ( 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 );

   function ExemploDocumento( TipoDoc: TTipoDoc ): string;

implementation

   function ExemploDocumento( TipoDoc: TTipoDoc ): string;
   begin
      case TipoDoc of
         tpCPF: Result         := '751.002.781-02';
         tpCNPJ: Result        := '27.633.575/0001-06';
         tpCep: Result         := '27.650-000';
         tpData: Result        := '22-03-1980';
         tpCelular: Result     := '999384886';
         tpTelefone: Result    := '36470697';
         tpCelularDDD: Result  := '999384886';
         tpTelefoneDDD: Result := '999384886';
      end;
   end;

End.
