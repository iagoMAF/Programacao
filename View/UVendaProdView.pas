unit UVendaProdView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, DB, DBClient, Grids, DBGrids, StdCtrls,
  Mask, Buttons, uMessageUtil, UEnumerationUtil, NumEdit, UCliente,
  UCadProdutoPesqView, UPessoaController, UVendaProd, UVendaProdController,
  UComercio, UGridVenda, UClassFuncoes, frxClass, frxDBSet;

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

    function  DadosProduto         : Boolean;


    function  ProcessaConfirmacao  : Boolean;
    function  ProcessaInclusao     : Boolean;
    function  ProcessaVendaProd    : Boolean;

    function  ProcessaVenda        : Boolean;
    function  ProcessaGridVenda    : Boolean;

    function  ValidaVenda          : Boolean;

    function  ProcessaConsulta     : Boolean;






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
               'Deseja realmente sair cancelar essa opera��o? ')) then
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

         stbBarraStatus.Panels[0].Text := 'Inclus�o de Venda';
         edtDataPedido.Text := DateToStr(Date);

         CamposEnabled(True);

         edtNumeroPedido.Enabled := False;
         edtDataPedido.Enabled   := False;
         edtValorTotal.Enabled   := False;


         if (edtNumeroCliente.CanFocus) then
            (edtNumeroCliente.SetFocus);

      end;

      etAlterar:
      begin

         stbBarraStatus.Panels[0].Text := 'Altera��o';
         edtDataPedido.Text := DateToStr(Date);

         if (edtNumeroPedido.Text <> EmptyStr) then
         begin

            CamposEnabled(True);
            edtNumeroPedido.Enabled := False;
            btnAlterar.Enabled      := False;
            btnConfirmar.Enabled    := True;

            if (edtNumeroCliente.CanFocus) then
               (edtNumeroCliente.SetFocus);

         end
         else
         begin

            edtNumeroPedido.Enabled := True;

            if (edtNumeroPedido.CanFocus) then
               (edtNumeroPedido.SetFocus);

         end;

      end;

      etPesquisar:
      begin

         stbBarraStatus.Panels[0].Text := 'Pesquisa';
         edtDataPedido.Text := DateToStr(Date);

      end;

      etConsultar:
      begin

         stbBarraStatus.Panels[0].Text := 'Consulta';
         edtDataPedido.Text := DateToStr(Date);

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
   // Click Pesquisar
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

    edtNumeroCliente.Text     := IntToStr(vObjCliente.Id);
    edtNomeCliente.Text       := vObjCliente.Nome;

end;

procedure TfrmVendaProd.edtNumeroClienteExit(Sender: TObject);
begin

  if vKey = VK_RETURN then
        ProcessaConsulta;
    vKey := VK_CLEAR;

end;

function TfrmVendaProd.ProcessaConfirmacao: Boolean;
begin
   //ProcessaConfirmacao
   Result := False;

   try
      case vEstadoTela of
          etIncluir   : Result    := ProcessaInclusao;
         //etAlterar   : Result    := ProcessaAlteracao;
         //etExcluir   : Result    := ProcessaExclusao;
         //etConsultar : Result    := ProcessaConsulta;
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
            TMessageUtil.Alerta('C�digo do cliente n�o pode ficar em branco.');

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
              'Nenhum cliente encontrado para o c�digo informado. '#13 +
              'Confirme o c�digo do cliente ou cadastre caso necess�rio. '#13+
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
   //ProcessaConfirma��oPesq
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
var
   PrimeiroNumero, SegundoNumero, Resultado : Double;
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

      PrimeiroNumero := StrToFloat(dbgVenda.columns.items[3].field.text);
      Resultado := 0;
      SegundoNumero := edtValorTotal.Value;
      Resultado := (PrimeiroNumero) + SegundoNumero;
      edtValorTotal.Value := (Resultado);

   end
   else
   begin
      TMessageUtil.Alerta('Nenhum produto foi selecionado. ');
   end;

//   PrimeiroNumero := StrToFloat(dbgVenda.columns.items[3].field.text);
//   Resultado := 0;
//   SegundoNumero := edtValorTotal.Value;
//   Resultado := (PrimeiroNumero) + SegundoNumero;
//   edtValorTotal.Value := (Resultado);

   btnMaisProduto.Enabled := True;

   if btnMaisProduto.CanFocus then
      btnMaisProduto.SetFocus;

end;

procedure TfrmVendaProd.btnMaisProdutoClick(Sender: TObject);
begin
   DadosProduto;
end;

function TfrmVendaProd.ProcessaInclusao: Boolean;
begin

   try
      Result := False;

      if ProcessaVendaProd then
      begin

         TMessageUtil.Informacao('Venda cadastrado com sucesso.'#13+
            'C�digo cadastrado: '+ IntToStr(vObjVendaProd.Id));

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
        // Grava��o no Banco de dados
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
            if vObjVendaProd = nil then
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
              'Falha ao gravar os dados dessa Unidade [View]: '#13+
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

//   if (edtPreco.Text = EmptyStr) then
//   begin
//      TMessageUtil.Alerta(
//         'O Campo do pre�o n�o pode ficar em branco.');
//
//      if edtPreco.CanFocus then
//         edtPreco.SetFocus;
//         Exit;
//   end;

//   if (edtEstoque.Text = EmptyStr) then
//   begin
//      TMessageUtil.Alerta(
//         'O Campo do estoque n�o pode ficar em branco.');
//
//      if edtEstoque.CanFocus then
//         edtEstoque.SetFocus;
//         Exit;
//   end;

    Result := True;
end;

function TfrmVendaProd.ProcessaGridVenda: Boolean;
var
   xGridVenda  : TGridVenda;
   xID_Venda  : Integer;
begin
   try

      Result := False;

      xGridVenda  := nil;
      xID_Venda   := 0;

      if (vObjColGridVenda <> nil) then
        FreeAndNil(vObjColGridVenda);

      vObjColGridVenda := TColGridVenda.Create;

      if (vEstadoTela = etAlterar) then
          xID_Venda := StrToIntDef(edtNumeroPedido.Text, 0);

      cdsVenda.First;

      while  not cdsVenda.Eof do
      begin
      
         xGridVenda               := TGridVenda.Create;
         xGridVenda.ID_Venda      := xID_Venda;
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
         'Falha ao preencher os dados de endere�o [View]. '#13+
         e.Message);
      end;
   end;
end;

end.
