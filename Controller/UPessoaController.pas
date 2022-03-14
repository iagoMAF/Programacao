unit UPessoaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UPessoa, UEndereco;

type
  TPessoaController = class
    public
      constructor Create;
      function  GravaPessoa(
                pPessoa : TPessoa;
                pColEndereco: TColEndereco)    : Boolean;

      function ExcluiPessoa(pPessoa : Tpessoa) : Boolean;

      function  BuscaPessoa(pID : Integer)     : Tpessoa;
      function  PesquisaPessoa(pNome : String) : TColPessoa;
      function  BuscaEnderecoPessoa(pID_Pessoa :  Integer ) : TColEndereco;

      function RetornaCondicaoPessoa(
               pID_Pessoa : Integer;
               pRelacionada : Boolean = False) : String;
    published
        class function getInstancia            : TPessoaController;
  end;

implementation

uses UPessoaDAO, UEnderecoDAO;

var
  _instance : TPessoaController;

{ TPessoaController }
function TPessoaController.BuscaEnderecoPessoa(
  pID_Pessoa: Integer): TColEndereco;
var
  xEnderecoDao : TEnderecoDAO;
begin
    try
      try
        Result := nil;

        xEnderecoDao :=
            TEnderecoDAO.Create(TConexao.getInstance.getConn);

        Result :=
          xEnderecoDao.RetornaLista(RetornaCondicaoPessoa(pID_Pessoa, True));
      finally
        if (xEnderecoDao <> nil) then
        FreeAndNil(xEnderecoDao);
      end;
    except
      on E : Exception do
      begin
        Raise Exception.Create(
        'Falha ao retornar os dados do endereço da pessoa [Controller]: '#13+
        e.Message);
      end;
    end;
end;

function TPessoaController.BuscaPessoa(pID: Integer): Tpessoa;
var
  xPessoaDAO : TPessoaDAO;
begin
  try
    try
      Result := nil;

      xPessoaDAO := TPessoaDAO.Create(TConexao.getInstance.getConn);
      Result := xPessoaDAO.Retorna(RetornaCondicaoPessoa(pID));
    finally
      if (xPessoaDAO <> nil ) then
        FreeAndNil(xPessoaDAO);
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create(
          'Falha ao buscar os dados da pessoa. [Controller] '#13+
          e.Message);

    end;
  end;
end;

constructor TPessoaController.Create;
begin
    inherited Create;
end;

function TPessoaController.ExcluiPessoa(pPessoa: Tpessoa): Boolean;
var
  xPessoaDAO   : TPessoaDAO;
  xEnderecoDAO : TEnderecoDAO;
begin
    try
      try
        Result := False;

        TConexao.get.iniciaTransacao;

        xPessoaDAO := TPessoaDAO.Create(TConexao.get.getConn);

        xEnderecoDAO := TEnderecoDAO.Create(TConexao.get.getConn);

        if (pPessoa.Id = 0) then
          Exit
        else
        begin
          xPessoaDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id));

          xEnderecoDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));
        end;

        TConexao.get.confirmaTransacao;

        Result := True;
      finally
        if xPessoaDAO <> nil then
           FreeAndNil(xPessoaDAO);
        if xEnderecoDAO <> nil then
           FreeAndNil(xEnderecoDAO);
      end;
    except
      on E: Exception do
      begin
        raise Exception.Create(
        'Falha ao excluir os dados da pessoa [Controller]: '#13+
        e.Message);
      end;
    end;
end;

class function TPessoaController.getInstancia: TPessoaController;
begin
    if _instance = nil then
       _instance := TPessoaController.Create;

    Result := _instance;
end;

function TPessoaController.GravaPessoa(
    pPessoa: TPessoa;
    pColEndereco : TColEndereco): Boolean;
var
  xPessoaDAO    : TPessoaDAO;
  xEnderecoDao  : TEnderecoDAO;
  xAux : Integer;
begin
    try
        try
          TConexao.get.iniciaTransacao;

          Result := False;

          xPessoaDAO   :=
            TPessoaDAO.Create(TConexao.get.getConn);

          xEnderecoDao :=
            TEnderecoDAO.Create(TConexao.get.getConn);

           if pPessoa.Id = 0 then
           begin
              xPessoaDAO.Insere(pPessoa);

              for xAux := 0 to pred(pColEndereco.Count) do
                  pColEndereco.Retorna(xAux).ID_Pessoa := pPessoa.Id;

              xEnderecoDao.InsereLista(pColEndereco);
           end
           else
           begin
              xPessoaDAO.Atualiza(pPessoa, RetornaCondicaoPessoa(pPessoa.Id));

              xEnderecoDao.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));
              xEnderecoDao.InsereLista(pColEndereco);
           end;

           TConexao.get.confirmaTransacao;
        finally
           if (xPessoaDAO <> nil) then
              FreeAndNil(xPessoaDAO);
        end;
    except  //Tratamento
        on E : Exception do
        begin
          TConexao.get.cancelaTransacao;
          raise Exception.Create(
             'Falha ao gravar os dados da pessoa [Controller]. '#13+
             e.Message);
        end;
    end;
end;

function TPessoaController.PesquisaPessoa(pNome: String): TColPessoa;
var
  xPessoaDAO : TPessoaDAO;
  xCondicao  : String;
begin
  try
    try
      Result     := nil;

      xPessoaDAO := TPessoaDAO.Create(TConexao.get.getConn);

      xCondicao  :=
        IfThen(pNome <> EmptyStr,
          'WHERE                              '#13+
          '    (NOME LIKE ''%'+ pNome + '%'' )', EmptyStr);

      Result     := xPessoaDAO.RetornaLista(xCondicao);
    finally
      if (xPessoaDAO <> nil) then
          FreeAndNil(xPessoaDAO);
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create(
        'Falha ao buscas os dados da pessoa [Controller]: '#13+
        e.Message);
    end;
  end;
end;

function TPessoaController.RetornaCondicaoPessoa(
     pID_Pessoa: Integer; pRelacionada : Boolean): String;
var
  xChave : String;
begin
  if (pRelacionada) then
      xChave := 'ID_Pessoa'
  else
        xChave := 'ID';

  Result :=
  'WHERE                                                   '#13+
  '   '+xChave + ' = '+ QuotedStr(IntToStr(pID_Pessoa))+ ' '#13;

end;

end.
 