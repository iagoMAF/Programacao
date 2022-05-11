unit UVendaProdController;

interface

uses SysUtils, Math, StrUtils, UConexao, UVendaProd;

type
   TVendaProdController = class
      public
        constructor Create;
        function    GravaVendaProd(
                    pVendaProd : TVendaProd) : Boolean;

        function  ExcluiVendaProd(pVendaProd : TVendaProd)  : Boolean;
        function  BuscaVendaProd(pID : Integer)             : TVendaProd;
        function  PesquisaVendaProd(pNome : string)         : TColVendaProd;

        function RetornaCondicaoVendaProd(pID_VendaProd : Integer) :  String;

      published
        class function getInstancia : TVendaProdController;


    end;

implementation

uses UVendaProdDao;

var
   _instance : TVendaProdController;

{ TVendaProdController }

function TVendaProdController.BuscaVendaProd(pID: Integer): TVendaProd;
var
   xVendaProdDAO : TVendaProdDAO;
begin
   try
      try
         Result      := nil; // � nil pois n�o � do tipo boolean

         xVendaProdDAO := TVendaProdDAO.Create(TConexao.getInstance.getConn);
         Result      := xVendaProdDAO.Retorna(RetornaCondicaoVendaProd(pID));

      finally
         if (xVendaProdDAO <> nil ) then
            FreeAndNil(xVendaProdDAO);
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

constructor TVendaProdController.Create;
begin
       inherited Create;
end;

function TVendaProdController.ExcluiVendaProd(
  pVendaProd: TVendaProd): Boolean;
var
   xVendaProdDAO : TVendaProdDAO;
begin

   try
   try
      Result := True;

      TConexao.get.iniciaTransacao;

      xVendaProdDAO := TVendaProdDAO.Create(TConexao.get.getConn);

      if (pVendaProd.Id = 0) then
         Exit
      else
      begin
         xVendaProdDAO.Deleta(RetornaCondicaoVendaProd(pVendaProd.Id))
      end;

      TConexao.get.confirmaTransacao;

      Result := False;

   finally

      if xVendaProdDAO <> nil then
         FreeAndNil(xVendaProdDAO);
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

class function TVendaProdController.getInstancia: TVendaProdController;
begin
   if _instance = nil then
       _instance := TVendaProdController.Create;

    Result := _instance;
end;

function TVendaProdController.GravaVendaProd(
  pVendaProd: TVendaProd): Boolean;
var
  xVendaProdDAO : TVendaProdDAO;
  xAux        : Integer;
begin
   try
        try
            TConexao.get.iniciaTransacao;
            Result := False;

            xVendaProdDAO :=
              TVendaProdDao.Create(TConexao.get.getConn);

            if pVendaProd.Id = 0 then
            begin
                xVendaProdDAO.Insere(pVendaProd);
            end
            else
            begin
               xVendaProdDAO.Atualiza(pVendaProd, RetornaCondicaoVendaProd(pVendaProd.Id));
            end;

            TConexao.get.confirmaTransacao;

        finally
            if xVendaProdDAO <> nil then
               FreeAndNil(xVendaProdDAO);
        end;
   except
        on E: Exception do
        begin
          TConexao.get.cancelaTransacao;
          Raise Exception.Create(
              'Falha ao cadastrar os dados da Venda [Controller]. '#13+
              e.Message);
        end;

   end;
end;

function TVendaProdController.PesquisaVendaProd(
  pNome: string): TColVendaProd;
var
   xVendaProdDAO : TVendaProdDAO;
   xCondicao   : string;
begin
//   try
//      try
//         Result := nil;
//
//         xVendaProdDAO := TVendaProdDAO.Create(TConexao.get.getConn);
//
//         xCondicao  :=
//            IfThen( pNome <> EmptyStr,
//               'WHERE                                           '#13+
//               '    (DESCRICAO LIKE UPPER(''%'+ pNome + '%''))  '#13+
//               'ORDER BY DESCRICAO, ID', EmptyStr);
//
//         Result := xVendaProd.RetornaLista(xCondicao);
//
//      finally
//         if (xVendaProdDAO <> nil) then
//            (FreeAndNil(xVendaProdDAO));
//      end;
//   except
//      on E: Exception do
//      begin
//         raise Exception.Create(
//            'Falha ao buscas os dados do produto [Controller]: '#13+
//            e.Message);
//      end;
//   end;
end;

function TVendaProdController.RetornaCondicaoVendaProd(
  pID_VendaProd: Integer): String;
var
  xChave : string;
begin
   xChave := 'ID';

   Result :=
      'WHERE                                                    '#13+
      '   '+xChave + ' = '+ QuotedStr(IntToStr(pID_VendaProd))+ ' '#13;
end;

end.
