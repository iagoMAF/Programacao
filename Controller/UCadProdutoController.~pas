unit UCadProdutoController;

interface

uses SysUtils, Math, StrUtils, UConexao, UCadProduto;

type
   TCadProdutoController = class
      public
        constructor Create;
        function  GravaCadProduto(
                    pCadProduto : TCadProduto) : Boolean;

        function  ExcluiCadProduto(pCadProduto : TCadProduto)  : Boolean;
        function  BuscaCadProduto(pID : Integer)               : TCadProduto;
        function  PesquisaCadProduto(pDescricao : string)      : TColCadProduto;

        function RetornaCondicaoCadProduto(pID_CadProduto : Integer) :  String;

      published
        class function getInstancia : TCadProdutoController;


    end;

implementation

uses UCadProdutoDAO;

var
   _instance : TCadProdutoController;

{ TCadProdutoController }

function TCadProdutoController.BuscaCadProduto(pID: Integer): TCadProduto;
var
   xCadProdutoDAO : TCadProdutoDAO;
begin
   //BuscaCadProduto
   try
      try
         Result      := nil; // é nil pois não é do tipo boolean

         xCadProdutoDAO := TCadProdutoDAO.Create(TConexao.getInstance.getConn);
         Result      := xCadProdutoDAO.Retorna(RetornaCondicaoCadProduto(pID));

      finally
         if (xCadProdutoDAO <> nil ) then
            FreeAndNil(xCadProdutoDAO);
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

constructor TCadProdutoController.Create;
begin
    inherited Create;
end;

function TCadProdutoController.ExcluiCadProduto(
  pCadProduto: TCadProduto): Boolean;
var
   xCadProdutoDAO : TCadProdutoDAO;
begin
   try
   try
      Result := True;

      TConexao.get.iniciaTransacao;

      xCadProdutoDAO := TCadProdutoDAO.Create(TConexao.get.getConn);

      if (pCadProduto.Id = 0) then
         Exit
      else
      begin
         xCadProdutoDAO.Deleta(RetornaCondicaoCadProduto(pCadProduto.Id))
      end;

      TConexao.get.confirmaTransacao;

      Result := False;

   finally

      if xCadProdutoDAO <> nil then
         FreeAndNil(xCadProdutoDAO);
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

class function TCadProdutoController.getInstancia: TCadProdutoController;
begin
   if _instance = nil then
       _instance := TCadProdutoController.Create;

    Result := _instance;
end;

function TCadProdutoController.GravaCadProduto(
  pCadProduto: TCadProduto): Boolean;
var
  xCadProdutoDAO : TCadProdutoDAO;
  xAux        : Integer;
begin
   //GravaCadProduto
    try
        try
            TConexao.get.iniciaTransacao;
            Result := False;

            xCadProdutoDAO :=
              TCadProdutoDao.Create(TConexao.get.getConn);

            if pCadProduto.Id = 0 then
            begin
                xCadProdutoDAO.Insere(pCadProduto);
            end
            else
            begin
               xCadProdutoDAO.Atualiza(pCadProduto, RetornaCondicaoCadProduto(pCadProduto.Id));
            end;

            TConexao.get.confirmaTransacao;

        finally
            if xCadProdutoDAO <> nil then
               FreeAndNil(xCadProdutoDAO);
        end;
    except
        on E: Exception do
        begin
          TConexao.get.cancelaTransacao;
          Raise Exception.Create(
              'Falha ao cadastrar os dados do produto [Controller]. '#13+
              e.Message);
        end;

    end;
end;

function TCadProdutoController.PesquisaCadProduto(
  pDescricao: string): TColCadProduto;
//var
//   xCadProdutoDAO : TCadProdutoDAO;
//   xCondicao   : string;
begin
//   try
//      try
//         Result := nil;
//
//         xCadProdutoDAO := TCadProdutoDAO.Create(TConexao.get.getConn);
//
//         xCondicao  :=
//            IfThen(pDescricao <> EmptyStr,
//               'WHERE                                           '#13+
//               '    (DESCRICAO LIKE UPPER(''%'+ pDescricao + '%''))  '#13+
//               'ORDER BY DESCRICAO, ID', EmptyStr);
//
//         Result := xCadProdutoDAO.RetornaLista(xCondicao);
//
//      finally
//         if (xCadProdutoDAO <> nil) then
//            (FreeAndNil(xCadProdutoDAO));
//      end;
//   except
//      on E: Exception do
//      begin
//         raise Exception.Create(
//            'Falha ao buscas os dados da produto [Controller]: '#13+
//            e.Message);
//      end;
//   end;
end;

function TCadProdutoController.RetornaCondicaoCadProduto(
  pID_CadProduto: Integer): String;
var
  xChave : string;
begin
   xChave := 'ID';
  
   Result :=
      'WHERE                                                    '#13+
      '   '+xChave + ' = '+ QuotedStr(IntToStr(pID_CadProduto))+ ' '#13;
end;

end.
