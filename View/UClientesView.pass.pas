unit UClientesView.pass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, ExtCtrls, ComCtrls, UEnumerationUtil,
  UCliente, UPessoaController, UEndereco, frxClass, DB, DBClient, frxDBSet,
  UClassFuncoes;

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
    edtCPFCNPJ: TMaskEdit;
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
    frxListagemCliente: TfrxReport;
    cdsCliente: TClientDataSet;
    cdsClienteID: TStringField;
    cdsClienteNome: TStringField;
    cdsClienteCPFCNPJ: TStringField;
    cdsClienteAtivo: TStringField;
    cdsClienteEndereco: TStringField;
    cdsClienteNumero: TStringField;
    cdsClienteComplemento: TStringField;
    cdsClienteBairro: TStringField;
    cdsClienteCidadeUF: TStringField;
    frxDBCliente: TfrxDBDataset;
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
    procedure edtCodigoExit(Sender: TObject);
    procedure rdgTipoPessoaClick(Sender: TObject);
   // procedure edtCPFCNPJChange(Sender: TObject);
    procedure edtCPFCNPJExit(Sender: TObject);
    procedure edtNumeroKeyPress(Sender: TObject; var Key: Char);
    procedure edtNomeKeyPress(Sender: TObject; var Key: Char);
    procedure edtEnderecoKeyPress(Sender: TObject; var Key: Char);
    procedure edtComplementoKeyPress(Sender: TObject; var Key: Char);
    procedure edtBairroKeyPress(Sender: TObject; var Key: Char);
    procedure edtCidadeKeyPress(Sender: TObject; var Key: Char);
    procedure cmbUFKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    vKey : Word;

    // Vari?veis de Classes
    vEstadoTela     : TEstadoTela;
    vObjCliente     : TCliente;
    vObjColEndereco : TColEndereco;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;

    //Carrega dados padr?o na Tela
    procedure CarregaDadosTela;

    function  ProcessaConfirmacao       : Boolean;
    function  ProcessaInclusao          : Boolean;
    function  ProcessaAlteracao         : Boolean;
    function  ProcessaExclusao          : Boolean;
    function  ProcessaConsulta          : Boolean;
    function  ProcessaListagem          : Boolean;
    function  ProcessaCliente           : Boolean;

    function  ProcessaPessoa            : Boolean;
    function  ProcessaEndereco          : Boolean;

    function  ValidaCliente             : Boolean;
    function  ValidaEndereco            : Boolean;
    function  ValidaCPF(CPF : string)   : Boolean;
    function  ValidaCNPJ(CNPJ : string) : Boolean;

    function ValidateField(var Key: Char; TipoFiltro: Byte = 0) : Boolean;

  public
    { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

uses
    uMessageUtil, UClientesPesqView, StrUtils;
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
                    'Deseja realmente abortar essa opera??o?')) then
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
  i : Integer; // Variavel para auxiliar o comando de repeti??o
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
    if (Components[i] is TMaskEdit) then   //Limpa o valor que est? no campo
      (Components[i] as TMaskEdit).Text := EmptyStr;

    // Se o campo  for do tipo RADIOGROUP
    if (Components[i] is TRadioGroup) then // Ent?o, define o seu padr?o 0
      (Components[i] as TRadioGroup).ItemIndex := 0;

    // Se o campo  for do tipo COMBOBOX
    if (Components[i] is TComboBox) then // Ent?o, define o seu padr?o -1
    begin
      (Components[i] as TComboBox).Clear;
      (Components[i] as TComboBox).ItemIndex := -1;
    end;

    // Se o campo  for do tipo CHECKBOX
    if (Components[i] is TCheckBox) then // Ent?o, define o seu padr?o desmarcando
      (Components[i] as TCheckBox).Checked := False;

  end;

  if (vObjCliente <> nil ) then
    FreeAndNil(vObjCliente);

  if (vObjColEndereco <> nil) then
    FreeAndNil(vObjColEndereco);

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
         stbBarraStatus.Panels[0].Text := 'Inclus?o';
         CamposEnabled(True);

         edtCodigo.Enabled := False;

         chkAtivo.Checked := True;

         if edtNome.CanFocus then
         edtNome.SetFocus;
      end;

      etAlterar:
      begin
         stbBarraStatus.Panels[0].Text := 'Altera??o';

         if (edtCodigo.Text <> EmptyStr) then
         begin
            CamposEnabled(True);

            edtCodigo.Enabled    := False;
            btnAlterar.Enabled   := False;
            btnConfirmar.Enabled := True;

            if (chkAtivo.CanFocus) then
               chkAtivo.SetFocus;
         end
         else
         begin
            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if (edtCodigo.CanFocus) then
               edtCodigo.SetFocus;

         end;
      end;

      etExcluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Exclus?o';

         if (edtCodigo.Text <> EmptyStr) then
            ProcessaExclusao
         else
         begin
            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if (edtCodigo.CanFocus) then
               edtCodigo.SetFocus;
         end;
      end;

          etConsultar:
          begin
              stbBarraStatus.Panels[0].Text := 'Consulta';

              CamposEnabled(False);

              if (edtCodigo.Text <> EmptyStr) then
              begin
                  edtCodigo.Enabled         := False;
                  btnAlterar.Enabled        := True;
                  btnExcluir.Enabled        := True;
                  btnListar.Enabled         := True;
                  btnConfirmar.Enabled      := False;

                  if (btnAlterar.CanFocus) then
                      btnAlterar.SetFocus;
              end
              else
              begin
                  lblCodigo.Enabled         := True;
                  edtCodigo.Enabled         := True;

                  if edtCodigo.CanFocus then
                    edtCodigo.SetFocus;
              end;
          end;

          etListar:
          begin
              stbBarraStatus.Panels[0].Text := 'Listagem';

              if (edtCodigo.Text <> EmptyStr) then
                  ProcessaListagem
              else
              begin
                  lblCodigo.Enabled         := True;
                  edtCodigo.Enabled         := True;

                  if (edtCodigo.CanFocus) then
                     (edtCodigo.SetFocus);
              end;


          end;

          etPesquisar:
          begin
              stbBarraStatus.Panels[0].Text := 'Pesquisa';



              if (frmClientesPesq  = nil)then
                  frmClientesPesq := TfrmClientesPesq.Create(nil);

              frmClientesPesq.ShowModal;

              if (frmClientesPesq.mClienteID <> 0) then
              begin
                  edtCodigo.Text := IntToStr(frmClientesPesq.mClienteID);
                  vEstadoTela    := etConsultar;
                  ProcessaConsulta;
              end
              else
              begin
                  vEstadoTela := etPadrao;
                  DefineEstadoTela;
              end;

              frmClientesPesq.mClienteID   := 0;
              frmClientesPesq.mClienteNome := EmptyStr;

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
         etIncluir   : Result    := ProcessaInclusao;
         etAlterar   : Result    := ProcessaAlteracao;
         etExcluir   : Result    := ProcessaExclusao;
         etConsultar : Result    := ProcessaConsulta;
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
            'C?digo cadastrado: '+ IntToStr(vObjCliente.Id));
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Result := True;
      end;
   except
      on E: Exception do
      begin
          Raise Exception.Create(
            'Falha ao incluir os dados do cliente [View]: '#13+
            e.Message);
      end;
   end;
end;

function TfrmClientes.ProcessaCliente: Boolean;
begin
   try
      Result := False;
      if (ProcessaPessoa) and
         (ProcessaEndereco) then
      begin
        // Grava??o no Banco de dados
         TPessoaController.getInstancia.GravaPessoa(
            vObjCliente, vObjColEndereco);

         Result := True;
      end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao gravar os dados do cliente [View]. '#13+
            e.Message);
      end;
   end;
end;

function TfrmClientes.ProcessaPessoa: Boolean;
begin
   try
      Result := False;

      if not ValidaCliente then
        Exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjCliente = nil  then
            vObjCliente := TCliente.Create;
      end
      else
      if vEstadoTeLa = etAlterar then
      begin
         if vObjCliente = nil then
            Exit;
      end;

      if (vObjCliente = nil) then
         Exit;

      vObjCliente.Tipo_Pessoa         := 0; //Cliente
      vObjCliente.Nome                := edtNome.Text;
      vObjCliente.Fisica_Juridica     := rdgTipoPessoa.ItemIndex;
      vObjCliente.Ativo               := chkAtivo.Checked;
      vObjCliente.IdentificadorPessoa := edtCPFCNPJ.Text;
      Result := True;
   except
      on E: Exception do
      begin
        Raise Exception.Create(
          'Falha ao processar os dados da pessoas [View] '#13+
          e.Message);
      end;
   end;
end;

function TfrmClientes.ProcessaEndereco: Boolean;
var
  xEndereco  : TEndereco;
  xID_Pessoa : Integer;
begin
   try
      Result := False;

      xEndereco  := nil;
      xID_Pessoa := 0;

      if (not ValidaEndereco) then
         Exit;

      if (vObjColEndereco <> nil) then
        FreeAndNil(vObjColEndereco);

      vObjColEndereco := TColEndereco.Create;

      if (vEstadoTela = etAlterar) then
         xID_Pessoa := StrToIntDef(edtCodigo.Text, 0);


      xEndereco               := TEndereco.Create;
      xEndereco.ID_Pessoa     := xID_Pessoa;
      xEndereco.Tipo_Endereco := 0;
      xEndereco.Endereco      := edtEndereco.Text;
      xEndereco.Numero        := edtNumero.Text;
      xEndereco.Complemento   := edtComplemento.Text;
      xEndereco.Bairro        := edtBairro.Text;
      xEndereco.UF            := cmbUF.Text;
      xEndereco.Cidade        := edtCidade.Text;

      vObjColEndereco.Add(xEndereco);
      Result := True;

   except
      on E : Exception do
      begin
         Raise Exception.Create(
         'Falha ao preencher os dados de endere?o [View]. '#13+
         e.Message);
      end;
   end;
end;

function TfrmClientes.ValidaCliente: Boolean;
begin
   Result := False;
   if (edtNome.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta('Nome do Cliente n?o pode ficar em branco.');
      if edtNome.CanFocus then
         edtNome.SetFocus;
      Exit;
   end;
   Result := True;
end;

function TfrmClientes.ProcessaConsulta: Boolean;
begin
    try
        Result := False;

        if (edtCodigo.Text = EmptyStr) then
        begin
            TMessageUtil.Alerta('C?digo do cliente n?o pode ficar em branco.');

            if edtCodigo.CanFocus then
               edtCodigo.SetFocus;

            Exit;
        end;

        vObjCliente :=
             TCliente(TPessoaController.getInstancia.BuscaPessoa(
                  StrToIntDef(edtCodigo.Text, 0)));

        vObjColEndereco :=
             TPessoaController.getInstancia.BuscaEnderecoPessoa(
                  StrToIntDef(edtCodigo.Text, 0));

        if (vObjCliente <> nil) then
            CarregaDadosTela
        else
        begin
            TMessageUtil.Alerta(
              'Nenhum cliente encontrado para o c?digo informado.');

            LimpaTela;

            if (edtCodigo.CanFocus) then
               (edtCodigo.SetFocus);

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

procedure TfrmClientes.CarregaDadosTela;
var
  i : Integer;
begin
   if (vObjCliente = nil) then
      Exit;

   edtCodigo.Text            := IntToStr(vObjCliente.Id);
   rdgTipoPessoa.ItemIndex   := vObjCliente.Fisica_Juridica;
   edtNome.Text              := vObjCliente.Nome;
   chkAtivo.Checked          := vObjCliente.Ativo;
   edtCPFCNPJ.Text           := vObjCliente.IdentificadorPessoa;

   if (vObjColEndereco <> nil) then
   begin
      for i := 0 to pred(vObjColEndereco.Count) do
      begin
         edtEndereco.Text    := vObjColEndereco.Retorna(i).Endereco;
         edtNumero.Text      := vObjColEndereco.Retorna(i).Numero;
         edtComplemento.Text := vObjColEndereco.Retorna(i).Complemento;
         edtBairro.Text      := vObjColEndereco.Retorna(i).Bairro;
         cmbUF.Text          := vObjColEndereco.Retorna(i).UF;
         edtCidade.Text      := vObjColEndereco.Retorna(i).Cidade;
      end;
   end;
end;

function TfrmClientes.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;
      if ProcessaCliente then
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

procedure TfrmClientes.edtCodigoExit(Sender: TObject);
begin
    if vKey = VK_RETURN then
        ProcessaConsulta;
    vKey := VK_CLEAR;
end;

function TfrmClientes.ProcessaExclusao: Boolean;
begin
    try
        Result := False;
        if (vObjCliente = nil) or
           (vObjColEndereco = nil) then
        begin
            TMessageUtil.Alerta(
            'N?o foi possivel carregar todos os dados cadastrados do cliente.');

            LimpaTela;
            vEstadoTela := etPadrao;
            DefineEstadoTela;
            Exit;
        end;

        try
          if TMessageUtil.Pergunta('Confirma a exclus?o do Cliente?') then
          begin
            Screen.Cursor := crHourGlass;
            TPessoaController.getInstancia.ExcluiPessoa(vObjCliente);
            TMessageUtil.Informacao('Cliente exclu?do com sucesso.');
          end
          else
          begin
            LimpaTela;
            vEstadoTela := etPadrao;
            DefineEstadoTela;
            Exit;
          end;
        finally
          Screen.Cursor := crDefault;
          Application.ProcessMessages;

        end;

        Result := True;
        LimpaTela;
        vEstadoTela := etPadrao;
        DefineEstadoTela;
        Exit;
    except
        on E: Exception do
        begin
          Raise Exception.Create(
              'Falha ao excluir os dados do cliente '#13+
              e.Message);
        end;
    end;
end;

function TfrmClientes.ValidaEndereco: Boolean;
begin
    Result := False;

    if (Trim(edtEndereco.Text) = EmptyStr) then
    begin
      TMessageUtil.Alerta('Endere?o do cliente n?o pode ficar em branco');

      if (edtEndereco.CanFocus) then
      begin   edtEndereco.SetFocus;
      Exit;
      end;
    end;

    if (Trim(edtNumero.text) = EmptyStr) then
    begin
        TMessageUtil.Alerta(
          'N?mero de Endere?o do Cliente n?o pode ficar em branco.');

        if (edtNumero.CanFocus) then
        begin
           edtNumero.SetFocus;
           Exit;
        end;
    end;

    if (Trim(edtBairro.text) = EmptyStr) then
    begin
        TMessageUtil.Alerta(
          'Bairro n?o pode ficar em branco. ');

        if (edtBairro.CanFocus) then
        begin
            edtBairro.SetFocus;
        Exit;
        end;
    end;

   if (Trim(cmbUF.Text) =  EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'UF n?o pode ficar em branco. ');

      if (cmbUF.CanFocus)then
      begin
         cmbUF.SetFocus;
         Exit;
      end;
   end;

    if (Trim(edtCidade.Text) = EmptyStr) then
    begin
      TMessageUtil.Alerta(
         'Cidade n?o pode ficar em branco');

      if (edtCidade.CanFocus) then
      begin
         edtCidade.SetFocus;
      Exit;
      end;
    end;

    Result := True;
end;

procedure TfrmClientes.rdgTipoPessoaClick(Sender: TObject);
begin
   if rdgTipoPessoa.ItemIndex = 1 then
   begin
      edtCPFCNPJ.Clear;
      edtCPFCNPJ.EditMask := '00\.000\.000\/0000\-00;1;_'
   end
   else
   begin
      edtCPFCNPJ.Clear;
      edtCPFCNPJ.EditMask := '000\.000\.000\-00;1;_';
   end;
end;

function TfrmClientes.ProcessaListagem: Boolean;
begin
   try
      if (not cdsCliente.Active) then
        Exit;

      cdsCliente.Append;
      cdsClienteID.Value          := edtCodigo.Text;
      cdsClienteNome.Value        := edtNome.Text;
      cdsClienteCPFCNPJ.Value     := edtCPFCNPJ.Text;
      cdsClienteAtivo.Value       := IfThen(chkAtivo.Checked, 'Sim', 'N?o');
      cdsClienteEndereco.Value    := edtEndereco.Text;
      cdsClienteNumero.Value      := edtNumero.Text;
      cdsClienteComplemento.Value := edtComplemento.Text;
      cdsClienteBairro.Value      := edtBairro.Text;
      cdsClienteCidadeUF.Value    := edtCidade.Text + '/' + cmbUF.Text;
      cdsCliente.Post;

      frxListagemCliente.Variables['DATAHORA'] :=
        QuotedStr(FormatDateTime('DD/MM/YYYY hh:mm', Date + Time));
      frxListagemCliente.Variables['NOMEEMPRESA'] :=
        QuotedStr('Nome da empresa');
      frxListagemCliente.ShowReport();

   finally
      vEstadoTela := etPadrao;
      DefineEstadoTela;
      cdsCliente.EmptyDataSet;
   end;
end;


function TfrmClientes.ValidaCPF(CPF: string): Boolean;
var xDigito10, xDigito11, xAux : string;
    xS, i, xR, xPeso  : Integer;
begin
   xAux := TFuncoes.SoNumero(edtCPFCNPJ.Text);

   if (xAux = '00000000000') or (xAux = '11111111111') or
      (xAux = '22222222222') or (xAux = '33333333333') or
      (xAux = '44444444444') or (xAux = '55555555555') or
      (xAux = '66666666666') or (xAux = '77777777777') or
      (xAux = '88888888888') or (xAux = '99999999999') then
      //(length(CPF) <> 11)) then
   begin
      Result := False;
      Exit;
   end;

   try
      // Calculando o primeiro Digito Verificador
      xS := 0;
      //Peso igual a 10, pois, o primiero digito verificador n?o foi calculado
      xPeso := 10;

      for i := 1 to 9 do
      begin
         xS := xS + (StrToInt(xAux[i]) * xPeso);
         xPeso := xPeso - 1;
      end;

      xR := 11 - (xS mod 11);

      if ((xR = 10) or (xR = 11)) then
         xDigito10 := '0'
      else
         str(xR:1, xDigito10);

      // Calculando o Segundo Digito Verificador

      xS := 0;

      //Peso igual a 11, pois, o primeiro digito verificador j? foi calculado

      xPeso := 11;

      for i := 1 to 10 do
      begin
         // xS ? a variavel a qual vai receber os valores das somas
         xS := xS + (StrToInt(xAux[i]) * xPeso);
         // O Peso sempre diminui de uma soma para a outra
         xPeso := xPeso - 1;
      end;

      xR := 11 - (xS mod 11);

      if ((xR = 10) or (xR = 11)) then
         xDigito11 := '0'
      else
         str(xR:1, xDigito11);


      if ((xDigito10 = xAux[10]) and (xDigito11 = xAux[11])) then
         Result := true
      else
         Result := false;
   except
      Result := false
   end;
end;


procedure TfrmClientes.edtCPFCNPJExit(Sender: TObject);
var
   xAux : string;
begin
   xAux := TFuncoes.SoNumero(edtCPFCNPJ.Text);

   if (rdgTipoPessoa.ItemIndex <> 1) then
         if (ValidaCPF(edtCPFCNPJ.Text)) = False then
      begin
         if (length(xAux) = 11) then
         begin
            edtCPFCNPJ.Clear;
            TMessageUtil.Alerta(
               'CPF invalido : Digite outro CPF');

           // if edtCPFCNPJ.CanFocus then
              // edtCPFCNPJ.SetFocus;
         end;
      end;

   if (rdgTipoPessoa.ItemIndex = 1) then
         if (ValidaCNPJ(edtCPFCNPJ.Text)) = False then
      begin
        if (length(xAux) = 14) then
         begin
            edtCPFCNPJ.Clear;
            TMessageUtil.Alerta(
               'CNPJ invalido : Digite outro CNPJ');

           // if edtCPFCNPJ.CanFocus then
              // edtCPFCNPJ.SetFocus;
         end;
      end;
end;

function TfrmClientes.ValidaCNPJ(CNPJ: string): Boolean;
var   xDigito13, xDigito14, xAux: string;
      xSM, i, xR, xPeso: integer;
begin
   xAux := TFuncoes.SoNumero(edtCPFCNPJ.Text);

   if (xAux = '00000000000000') or (xAux = '11111111111111') or
      (xAux = '22222222222222') or (xAux = '33333333333333') or
      (xAux = '44444444444444') or (xAux = '55555555555555') or
      (xAux = '66666666666666') or (xAux = '77777777777777') or
      (xAux = '88888888888888') or (xAux = '99999999999999') then
      //(length(CNPJ) <> 14)) then
   begin
      Result := false;
      exit;
   end;

   try
    //Calculando o primeiro digito verificador
      xSM := 0;
      xPeso := 2;
      for i := 12 downto 1 do
      begin
         xSM := xSM + (StrToInt(xAux[i]) * xPeso);
         xPeso := xPeso + 1;
         if (xPeso = 10) then
            xPeso := 2;
      end;

      xR := xSM mod 11;

      if ((xR = 0) or (xR = 1)) then
         xDigito13 := '0'
      else
         str((11 - xR):1, xDigito13);

      //Calculando o segundo Digito Verificador
      xSM := 0;
      xPeso := 2;

      for i := 13 downto 1 do
      begin
         xSM := xSM + (StrToInt(xAux[i]) * xPeso);
         xPeso := xPeso + 1;
         if (xPeso = 10) then
            xPeso := 2;
      end;

      xR := xSM mod 11;

      if ((xR = 0) or (xR = 1)) then
         xDigito14 := '0'
      else
         str((11 - xR):1, xDigito14);


      if ((xDigito13 = xAux[13]) and (xDigito14 = xAux[14])) then
         Result := true
      else
         Result := false;

   except
      Result := false
   end;
end;

function TfrmClientes.ValidateField(var Key: Char;
  TipoFiltro: Byte): Boolean;
function IsDigit(Key : Char) : Boolean;
   begin
      Result := (Key in ['0'..'9']);
   end;
begin
   if not (Key in [#8, #37, #38, #39, #40, #46]) then
   case TipoFiltro of
      2 : if not (IsDigit(Key)) then Key := #0;
   else
        raise Exception.Create('Tipo de filtro inv?lido.');
   end;
   Result := (not (Key = #0));
end;

procedure TfrmClientes.edtNumeroKeyPress(Sender: TObject; var Key: Char);
begin
   ValidateField(Key, 2);
end;

procedure TfrmClientes.edtNomeKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in['a'..'z','A'..'Z',Chr(8),Chr(32)]) then
      Key:= #0
end;

procedure TfrmClientes.edtEnderecoKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in['a'..'z','A'..'Z',Chr(8),Chr(32)]) then
      Key:= #0
end;

procedure TfrmClientes.edtComplementoKeyPress(Sender: TObject;
  var Key: Char);
begin
   if not (Key in['a'..'z','A'..'Z',Chr(8),Chr(32)]) then
      Key:= #0
end;

procedure TfrmClientes.edtBairroKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in['a'..'z','A'..'Z',Chr(8),Chr(32)]) then
      Key:= #0
end;

procedure TfrmClientes.edtCidadeKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in['a'..'z','A'..'Z',Chr(8),Chr(32)]) then
      Key:= #0
end;

procedure TfrmClientes.cmbUFKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in['a'..'z','A'..'Z',Chr(8),Chr(32)]) then
      Key:= #0
end;

end.
