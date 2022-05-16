unit UVendaProdView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, DB, DBClient, Grids, DBGrids, StdCtrls,
  Mask, Buttons, uMessageUtil, UEnumerationUtil, NumEdit, UCliente,
  UCadProdutoPesqView, UPessoaController, UVendaProd, UVendaProdController,
  UComercio, UGridVenda, UClassFuncoes, frxClass, frxDBSet, UVendaProdPesqView;

type
  TfrmVendaProd = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlInfo: TPanel;
    pnlBotoes: TPanel;
    btnConsultar: TBitBtn;
    btnSair: TBitBtn;
    btnPesquisar: TBitBtn;
    btnAlterar: TBitBtn;
    lblNumeroPedido: TLabel;
    edtNumeroPedido: TEdit;
    lblCliente: TLabel;
    edtNumeroCliente: TEdit;
    edtNomeCliente: TEdit;
    Label1: TLabel;
    lblData: TLabel;
    GroupBox1: TGroupBox;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnLimpar: TBitBtn;
    btnIncluir: TBitBtn;
    dbgVenda: TDBGrid;
    dtsVenda: TDataSource;
    cdsVenda: TClientDataSet;
    cdsVendaID: TIntegerField;
    cdsVendaDescricao: TStringField;
    cdsVendaQuantidade: TIntegerField;
    cdsVendaPreco: TFloatField;
    btnMaisProduto: TBitBtn;
    edtValorTotal: TNumEdit;
    Label2: TLabel;
    edtDataPedido: TEdit;
    SpeedButton1: TSpeedButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtNumeroClienteExit(Sender: TObject);
    procedure dbgVendaKeyPress(Sender: TObject; var Key: Char);
    procedure dbgVendaDblClick(Sender: TObject);
    procedure dbgVendaExit(Sender: TObject);
    procedure btnMaisProdutoClick(Sender: TObject);
    procedure edtNumeroPedidoExit(Sender: TObject);
    procedure cdsVendaAfterDelete(DataSet: TDataSet);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnConsultarExit(Sender: TObject);
  private
    { Private declarations }

    vKey : Word;

    //Variaveis de Classe
    vEstadoTela : TEstadoTela;
    vObjCliente : TCliente;

    vObjVendaProd : TVendaProd;
    vObjColGridVenda : TColGridVenda;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimparTela;
    procedure DefineEstadoTela;
    procedure CarregaDadosCliente;
    procedure CarregaDadosTela;

    //Parte da pesquisa
    procedure ProcessaConfirmacaoPesq;
    procedure ProcessaPesquisaEntrada;

    function  DadosProduto          : Boolean;
    function  ProcessaConfirmacao   : Boolean;
    function  ProcessaInclusao      : Boolean;
    function  ProcessaAlteracao     : Boolean;
    function  ProcessaVendaProd     : Boolean;
    function  ProcessaVenda         : Boolean;
    function  ProcessaGridVenda     : Boolean;
    function  ValidaVenda           : Boolean;
    function  ProcessaConsulta      : Boolean;
    function  ProcessaConsultaVenda : Boolean;

    function  ValorTotalPreco      : Currency;

  public
    { Public declarations }
    mProdutoID        : Integer;
    mProdutoDescricao : String;
   // mProdutoEstoque   : Integer;
    mProdutoPreco     : Double;
  end;

var
  frmVendaProd: TfrmVendaProd;

implementation

{$R *.dfm}

procedure TfrmVendaProd.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;
   case vKey of
      VK_RETURN: //Tecla <Enter>
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

procedure TfrmVendaProd.CamposEnabled(pOpcao: Boolean);
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled     := pOpcao;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Enabled := pOpcao;

      if (Components[i] is TNumEdit) then
         (Components[i] as TNumEdit).Enabled  := pOpcao;
   end;
end;


procedure TfrmVendaProd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action       := caFree;
   frmVendaProd := nil;
end;

procedure TfrmVendaProd.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text     := EmptyStr;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Text := EmptyStr ;

      if (Components[i] is TNumEdit) then
         (Components[i] as TNumEdit).Text  := EmptyStr;
   end;
   if (not cdsVenda.IsEmpty) then
      (cdsVenda.EmptyDataSet);
end;

procedure TfrmVendaProd.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);
   //btnExcluir.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etConsultar];

   btnCancelar.Enabled  :=
      vEstadoTela in [etIncluir, etAlterar, etConsultar];

   case vEstadoTela of

      etPadrao:
      begin
         CamposEnabled(False);
         LimparTela;
         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[0].Text := EmptyStr;
         edtDataPedido.Text := DateToStr(Date);

         if (frmVendaProd <> nil) and
            (frmVendaProd.Active) and
            (btnIncluir.CanFocus) then
            (btnIncluir.SetFocus);

         Application.ProcessMessages;
      end;

      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Inclusão de Venda';
         edtDataPedido.Text      := DateToStr(Date);
         CamposEnabled(True);
         dbgVenda.Enabled        := True;
         edtNumeroPedido.Enabled := False;
         edtDataPedido.Enabled   := False;
         edtValorTotal.Enabled   := False;

         btnMaisProduto.Enabled := True;

         if (edtNumeroCliente.CanFocus) then
            (edtNumeroCliente.SetFocus);
      end;

      etAlterar:
      begin
         stbBarraStatus.Panels[0].Text := 'Alteração';
         edtDataPedido.Text     := DateToStr(Date);
         dbgVenda.Enabled       := True;
         btnMaisProduto.Enabled := True;
         edtDataPedido.Enabled  := False;

         if (edtNumeroPedido.Text <> EmptyStr) then
         begin
            CamposEnabled(True);
            edtNumeroPedido.Enabled := False;
            btnAlterar.Enabled      := False;
            btnConfirmar.Enabled    := True;
            edtDataPedido.Enabled   := False;

            if (edtNumeroCliente.CanFocus) then
               (edtNumeroCliente.SetFocus);

            edtNumeroCliente.Enabled := False;
            edtNomeCliente.Enabled := False;
         end
         else
         begin
            edtNumeroPedido.Enabled := True;
            edtDataPedido.Enabled   := False;

            if (edtNumeroPedido.CanFocus) then
               (edtNumeroPedido.SetFocus);
         end;
      end;

      etPesquisar:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisa';
         edtDataPedido.Text := DateToStr(Date);

         if (frmVendaPesq = nil) then
             frmVendaPesq := TfrmVendaPesq.Create(nil);

         frmVendaPesq.ShowModal;


         if (frmVendaPesq.mVendaID <> EmptyStr) then
         begin
            edtNumeroPedido.Text := (frmVendaPesq.mVendaID);
            vEstadoTela    := etConsultar;
            ProcessaConsulta;
         end
         else
         begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
         end;

         frmVendaPesq.mVendaID := EmptyStr;
         //frmVendaPesq.mNomeCliente := EmptyStr;
         frmVendaPesq.mValorTotal := 0;
         frmVendaPesq.mDataVenda := 0;

      end;

      etConsultar:
      begin
         stbBarraStatus.Panels[0].Text := 'Consulta';
         edtDataPedido.Text := DateToStr(Date);
         dbgVenda.Enabled := False;
         CamposEnabled(False);

         if (edtNumeroPedido.Text <> EmptyStr) then
         begin
            edtNumeroPedido.Enabled := False;
            btnAlterar.Enabled      := True;
            btnConfirmar.Enabled    := False;

            if (btnAlterar.CanFocus) then
               (btnAlterar.SetFocus);
         end
         else
         begin
            edtNumeroPedido.Enabled := True;

            if (edtNumeroPedido.CanFocus) then
               (edtNumeroPedido.SetFocus);
         end;
      end;

   end;
end;

procedure TfrmVendaProd.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmVendaProd.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmVendaProd.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmVendaProd.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmVendaProd.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmVendaProd.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
   btnMaisProduto.Enabled := False;
end;

procedure TfrmVendaProd.btnLimparClick(Sender: TObject);
begin
   LimparTela;
   //DefineEstadoTela;
   btnMaisProduto.Enabled := False;
end;

procedure TfrmVendaProd.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin

      if (TMessageUtil.Pergunta(
         'Deseja realmente sair desaa rotina?')) then
      begin

         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end;
   end
   else
      close;
end;

procedure TfrmVendaProd.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmVendaProd.CarregaDadosCliente;
begin

   if (vObjCliente = nil) then
      Exit;

   edtNumeroCliente.Text  := IntToStr(vObjCliente.Id);
   edtNomeCliente.Text    := vObjCliente.Nome;

end;

procedure TfrmVendaProd.edtNumeroClienteExit(Sender: TObject);
begin
  if vKey = VK_RETURN then
        ProcessaConsulta;
    vKey := VK_CLEAR;

   if btnMaisProduto.CanFocus then
      btnMaisProduto.SetFocus;
end;

function TfrmVendaProd.ProcessaConfirmacao: Boolean;
begin
   Result := False;

   try
      case vEstadoTela of
         etIncluir   : Result    := ProcessaInclusao;
         etAlterar   : Result    := ProcessaAlteracao;
         //etExcluir   : Result    := ProcessaExclusao;
         etConsultar : Result    := ProcessaConsultaVenda;
      end;

      if not Result then
         Exit;
   except
      on E: Exception do
         TMessageUtil.Alerta(E.Message);
   end;

   Result := True;
end;

function TfrmVendaProd.ProcessaConsulta: Boolean;
begin

   try
      Result := False;

      if (edtNumeroCliente.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Código do cliente não pode ficar em branco.');

         if edtNumeroCliente.CanFocus then
            edtNumeroCliente.SetFocus;

         Exit;
      end;

      vObjCliente :=
         TCliente(TPessoaController.getInstancia.BuscaPessoa(
            StrToIntDef(edtNumeroCliente.Text, 0)));

      if (vObjCliente <> nil) then
         CarregaDadosCliente
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum cliente encontrado para o código informado. '#13 +
            'Confirme o código do cliente ou cadastre caso necessário. '#13+
            'Cadastro -> Clientes');

         LimparTela;

         if (edtNumeroCliente.CanFocus) then
            (edtNumeroCliente.SetFocus);

         Exit;
      end;

      DefineEstadoTela;
      Result := True;

      if dbgVenda.CanFocus then
         dbgVenda.Setfocus;

   except
        on E: Exception do
        begin
          raise Exception.Create(
              'Falha ao consultar os dados do cliente [View]. '#13+
              e.Message);
        end;
   end;
end;

procedure TfrmVendaProd.dbgVendaKeyPress(Sender: TObject; var Key: Char);
begin
   if (vKey = 13) and (dbgVenda.SelectedIndex = 0) then
   begin
      DadosProduto;
   end;
end;

procedure TfrmVendaProd.ProcessaConfirmacaoPesq;
begin
   //ProcessaConfirmaçãoPesq
end;

procedure TfrmVendaProd.ProcessaPesquisaEntrada;
begin
   //Pesq.Entrad.
end;

procedure TfrmVendaProd.dbgVendaDblClick(Sender: TObject);
begin
   //ProcessaConfirmacaoPesq;
end;

procedure TfrmVendaProd.dbgVendaExit(Sender: TObject);
begin
   //ProcessaConfirmacaoPesq;
end;

function TfrmVendaProd.DadosProduto: Boolean;
//var
//   PrimeiroNumero, SegundoNumero, Resultado : Double;
begin
   if (vKey = 13) and (dbgVenda.SelectedIndex = 0) then
   try
      Screen.Cursor  := crHourGlass;
      if frmCadProdutoPesq = nil then
      frmCadProdutoPesq := TfrmCadProdutoPesq.Create(Application);
      frmCadProdutoPesq.ShowModal;
   finally
      Screen.Cursor := crDefault;
   end;

   if (frmCadProdutoPesq.mProdutoID <> 0) then
   begin
      cdsVenda.Insert;
      cdsVendaID.Value         := frmCadProdutoPesq.mProdutoID;
      cdsVendaDescricao.Text   := frmCadProdutoPesq.mProdutoDescricao;
      cdsVendaQuantidade.Value := 1;
      cdsVendaPreco.Value      := frmCadProdutoPesq.mProdutoPreco;
      cdsVenda.Post;

//      PrimeiroNumero := StrToFloat(dbgVenda.columns.items[3].field.text);
//      Resultado := 0;
//      SegundoNumero := edtValorTotal.Value;
//      Resultado := (PrimeiroNumero) + SegundoNumero;
//      edtValorTotal.Value := (Resultado);
//      ValorTotalColuna;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhum produto foi selecionado. ');
   end;
   btnMaisProduto.Enabled := True;
   ValorTotalPreco;
   if btnMaisProduto.CanFocus then
      btnMaisProduto.SetFocus;
end;

procedure TfrmVendaProd.btnMaisProdutoClick(Sender: TObject);
begin
   try
      Screen.Cursor  := crHourGlass;
      if frmCadProdutoPesq = nil then
         frmCadProdutoPesq := TfrmCadProdutoPesq.Create(Application);
      frmCadProdutoPesq.ShowModal;
   finally
      Screen.Cursor := crDefault;
   end;

   if (frmCadProdutoPesq.mProdutoID <> 0) then
   begin

      cdsVenda.Insert;

      cdsVendaID.Value         := frmCadProdutoPesq.mProdutoID;
      cdsVendaDescricao.Text   := frmCadProdutoPesq.mProdutoDescricao;
      cdsVendaQuantidade.Value := 1;
      cdsVendaPreco.Value      := frmCadProdutoPesq.mProdutoPreco;

      cdsVenda.Post;
//      PrimeiroNumero := StrToFloat(dbgVenda.columns.items[3].field.text);
//      Resultado := 0;
//      SegundoNumero := edtValorTotal.Value;
//      Resultado := (PrimeiroNumero) + SegundoNumero;
//      edtValorTotal.Value := (Resultado);
//      ValorTotalColuna;

   end
   else
   begin
      TMessageUtil.Alerta('Nenhum produto foi selecionado. ');
   end;

   ValorTotalPreco;

//   DadosProduto;

end;

function TfrmVendaProd.ProcessaInclusao: Boolean;
begin

   try
      Result := False;
      if ProcessaVendaProd then
      begin
         TMessageUtil.Informacao('Venda cadastrada com sucesso.'#13+
            'Código cadastrado: '+ IntToStr(vObjVendaProd.Id));
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Result := True;
      end;
   except
      on E: Exception do
      begin
          Raise Exception.Create(
            'Falha ao incluir os dados da Venda [View]: '#13+
            e.Message);
      end;
   end;
end;

function TfrmVendaProd.ProcessaVendaProd: Boolean;
begin
   try
      Result := False;
      if (ProcessaVenda) and
         (ProcessaGridVenda) then
      begin
        // Gravação no Banco de dados
         TVendaProdController.getInstancia.GravaVendaProd(
         vObjVendaProd, vObjColGridVenda);
         Result := True;
      end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao gravar os dados da Venda [View]. '#13+
            e.Message);
      end;
   end;
end;

function TfrmVendaProd.ProcessaVenda: Boolean;
begin
   try
        Result := False;
       if not ValidaVenda then
            Exit;
        if vEstadoTela = etIncluir then
        begin
            if vObjVendaProd  = nil then
               vObjVendaProd := TVendaProd.Create;
        end
        else
        if vEstadoTela = etAlterar then
        begin
            if vObjVendaProd = nil then
                Exit;
        end;

        if (vObjVendaProd = nil) then
            Exit;
        vObjVendaProd.DataVenda  := StrToDate(edtDataPedido.Text);
        vObjVendaProd.TotalVenda := StrToFloat(edtValorTotal.Text);
        vObjVendaProd.Id_Cliente := StrToInt(edtNumeroCliente.Text);
        //vObjVendaProd. := StrToInt(edtEstoque.Text);
        Result := True;
   except
    on E: Exception do
        begin
            Raise Exception.Create(
              'Falha ao gravar os dados dessa Venda. [View]: '#13+
              e.Message);
        end;
   end;
end;

procedure TfrmVendaProd.CarregaDadosTela;
var
   i : Integer;
begin
   if (vObjVendaProd = nil) then
      Exit;
   edtNumeroPedido.Text  := IntToStr(vObjVendaProd.Id);
   edtNumeroCliente.Text := IntToStr(vObjVendaProd.Id_Cliente);
   edtDataPedido.Text    := DateToStr(vObjVendaProd.DataVenda);
   edtValorTotal.Value   := (vObjVendaProd.TotalVenda);
   if (vObjColGridVenda <> nil) then
   begin
      cdsVenda.First;
      for i := 0 to pred(vObjColGridVenda.Count) do
      begin

         cdsVenda.Edit;

         cdsVendaID.Value         := vObjColGridVenda.Retorna(i).Id;
         cdsVendaPreco.Value      := vObjColGridVenda.Retorna(i).ValorUnitario;
         cdsVendaDescricao.Text   := vObjColGridVenda.Retorna(i).Descricao;
         cdsVendaQuantidade.Value := vObjColGridVenda.Retorna(i).Quantidade;

         ProcessaConsulta;

         cdsVenda.Append;
      end;
   end;
end;

function TfrmVendaProd.ValidaVenda: Boolean;
begin
   Result := False;
   if (edtNumeroCliente.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'O Campo do numero do cliente.');

      if edtNumeroCliente.CanFocus then
         edtNumeroCliente.SetFocus;
         Exit;
   end;
    Result := True;
end;

function TfrmVendaProd.ProcessaGridVenda: Boolean;
var
   xGridVenda  : TGridVenda;
   xID_Venda   : Integer;
begin
   try
      Result := False;
      xGridVenda  := nil;
      xID_Venda   := 0;

      if (vObjColGridVenda <> nil) then
        FreeAndNil(vObjColGridVenda);
      vObjColGridVenda := TColGridVenda.Create;

      if (vEstadoTela = etAlterar) then
          xID_Venda  := StrToIntDef(edtNumeroPedido.Text, 0);

      cdsVenda.First;
      while  not cdsVenda.Eof do
      begin
         xGridVenda               := TGridVenda.Create;
         xGridVenda.ID_Venda      := xID_Venda;
         xGridVenda.ID_Produto    := cdsVendaID.Value;
         xGridVenda.Descricao     := cdsVendaDescricao.Text;
         xGridVenda.Quantidade    := cdsVendaQuantidade.Value;
         xGridVenda.ValorUnitario := cdsVendaPreco.Value;
         vObjColGridVenda.Add(xGridVenda);
         cdsVenda.Next;
      end;
      Result := True;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
         'Falha ao preencher os dados da venda do Grid [View]. '#13+
         e.Message);
      end;
   end;
end;

function TfrmVendaProd.ProcessaConsultaVenda: Boolean;
begin
   try
        Result := False;
        if (edtNumeroPedido.Text = EmptyStr) then
        begin
            TMessageUtil.Alerta(
               'Código do numero da venda não pode ficar em branco.');
            if edtNumeroPedido.CanFocus then
               edtNumeroPedido.SetFocus;
            Exit;
        end;

        vObjVendaProd    :=
             TVendaProd(TVendaProdController.getInstancia.BuscaVendaProd(
                  StrToIntDef(edtNumeroPedido.Text, 0)));

        vObjColGridVenda :=
             TVendaProdController.getInstancia.BuscaGridVenda(
                  StrToIntDef(edtNumeroPedido.Text, 0));

        if (vObjVendaProd <> nil) then
            CarregaDadosTela
        else
        begin
            TMessageUtil.Alerta(
              'Nenhuma venda encontrada para o código informado.');
            LimparTela;
            if (edtNumeroPedido.CanFocus) then
               (edtNumeroPedido.SetFocus);
            Exit;
        end;
        DefineEstadoTela;
        Result := True;
   except
        on E: Exception do
        begin
          raise Exception.Create(
              'Falha ao consultar os dados da venda [View]. '#13+
              e.Message);
        end;
   end;
end;

procedure TfrmVendaProd.edtNumeroPedidoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
        ProcessaConsultaVenda;
    vKey  := VK_CLEAR;
end;

function TfrmVendaProd.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;
      if ProcessaVendaProd then
      begin
         TMessageUtil.Informacao('Dados alterados com sucesso.');
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Result := True;
      end;
   except
      on E: Exception do
      begin
          raise Exception.Create(
              'Falha ao alterar os dados do cliente [View]: '#13+
              e.Message);
      end;
   end;
end;

function TfrmVendaProd.ValorTotalPreco: Currency;
var
   xtotal : Currency;
   xPosic : Integer;
begin
   xTotal := 0;
   xPosic := cdsVenda.RecNo;
   cdsVenda.DisableControls;
   try
      cdsVenda.First;
      while not cdsVenda.EOF do
      begin
         xTotal := xTotal + cdsVenda.FieldByName('Preco').AsCurrency;
         cdsVenda.Next;
      end;
      cdsVenda.RecNo     := xPosic;
      edtValorTotal.Text := FormatFloat('#,0.00', xTotal);
   finally
      cdsVenda.EnableControls;
   end;
end;

procedure TfrmVendaProd.cdsVendaAfterDelete(DataSet: TDataSet);
begin
   //cdsVenda.Refresh;
   ValorTotalPreco;
end;

procedure TfrmVendaProd.SpeedButton1Click(Sender: TObject);
begin
   TMessageUtil.Informacao(
   'Para deletar um produto da venda, basta selecionar a linha do produto e '#13+
   'utilizar as teclas Ctrl + Shift + Del  ao mesmo tempo.'#13+
   'Essa função de deletar um produto, serve no modo de inclusão ou no de   '#13+
   'alteração das vendas.                                                   '#13+
   'Lembrando que essa ação é irreversível.');
end;

procedure TfrmVendaProd.btnConsultarExit(Sender: TObject);
begin
   if btnAlterar.CanFocus then
      btnAlterar.SetFocus;
end;

end.
