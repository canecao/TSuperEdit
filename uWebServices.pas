unit uWebServices;

interface

   type
      TWebServices = class
      private
         function GetCep( pcep: Integer ): String;
         function GetConversorDolarReal : Double;
      public
         property Cep[ pcep: Integer ]: String read GetCep;
         property ConversorDolarReal  : Double read GetConversorDolarReal;
      end;

implementation

   uses uCep,uCurrencyConvertor, System.SysUtils;
   { TWebServices }

   function TWebServices.GetCep( pcep: Integer ): String;
   var
      vCep: CEPServicePort;
   begin
      vCep   := GetCEPServicePort;
      Try
         Result := vCep.obterLogradouroAuth( IntToStr( pcep ), 'canecao', '423801ric' );
      Finally
         vCep := nil;
      End;
   end;

   function TWebServices.GetConversorDolarReal : Double;
   var Curr : CurrencyConvertorSoap;
   begin
       Curr := GetCurrencyConvertorSoap();
       try
          Result := Curr.ConversionRate(Currency.USD, Currency.BRL);
       finally
          Curr := nil;
       end;
   end;

end.

