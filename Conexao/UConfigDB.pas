unit UConfigDB;

interface
   uses inifiles, classes, SysUtils;

type
   TConfigDB = Class(TPersistent)
   private
      Fip_servidor: string;
      FDB: string;
      Fporta: string;
   published
      property ip_servidor: string read Fip_servidor write Fip_servidor;
      property porta: string read Fporta write Fporta;
      property DB: string read FDB write FDB;
   public
      constructor Create();
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
   finally
      oIni.Free;
   end;


end;

end.
