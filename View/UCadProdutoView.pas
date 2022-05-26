unit UCadProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, UEnumerationUtil, frxClass,
  DB, frxDBSet, UClassFuncoes, uMessageUtil, UCadProduto, UCadProdutoDAO,
  UCadProdutoController, UMercadoria, NumEdit;

type
  TfrmCadProduto = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlInfo: TPanel;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    lblPreco: TLabel;
    lblEstoque: TLabel;
    edtEstoque: TEdit;
    lblDescricao: TLabel;
    edtDescricao: TEdit;
    btnSair: TBitBtn;
    btnCancelar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnPesquisar: TBitBtn;
    Label1: TLabel;
    edtPreco: TNumEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCodigoExit(Sender: TObject);
    procedure edtPrecoExit(Sender: TObject);
    procedure edtEstoqueKeyPress(Sender: TObject; var Key: Char);
    procedure edtDescricaoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    vKey : Word;

    // Variaveis de Classe

    vEstadoTela : TEstadoTela;
    vObjCadProduto : TCadProduto;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;

    procedure CarregaDadosTela;

    function  ProcessaConfirmacao  : Boolean;
    function  ProcessaInclusao     : Boolean;
    function  ProcessaConsulta     : Boolean;
    function  ProcessaCadProduto   : Boolean;
    function  ProcessaAlteracao    : Boolean;
    function  ProcessaExclusao     : Boolean;

    function ValidateField(var Key: Char; TipoFiltro: Byte = 0) : Boolean;


    function  ProcessaUnidade     : Boolean;
    function  ValidaProduto       : Boolean;

  public
    { Public declarations }
  end;

var
  frmCadProduto: TfrmCadProduto;

implementation

uses UCadProdutoPesqView;

{$R *.dfm}


procedure TfrmCadProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

   vKey := Key;

   case vKey of

      VK_RETURN: //Corresponde a tecla <ENTER>
      begin
         Perform(WM_NEXTDlgCtl, 0, 0);
      end;

      VK_ESCAPE:
      begin
         if (vEstadoTela <> etPadrao)then
         begin

             if (TMessageUtil.Pergunta(
               'Deseja realmente sair cancelar essa operação? ')) then
             begin
               vEstadoTela := etPadrao;
               DefineEstadoTela;
             end;

         end
         else
         begin

            if (TMessageUtil.Pergunta(
               'Deseja sair dessa rotina?' ))then
               Close;

         end;
      end;
   end;
end;

procedure TfrmCadProduto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action        := caFree;
   frmCadProduto := nil;
end;

procedure TfrmCadProduto.CamposEnabled(pOpcao: Boolean);
var
   i : Integer;
begin

   for i := 0 to pred(ComponentCount) do
   begin

      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

      if (Components[i] is TNumEdit) then
         (Components[i] as TNumEdit).Enabled := pOpcao;

   end;
end;

procedure TfrmCadProduto.LimpaTela;
var
   i : Integer;
begin

   for i := 0 to pred(ComponentCount) do
   begin

      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;

      if (Components[i] is TNumEdit) then
         (Components[i] as TNumEdit).Text := EmptyStr;

   end;

   if (vObjCadProduto <> nil) then
      FreeAndNil(vObjCadProduto);
end;

procedure TfrmCadProduto.DefineEstadoTela;
begin

   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled    := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir ,etConsultar];

   btnCancelar.Enabled  :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   case vEstadoTela of

      etPadrao:
      begin

         CamposEnabled(False);
         LimpaTela;

         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[0].Text := EmptyStr;

         if (frmCadProduto <> nil) and
            (frmCadProduto.Active) and
            (btnIncluir.CanFocus)  then
            (btnIncluir.SetFocus);

         Application.ProcessMessages;
      end;

      etIncluir:
      begin

         stbBarraStatus.Panels[0].Text := 'Inclusão';
         CamposEnabled(True);

         edtCodigo.Enabled := False;

         if (edtDescricao.CanFocus) then
            (edtDescricao.SetFocus);

      end;

      etAlterar:
      begin

         stbBarraStatus.Panels[0].Text := 'Alteração';

         if (edtCodigo.Text <> EmptyStr) then
         begin

            CamposEnabled(True);

            edtCodigo.Enabled    := False;
            btnAlterar.Enabled   := False;
            btnConfirmar.Enabled := True;

            if (edtDescricao.CanFocus) then
               (edtDescricao.SetFocus);

         end
         else
         begin

            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if (edtCodigo.CanFocus) then
               (edtCodigo.SetFocus);

         end;
      end;

      etExcluir:
      begin

         stbBarraStatus.Panels[0].Text := 'Exclusão';

         if (edtCodigo.Text <> EmptyStr) then
            ProcessaExclusao
         else
         begin

            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if (edtCodigo.CanFocus) then
               (edtCodigo.SetFocus);

         end;
      end;

      etConsultar:
      begin
         stbBarraStatus.Panels[0].Text := 'Consulta';

         CamposEnabled(False);

         if (edtCodigo.Text <> EmptyStr) then
         begin

            edtCodigo.Enabled         := False;
            btnAlterar.Enabled        := True;
            btnExcluir.Enabled        := True;
            btnConfirmar.Enabled      := False;

            if (btnAlterar.CanFocus) then
               (btnAlterar.SetFocus);
         end
         else
         begin

            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if (edtCodigo.CanFocus) then
               (edtCodigo.SetFocus);

         end;
      end;

      etPesquisar:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisa';

            if (frmCadProdutoPesq = nil ) then
                frmCadProdutoPesq := TfrmCadProdutoPesq.Create(Application);

            frmCadProdutoPesq.ShowModal;

            if (frmCadProdutoPesq.mProdutoID <> 0) then
            begin
               edtCodigo.Text := IntToStr(frmCadProdutoPesq.mProdutoID);
               vEstadoTela    := etConsultar;
               ProcessaConsulta;
            end
            else
            begin
               vEstadoTela := etPadrao;
               DefineEstadoTela;
            end;

            frmCadProdutoPesq.mProdutoID        := 0;
            frmCadProdutoPesq.mProdutoDescricao := EmptyStr;

            if edtDescricao.CanFocus then
               edtDescricao.SetFocus;
      end;

   end;
end;

procedure TfrmCadProduto.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmCadProduto.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmCadProduto.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmCadProduto.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmCadProduto.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmCadProduto.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmCadProduto.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmCadProduto.btnSairClick(Sender: TObject);
begin

   if (vEstadoTela <> etPadrao) then
      begin
         if (TMessageUtil.Pergunta(
            'Deseja realmente fechar essa tela?')) then
         begin

            vEstadoTela := etPadrao;
            DefineEstadoTela;

         end;
      end
   else
      Close;

end;

procedure TfrmCadProduto.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

function TfrmCadProduto.ProcessaConfirmacao: Boolean;
begin
   Result := False;

   try
      case vEstadoTela of
          etIncluir   : Result    := ProcessaInclusao;
          etAlterar   : Result    := ProcessaAlteracao;
          //etExcluir   : Result    := ProcessaExclusao;
          etConsultar : Result    := ProcessaConsulta;
      end;

      if not Result then
         Exit;
   except
      on E: Exception do
         TMessageUtil.Alerta(E.Message);
   end;

   Result := True;

end;

function TfrmCadProduto.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaCadProduto then
      begin

         TMessageUtil.Informacao('Produto cadastrado com sucesso.'#13+
            'Código cadastrado: '+ IntToStr(vObjCadProduto.Id));

         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;

      end;

   except
      on E: Exception do
      begin
          Raise Exception.Create(
            'Falha ao incluir os dados do produto [View]: '#13+
            e.Message);
      end;
   end;

end;

function TfrmCadProduto.ProcessaCadProduto: Boolean;
begin
   try

      Result := False;
      if (ProcessaUnidade) then
      begin
        // Gravação no Banco de dados
         TCadProdutoController.getInstancia.GravaCadProduto(vObjCadProduto);

         Result := True;
      end;

   except

      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao gravar os dados do produto [View]. '#13+
            e.Message);
      end;

   end;
end;

function TfrmCadProduto.ProcessaUnidade: Boolean;
begin
   try
        Result := False;

       if not ValidaProduto then
            Exit;

        if vEstadoTela = etIncluir then
        begin
            if vObjCadProduto = nil then
               vObjCadProduto := TCadProduto.Create;
        end
        else
        if vEstadoTela = etAlterar then
        begin
            if vObjCadProduto = nil then
                Exit;
        end;

        if (vObjCadProduto = nil) then
            Exit;

        vObjCadProduto.Descricao := edtDescricao.Text;
        vObjCadProduto.Precovenda := StrToFloat(edtPreco.Text);
        vObjCadProduto.Estoque := StrToInt(edtEstoque.Text);


        Result := True;

   except

    on E: Exception do
        begin
            Raise Exception.Create(
              'Falha ao gravar os dados dessa Unidade [View]: '#13+
              e.Message);
        end;
        
   end;
end;

function TfrmCadProduto.ValidaProduto: Boolean;
begin

   Result := False;

   if (edtDescricao.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'O Campo da descrição não pode ficar em branco.');

      if edtDescricao.CanFocus then
         edtDescricao.SetFocus;
         Exit;
   end;

   if (edtPreco.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'O Campo do preço não pode ficar em branco.');

      if edtPreco.CanFocus then
         edtPreco.SetFocus;
         Exit;
   end;

   if (edtEstoque.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'O Campo do estoque não pode ficar em branco.');

      if edtEstoque.CanFocus then
         edtEstoque.SetFocus;
         Exit;
   end;

    Result := True;

end;

function TfrmCadProduto.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtCodigo.Text = EmptyStr ) then
      begin
         TMessageUtil.Alerta('Código do produto não pode ficar em branco.');

         if edtCodigo.CanFocus then
            edtCodigo.SetFocus;

         Exit;
      end;

      vObjCadProduto :=
         TCadProduto(TCadProdutoController.getInstancia.BuscaCadProduto(
            StrToIntDef(edtCodigo.Text, 0)));

      if (vObjCadProduto <> nil) then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum produto foi encontrado para o código informado.');

         LimpaTela;

         if (edtCodigo.CanFocus) then
            (edtCodigo.SetFocus);

         Exit;
      end;

      DefineEstadoTela; // Para liberar os campos

      Result := True;

   except
      on E: Exception do
      begin
         raise Exception.Create(
            'Falha ao consultar os dados do produto [View]. '#13+
             e.Message);
      end;
   end;
end;

procedure TfrmCadProduto.CarregaDadosTela;
begin
   if (vObjCadProduto = nil) then
      Exit;

   edtPreco.Text  := FormatFloat('#0.00',vObjCadProduto.Precovenda);

   edtCodigo.Text    := IntToStr(vObjCadProduto.Id);
   edtDescricao.Text := vObjCadProduto.Descricao;
   //edtPreco.Text   := FloatToStr(vObjCadProduto.Precovenda);
   edtEstoque.Text   := IntToStr(vObjCadProduto.Estoque);

end;

procedure TfrmCadProduto.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      ProcessaConsulta;

   vKey := VK_CLEAR;
end;

function TfrmCadProduto.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if ProcessaCadProduto then
      begin
         TMessageUtil.Informacao('Dados do produto alterados com sucesso.');

         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Result := True;
      end;

   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao alterar os dados do produto [View]: '#13+
            e.Message);
      end;
   end;
end;

function TfrmCadProduto.ProcessaExclusao: Boolean;
begin
   try

      Result := False;

      if (vObjCadProduto = nil) then
      begin
         TMessageUtil.Alerta(
            'Não foi possivel carregar os dados cadastrados do produto.');

         LimpaTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Exit;
      end;

      try
         if TMessageUtil.Pergunta('Deseja mesmo excluir esse produto?') then
         begin
            Screen.Cursor := crHourGlass;
            TCadProdutoController.getInstancia.ExcluiCadProduto(vObjCadProduto);
         end
         else
         begin
            LimpaTela;
            vEstadoTela   := etPadrao;
            DefineEstadoTela;
            Exit;
         end;
      finally
         Screen.Cursor    := crDefault;
         Application.ProcessMessages;
      end;

      Result := True;
      TMessageUtil.Informacao('O produto foi excluído com sucesso');
      LimpaTela;
      vEstadoTela := etPadrao;
      DefineEstadoTela;

   except

   on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao excluir os dados do produto '#13+
            e.Message);
      end;

   end;

end;

procedure TfrmCadProduto.edtPrecoExit(Sender: TObject);
begin

   if (edtPreco.Value < 0 ) then
   begin
      TMessageUtil.Alerta(
         'O Campo do preço não pode ser negativo.');

      edtPreco.Text := EmptyStr;

      if edtPreco.CanFocus then
         edtPreco.SetFocus;
   end;

   if (edtPreco.Value = 0 ) then
   begin
      TMessageUtil.Alerta(
         'O Campo do preço não pode ser igual a zero.');

      edtPreco.Text := EmptyStr;

      if edtPreco.CanFocus then
         edtPreco.SetFocus;
   end;

end;

function TfrmCadProduto.ValidateField(var Key: Char;
  TipoFiltro: Byte): Boolean;
function IsDigit(Key : Char) : Boolean;
   begin
      Result := (Key in ['0'..'9']);
   end;
begin

   if not (Key in [#8, #37, #38, #39, #40, #46]) then
   case TipoFiltro of

      2 : if not (IsDigit(Key)) then Key := #0;

   else
        raise Exception.Create('Tipo de filtro inválido.');
   end;

  Result := (not (Key = #0));

end;

procedure TfrmCadProduto.edtEstoqueKeyPress(Sender: TObject;
  var Key: Char);
begin

   ValidateField(Key, 2);

end;


procedure TfrmCadProduto.edtDescricaoKeyPress(Sender: TObject;
  var Key: Char);
begin
   if not (Key in['a'..'z','A'..'Z',Chr(8),Chr(32)]) then
      Key:= #0
end;

end.
