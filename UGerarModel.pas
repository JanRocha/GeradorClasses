unit UGerarModel;

interface

uses Classes;

type
  TGerarModel = class(TPersistent)
  public
    function ValidaCampo(value: string): string;
    procedure GerarModel(Tabela: string);
  end;

implementation

uses
  FMX.Memo, UTabelas, System.SysUtils;

{ TGerarModel }

procedure TGerarModel.GerarModel(Tabela: string);
var
  Memo1: TMemo;
  oTabela: TTabela;
begin
  oTabela := TTabela.Create;
  oTabela.Query.SQL.Add('SELECT R.RDB$FIELD_NAME AS Nome_Campo,');
  oTabela.Query.SQL.Add('         CASE F.RDB$FIELD_TYPE        ');
  oTabela.Query.SQL.Add('           WHEN 7 THEN ''SMALLINT''     ');
  oTabela.Query.SQL.Add('           WHEN 8 THEN ''INTEGER''      ');
  oTabela.Query.SQL.Add('           WHEN 10 THEN ''FLOAT''       ');
  oTabela.Query.SQL.Add('           WHEN 11 THEN ''D_FLOAT''     ');
  oTabela.Query.SQL.Add('           WHEN 12 THEN ''DATE''        ');
  oTabela.Query.SQL.Add('           WHEN 13 THEN ''TIME''        ');
  oTabela.Query.SQL.Add('           WHEN 14 THEN ''CHAR''       ');
  oTabela.Query.SQL.Add('           WHEN 16 THEN ''INT64''      ');
  oTabela.Query.SQL.Add('           WHEN 27 THEN ''DOUBLE''      ');
  oTabela.Query.SQL.Add('           WHEN 35 THEN ''TIMESTAMP''    ');
  oTabela.Query.SQL.Add('           WHEN 37 THEN ''VARCHAR''     ');
  oTabela.Query.SQL.Add('           WHEN 40 THEN ''CSTRING''       ');
  oTabela.Query.SQL.Add('           WHEN 261 THEN ''BLOB''         ');
  oTabela.Query.SQL.Add('           ELSE ''UNKNOWN''               ');
  oTabela.Query.SQL.Add('          END AS Tipo_Campo              ');
  oTabela.Query.SQL.Add('    FROM RDB$RELATION_FIELDS R           ');
  oTabela.Query.SQL.Add
    ('     JOIN RDB$FIELDS F ON R.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME ');
  oTabela.Query.SQL.Add('   WHERE R.RDB$RELATION_NAME = ' + quotedSTr(Tabela));
  oTabela.Query.SQL.Add(' ORDER BY R.RDB$FIELD_POSITION');

  oTabela.Query.Open();

  Memo1 := TMemo.Create(nil);
  Memo1.Lines.Add('unit U' + Tabela + ';');
  Memo1.Lines.Add('');
  Memo1.Lines.Add('interface');
  Memo1.Lines.Add('');
  Memo1.Lines.Add('uses');
  Memo1.Lines.Add('  Classes;');
  Memo1.Lines.Add('');
  Memo1.Lines.Add('type');
  Memo1.Lines.Add('  T' + Tabela + ' = class(TPersistent)');
  Memo1.Lines.Add('  private');
  while not oTabela.Query.Eof do
  begin
    Memo1.Lines.Add('    F' + oTabela.Query.FieldByName('Nome_Campo').AsString + ': '+
    ValidaCampo(oTabela.Query.FieldByName('Nome_Campo').AsString) +';');
    oTabela.Query.Next;
  end;
  Memo1.Lines.Add('  published');
  oTabela.Query.First;
  while not oTabela.Query.Eof do
  begin
    Memo1.Lines.Add('    property ' +
    oTabela.Query.FieldByName('Nome_Campo').AsString + ': ' +
    ValidaCampo(oTabela.Query.FieldByName('Tipo_Campo').AsString)+
     ' read F'+ oTabela.Query.FieldByName('Nome_Campo').AsString+
     ' write F'+ oTabela.Query.FieldByName('Nome_Campo').AsString +';');
    oTabela.Query.Next;
  end;
  Memo1.Lines.Add('   function NomeTabela():string;');
  Memo1.Lines.Add('  end;');
  Memo1.Lines.Add('');
  Memo1.Lines.Add('implementation');
  Memo1.Lines.Add('');
  Memo1.Lines.Add('{T'+Tabela+'}');
  Memo1.Lines.Add('');
  Memo1.Lines.Add('function TCIDADES.NomeTabela: string;');
  Memo1.Lines.Add('begin');
  Memo1.Lines.Add('   Result:= '''+ Tabela + ''';');
  Memo1.Lines.Add('end;');
  Memo1.Lines.Add('');
  Memo1.Lines.Add('end.');

  Memo1.Lines.SaveToFile('U' + Tabela + '.pas');
end;

function TGerarModel.ValidaCampo(value: string): string;
begin
  if value = 'SMALLINT' then
    Result := 'integer'
  else if value = 'SMALLINT' then
    Result := 'integer'
  else if value = 'FLOAT' then
    Result := 'Currency'
  else if value = 'D_FLOAT' then
    Result := 'Currency'
  else if value = 'DATE' then
    Result := 'TDate'
  else if value = 'TIME' then
    Result := 'TTime'
  else if value = 'CHAR' then
    Result := 'String'
  else if value = 'INT64' then
    Result := 'int64'
  else if value = 'DOUBLE' then
    Result := 'Currency'
  else if value = 'TIMESTAMP' then
    Result := 'Tdatetime'
  else if value = 'CSTRING' then
    Result := 'String'
  else
    Result := 'String';

end;

end.
