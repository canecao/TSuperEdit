unit uTipos;

interface

   type
      TVetorMultiplicador = array of Integer;
      TTipoDoc            = ( tpCPF, tpCNPJ, tpCep, tpData, tpCelular, tpTelefone, tpCelularDDD, tpTelefoneDDD, tpMascaraRede );

   const
      VetorMultCNPJ      : array [ 1 .. 13 ] of Integer  = ( 6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 );
      VetorMultCPF       : array [ 1 .. 10 ] of Integer  = ( 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 );
      ExemplosDocumentos : array [ 0 .. 8 ]  of String   = ( '751.002.781-02', '27.633.575/0001-06', '27.650-000', '22-03-1980', '99938-4886', '3647-0697', '(21)99938-4886', '(21)3647-0697', '192.168.001.001' );
      Mascaras           : array [ 0 .. 8 ]  of String   = ( '999.999.999-99', '99.999.999/9999-99', '99-99-9999', '99.999-999', '99999-9999', '9999-9999', '(99)99999-9999', '(99)9999-9999', '999.999.999.999' );

   function ExemploDocumento( TipoDoc: TTipoDoc ): string;
   function Mascara( TipoDoc: TTipoDoc ): string;

implementation

   function ExemploDocumento( TipoDoc: TTipoDoc ): string;
   begin
      Result := ExemplosDocumentos[ Ord( TipoDoc ) ];
   end;

   function Mascara( TipoDoc: TTipoDoc ): string;
   begin
      Result := Mascaras[ Ord( TipoDoc ) ];
   end;
End.
