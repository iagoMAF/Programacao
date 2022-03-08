unit UPrincipalView;  // Nome da Unit

interface

uses      // Units que são utilizadas dentro dessas classes
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, ExtCtrls, pngimage;

type
  TfrmPrincipal = class(TForm) // Nome da classes
    {
      Lista de componentes visuais, que são adicionados no prótotipo da tela
      Lembre-se de renomear TODOS os componentes que foram adicionados
    }
    menMenu: TMainMenu;
    menCadastros: TMenuItem;
    menClientes: TMenuItem;
    menProdutos: TMenuItem;
    menRelatorios: TMenuItem;
    menRelVendas: TMenuItem;
    menMovimentos: TMenuItem;
    menVendas: TMenuItem;
    menSair: TMenuItem;
    stbBarraStatus: TStatusBar;
    imgLogo: TImage;
    // Métodos do formulário
    procedure menSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menClientesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  Uconexao, UClientesView.pass;

{$R *.dfm}

procedure TfrmPrincipal.menSairClick(Sender: TObject);
begin
    Close; // Fecha a aplicação(sistema)
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
    stbBarraStatus.Panels[0].Text :=
      'Caminho do  BD: ' + TConexao.get.getCaminhoBanco;
end;

procedure TfrmPrincipal.menClientesClick(Sender: TObject);
begin
  try
    Screen.Cursor := crHourGlass;

    if frmClientes  = nil then
      frmClientes := TfrmClientes.Create(Application);

      frmClientes.Show;
  finally
      Screen.Cursor := crDefault;

  end;
end;

end.

