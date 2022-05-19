unit UVendaProdPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls,
  ComCtrls, UVendaProdController, uMessageUtil, UVendaProd, UCliente,
  UPessoaController, UPessoa;

type
  TfrmVendaPesq = class(TForm)
    StatusBar1: TStatusBar;
    pnlBotoes: TPanel;
    pnlFiltro: TPanel;
    pnlResultadoBusca: TPanel;
    grbFiltrar: TGroupBox;
    lblCodigoVenda: TLabel;
    edtCodigoVenda: TEdit;
    btnFiltrar: TBitBtn;
    Label1: TLabel;
    btnSair: TBitBtn;
    btnLimpar: TBitBtn;
    btnConfirmar: TBitBtn;
    grbResultadoBusca: TGroupBox;
    dbgVendaCliente: TDBGrid;
    dtsVendaCliente: TDataSource;
    cdsVendaCliente: TClientDataSet;
    cdsVendaClienteVendaID: TIntegerField;
    cdsVendaClienteNomeCliente: TStringField;
    cdsVendaClienteDataVenda: TDateField;
    cdsVendaClienteValorTotal: TFloatField;
    cdsVendaClienteIDCliente: TIntegerField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure cdsVendaClienteBeforeDelete(DataSet: TDataSet);
    procedure dbgVendaClienteDblClick(Sender: TObject);
    procedure dbgVendaClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

   vKey : Word;

   vObjCliente : TCliente;

   procedure LimparTela;
   procedure ProcessaConfirmacao;
   procedure ProcessaPesquisa;
   procedure CarregaNomeClienteGrid;
   procedure ProcessaConsultaCliente;

  public
    { Public declarations }
    mVendaID     : String;
    mNomeCliente : String;
    mValorTotal  : Double;
    mDataVenda   : TDateTime;
    mIDCliente   : String;
  end;

var
  frmVendaPesq: TfrmVendaPesq;

implementation

{$R *.dfm}

procedure TfrmVendaPesq.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;

   case vKey of
      VK_RETURN:
      begin
         Perform(WM_NEXTDLGCTL, 0, 0);
      end;

      VK_ESCAPE:
      begin
         if TMessageUtil.Pergunta('Deseja sair da rotina? ') then
            Close;
      end;

      VK_UP:
      begin
         vKey := VK_CLEAR;
         if (ActiveControl = dbgVendaCliente) then
            Exit;
         Perform(WM_NEXTDLGCTL, 1, 0);
      end;
   end;
end;

procedure TfrmVendaPesq.LimparTela;
var
  i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if (not cdsVendaCliente.IsEmpty) then
      (cdsVendaCliente.EmptyDataSet);

   if (edtCodigoVenda.CanFocus) then
      (edtCodigoVenda.SetFocus);
end;

procedure TfrmVendaPesq.ProcessaConfirmacao;
begin
   if (not cdsVendaCliente.IsEmpty) then
   begin
      mVendaID     := cdsVendaClienteVendaID.Text;
      mNomeCliente := cdsVendaClienteNomeCliente.Text;
      mDataVenda   := cdsVendaClienteDataVenda.Value;
      mValorTotal  := cdsVendaClienteValorTotal.Value;
      mIDCliente   := cdsVendaClienteIDCliente.Text;
      Self.ModalResult  := mrOk;
      LimparTela;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhuma venda foi selecionada.');

      if (edtCodigoVenda.CanFocus) then
         (edtCodigoVenda.SetFocus);
   end;
end;

procedure TfrmVendaPesq.ProcessaPesquisa;
var
  xListaVendaProd   : TColVendaProd;
  xAux          : Integer;
begin
   try
      try
         xListaVendaProd   := TColVendaProd.Create;

         xListaVendaProd :=
            TVendaProdController.getInstancia.PesquisaVendaProd(Trim(
               (edtCodigoVenda.Text)));

//         vObjCliente :=
//            TCliente(TPessoaController.getInstancia.BuscaPessoa(
//               StrToIntDef(cdsVendaClienteIDCliente.Text, 0)));

         cdsVendaCliente.EmptyDataSet;

         if (xListaVendaProd <> nil) then
         begin
            for xAux := 0 to pred(xListaVendaProd.Count) do
            begin

               cdsVendaCliente.Append;

               cdsVendaClienteVendaID.Value := xListaVendaProd.Retorna(xAux).Id;

              cdsVendaClienteIDCliente.Value :=
                  xListaVendaProd.Retorna(xAux).Id_Cliente;

               vObjCliente :=
                  TCliente(TPessoaController.getInstancia.BuscaPessoa(
                  StrToIntDef(cdsVendaClienteIDCliente.Text, 0)));

               if (vObjCliente <> nil) then
                  cdsVendaClienteNomeCliente.Text := vObjCliente.Nome;

               cdsVendaClienteDataVenda.Value :=
                  xListaVendaProd.Retorna(xAux).DataVenda;
               cdsVendaClienteValorTotal.Value :=
                  xListaVendaProd.Retorna(xAux).TotalVenda;

               cdsVendaCliente.Post;
            end;
         end;

         if (cdsVendaCliente.RecordCount = 0) then
         begin
            TMessageUtil.Alerta('Nenhuma venda encontrada para este filtro');
            if (edtCodigoVenda.CanFocus) then
               (edtCodigoVenda.SetFocus);
         end
         else
         begin
            cdsVendaCliente.First;
            if dbgVendaCliente.CanFocus then
               dbgVendaCliente.SetFocus;
         end;
      finally
         if (xListaVendaProd <> nil) then
            FreeAndNil(xListaVendaProd);
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
            'Falha ao pesquisar os dados da pessoa [View]: '#13+
            e.Message);
      end;
   end;
end;

procedure TfrmVendaPesq.btnFiltrarClick(Sender: TObject);
begin
   mVendaID    := EmptyStr;
  // mNomeCliente := EmptyStr;
   mValorTotal := 0;
   mDataVenda  := 0;
   mIDCliente  := EmptyStr;
   ProcessaPesquisa;
end;

procedure TfrmVendaPesq.btnConfirmarClick(Sender: TObject);
begin
   mVendaID    := EmptyStr;
  // mNomeCliente := EmptyStr;
   mValorTotal := 0;
   mDataVenda  := 0;
   mIDCliente  := EmptyStr;
   //ProcessaPesquisa;
   ProcessaConfirmacao;
end;

procedure TfrmVendaPesq.btnLimparClick(Sender: TObject);
begin
   LimparTela;
end;

procedure TfrmVendaPesq.btnSairClick(Sender: TObject);
begin
   mVendaID    := EmptyStr;
  // mNomeCliente := EmptyStr;
   mValorTotal := 0;
   mDataVenda  := 0;
   mIDCliente  := EmptyStr;
   Close;
end;

procedure TfrmVendaPesq.cdsVendaClienteBeforeDelete(DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmVendaPesq.dbgVendaClienteDblClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmVendaPesq.dbgVendaClienteKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key =  VK_RETURN) and
      (btnConfirmar.CanFocus) then
      (btnConfirmar.SetFocus);
end;

procedure TfrmVendaPesq.CarregaNomeClienteGrid;
begin
   if (vObjCliente = nil) then
      Exit;
   //edtNumeroCliente.Text             := IntToStr(vObjCliente.Id);
   cdsVendaClienteNomeCliente.Text   := vObjCliente.Nome;
end;

procedure TfrmVendaPesq.ProcessaConsultaCliente;
begin
   vObjCliente :=
      TCliente(TPessoaController.getInstancia.BuscaPessoa(
         StrToIntDef(cdsVendaClienteIDCliente.Text, 0)));
   CarregaNomeClienteGrid;
end;

procedure TfrmVendaPesq.FormShow(Sender: TObject);
begin
   LimparTela;
end;

end.
