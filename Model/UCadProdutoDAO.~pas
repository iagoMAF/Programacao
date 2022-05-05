unit UCadProdutoDAO;

interface

uses SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UCadProduto;

type

  TCadProdutoDAO = Class(TGenericDAO)
    public
      constructor Create(pConexao :  TSQLConnection);
      function  Insere(pCadProduto : TCadProduto) : Boolean;
      function  InsereLista(pColCadProduto : TColCadProduto) : Boolean;
      function  Atualiza(pCadProduto : TCadProduto; pCondicao : String) : Boolean;
      function  Retorna(pCondicao : String) : TCadProduto;
      function  RetornaLista(pCondicao : String = '') : TCadProduto;
  end;

implementation

{ TCadProdutoDAO }

function TCadProdutoDAO.Atualiza(pCadProduto: TCadProduto;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pCadProduto, pCondicao);
end;

constructor TCadProdutoDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
    vEntidade := 'PRODUTO';
    vConexao := pConexao;
    vClass := TCadProduto;
end;

function TCadProdutoDAO.Insere(pCadProduto: TCadProduto): Boolean;
begin
   Result := inherited Insere(pCadProduto, 'ID');
end;

function TCadProdutoDAO.InsereLista(
  pColCadProduto: TColCadProduto): Boolean;
begin
   Result := inherited InsereLista(pColCadProduto);
end;

function TCadProdutoDAO.Retorna(pCondicao: String): TCadProduto;
begin
   Result := TCadProduto(inherited Retorna(pCondicao));
end;

function TCadProdutoDAO.RetornaLista(pCondicao: String): TCadProduto;
begin
   Result := TCadProduto(inherited RetornaLista(pCondicao));
end;

end.
