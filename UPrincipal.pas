unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.ListBox,
  UConfigDB,
  UFrmGerarClassJson,
  UModelDataBaseGenerator, FMX.Edit, FMX.Objects
  ;

type
  TForm2 = class(TForm)
    StatusBar1: TStatusBar;
    LblConexao: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Panel2: TPanel;
    Button3: TButton;
    Button2: TButton;
    Button1: TButton;
    Panel3: TPanel;
    Label2: TLabel;
    Edit1: TEdit;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FConfig: TConfigDB;
    function SelectADirectory(Title: string): string;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

function TForm2.SelectADirectory(Title : string) : string;
var
  Pasta : String;
begin
  SelectDirectory(Title, '', Pasta);

  if (Trim(Pasta) <> '') then
    if (Pasta[Length(Pasta)] <> '\') then
      Pasta := Pasta + '\';

  Result := Pasta;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
    FConfig:= TConfigDB.Create;
  try
    FConfig.ip_servidor:= InputBox('Configuração','Digite o IP do servidor','127.0.0.1');
    OpenDialog1.Title:= 'Selecione a base de dados Firebird';
    OpenDialog1.Filter:= 'Arquivos .FDB|*.FDB|';
    if OpenDialog1.Execute then
       FConfig.DB := OpenDialog1.FileName;

     FConfig.gravar();
     LblConexao.Text := FConfig.ip_servidor + ':' + FConfig.DB;
  finally
    FConfig.Free;
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
  begin
  frmModelDataBaseGenerator:= TfrmModelDataBaseGenerator.Create(nil);
  try
    frmModelDataBaseGenerator.ShowModal;
  finally
    frmModelDataBaseGenerator.Free;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  frmGerarClassJson:= TfrmGerarClassJson.create(nil);
  try
   frmGerarClassJson.showmodal;
  finally
    frmGerarClassJson.free;
  end;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  Edit1.Text := SelectADirectory('Selecione a pasta raiz do projeto');

  if DirectoryExists(Edit1.Text) then
  begin
    FConfig:= TConfigDB.Create;
    try
      FConfig.CaminhoProjeto := Edit1.Text;
      FConfig.gravar();
    finally
      FConfig.Free();
    end;
  end;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  LblConexao.Text:='';
  FConfig:= TConfigDB.Create;
  try
    LblConexao.Text := FConfig.ip_servidor + ':' + FConfig.DB;
    if LblConexao.Text = '' then
      MessageDlg('Configure o acesso a dados',TMsgDlgType.mtwarning,[TMsgDlgBtn.mbok],0);

    Edit1.Text := FConfig.CaminhoProjeto;
  finally
    FConfig.Free;
  end;
end;

end.
