unit UProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB, DBClient, Grids,
  DBGrids, uMessageUtil, UEnumerationUtil, UUnidade, UProdutoController;

type
  TfrmProduto = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlPBotoes: TPanel;
    pnlProduto: TPanel;
    btnSair: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnExcluir: TBitBtn;
    btnPesquisar: TBitBtn;
    btnAlterar: TBitBtn;
    btnIncluir: TBitBtn;
    btnConsultar: TBitBtn;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    chkAtivo: TCheckBox;
    lblUnidade: TLabel;
    edtUnidade: TEdit;
    lblDescricao: TLabel;
    edtDescricao: TEdit;
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    vKey : Word;

    vEstadoTela : TEstadoTela;
    vObjProduto : TCliente;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimparTela;
    procedure DefineEstadoTela; //Vai ser utilizada em cada botão


    procedure CarregaDadosTela; // Carrega os dados na tela

    function  ProcessaConfirmacao : Boolean;
    function  ProcessaInclusao    : Boolean;
    function  ProcessaConsulta    : Boolean;
    function  ProcessaProduto     : Boolean;


    function  ProcessaUnidade     : Boolean;

    function  ValidaProduto       : Boolean;

  public
    { Public declarations }
  end;

var
  frmProduto: TfrmProduto;

implementation

{$R *.dfm}

procedure TfrmProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    vKey := key;

    case vKey of
      VK_RETURN:    //CorresPonde a tecla enter
      begin
          Perform(WM_NEXTDLGCTL, 0, 0); //Passar o proximo campo usando enter
      end;

      VK_ESCAPE:   //CorresPonde a tecla ESC
      begin
          if (vEstadoTela <> etPadrao) then
          begin
              if (TMessageUtil.Pergunta(
                  'Deseja realmente fechar essa operação?')) then
              begin
                  vEstadoTela := etPadrao;
                  DefineEstadoTela;
              end;
          end
          else
          begin
              if (TMessageUtil.Pergunta('Deseja sair da rotina? ')) then
                  Close;
          end;
      end;
    end;
end;

procedure TfrmProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action     := caFree;  //Para não ficar minimizado na tela
    frmProduto := nil;
end;

procedure TfrmProduto.CamposEnabled(pOpcao: Boolean);
var
   i : Integer; // i é a variavel para  o comando de repetição
begin
    for i := 0 to pred(ComponentCount) do
    begin
      // Se o campo for do tipo TEdit
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled     := pOpcao;

      // Se o campo for do tipo TCheckBox
      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Enabled := pOpcao;
    end;
end;

procedure TfrmProduto.LimparTela;
var
   i : Integer;
begin
  for i :=0 to pred(ComponentCount) do
    begin
        if (Components[i] is TEdit) then
           (Components[i] as TEdit).Text := EmptyStr;

        if (Components[i] is TCheckBox) then // Então, define o seu padrão desmarcando
           (Components[i] as TCheckBox).Checked := False;
    end;

    if (btnIncluir.CanFocus) then
       (btnIncluir.SetFocus);
end;

procedure TfrmProduto.DefineEstadoTela;
begin
    //Validando o Estado da Tela em cada botão
    btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
    btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
    btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
    btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
    btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

    //Casos em que os outros botões vão ser habilitados
    btnConfirmar.Enabled :=
        vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];
    btnCancelar.Enabled  :=
        vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

    //Para definir os estados da tela
    case vEstadoTela of

        etPadrao:
        begin
            CamposEnabled(False);//Se estiver padrão, desabilita todos os campos
            LimparTela;

            stbBarraStatus.Panels[0].Text := EmptyStr;

            //Validação para ver se a tela está criada
            if (frmProduto <> nil)   and
               (frmProduto.Active)   and
               (btnIncluir.CanFocus) then
               (btnIncluir.SetFocus);

            //Para Recarregar a pagina
            Application.ProcessMessages;
        end;

        etIncluir:
        begin
            stbBarraStatus.Panels[0].Text := 'Inclusão';
            CamposEnabled(True);

            edtCodigo.Enabled := False;
            //Sempre que for incluir um produto ele vem ativo
            chkAtivo.Checked  := True;

            if (edtUnidade.CanFocus) then
               (edtUnidade.SetFocus);
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
                  btnConfirmar.Enabled      := False;

                  if (btnAlterar.CanFocus) then
                     (btnAlterar.SetFocus);
            end
            else
            begin
                  lblCodigo.Enabled         := True;
                  edtCodigo.Enabled         := True;

                  if edtCodigo.CanFocus then
                     edtCodigo.SetFocus;
            end;
        end;
    end;
end;

procedure TfrmProduto.btnIncluirClick(Sender: TObject);
begin
    vEstadoTela := etIncluir;
    DefineEstadoTela;
end;

procedure TfrmProduto.btnAlterarClick(Sender: TObject);
begin
    vEstadoTela := etAlterar;
    DefineEstadoTela;
end;

procedure TfrmProduto.btnExcluirClick(Sender: TObject);
begin
    vEstadoTela := etExcluir;
    DefineEstadoTela;
end;

procedure TfrmProduto.btnConsultarClick(Sender: TObject);
begin
    vEstadoTela := etConsultar;
    DefineEstadoTela;
end;

procedure TfrmProduto.btnPesquisarClick(Sender: TObject);
begin
    vEstadoTela := etPesquisar;
    DefineEstadoTela;
end;

procedure TfrmProduto.btnConfirmarClick(Sender: TObject);
begin
    ProcessaConfirmacao;
end;

procedure TfrmProduto.btnCancelarClick(Sender: TObject);
begin
    vEstadoTela := etPadrao;
    DefineEstadoTela;
end;

procedure TfrmProduto.btnSairClick(Sender: TObject);
begin
    //Validar, caso tenha algum dado na tela
    if (vEstadoTela <> etPadrao) then
    begin
        if (TMessageUtil.Pergunta(
            'Deseja realmente fechar essa operação?')) then
        begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
        end;
    end
    else
      Close;
end;

procedure TfrmProduto.FormCreate(Sender: TObject);
begin
    vEstadoTela := etPadrao;
end;

procedure TfrmProduto.FormShow(Sender: TObject);
begin
    DefineEstadoTela;
end;

procedure TfrmProduto.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    vKey := VK_CLEAR;
end;

function TfrmProduto.ProcessaConfirmacao: Boolean;
begin
    Result := False;

    try
        case vEstadoTela of
            etIncluir   : Result := ProcessaInclusao;
            etConsultar : Result := ProcessaConsulta;
        end;

        if not Result then
            Exit;
    except
        on E: Exception do
            TMessageUtil.Alerta(E.Message);
    end;

    Result := True;
end;

function TfrmProduto.ProcessaInclusao: Boolean;
begin
    try
    Result := False;
        if ProcessaProduto then
        begin
          TMessageUtil.Informacao('Produto cadastrado com sucesso.'#13+
            'Código cadastrado: '+ IntToStr(vObjProduto.Id));

            vEstadoTela := etPadrao;
            DefineEstadoTela;

            Result := True;
        end;
    except
        on E: Exception do
        begin
            Raise Exception.Create(
              'Falha ao incluir os dados do produto [View]: '#13+
              e.Message);
        end;
    end;
end;

function TfrmProduto.ProcessaProduto: Boolean;
begin
    try
        Result := False;
        if (ProcessaUnidade)then
        begin
            //Gravação no banco
            TProdutoController.getInstancia.GravaProduto(vObjProduto);
        

            Result := True;
        end;
    except
    on E: Exception do
        begin
            Raise Exception.Create(
              'Falha ao gravar os dados do produto [View]: '#13+
              e.Message);
        end;
    end;
end;

function TfrmProduto.ProcessaUnidade: Boolean;
begin
    try
        Result := False;

       if not ValidaProduto then
            Exit;

        if vEstadoTela = etIncluir then
        begin
            if vObjProduto = nil then
               vObjProduto := TCliente.Create;
        end
        else
        if vEstadoTela = etAlterar then
        begin
            if vObjProduto = nil then
                Exit;
        end;

        if (vObjProduto = nil) then
            Exit;

        vObjProduto.Ativo     := chkAtivo.Checked;
        vObjProduto.Unidade   := edtUnidade.Text;
        vObjProduto.Descricao := edtDescricao.Text;

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

function TfrmProduto.ValidaProduto: Boolean;
begin
      Result := False;

      if (edtUnidade.Text = EmptyStr) then
      begin
            TMessageUtil.Alerta(
                  'O Campo da unidade não pode ficar em branco.');

            if edtUnidade.CanFocus then
               edtUnidade.SetFocus;
            Exit;
      end;

      if (edtDescricao.Text = EmptyStr) then
      begin
            TMessageUtil.Alerta(
                  'O Campo da descrição não pode ficar em branco.');

            if edtDescricao.CanFocus then
               edtDescricao.SetFocus;
            Exit;
      end;

    Result := True;
end;

function TfrmProduto.ProcessaConsulta: Boolean;
begin
   try
      Result := False;
      if (edtCodigo.Text = EmptyStr ) then
      begin
         TMessageUtil.Alerta('Código do produto não pode ficar em branco.');

         if edtCodigo.CanFocus then
            edtCodigo.SetFocus;

         Exit;
      end;

      vObjProduto :=
         TCliente(TProdutoController.getInstancia.BuscaProduto(
            StrToIntDef(edtCodigo.Text, 0)));

      if (vObjProduto <> nil) then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum produto foi encontrado para o código informado.');

         LimparTela;

         if (edtCodigo.CanFocus) then
            (edtCodigo.SetFocus);

         Exit;
      end;

      DefineEstadoTela; // Para liberar os campos

      Result := True;

   except
      on E: Exception do
      begin
         raise Exception.Create(
            'Falha ao consultar os dados do produto [View]. '#13+
             e.Message);
      end;
   end;
end;

procedure TfrmProduto.CarregaDadosTela;
begin
   if (vObjProduto = nil) then
      Exit;

   edtCodigo.Text    := IntToStr(vObjProduto.Id);
   chkAtivo.Checked  := vObjProduto.Ativo;
   edtUnidade.Text   := vObjProduto.Unidade;
   edtDescricao.Text := vObjProduto.Descricao;
end;

end.
