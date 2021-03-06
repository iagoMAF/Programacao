unit UProdutoPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB, DBClient, Grids,
  DBGrids, uMessageUtil, UProduto, UProdutoController;

type
  TfrmProdutoPesqView = class(TForm)
    StatusBar1: TStatusBar;
    pnlBotoes: TPanel;
    btnLimpar: TBitBtn;
    btnSair: TBitBtn;
    pnlFiltro: TPanel;
    grbFiltrar: TGroupBox;
    lblNome: TLabel;
    lblInfo: TLabel;
    edtNome: TEdit;
    btnFiltrar: TBitBtn;
    pnlResultado: TPanel;
    btnConfirmar: TBitBtn;
    grbGrid: TGroupBox;
    dbgProduto: TDBGrid;
    dtsProduto: TDataSource;
    cdsProduto: TClientDataSet;
    cdsProdutoID: TIntegerField;
    cdsProdutoUnidade: TStringField;
    cdsProdutoDescricao: TStringField;
    cdsProdutoAtivo: TIntegerField;
    cdsProdutoDescricaoAtivo: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure cdsProdutoBeforeDelete(DataSet: TDataSet);
    procedure dbgProdutoDblClick(Sender: TObject);
    procedure dbgProdutoKeyDown(Sender: TObject; var Key: Word;
     Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    vKey : Word;

    procedure LimparTela;
    procedure ProcessaPesquisa;
    procedure ProcessaConfirmacao;
  public
    { Public declarations }
    mProdutoID        : Integer;
    mProdutoUnidade   : string;
    mProdutoDescricao : String;

  end;

var
  frmProdutoPesqView: TfrmProdutoPesqView;

implementation

uses Math, StrUtils;

{$R *.dfm}

procedure TfrmProdutoPesqView.FormKeyDown(Sender: TObject; var Key: Word;
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

          if (ActiveControl = dbgProduto) then
            Exit;

          Perform(WM_NEXTDLGCTL, 1, 0);
      end;
   end;
end;

procedure TfrmProdutoPesqView.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if (not cdsProduto.IsEmpty) then
      (cdsProduto.EmptyDataSet);

   if (edtNome.CanFocus) then
      (edtNome.SetFocus);

end;

procedure TfrmProdutoPesqView.ProcessaConfirmacao;
begin
   if (not cdsProduto.IsEmpty) then
   begin
      mProdutoID        := cdsProdutoID.Value;
      mProdutoUnidade   := cdsProdutoUnidade.Value;
      mProdutoDescricao := cdsProdutoDescricao.Value;
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

procedure TfrmProdutoPesqView.ProcessaPesquisa;
var
   xListaProduto : TColProduto;
   xAux          : Integer;
begin
   try
      try
         xListaProduto := TColProduto.Create;

         xListaProduto:=
           TProdutoController.getInstancia.PesquisaProduto(Trim(edtNome.Text));

         cdsProduto.EmptyDataSet;

         if xListaProduto <> nil then
         begin
            for xAux := 0 to pred(xListaProduto.Count) do
            begin
               cdsProduto.Append;
               cdsProdutoID.Value        := xListaProduto.Retorna(xAux).Id;
               cdsProdutoDescricao.Value :=
                  xListaProduto.Retorna(xAux).Descricao;
               cdsProdutoUnidade.Value   := xListaProduto.Retorna(xAux).Unidade;
               cdsProdutoAtivo.Value     :=
                  IfThen(xListaProduto.Retorna(xAux).Ativo, 1, 0);
               cdsProdutoDescricaoAtivo.Value  :=
                  IfThen(xListaProduto.Retorna(xAux).Ativo, 'Sim', 'N?o');
               cdsProduto.Post;
            end;
         end;

         if (cdsProduto.RecordCount = 0) then
         begin
            TMessageUtil.Alerta('Nenhum produto encontrado para esse filtro');
            if edtNome.CanFocus then
               edtNome.SetFocus;
         end
         else
         begin
            cdsProduto.First;
            if dbgProduto.CanFocus then
               dbgProduto.SetFocus;
         end;

      finally
         if (xListaProduto <> nil) then
            FreeAndNil(xListaProduto);
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

procedure TfrmProdutoPesqView.btnFiltrarClick(Sender: TObject);
begin
   mProdutoID        := 0;
   mProdutoDescricao := EmptyStr;
   mProdutoUnidade   := EmptyStr;
   ProcessaPesquisa;
end;

procedure TfrmProdutoPesqView.btnConfirmarClick(Sender: TObject);
begin
   mProdutoID        := 0;
   mProdutoDescricao := EmptyStr;
   mProdutoUnidade   := EmptyStr;
   ProcessaConfirmacao;
end;

procedure TfrmProdutoPesqView.btnLimparClick(Sender: TObject);
begin
   LimparTela;
end;

procedure TfrmProdutoPesqView.btnSairClick(Sender: TObject);
begin
   mProdutoID        := 0;
   mProdutoDescricao := EmptyStr;
   mProdutoUnidade   := EmptyStr;
   LimparTela;
   Close;
end;

procedure TfrmProdutoPesqView.cdsProdutoBeforeDelete(DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmProdutoPesqView.dbgProdutoDblClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmProdutoPesqView.dbgProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key =  VK_RETURN) and
      (btnConfirmar.CanFocus) then
         (btnConfirmar.SetFocus);
end;

procedure TfrmProdutoPesqView.FormShow(Sender: TObject);
begin
   if edtNome.CanFocus then
      edtNome.SetFocus;

end;

end.
