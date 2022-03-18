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
  private
    { Private declarations }
    vKey : Word;

    procedure LimparTela;
    procedure ProcessaPesquisa;
  public
    { Public declarations }
  end;

var
  frmProdutoPesqView: TfrmProdutoPesqView;

implementation

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
   for i := 0 pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if (not cdsProduto.IsEmpty) then
      (cdsProduto.EmptyDataSet);

   if (edtNome.CanFocus) then
      (edtNome.SetFocus);
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
            TProdutoController


      finally

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

end.
