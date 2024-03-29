unit UTabelas;

interface

uses
  UConexao,
  Classes,
  FireDAC.Comp.Client;

type
  TTabela = class(Tpersistent)
  private
    FQuery: TFDQuery;
    FConn : TConexao;
  published
    property Query: TFDQuery read FQuery write FQuery;
  public
    constructor Create();
    destructor Destroy; override;
  end;

implementation

{ TTabela }

constructor TTabela.Create;
begin
   FConn           := TConexao.Create;
   Query           := TFDQuery.Create(Query);
   Query.Connection:= FConn.Connection;
   FConn.Connection.Connected := true;
end;

destructor TTabela.Destroy;
begin
   Query.Free;
   FConn.Create;
  inherited;
end;

end.
