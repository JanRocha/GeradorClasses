program GeradorDeClasses;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPrincipal in 'UPrincipal.pas' {Form2},
  UConexao in 'Conexao\UConexao.pas',
  UConfigDB in 'Conexao\UConfigDB.pas',
  UTabelas in 'Conexao\UTabelas.pas',
  UGerarModel in 'UGerarModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
