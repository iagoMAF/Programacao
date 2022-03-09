unit UPessoaDAO;

interface

uses SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UPessoa;

type

  TPessoaDAO = Class(TGenericDAO)
    public
      constructor Create(pConexao :  TSQLConnection);
      function  Insere(pPessoa : TPessoa) : Boolean;

  end;

implementation

{ TPessoaDAO }

constructor TPessoaDAO.Create(pConexao: TSQLConnection);
begin
    inherited Create;
    vEntidade := 'PESSOA';
    vConexao := pConexao;
    vClass := TPessoa;

end;

function TPessoaDAO.Insere(pPessoa: TPessoa): Boolean;
begin
  Result := inherited Insere(pPessoa, 'ID');

end;

end.
 