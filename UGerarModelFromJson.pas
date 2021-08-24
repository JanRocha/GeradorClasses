unit UGerarModelFromJson;

interface
uses
  Pkg.Json.Mapper,
  UViewClassjon,
  Classes;

type

  TGerarModelFromJson = class(TPersistent)
  private
    Fjm: TPkgJsonMapper;
    Fjson: string;
    FNomeClasse: string;
   published
    property json:string read Fjson write Fjson;
    property NomeClasse:string read  FNomeClasse write FNomeClasse;
  public
    procedure GerarClasse();
  end;
implementation

uses
  FMX.Memo;

{ TGerarModelFromJson }

procedure TGerarModelFromJson.GerarClasse;
var memo:TMemo;
begin
  Fjm:= TPkgJsonMapper.Create();
  try
    Fjm.Parse(json,NomeClasse);
    Fjm.DestinationUnitName:= 'U'+NomeClasse;
    memo:= TMemo.Create(nil);
    try
      memo.Lines.Text:= Fjm.GenerateUnit();
      memo.Lines.SaveToFile(NomeClasse+'.pas');


      frmViewClassjson:= TfrmViewClassjson.Create(nil);
      try
        frmViewClassjson.memo.Lines.Text:= memo.Lines.Text;
        frmViewClassjson.ShowModal;
      finally
        frmViewClassjson.free;
      end;

    finally
      memo.Free;
    end;
  finally
    Fjm.Free;
  end;
end;

end.
