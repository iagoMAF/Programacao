unit UVendaProd;

interface

uses SysUtils, Classes;

type
   TVendaProd = Class(TPersistent)

    private
      vId                  : Integer;
      vId_Cliente          : Integer;
      vTotalVenda          : Double;
      vDataVenda           : TDateTime;

      public
      constructor Create;
    published
      property Id              : Integer  read vId write vId;
      property Id_Cliente      : Integer  read vId_Cliente write vId_Cliente;
      property DataVenda       : TDateTime read vDataVenda  write vDataVenda;
      property TotalVenda      : Double   read vTotalVenda write vTotalVenda;
  end;

  TColVendaProd = Class(Tlist)
    public
        function Retorna(pIndex : Integer) : TVendaProd;
        procedure Adiciona(pVendaProd : TVendaProd);
  end;

implementation

{ TVendaProd }

constructor TVendaProd.Create;
begin
   Self.vId                  := 0;
   Self.vId_Cliente          := 0;
   Self.vDataVenda           := 0;
   Self.vTotalVenda          := 0;
end;

{ TColVendaProd }

procedure TColVendaProd.Adiciona(pVendaProd: TVendaProd);
begin
   Self.add(TVendaProd(pVendaProd));
end;

function TColVendaProd.Retorna(pIndex: Integer): TVendaProd;
begin
   Result := TVendaProd(Self[pIndex]);
end;

end.
