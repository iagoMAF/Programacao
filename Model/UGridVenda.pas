unit UGridVenda;

interface

uses SysUtils, Classes;

type
   TGridVenda = Class (TPersistent)
      private
         vId            : Integer;
         vID_Produto    : Integer;
         vID_Venda      : Integer;
         vDescricao     : String;
         vValorUnitario : Double;
         vQuantidade    : Integer;
        // vValorTotalProduto : Double;

    public
      constructor Create;

    published
      property Id            : Integer read vID         write vID;
      property ID_Produto    : Integer read vID_Produto  write vID_Produto;
      property ID_Venda      : Integer read vID_Venda   write vID_Venda;
      property Descricao     : String  read vDescricao  write vDescricao;
      property Quantidade    : Integer read vQuantidade write vQuantidade;
      property ValorUnitario : Double  read vValorUnitario write vValorUnitario;
     // property ValorTotalProduto : Double read vValorTotalProduto write vValorTotalProduto;

   end;

   TColGridVenda = class(TList)
    public
        function  Retorna(pIndex : Integer) : TGridVenda;
        procedure Adiciona(pGridVenda : TGridVenda);
   end;

implementation

{ TGridVenda }

constructor TGridVenda.Create;
begin
   Self.vId            := 0;
   Self.vID_Produto    := 0;
   Self.vID_Venda      := 0;
   Self.vDescricao     := EmptyStr;
   Self.vQuantidade    := 0;
   Self.vValorUnitario := 0;
end;

{ TColGridVenda }

procedure TColGridVenda.Adiciona(pGridVenda: TGridVenda);
begin
   Self.Add(TGridVenda(pGridVenda));
end;

function TColGridVenda.Retorna(pIndex: Integer): TGridVenda;
begin
   Result := TGridVenda(Self[pIndex]);
end;

end.
