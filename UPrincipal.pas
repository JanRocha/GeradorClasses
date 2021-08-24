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
  UModelDataBaseGenerator
  ;

type
  TForm2 = class(TForm)
    StatusBar1: TStatusBar;
    LblConexao: TLabel;
    Button2: TButton;
    Button3: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    FConfig: TConfigDB;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

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

procedure TForm2.FormShow(Sender: TObject);
begin
  LblConexao.Text:='';
  FConfig:= TConfigDB.Create;
  try
    LblConexao.Text := FConfig.ip_servidor + ':' + FConfig.DB;
    if LblConexao.Text = '' then
      MessageDlg('Configure o acesso a dados',TMsgDlgType.mtwarning,[TMsgDlgBtn.mbok],0);
  finally
    FConfig.Free;
  end;
end;

end.
