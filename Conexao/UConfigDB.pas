unit UConfigDB;

interface

uses
  inifiles,
  classes,
  SysUtils;

type
  TConfigDB = Class(TPersistent)
  private
    Fip_servidor: string;
    FDB: string;
    Fporta: string;
    FCaminhoProjeto: string;
  published
     property ip_servidor: string read Fip_servidor write Fip_servidor;
     property porta: string read Fporta write Fporta;
     property DB: string read FDB write FDB;
     property CaminhoProjeto: string read FCaminhoProjeto write FCaminhoProjeto;
  public
     constructor Create();
     procedure gravar();
  End;
implementation

{ TConfigDB }

constructor TConfigDB.Create;
var
 oIni: TIniFile;
begin

   oIni:= TIniFile.Create(GetCurrentDir+'\Conexao.ini');
   try
      Fip_servidor := oIni.ReadString('CONEXAO','IP_SERVIDOR','');
      Fporta       := oIni.ReadString('CONEXAO','PORTA'      ,'');
      FDB          := oIni.ReadString('CONEXAO', 'RETAGUARDA','');
      CaminhoProjeto := oIni.ReadString('CONFIGURACAO', 'CAMINHO_PROJETO','');
   finally
      oIni.Free;
   end;
end;

procedure TConfigDB.gravar;
var
 oIni: TIniFile;
begin
   oIni:= TIniFile.Create(GetCurrentDir+'\Conexao.ini');
   try
      oIni.WriteString('CONEXAO','IP_SERVIDOR', Fip_servidor);
      oIni.WriteString('CONEXAO','PORTA'      , Fporta);
      oIni.WriteString('CONEXAO', 'RETAGUARDA', FDB);
      oIni.WriteString('CONFIGURACAO', 'CAMINHO_PROJETO', CaminhoProjeto);
   finally
      oIni.Free;
   end;
end;

end.
