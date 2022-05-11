unit UVendaProdDao;

interface

uses SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UVendaProd;

type

  TVendaProdDAO = Class(TGenericDAO)
    public
      constructor Create(pConexao :  TSQLConnection);
      function  Insere(pVendaProd : TVendaProd) : Boolean;
      function  InsereLista(pColVendaProd : TColVendaProd) : Boolean;
      function  Atualiza(pVendaProd : TVendaProd; pCondicao : String) : Boolean;
      function  Retorna(pCondicao : String) : TVendaProd;
      function  RetornaLista(pCondicao : String = '') : TColVendaProd;
  end;

implementation

{ TVendaProdDAO }

function TVendaProdDAO.Atualiza(pVendaProd: TVendaProd;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pVendaProd, pCondicao);
end;

constructor TVendaProdDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
    vEntidade := 'VENDA';
    vConexao := pConexao;
    vClass := TVendaProd;
end;

function TVendaProdDAO.Insere(pVendaProd: TVendaProd): Boolean;
begin
   Result := inherited Insere(pVendaProd, 'ID');
end;

function TVendaProdDAO.InsereLista(pColVendaProd: TColVendaProd): Boolean;
begin
   Result := inherited InsereLista(pColVendaProd);
end;

function TVendaProdDAO.Retorna(pCondicao: String): TVendaProd;
begin
   Result := TVendaProd(inherited Retorna(pCondicao));
end;

function TVendaProdDAO.RetornaLista(pCondicao: String): TColVendaProd;
begin
   Result := TColVendaProd(inherited RetornaLista(pCondicao));
end;

end.
