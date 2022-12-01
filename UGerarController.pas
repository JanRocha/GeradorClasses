unit UGerarController;

interface

type

  TGerarController = class
  public
    procedure GerarController(const pNomeClasse: string);
  end;

implementation

uses
  FMX.Memo, UConfigDB, System.SysUtils, System.Classes;

{ TGerarController }

function NomeClasse(const NomeClasse: string): string;
var
  lPalavras: TstringList;
  lPalavra: string;
  I: Integer;
  lNomeClasse: string;
begin
  lNomeClasse := LowerCase(NomeClasse);
  lPalavras := TStringList.Create();
  try
    lPalavras.Delimiter := '_';
    lPalavras.DelimitedText := lNomeClasse;

    for I := 0 to lPalavras.Count -1 do
    begin
      lPalavra := lPalavras[I];
      Result := Result + AnsiUpperCase(lPalavra[1]) + Copy(lPalavra, 2, Length(lPalavra));
    end;

  finally
    lPalavras.Free();
  end;
end;

procedure TGerarController.GerarController(const pNomeClasse: string);
var
  pClasseController: TMemo;
  pConfig: TConfigDB;
  lNomeClasse: string;
begin
  lNomeClasse := NomeClasse(pNomeClasse);

  pClasseController := TMemo.Create(nil);
  pConfig := TConfigDB.Create();
  try
    with pClasseController.Lines do
    begin
      Add('unit Controller.' + lNomeClasse+  ';');
      Add('');
      Add('interface');
      Add('');
      Add('uses');
      Add('  Model.Entidade.'+ LowerCase(pNomeClasse) +',');
      Add('  Classes,');
      Add('  Data.DB,');
      Add('  FireDAC.Comp.Client,');
      Add('  Vcl.DBGrids,');
      Add('  Vcl.StdCtrls,');
      Add('  cxGridDBTableView,');
      Add('  System.Generics.Collections,');
      Add('  System.SysUtils,');
      Add('  Controller.Funcao,');
      Add('  Fenixplus.Controller.Helpers,');
      Add('  FenixPlusCxComboBox;');
      Add('');
      Add('type');
      Add('  TController' + lNomeClasse + ' = class(TPersistent)');
      Add('  private');
      Add('    F' + lNomeClasse + ': T' + LowerCase(pNomeClasse) + ';');
      Add('    FId' + lNomeClasse + ': Integer;');
      Add('    FDescricao: string;');
      Add('    procedure Validar();');
      Add('  public');
      Add('    property ' + lNomeClasse + ': T' + LowerCase(pNomeClasse) + ' read F' + lNomeClasse + ' write F' + lNomeClasse + ';');
      Add('    property Id' + lNomeClasse + ': Integer read FId' + lNomeClasse + ' write FId' + lNomeClasse + ';');
      Add('    //procedure CarregarDadosGrid(lGrid: TDBGrid); overload;');
      Add('    procedure CarregarDadosGrid(lTableView: TcxGridDBTableView); overload;');
      Add('    function CarregarDados(const pFiltro: string): TFDQuery;');
      Add('    //procedure LimparForm();');
      Add('    procedure Gravar();');
      Add('    procedure AfterScroll(Dataset: TDataSet);');
      Add('    procedure CarregarDadosComboBox(pCompo: TFenixCxComboBox);');
      Add('    function id(): string;');
      Add('    function Descricao(): string;');
      Add('    function NomeTabela(): string;');
      Add('    constructor Create(pFiltro: string); overload;');
      Add('    constructor Create(pId: Integer); overload;');
      Add('    constructor Create(); overload;');
      Add('    destructor Destroy(); override;)');
      Add('end;');
      Add('');
      Add('implementation');
      Add('');
      Add('{T'+pNomeClasse+'}');
      Add('');

      Add('procedure TController' + lNomeClasse + '.AfterScroll(Dataset: TDataSet);');
      Add('begin');
      Add('  if DataSet.RecordCount >0 then');
      Add('  begin');
      Add('    FId' + lNomeClasse + ' := DataSet.FieldByName(''ID'').AsInteger;');
      Add('    FDescricao := DataSet.FieldByName(''DESCRICAO'').AsString;');
      Add('  end;');
      Add('end;');
      Add('');
      Add('procedure TController' + lNomeClasse + '.CarregarDadosComboBox(pCompo: TFenixCxComboBox);');
      Add('var');
      Add('  lLista' + lNomeClasse + ': TFDQuery;');
      Add('begin');
      Add('  lLista' + lNomeClasse + ' := F' + lNomeClasse + '.Carregar(EmptyStr);');
      Add('  try');
      Add('    while not lLista' + lNomeClasse + '.Eof do');
      Add('    begin');
      Add('      pCompo.Properties.Items.AddObject(lLista' + lNomeClasse + '.FieldByName(''Descricao'').AsString,');
      Add('        TObject(lLista' + lNomeClasse + '.FieldByName(''Id'').AsInteger));');
      Add('      lLista' + lNomeClasse + '.Next();');
      Add('    end;');
      Add('  finally');
      Add('    FreeAndNil(lLista' + lNomeClasse + ');');
      Add('  end;');
      Add('end;');
      Add('');
      Add('procedure TController' + lNomeClasse + '.CarregarDadosGrid(lTableView: TcxGridDBTableView);');
      Add('const');
      Add('  CONSULTA =       ''SELECT'';');
      Add('    + sLineBreal + ''  *''');
      Add('    + sLineBreak + ''  FROM''');
      Add('    + sLineBreak + ''' + pNomeClasse+ ';');
      Add('begin');
      Add('  lTableView.DataController.DataSource.DataSet.Free();');
      Add('  lTableView.DataController.DataSource.DataSet := F' + lNomeClasse + '.CarregarPersonalizado(CONSULTA);');
      Add('  lTableView.DataController.DataSource.DataSet.AfterScroll := AfterScroll;');
      Add('  if ( not lTableView.DataController.DataSource.DataSet.IsEmpty()) then');
      Add('    lTableView.DataController.DataSource.DataSet.First();');
      Add('end;');
      Add('');
      Add('constructor TController' + lNomeClasse + '.CarregarDados(const pFiltro: string): TFDQuery;');
      Add('var');
      Add('  l'+ lNomeClasse + ';');
      Add('begin');
      Add('  l' + lNomeClasse + ' := T' + pNomeClasse + '.Create(pFiltro);');
      Add('  try');
      Add('    Result := l'+ lNomeClasse + '.Carregar(pFiltro);');
      Add('  finally');
      Add('    F'+ lNomeClasse + '.Free();');
      Add('  end;');
      Add('end;');
      Add('');
      Add('constructor TController' + lNomeClasse + '.Create(pFiltro: string);');
      Add('begin');
      Add('  F' + lNomeClasse + ' := T' + pNomeClasse + '.Create(pFiltro);');
      Add('end;');
      Add('');
      Add('constructor TController' + lNomeClasse + '.Create();');
      Add('begin');
      Add('  F' + lNomeClasse + ' := T' + pNomeClasse + '.Create();');
      Add('end;');
      Add('');
      Add('constructor TController' + lNomeClasse + '.Create(pId: Integer);');
      Add('begin');
      Add('  F' + lNomeClasse + ' := T' + pNomeClasse + '.Create(pId);');
      Add('end;');
      Add('');
      Add('function TController' + lNomeClasse + '.Descricao: string;');
      Add('begin');
      Add('  Result := FDescricao;');
      Add('end;');
      Add('');
      Add('destructor TController' + lNomeClasse + '.Destroy();');
      Add('begin');
      Add('  F' + lNomeClasse + '.Free();');
      Add('  inherited;');
      Add('end;');
      Add('');
      Add('procedure TController' + lNomeClasse + '.Gravar();');
      Add('begin');
      Add('  try');
      Add('    Validar();');
      Add('    F' + lNomeClasse + '.Gravar();');
      Add('  except on E: Exception do');
      Add('  end;');
      Add('end;');
      Add('');
      Add('function TController' + lNomeClasse + '.id(): string;');
      Add('begin');
      Add('  Result := FId' + lNomeClasse + '.ToStringFormatado();');
      Add('end;');
      Add('');
      Add('function TController' + lNomeClasse + '.NomeTabela(): string;');
      Add('begin');
      Add('  Result := F' + lNomeClasse + '.NomeTabela();');
      Add('end;');
      Add('');
      Add('procedure TController' + lNomeClasse + '.Validar();');
      Add('begin');
      Add('');
      Add('end;');
      Add('');
      Add('end.');

      SaveToFile('Controller.'+lNomeClasse + '.pas');
    end;

  finally
    pConfig.Free();
    pClasseController.Free();
  end;
end;

end.
