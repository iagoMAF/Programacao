unit UCadProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, UEnumerationUtil, frxClass,
  DB, frxDBSet, UClassFuncoes, uMessageUtil;

type
  TfrmCadProduto = class(TForm)
    stbBarraStatus: TStatusBar;
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
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

         if (edtProduto.CanFocus) then
            (edtProduto.SetFocus);

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
   //btnAlterar
end;

procedure TfrmCadProduto.btnExcluirClick(Sender: TObject);
begin
   //btnExcluir
end;

procedure TfrmCadProduto.btnConsultarClick(Sender: TObject);
begin
   //btnConsultar
end;

procedure TfrmCadProduto.btnPesquisarClick(Sender: TObject);
begin
   //btnPesquisar
end;

procedure TfrmCadProduto.btnConfirmarClick(Sender: TObject);
begin
   //btnConfirmar
end;

procedure TfrmCadProduto.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmCadProduto.btnSairClick(Sender: TObject);
begin
   //btnSair
end;

procedure TfrmCadProduto.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

end.
