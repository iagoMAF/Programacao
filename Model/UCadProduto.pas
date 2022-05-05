unit UCadProduto;

interface

uses SysUtils, Classes;

type
   TCadProduto = Class(TPersistent)

    private
      vId                  : Integer;
      vDescricao           : String;
      vEstoque             : Integer;
      vPrecovenda          : Double;

      public
      constructor Create;
    published
      property Id                  : Integer  read vId write vId;
      property Descricao           : String   read vDescricao write vDescricao;
      property Estoque             : Integer  read vEstoque write vEstoque;
      property Precovenda          : Double   read vPrecovenda write vPrecovenda;
  end;

  TColCadProduto = Class(Tlist)
    public
        function Retorna(pIndex : Integer) : TCadProduto;
        procedure Adiciona(pCadProduto : TCadProduto);
  end;

implementation

constructor TCadProduto.Create;
begin
   Self.vId                  := 0;
   Self.vDescricao           := EmptyStr;
   Self.vEstoque             := 0;
   Self.vPrecovenda          := 0;
end;

{ TColCadProduto }

procedure TColCadProduto.Adiciona(pCadProduto: TCadProduto);
begin
   Self.add(TCadProduto(pCadProduto));
end;

function TColCadProduto.Retorna(pIndex: Integer): TCadProduto;
begin
   Result := TCadProduto(Self[pIndex]);
end;

end.
