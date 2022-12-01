program GeradorDeClasses;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPrincipal in 'UPrincipal.pas' {Form2},
  UConexao in 'Conexao\UConexao.pas',
  UConfigDB in 'Conexao\UConfigDB.pas',
  UTabelas in 'Conexao\UTabelas.pas',
  UGerarModel in 'UGerarModel.pas',
  UModelDatabaseGenerator in 'UModelDatabaseGenerator.pas' {frmModelDataBaseGenerator},
  UGerarModelFromJson in 'UGerarModelFromJson.pas',
  UFrmGerarClassJson in 'UFrmGerarClassJson.pas' {frmGerarClassJson},
  Pkg.Json.Mapper in 'Pkg.Json.Mapper.pas',
  UViewClassjon in 'UViewClassjon.pas' {frmViewClassjson},
  UGerarController in 'UGerarController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TfrmModelDataBaseGenerator, frmModelDataBaseGenerator);
  Application.CreateForm(TfrmGerarClassJson, frmGerarClassJson);
  Application.CreateForm(TfrmViewClassjson, frmViewClassjson);
  Application.Run;
end.
