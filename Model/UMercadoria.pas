unit UMercadoria;

interface

uses SysUtils, Classes, UCadProduto;

type
  TMercadoria = class(TCadProduto)
    private
      vBloqueado : Boolean;
    public
      constructor Create;
    published
      property Bloqueado : Boolean read vBloqueado write vBloqueado;

  end;

implementation

{ TMercadoria }

constructor TMercadoria.Create;
begin
   vBloqueado := False;
end;

end.
