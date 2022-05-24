unit UCadProdutoPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls,
  ComCtrls, uMessageUtil, UCadProduto, UCadProdutoController;

type
  TfrmCadProdutoPesq = class(TForm)
    StatusBar1: TStatusBar;
    pnlBotoes: TPanel;
    pnlFiltro: TPanel;
    btnSair: TBitBtn;
    btnLimpar: TBitBtn;
    btnConfirmar: TBitBtn;
    grbFiltrar: TGroupBox;
    lblNome: TLabel;
    lblInfo: TLabel;
    edtNome: TEdit;
    btnFiltrar: TBitBtn;
    grbGrid: TGroupBox;
    dbgCadProduto: TDBGrid;
    dtsCadProduto: TDataSource;
    cdsCadProduto: TClientDataSet;
    cdsCadProdutoID: TIntegerField;
    cdsCadProdutoDescricao: TStringField;
    cdsCadProdutoEstoque: TIntegerField;
    cdsCadProdutoPreco: TFloatField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure cdsCadProdutoBeforeDelete(DataSet: TDataSet);
    procedure dbgCadProdutoDblClick(Sender: TObject);
    procedure dbgCadProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure dbgCadProdutoEnter(Sender: TObject);
  private
    { Private declarations }

   vKey : Word;

   procedure LimparTela;
   procedure ProcessaConfirmacao;
   procedure ProcessaPesquisa;


  public
    { Public declarations }

    mProdutoID        : Integer;
    //mProdutoUnidade   : string;
    mProdutoDescricao : String;
    mProdutoEstoque   : Integer;
    mProdutoPreco     : Double;

  end;

var
  frmCadProdutoPesq : TfrmCadProdutoPesq;

implementation

uses Math, StrUtils;

{$R *.dfm}

procedure TfrmCadProdutoPesq.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;

   case vKey of

      VK_RETURN: // Representa o Enter
      begin
         Perform(WM_NEXTDLGCTL, 0, 0);
      end;

      VK_ESCAPE: // ESC para sair
      begin
         if TMessageUtil.Pergunta('Deseja sair da rotina? ') then
            Close;
      end;

      VK_UP:    // Seta para cima
      begin
          vKey := VK_CLEAR;

          if (ActiveControl = dbgCadProduto) then
            Exit;

          Perform(WM_NEXTDLGCTL, 1, 0);
      end;
   end;
end;

procedure TfrmCadProdutoPesq.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if (not cdsCadProduto.IsEmpty) then
      (cdsCadProduto.EmptyDataSet);

   if (edtNome.CanFocus) then
      (edtNome.SetFocus);

end;

procedure TfrmCadProdutoPesq.ProcessaConfirmacao;
begin
   if (not cdsCadProduto.IsEmpty) then
   begin
      mProdutoID        := cdsCadProdutoID.Value;
      mProdutoDescricao := cdsCadProdutoDescricao.Value;
      mProdutoEstoque   := cdsCadProdutoEstoque.Value;
      mProdutoPreco     := cdsCadProdutoPreco.Value;
      Self.ModalResult  := mrOk;
      LimparTela;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhum produto foi selecionado. ');

      if (edtNome.CanFocus) then
         (edtNome.SetFocus);
   end;
end;

procedure TfrmCadProdutoPesq.ProcessaPesquisa;
var
   xListaCadProduto : TColCadProduto;
   xAux          : Integer;
begin
   try
      try
         xListaCadProduto := TColCadProduto.Create;

         xListaCadProduto:=
           TCadProdutoController.getInstancia.PesquisaCadProduto(
            Trim(edtNome.Text));

         cdsCadProduto.EmptyDataSet;

         if xListaCadProduto <> nil then
         begin
            for xAux := 0 to pred(xListaCadProduto.Count) do
            begin
               cdsCadProduto.Append;

               cdsCadProdutoID.Value        := xListaCadProduto.Retorna(xAux).Id;

               cdsCadProdutoDescricao.Value :=
                  xListaCadProduto.Retorna(xAux).Descricao;

               cdsCadProdutoEstoque.Value   :=
                  xListaCadProduto.Retorna(xAux).Estoque;

               cdsCadProdutoPreco.Value     :=
                  xListaCadProduto.Retorna(xAux).Precovenda;

               cdsCadProduto.Post;

            end;
         end;

         if (cdsCadProduto.RecordCount = 0) then
         begin
            TMessageUtil.Alerta('Nenhum produto encontrado para esse filtro');
            if edtNome.CanFocus then
               edtNome.SetFocus;
         end
         else
         begin
            cdsCadProduto.First;
            if dbgCadProduto.CanFocus then
               dbgCadProduto.SetFocus;
         end;

      finally
         if (xListaCadProduto <> nil) then
            FreeAndNil(xListaCadProduto);
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
            'Falha ao pesquisar os dados do produto [View]: '#13+
            e.Message);
      end;
   end;

end;

procedure TfrmCadProdutoPesq.btnFiltrarClick(Sender: TObject);
begin
   mProdutoID        := 0;
   mProdutoDescricao := EmptyStr;
   mProdutoEstoque   := 0;
   mProdutoPreco     := 0;
   ProcessaPesquisa;
end;

procedure TfrmCadProdutoPesq.btnConfirmarClick(Sender: TObject);
begin
   mProdutoID        := 0;
   mProdutoDescricao := EmptyStr;
   mProdutoEstoque   := 0;
   mProdutoPreco     := 0;
   ProcessaConfirmacao;
end;

procedure TfrmCadProdutoPesq.btnLimparClick(Sender: TObject);
begin
   LimparTela;
end;

procedure TfrmCadProdutoPesq.btnSairClick(Sender: TObject);
begin
   mProdutoID        := 0;
   mProdutoDescricao := EmptyStr;
   mProdutoEstoque   := 0;
   mProdutoPreco     := 0;
   LimparTela;
   Close;
end;

procedure TfrmCadProdutoPesq.cdsCadProdutoBeforeDelete(DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmCadProdutoPesq.dbgCadProdutoDblClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmCadProdutoPesq.dbgCadProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key =  VK_RETURN) and
      (btnConfirmar.CanFocus) then
      (btnConfirmar.SetFocus);
end;

procedure TfrmCadProdutoPesq.FormShow(Sender: TObject);
begin
   if edtNome.CanFocus then
      edtNome.SetFocus;
end;

procedure TfrmCadProdutoPesq.dbgCadProdutoEnter(Sender: TObject);
begin
   cdsCadProduto.Edit;
   dbgCadProduto.Columns[0].ReadOnly := True;
   dbgCadProduto.Columns[1].ReadOnly := True;
   dbgCadProduto.Columns[2].ReadOnly := True;
   dbgCadProduto.Columns[3].ReadOnly := True;
end;

end.
