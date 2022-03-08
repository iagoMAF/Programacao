unit UPessoa;

interface

uses SysUtils, Classes;

type
  Tpessoa = Class(TPersistent)

    private
      vId                  : Integer;
      vTipo_Pessoa         : Integer;
      vNome                : String;
      vFisica_Juridica     : Integer;
      vIdentificadorPessoa : String; // Numero de CPF, CNPJ, Passaporte
      vAtivo               : Boolean;

    public
      constructor Create;
    published
      property Id                  : Integer  read vId write vId;
      property Tipo_Pessoa         : Integer  read vTipo_Pessoa write vId;
      property Nome                : String   read vNome write vId;
      property Fisica_Juridica     : Integer  read vFisica_Juridica write vId;
      property IdentificadorPessoa : String   read vIdentificadorPessoa write vId;
      property Ativo               : Boolean  read vAtivo write vId;
  end;

  TColPessoa = class(Tlist)
    public
        function Retorna(pIndex : Integer) : Tpessoa;
        procedure Adiciona(pPessoa : TPessoa);
  end;

implementation

{ Tpessoa }

constructor Tpessoa.Create;
begin
  Self.vId                  := 0;
  Self.vTipo_Pessoa         := 0;
  Self.vNome                := EmptyStr;
  Self.vFisica_Juridica     := 0;
  Self.vIdentificadorPessoa := EmptyStr;
  Self.vAtivo               := False;
end;

{ TColPessoa }

procedure TColPessoa.Adiciona(pPessoa: TPessoa);
begin
    Self.add(TPessoa(pPessoa));
end;

function TColPessoa.Retorna(pIndex: Integer): Tpessoa;
begin
    Result := TPessoa(Self[pIndex]);
end;

end.
