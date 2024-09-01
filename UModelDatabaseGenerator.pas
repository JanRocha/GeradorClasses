unit UModelDatabaseGenerator;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,

  UTabelas,
  UGerarModel, FMX.ScrollBox, FMX.Memo
  ;

type
  TfrmModelDataBaseGenerator = class(TForm)
    Layout1: TLayout;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    listTabelaACriar: TListBox;
    listBanco: TListBox;
    Button7: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmModelDataBaseGenerator: TfrmModelDataBaseGenerator;

implementation

uses
  UGerarController;

{$R *.fmx}

procedure TfrmModelDataBaseGenerator.Button1Click(Sender: TObject);
var oTabela: TTabela;
begin
   oTabela:= TTabela.Create;
   oTabela.Query.SQL.Add('SELECT RDB$RELATION_NAME AS TABELA FROM RDB$RELATIONS WHERE RDB$VIEW_BLR IS NULL and RDB$SYSTEM_FLAG = 0 OR RDB$SYSTEM_FLAG IS NULL ORDER BY RDB$RELATION_NAME');
   oTabela.Query.Open();
   while not oTabela.Query.Eof do
   begin
     listBanco.Items.Add(oTabela.Query.FieldByName('TABELA').AsString);
     oTabela.Query.Next;
   end;
end;

procedure TfrmModelDataBaseGenerator.Button2Click(Sender: TObject);
var
  oGerar: TGerarModel;
  i: integer;
begin
   oGerar:= TGerarModel.Create;
   try
     for i := 0 to listTabelaACriar.Items.Count -1 do
       oGerar.GerarModel(listTabelaACriar.Items[i]);
   finally
     oGerar.Free;
   end;
end;

procedure TfrmModelDataBaseGenerator.Button3Click(Sender: TObject);
var index:integer;
begin
  index:=  listBanco.ItemIndex;
  listTabelaACriar.Items.Add(listBanco.Items[index]);

  listBanco.Items.Delete(listBanco.ItemIndex);
  listTabelaACriar.Sorted:= true;

  if index = 0 then
  index:= 1;
  listBanco.ItemIndex := index - 1;
  listBanco.SetFocus;

end;

procedure TfrmModelDataBaseGenerator.Button7Click(Sender: TObject);
var
  oGerar: TGerarController;
  i: integer;
begin
   oGerar:= TGerarController.Create();
   try
     for i := 0 to listTabelaACriar.Items.Count -1 do
       oGerar.GerarController(LowerCase(listTabelaACriar.Items[i]));
   finally
     oGerar.Free();
   end;

end;

end.
