program NovoSistema;

uses
  Forms,
  UPrincipalView in 'View\UPrincipalView.pas' {frmPrincipal},
  UConexao in 'Model\BD\UConexao.pas',
  UCriptografiaUtil in 'Model\Util\UCriptografiaUtil.pas',
  UClassFuncoes in 'Model\Util\UClassFuncoes.pas',
  UClientesView.pass in 'View\UClientesView.pass.pas' {frmClientes},
  uMessageUtil in 'Model\Util\uMessageUtil.pas',
  Consts in 'Model\Util\Consts.pas',
  UEnumerationUtil in 'Model\Util\UEnumerationUtil.pas',
  UPessoa in 'Model\UPessoa.pas',
  UPessoaDAO in 'Model\UPessoaDAO.pas',
  UGenericDAO in 'Model\BD\UGenericDAO.pas',
  UCliente in 'Model\UCliente.pas',
  UPessoaController in 'Controller\UPessoaController.pas',
  UEndereco in 'Model\UEndereco.pas',
  UEnderecoDAO in 'Model\UEnderecoDAO.pas',
  UClientesPesqView in 'View\UClientesPesqView.pas' {frmClientesPesq},
  UProdutoView in 'View\UProdutoView.pas' {frmProduto},
  UProduto in 'Model\UProduto.pas',
  UProdutoDAO in 'Model\UProdutoDAO.pas',
  UUnidade in 'Model\UUnidade.pas',
  UProdutoController in 'Controller\UProdutoController.pas',
  UProdutoPesqView in 'View\UProdutoPesqView.pas' {frmProdutoPesqView},
  UVendaProdView in 'View\UVendaProdView.pas' {frmVendaProd},
  UCadProdutoView in 'View\UCadProdutoView.pas' {frmCadProduto},
  UCadProdutoDAO in 'Model\UCadProdutoDAO.pas',
  UCadProduto in 'Model\UCadProduto.pas',
  UMercadoria in 'Model\UMercadoria.pas',
  UCadProdutoController in 'Controller\UCadProdutoController.pas',
  UCadProdutoPesqView in 'View\UCadProdutoPesqView.pas' {frmCadProdutoPesq},
  UVendaProd in 'Model\UVendaProd.pas',
  UVendaProdController in 'Controller\UVendaProdController.pas',
  UVendaProdDao in 'Model\UVendaProdDao.pas',
  UComercio in 'Model\UComercio.pas',
  UGridVenda in 'Model\UGridVenda.pas',
  UGridVendaDAO in 'Model\UGridVendaDAO.pas',
  UVendaProdPesqView in 'View\UVendaProdPesqView.pas' {frmVendaPesq};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
