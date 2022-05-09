unit UVendaProdView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, DB, DBClient, Grids, DBGrids, StdCtrls,
  Mask, Buttons, uMessageUtil, UEnumerationUtil, NumEdit, UCliente,
  UPessoaController;

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
    edtDataPedido: TMaskEdit;
    GroupBox1: TGroupBox;
    dbgVenda: TDBGrid;
    DataSource1: TDataSource;
    cdsVenda: TClientDataSet;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnLimpar: TBitBtn;
    btnIncluir: TBitBtn;
    edtValorTotal: TNumEdit;
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
  private
    { Private declarations }

    vKey : Word;

    //Variaveis de Classe
    vEstadoTela : TEstadoTela;
    vObjCliente : TCliente;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimparTela;
    procedure DefineEstadoTela;

    procedure CarregaDadosCliente;


    function  ProcessaConfirmacao  : Boolean;
    function  ProcessaConsulta     : Boolean;


  public
    { Public declarations }
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

         if (frmVendaProd <> nil) and
            (frmVendaProd.Active) and
            (btnIncluir.CanFocus) then
            (btnIncluir.SetFocus);

         Application.ProcessMessages;

      end;

      etIncluir:
      begin

         stbBarraStatus.Panels[0].Text := 'Inclus�o de Venda';
         edtDataPedido.Text := DateToStr(Date());

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
   // Click Consultar
end;

procedure TfrmVendaProd.btnPesquisarClick(Sender: TObject);
begin
   // Click Pesquisar
end;

procedure TfrmVendaProd.btnConfirmarClick(Sender: TObject);
begin
   // Click Confirmar
end;

procedure TfrmVendaProd.btnCancelarClick(Sender: TObject);
begin
   // Click Cancelar
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmVendaProd.btnLimparClick(Sender: TObject);
begin
   // Click Limpar
   LimparTela;
   //DefineEstadoTela;
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

//   Result := False;
//
//    try
//      case vEstadoTela of
//          etIncluir   : Result    := ProcessaInclusao;
//          tAlterar   : Result    := ProcessaAlteracao;
//          etExcluir   : Result    := ProcessaExclusao;
//          etConsultar : Result    := ProcessaConsulta;
//      end;
//
//      if not Result then
//        Exit;
//    except
//      on E: Exception do
//        TMessageUtil.Alerta(E.Message);
//    end;
//    Result := True;

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


   except
        on E: Exception do
        begin
          raise Exception.Create(
              'Falha ao consultar os dados do cliente [View]. '#13+
              e.Message);
        end;
   end;

end;

end.
