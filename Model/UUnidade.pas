unit UUnidade;

interface

uses SysUtils, Classes, UProduto;

type
  TCliente = Class(TProduto)
      private
          vBloqueado : Boolean;
      public
          constructor Create;
      published
          property Bloqueado : Boolean read vBloqueado write vBloqueado;

  end;
implementation

{ TCliente }

constructor TCliente.Create;
begin
    vBloqueado := False;
end;

end.
 