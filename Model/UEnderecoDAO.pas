unit UEnderecoDAO;

interface

uses SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UEndereco;

type

  TEnderecoDAO = Class(TGenericDAO)
    public
      constructor Create(pConexao :  TSQLConnection);
      function  Insere(pEndereco : TEndereco) : Boolean;
      function  InsereLista(pColEndereco : TColEndereco) : Boolean;
      function  Atualiza(pEndereco : TEndereco; pCondicao : String) : Boolean;
      function  Retorna(pCondicao : String) : TEndereco;
      function  RetornaLista(pCondicao : String = '') : TColEndereco;
  end;

implementation

end.
