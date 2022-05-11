unit UComercio;

interface

uses SysUtils, Classes, UVendaProd;

type
  TComercio = class(TVendaProd)
    private
      vBloqueado : Boolean;
    public
      constructor Create;
    published
      property Bloqueado : Boolean read vBloqueado write vBloqueado;

  end;

implementation

{ TComercio }

constructor TComercio.Create;
begin
   vBloqueado := False;
end;

end.
