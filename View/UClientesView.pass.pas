unit UClientesView.pass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, ExtCtrls, ComCtrls, UEnumerationUtil;

type
  TfrmClientes = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlArea: TPanel;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    chkAtivo: TCheckBox;
    rdgTipoPessoa: TRadioGroup;
    lblCPFCNPJ: TLabel;
    editCPFCNPJ: TMaskEdit;
    lblNome: TLabel;
    edtNome: TEdit;
    grbEndereco: TGroupBox;
    lblEndereco: TLabel;
    edtEndereco: TEdit;
    lblNumero: TLabel;
    edtNumero: TEdit;
    lblComplemento: TLabel;
    edtComplemento: TEdit;
    lblBairro: TLabel;
    edtBairro: TEdit;
    lblUF: TLabel;
    cmbUF: TComboBox;
    lblCidade: TLabel;
    edtCidade: TEdit;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnListar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    vKey : Word;

    // Vari�veis de Classes
    vEstadoTela : TEstadoTela;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;

    function  ProcessaConfirmacao : Boolean;
    function  ProcessaInclusao : Boolean;
    function  ProcessaCliente : Boolean;

    function  ProcessaPessoa : Boolean;
    function  ProcessaEndereco : Boolean;
  public
    { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

uses
    uMessageUtil;
{$R *.dfm}

procedure TfrmClientes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    vKey := Key;

    case vKey of
        VK_RETURN: //Correspondente a tecLa <ENTER>
        begin
            // Comando responsavel para passar para o proximo campo do fomr
            Perform(WM_NEXTDlgCtl, 0, 0);
        end;

        VK_ESCAPE: //Correspondente a tecla <ESC>
        begin
            if (vEstadoTela <> etPadrao) then
            begin
                if (TMessageUtil.Pergunta(
                    'Deseja realmente abortar essa opera��o?')) then
                begin
                   vEstadoTela := etPadrao;
                   DefineEstadoTela;
                end;
            end
            else
            begin
              if (TMessageUtil.Pergunta(
                 'Deseja sair da rotina?')) then
                  Close; // fechar o formulario
            end;
        end;
    end;
end;

procedure TfrmClientes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
    frmClientes := nil;
end;

procedure TfrmClientes.CamposEnabled(pOpcao: Boolean);
var
  i : Integer; // Variavel para auxiliar o comando de repeti��o
begin
    for i := 0 to pred(ComponentCount) do
    begin
      // Se o campo for do tipo TEdit
      if (Components[i] is TEdit) then
      (Components[i] as TEdit).Enabled := pOpcao;

      // Se o campo for do tipo TMaskEdit
      if (Components[i] is TMaskEdit) then
        (Components[i] as TMaskEdit).Enabled := pOpcao;

      // Se o campo for do tipo TRadioGroup
      if (Components[i] is TRadioGroup) then
        (Components[i] as TRadioGroup).Enabled := pOpcao;

      // Se o campo for do tipo TComboBox
      if (Components[i] is TComboBox) then
        (Components[i] as TComboBox).Enabled := pOpcao;

      // Se o campo for do tipo TCheckBox
      if (Components[i] is TCheckBox) then
        (Components[i] as TCheckBox).Enabled := pOpcao;

    end;
    grbEndereco.Enabled := pOpcao;
end;

procedure TfrmClientes.LimpaTela;
var
  i : Integer;
begin
  for i := 0 to pred(ComponentCount) do
  begin
    // Se o campo  for do tipo EDIT
    if (Components[i] is TEdit) then
      (Components[i] as TEdit).Text := EmptyStr;

    // Se o campo  for do tipo MASKEDIT
    if (Components[i] is TMaskEdit) then   //Limpa o valor que est� no campo
      (Components[i] as TMaskEdit).Text := EmptyStr;

    // Se o campo  for do tipo RADIOGROUP
    if (Components[i] is TRadioGroup) then // Ent�o, define o seu padr�o 0
      (Components[i] as TRadioGroup).ItemIndex := 0;

    // Se o campo  for do tipo COMBOBOX
    if (Components[i] is TComboBox) then // Ent�o, define o seu padr�o -1
    begin
      (Components[i] as TComboBox).Clear;
      (Components[i] as TComboBox).ItemIndex := -1;
    end;

    // Se o campo  for do tipo CHECKBOX
    if (Components[i] is TCheckBox) then // Ent�o, define o seu padr�o desmarcando
      (Components[i] as TCheckBox).Checked := False;

  end;
end;

Procedure TfrmClientes.DefineEstadoTela;
begin
      btnIncluir.Enabled     := (vEstadoTela in [etPadrao]);
      btnAlterar.Enabled     := (vEstadoTela in [etPadrao]);
      btnExcluir.Enabled     := (vEstadoTela in [etPadrao]);
      btnConsultar.Enabled   := (vEstadoTela in [etPadrao]);
      btnListar.Enabled      := (vEstadoTela in [etPadrao]);
      btnPesquisar.Enabled   := (vEstadoTela in [etPadrao]);

      btnConfirmar.Enabled :=
        vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

      btnCancelar.Enabled :=
        vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

      case vEstadoTela of
          etPadrao:
          begin
            CamposEnabled(False);
            LimpaTela;

            stbBarraStatus.Panels[0].Text := EmptyStr;
            stbBarraStatus.Panels[1].Text := EmptyStr;

            if (frmClientes <> nil) and
               (frmClientes.Active) and
               (btnIncluir.CanFocus) then
               btnIncluir.SetFocus;

            Application.ProcessMessages;
          end;

          etIncluir:
          begin
            stbBarraStatus.Panels[0].Text := 'Inclus�o';
            CamposEnabled(True);

            edtCodigo.Enabled := False;

            chkAtivo.Checked := True;

            if edtNome.CanFocus then
            edtNome.SetFocus;
          end;
      end;
end;

procedure TfrmClientes.btnIncluirClick(Sender: TObject);
begin
    vEstadoTela := etIncluir;
    DefineEstadoTela;
end;

procedure TfrmClientes.btnAlterarClick(Sender: TObject);
begin
    vEstadoTela := etAlterar;
    DefineEstadoTela;
end;

procedure TfrmClientes.btnExcluirClick(Sender: TObject);
begin
    vEstadoTela := etExcluir;
    DefineEstadoTela;
end;

procedure TfrmClientes.btnConsultarClick(Sender: TObject);
begin
    vEstadoTela := etConsultar;
    DefineEstadoTela;
end;

procedure TfrmClientes.btnListarClick(Sender: TObject);
begin
    vEstadoTela := etListar;
    DefineEstadoTela;
end;

procedure TfrmClientes.btnPesquisarClick(Sender: TObject);
begin
    vEstadoTela := etPesquisar;
    DefineEstadoTela;
end;

procedure TfrmClientes.btnConfirmarClick(Sender: TObject);
begin
    ProcessaConfirmacao;
end;

procedure TfrmClientes.btnCancelarClick(Sender: TObject);
begin
    vEstadoTela := etPadrao;
    DefineEstadoTela;
end;

procedure TfrmClientes.btnSairClick(Sender: TObject);
begin
    if (vEstadoTela <> etPadrao) then
    begin
        if (TMessageUtil.Pergunta('Deseja realmente fechar essa tela?')) then
        begin
          vEstadoTela := etPadrao;
          DefineEstadoTela;
        end;
    end
    else
      Close;
end;

procedure TfrmClientes.FormCreate(Sender: TObject);
begin
  vEstadoTela := etPadrao;
  
end;

procedure TfrmClientes.FormShow(Sender: TObject);
begin
    DefineEstadoTela;
end;

procedure TfrmClientes.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  vKey := VK_CLEAR;
end;

function TfrmClientes.ProcessaConfirmacao: Boolean;
begin
    Result := False;

    try
      case vEstadoTela of
          etIncluir: Result := ProcessaInclusao;

      end;

      if not Result then
        Exit;
    except
      on E: Exception do
        TMessageUtil.Alerta(E.Message);
    end;
    Result := True;
end;

function TfrmClientes.ProcessaInclusao: Boolean;
begin
    try
        Result := False;

        if ProcessaCliente then
        begin
          TMessageUtil.Informacao('Cliente cadastrado com sucesso.'#13+
            'C�digo cadastrado: ');

            vEstadoTela = etPadrao;
            DefineEstadoTela;

            Result := True;
        end;
    except
      on E: Exception do
      begin
          Raise Exception.Creat(
            'Falha ao incluir os dados do cliente [View]: '#13+
            e.Message);
      end;
    end;
end;

function TfrmClientes.ProcessaCliente: Boolean;
begin
  try
    if (ProcessaPessoa) and
       (ProcessaEndereco) then
    begin
        // Grava��o no Banco de dados

        Result := True;
    end;

  except
      on E : Excception do
      begin
        Raise Exception.Create(
          'Falha ao gravar os dados do cliente [View]: '#13
          e.Message);
      end;
  end;

end;

function TfrmClientes.ProcessaPessoa: Boolean;
begin
    try
      Result := False;

//      if not ValidaCliente then
//        Exit;

      Result := True;
    except
      on E: Exception do
      begin
        Raise Exception.Create(
          'Falha ao processar os dados da pessoas [View]' #13+
          e.Message);
      end;
    end;
end;

function TfrmClientes.ProcessaEndereco: Boolean;
begin
  try

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
