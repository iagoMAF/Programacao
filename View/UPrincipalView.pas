unit UPrincipalView;  // Nome da Unit

interface

uses      // Units que s?o utilizadas dentro dessas classes
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, ExtCtrls, pngimage;

type
  TfrmPrincipal = class(TForm) // Nome da classes
    {
      Lista de componentes visuais, que s?o adicionados no pr?totipo da tela
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
    Unidade1: TMenuItem;
    // M?todos do formul?rio
    procedure menSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menClientesClick(Sender: TObject);
    procedure menProdutosClick(Sender: TObject);
    procedure menVendasClick(Sender: TObject);
    procedure Unidade1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  Uconexao, UClientesView.pass, UProdutoView, UVendaProdView, UCadProdutoView;

{$R *.dfm}

procedure TfrmPrincipal.menSairClick(Sender: TObject);
begin
    Close; // Fecha a aplica??o(sistema)
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

procedure TfrmPrincipal.menProdutosClick(Sender: TObject);
begin
  try

    Screen.Cursor := crHourGlass;

    if frmCadProduto  = nil then
      frmCadProduto := TfrmCadProduto.Create(Application);

      frmCadProduto.Show;

  finally
      Screen.Cursor := crDefault;

  end;
end;

procedure TfrmPrincipal.menVendasClick(Sender: TObject);
begin
   try

      Screen.Cursor  := crHourGlass;

      if frmVendaProd = nil then
         frmVendaProd := TfrmVendaProd.Create(Application);

      frmVendaProd.Show;

   finally

      Screen.Cursor := crDefault;

   end;
end;

procedure TfrmPrincipal.Unidade1Click(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmProduto  = nil then
         frmProduto := TfrmProduto.Create(Application);

         frmProduto.Show;

   finally

         Screen.Cursor := crDefault;

   end;
end;

end.

