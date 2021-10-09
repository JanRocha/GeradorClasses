unit UConexao;

interface

uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  UConfigDB;

type
  TConexao = class
  private
    FConfigDB: TConfigDB;
    FConnection: TFDConnection;
  public
    property Connection: TFDConnection read FConnection write FConnection;
    constructor Create();
    destructor Destroy; override;
  end;

implementation

{ TConexao }

constructor TConexao.Create;
begin
   Connection                 := TFDConnection.Create(Connection);
   FConfigDB                  := TConfigDB.Create;
   Connection.LoginPrompt     := false;
   Connection.Params.DriverID := 'FB';
   Connection.Params.Database := FConfigDB.ip_servidor+'/'+FConfigDB.porta + ':' + FConfigDB.DB;
   Connection.Params.UserName := 'SYSDBA';
   Connection.Params.Password := 'masterkey';
  end;

destructor TConexao.Destroy;
begin
  Connection.Free;
  inherited;
end;

end.
