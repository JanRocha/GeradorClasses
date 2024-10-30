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
  var lNomeObjeto := AnsiUpperCase(pNomeClasse[1]) + LowerCase(Copy(pNomeClasse, 2, Length(pNomeClasse)));
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
      Add('  Model.Entidade.'+ lNomeObjeto +',');
      Add('  Controller.Funcao,');
      Add('  Classes,');
      Add('  cxGridDBTableView,');
      Add('  Data.DB,');
      Add('  FireDAC.Comp.Client,');
      Add('  Controller.Helpers,');
      Add('  FenixPlusCxComboBox,');
      Add('  FenixSQL,');
      Add('  FenixORM,');
      Add('  Vcl.DBGrids,');
      Add('  Vcl.StdCtrls,');
      Add('  Vcl.Session,');
      Add('  Model.DataModule,');
      Add('  System.Generics.Collections,');
      Add('  System.SysUtils;');
      Add('');
      Add('type');
      Add('  TController' + lNomeClasse + ' = class(TPersistent)');
      Add('  private');
      Add('    FDAO: TFenixORM<T'+ lNomeObjeto + '>;');
      Add('    F' + lNomeClasse + ': T' + LowerCase(lNomeObjeto) + ';');
      Add('    FId' + lNomeClasse + ' :Integer;');
      Add('    FDescricao: string;');
      Add('  public');
      Add('    property ' + lNomeClasse + ': T' + LowerCase(pNomeClasse) + ' read F' + lNomeClasse + ' write F' + lNomeClasse + ';');
      Add('    property Id' + lNomeClasse + ': Integer read FId' + lNomeClasse + ' write FId' + lNomeClasse + ';');
      Add('    procedure CarregarDadosGrid(lTableView: TcxGridDBTableView); overload;');
      Add('    function Carregar(const pFiltro: string): TFDQuery;');
      Add('    procedure Gravar();');
      Add('    procedure AfterScroll(Dataset: TDataSet);');
      Add('');
      Add('    constructor Create(Const pFiltro: string); overload;');
      Add('    constructor Create(Const pId: Integer); overload;');
      Add('    constructor Create(); overload;');
      Add('    destructor Destroy(); override;');
      Add('end;');
      Add('');
      Add('implementation');
      Add('');
      Add('{T'+lNomeClasse+'}');
      Add('');

      Add('procedure TController' + lNomeClasse + '.AfterScroll(Dataset: TDataSet);');
      Add('begin');
      Add('  if DataSet.RecordCount > 0 then');
      Add('  begin');
      Add('    FId' + lNomeClasse + ' := DataSet.FieldByName(''ID'').AsInteger;');
      Add('    FDescricao := DataSet.FieldByName(''DESCRICAO'').AsString;');
      Add('  end;');
      Add('end;');
      Add('');
      Add('procedure TController' + lNomeClasse + '.CarregarDadosGrid(lTableView: TcxGridDBTableView);');
      Add('const');
      Add('  CONSULTA =       ''SELECT''');
      Add('    + sLineBreak + ''  *''');
      Add('    + sLineBreak + ''  FROM''');
      Add('    + sLineBreak + ''' + lNomeObjeto+ ''';');
      Add('begin');
      Add('  lTableView.DataController.DataSource.DataSet.Free();');
      Add('  lTableView.DataController.DataSource.DataSet := FDAO.Find(CONSULTA);');
      Add('  lTableView.DataController.DataSource.DataSet.AfterScroll := AfterScroll;');
      Add('  if ( not lTableView.DataController.DataSource.DataSet.IsEmpty()) then');
      Add('    lTableView.DataController.DataSource.DataSet.First();');
      Add('end;');
      Add('');
      Add('function TController' + lNomeClasse + '.Carregar(const pFiltro: string): TFDQuery;');
      Add('begin');
      Add('  Result := FDAO.Find(pFiltro);');
      Add('end;');
      Add('');
      Add('constructor TController' + lNomeClasse + '.Create(const pFiltro: string);');
      Add('begin');
      Add('  F' + lNomeClasse + ' := T' + lNomeObjeto + '.Create();');
      Add('  FDAO := TFenixORM<T' + lNomeObjeto + '>.Create(DM.Conexao);');
      Add('  FDAO.Find(pFiltro, F' + lNomeClasse + ');');
      Add('end;');
      Add('');
      Add('constructor TController' + lNomeClasse + '.Create();');
      Add('begin');
      Add('  F' + lNomeClasse + ' := T' + lNomeObjeto + '.Create();');
      Add('  FDAO := TFenixORM<T' + lNomeObjeto + '>.Create(DM.Conexao);');
      Add('end;');
      Add('');
      Add('constructor TController' + lNomeClasse + '.Create(const pId: Integer);');
      Add('begin');
      Add('  F' + lNomeClasse + ' := T' + lNomeObjeto + '.Create();');
      Add('  FDAO := TFenixORM<T' + lNomeObjeto + '>.Create(DM.Conexao);');
      Add('  FDAO.Find(pId, F' + lNomeClasse + ');');
      Add('end;');
      Add('');
      Add('destructor TController' + lNomeClasse + '.Destroy();');
      Add('begin');
      Add('  F' + lNomeClasse + '.Free();');
      Add('  FDAO.Free();');
      Add('  inherited;');
      Add('end;');
      Add('');
      Add('procedure TController' + lNomeClasse + '.Gravar();');
      Add('begin');
      Add('  if F' + lNomeClasse + '.id > 0 then');
      Add('    FDAO.Update(F' + lNomeClasse + ')');
      Add('  else');
      Add('  begin');
      Add('    F' + lNomeClasse + '.Id_usuario := TSession.Id_usuario;');
      Add('    if FDAO.Insert(F' + lNomeClasse + ') then');
      Add('    F' + lNomeClasse + '.Id := FDAO.LastId();');
      Add('  end;');
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
