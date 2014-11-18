unit uTipos;

interface

   type
      TTipoDoc = ( tpCPF, tpCNPJ, tpCep, tpData, tpCelular, tpTelefone, tpCelularDDD, tpTelefoneDDD );

      TVetorMultiplicador = array of Integer;

   const
      VetorMultCNPJ: array [ 1 .. 13 ] of Integer = ( 6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 );
      VetorMultCPF : array [ 1 .. 10 ] of Integer = ( 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 );



implementation

end.
