unit UFrmGerarClassJson;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ScrollBox, FMX.Memo,
  UGerarModelFromJson;

type
  TfrmGerarClassJson = class(TForm)
    Layout1: TLayout;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGerarClassJson: TfrmGerarClassJson;

implementation

{$R *.fmx}

procedure TfrmGerarClassJson.Button2Click(Sender: TObject);
var FclassJson: TGerarModelFromJson;
begin
  FclassJson:= TGerarModelFromJson.Create;
  try
    FclassJson.json:= Memo1.Lines.Text;
    FclassJson.NomeClasse := 'teste';
    FclassJson.GerarClasse;
  finally
    FclassJson.Free;
  end;
end;

end.
