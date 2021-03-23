unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Layouts,
  UGerarModel, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.ListBox;

type
  TForm2 = class(TForm)
    Layout1: TLayout;
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses UTabelas;

procedure TForm2.Button1Click(Sender: TObject);
var oTabela: TTabela;
begin
   oTabela:= TTabela.Create;
   oTabela.Query.SQL.Add('SELECT RDB$RELATION_NAME AS TABELA FROM RDB$RELATIONS WHERE RDB$VIEW_BLR IS NULL and RDB$SYSTEM_FLAG = 0 OR RDB$SYSTEM_FLAG IS NULL ORDER BY RDB$RELATION_NAME');
   oTabela.Query.Open();
   while not oTabela.Query.Eof do
   begin
     ComboBox1.Items.Add(oTabela.Query.FieldByName('TABELA').AsString);
     oTabela.Query.Next;
   end;
end;

procedure TForm2.Button2Click(Sender: TObject);
var oGerar: TGerarModel;
begin
   oGerar:= TGerarModel.Create;
   try
     oGerar.GerarModel(ComboBox1.Items[ComboBox1.ItemIndex]);
   finally
     oGerar.Free;
   end;
end;

end.
