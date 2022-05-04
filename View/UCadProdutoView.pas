unit UCadProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, UEnumerationUtil, frxClass,
  DB, frxDBSet, UClassFuncoes, uMessageUtil;

type
  TfrmCadProduto = class(TForm)
    StatusBar1: TStatusBar;
    pnlBotoes: TPanel;
    pnlInfo: TPanel;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    Label1: TLabel;
    edtProduto: TEdit;
    lblPreco: TLabel;
    edtPreco: TEdit;
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
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    vKey : Word;

    // Variaveis de Classe

    vEstadoTela : TEstadoTela;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;

  public
    { Public declarations }
  end;

var
  frmCadProduto: TfrmCadProduto;

implementation

{$R *.dfm}


procedure TfrmCadProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

   vKey := Key;

   case vKey of

      VK_RETURN: //Corresponde a tecla <ENTER>
      begin
         Perform(WM_NEXTDLGCTL, 0, 0);
      end;

      VK_ESCAPE:
      begin
         // Adicionar o comando do Esc depois de fazer a Tela Padrao
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

   end;
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

      end;
      
   end;
end;

end.
