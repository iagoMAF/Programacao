unit UProdutoController;

interface

uses SysUtils, Math, StrUtils, UConexao, UProduto;

type
    TProdutoController = class
      public
        constructor Create;
        function  GravaProduto(
                    pProduto : TProduto) : Boolean;

        function  ExcluiProduto(pProduto : TProduto)           : Boolean;
        function  BuscaProduto(pID : Integer)                  : TProduto;
        function  PesquisaProduto(pNome : string)              : TColProduto;

        function RetornaCondicaoProduto(pID_Produto : Integer) :  String;

      published
        class function getInstancia : TProdutoController;


    end;


implementation

uses UProdutoDAO;

var
  _instance : TProdutoController;

{ TProdutoController }

function TProdutoController.BuscaProduto(pID: Integer): TProduto;
var
   xProdutoDAO : TProdutoDAO;
begin
   try
      try
         Result      := nil; // ? nil pois n?o ? do tipo boolean

         xProdutoDAO := TProdutoDAO.Create(TConexao.getInstance.getConn);
         Result      := xProdutoDAO.Retorna(RetornaCondicaoProduto(pID));

      finally
         if (xProdutoDAO <> nil ) then
            FreeAndNil(xProdutoDAO);
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
            'Falha ao buscar os dados do produto. [Controller] '#13+
            e.Message);
      end;
   end;
end;

constructor TProdutoController.Create;
begin
    inherited Create;
end;

function TProdutoController.ExcluiProduto(pProduto: TProduto): Boolean;
var
   xProdutoDAO : TProdutoDAO;
begin
   try
      try
         Result := True;

         TConexao.get.iniciaTransacao;

         xProdutoDAO := TProdutoDAO.Create(TConexao.get.getConn);

         if (pProduto.Id = 0) then
            Exit
         else
         begin
            xProdutoDAO.Deleta(RetornaCondicaoProduto(pProduto.Id))
         end;

         TConexao.get.confirmaTransacao;

         Result := False;
      finally
         if xProdutoDAO <> nil then
            FreeAndNil(xProdutoDAO);
      end;
   except
      on E: Exception do
      begin
         TConexao.get.cancelaTransacao;
         raise Exception.Create(
            'Falha ao excluir os dados do produto [Controller]: '#13+
            e.Message);
      end;
   end;
end;

class function TProdutoController.getInstancia: TProdutoController;
begin
    if _instance = nil then
       _instance := TProdutoController.Create;

    Result := _instance;
end;

function TProdutoController.GravaProduto(pProduto: TProduto): Boolean;
var
  xProdutoDAO : TProdutoDAO;
  xAux        : Integer;
begin
    try
        try
            TConexao.get.iniciaTransacao;
            Result := False;

            xProdutoDAO :=
              TProdutoDao.Create(TConexao.get.getConn);

            if pProduto.Id = 0 then
            begin
                xProdutoDAO.Insere(pProduto);
            end
            else
            begin
            xProdutoDAO.Atualiza(pProduto, RetornaCondicaoProduto(pProduto.Id));
            end;

            TConexao.get.confirmaTransacao;
        finally
            if xProdutoDAO <> nil then
               FreeAndNil(xProdutoDAO);
        end;
    except
        on E: Exception do
        begin
          TConexao.get.cancelaTransacao;
          Raise Exception.Create(
              'Falha ao grava os dados do produto [Controller]. '#13+
              e.Message);
        end;

    end;
end;

function TProdutoController.PesquisaProduto(pNome: string): TColProduto;
var
   xProdutoDAO : TProdutoDAO;
   xCondicao   : string;
begin
   try
      try
         Result := nil;

         xProdutoDAO := TProdutoDAO.Create(TConexao.get.getConn);

         xCondicao  :=
            IfThen(pNome <> EmptyStr,
               'WHERE                                           '#13+
               '    (DESCRICAO LIKE UPPER(''%'+ pNome + '%''))  '#13+
               'ORDER BY DESCRICAO, ID', EmptyStr);

         Result := xProdutoDAO.RetornaLista(xCondicao);

      finally
         if (xProdutoDAO <> nil) then
            (FreeAndNil(xProdutoDAO));
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
            'Falha ao buscas os dados da produto [Controller]: '#13+
            e.Message);
      end;
   end;
end;  

function TProdutoController.RetornaCondicaoProduto(
  pID_Produto: Integer): String;
var
  xChave : string;
begin
  xChave := 'ID';
  
  Result :=
  'WHERE                                                    '#13+
  '   '+xChave + ' = '+ QuotedStr(IntToStr(pID_Produto))+ ' '#13;
end;

end.
 