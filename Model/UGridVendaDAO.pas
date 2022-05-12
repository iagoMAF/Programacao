unit UGridVendaDAO;

interface

uses SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UGridVenda;

type

   TGridVendaDAO = Class(TGenericDAO)
      public
         constructor Create(pConexao :  TSQLConnection);
         function  Insere(pGridVenda : TGridVenda) : Boolean;
         function  InsereLista(pColGridVenda : TColGridVenda) : Boolean;
         function  Atualiza(pGridVenda : TGridVenda; pCondicao : String) : Boolean;
         function  Retorna(pCondicao : String) : TGridVenda;
         function  RetornaLista(pCondicao : String = '') : TColGridVenda;
  end;

implementation

{ TGridVendaDAO }

function TGridVendaDAO.Atualiza(pGridVenda: TGridVenda;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pGridVenda, pCondicao);
end;

constructor TGridVendaDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'VENDA_ITEM';
   vConexao  := pConexao;
   vClass    := TGridVenda;
end;

function TGridVendaDAO.Insere(pGridVenda: TGridVenda): Boolean;
begin
   Result := inherited Insere(pGridVenda, 'ID');
end;

function TGridVendaDAO.InsereLista(pColGridVenda: TColGridVenda): Boolean;
begin
   Result := inherited InsereLista(pColGridVenda);
end;

function TGridVendaDAO.Retorna(pCondicao: String): TGridVenda;
begin
   Result := TGridVenda(inherited Retorna(pCondicao));
end;

function TGridVendaDAO.RetornaLista(pCondicao: String): TColGridVenda;
begin
   Result := TColGridVenda(inherited RetornaLista(pCondicao));
end;

end.
