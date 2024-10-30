unit UGerarModel;

interface

uses
  Classes,
  UConfigDB;

type
  TGerarModel = class(TPersistent)
  private
    FConfig: TConfigDB;
  public
    function ValidaCampo(value, precisao, subTipo: string): string;
    procedure GerarModel(Tabela: string);
    function PrimeiraLetraMaiscula(Str: string): string;
    function PrimaryKey(Tabela:string):string;
    function Gen(Tabela:string):string;
  end;

implementation

uses
  FMX.Memo, UTabelas, System.SysUtils;

{ TGerarModel }

function TGerarModel.Gen(Tabela: string): string;
var
  oTabela    : TTabela;
begin
  Result:= '';
  oTabela    := TTabela.Create;
  try
    oTabela.Query.SQL.Add('SELECT D.RDB$DEPENDED_ON_NAME AS GENERATOR    ');
    oTabela.Query.SQL.Add(' FROM RDB$DEPENDENCIES D                      ');
    oTabela.Query.SQL.Add(' INNER JOIN RDB$TRIGGERS T ON T.RDB$TRIGGER_NAME = D.RDB$DEPENDENT_NAME');
    oTabela.Query.SQL.Add(' AND D.RDB$DEPENDED_ON_NAME LIKE ''%GEN%''');
    oTabela.Query.SQL.Add(' AND T.RDB$RELATION_NAME = ' + QuotedStr(Tabela));
    oTabela.Query.Open();
    Result:= oTabela.Query.FieldByName('GENERATOR').AsString;
  finally
    oTabela.Free;
  end;
end;

procedure TGerarModel.GerarModel(Tabela: string);
var
  Memo1      : TMemo;
  oTabela    : TTabela;
  sPrimaryKey: string;
  sGen       : string;
begin
  FConfig := TConfigDB.Create();
  try
    sPrimaryKey := PrimaryKey(Tabela);
    sGen        := Gen(Tabela);
    {TODO: Encapsular esta função}
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
    oTabela.Query.SQL.Add('          END AS Tipo_Campo,              ');
    oTabela.Query.SQL.Add(' RDB$FIELD_PRECISION AS PRECISAO, ');
    oTabela.Query.SQL.Add(' RDB$FIELD_SUB_TYPE  AS SUB_TIPO');
    oTabela.Query.SQL.Add('    FROM RDB$RELATION_FIELDS R           ');
    oTabela.Query.SQL.Add
      ('     JOIN RDB$FIELDS F ON R.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME ');
    oTabela.Query.SQL.Add('   WHERE R.RDB$RELATION_NAME = ' + quotedSTr(Tabela));
    oTabela.Query.SQL.Add(' ORDER BY R.RDB$FIELD_POSITION');

    oTabela.Query.Open();
    Tabela:= PrimeiraLetraMaiscula(Tabela);
    Memo1 := TMemo.Create(nil);
    Memo1.Lines.Add('unit Model.Entidade.' + Tabela + ';');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('interface');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('uses');
    Memo1.Lines.Add('  Rtti.Atributos,');
    Memo1.Lines.Add('  Classes;');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('type');
    Memo1.Lines.Add('  [Tabela(''' + UpperCase(Tabela) + ''')]');
    Memo1.Lines.Add('  T' + Tabela + ' = class(TPersistent)');
    Memo1.Lines.Add('  private');

    while not oTabela.Query.Eof do
    begin
      Memo1.Lines.Add('    F' + PrimeiraLetraMaiscula(oTabela.Query.FieldByName('Nome_Campo').AsString) + ': '+
      ValidaCampo(oTabela.Query.FieldByName('Tipo_Campo').AsString,oTabela.Query.FieldByName('PRECISAO').AsString,oTabela.Query.FieldByName('SUB_TIPO').AsString) +';');
      oTabela.Query.Next;
    end;
    Memo1.Lines.Add('  published');
    oTabela.Query.First;

    while not oTabela.Query.Eof do
    begin
      if oTabela.Query.FieldByName('Nome_Campo').AsString = 'ID' then
        Memo1.Lines.Add('    [Pk]');
      if  pos('ID_', oTabela.Query.FieldByName('Nome_Campo').AsString) > 0 then
        Memo1.Lines.Add('    [Fk]');
      if oTabela.Query.FieldByName('Nome_Campo').AsString = 'OID' then
        Memo1.Lines.Add('    [Ignore]');

      Memo1.Lines.Add('    property ' + PrimeiraLetraMaiscula(oTabela.Query.FieldByName('Nome_Campo').AsString) + ': ' +
      ValidaCampo(oTabela.Query.FieldByName('Tipo_Campo').AsString,oTabela.Query.FieldByName('PRECISAO').AsString,oTabela.Query.FieldByName('SUB_TIPO').AsString)+
       ' read F' + PrimeiraLetraMaiscula(PrimeiraLetraMaiscula(oTabela.Query.FieldByName('Nome_Campo').AsString)) +
       ' write F'+ PrimeiraLetraMaiscula(PrimeiraLetraMaiscula(oTabela.Query.FieldByName('Nome_Campo').AsString)) +';');
      oTabela.Query.Next;
    end;
    Memo1.Lines.Add('  end;');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('implementation');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('{T'+Tabela+'}');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('end.');
    Memo1.Lines.SaveToFile(FConfig.CaminhoProjeto + 'Model.Entidade.' + Tabela + '.pas');
  finally
    FConfig.Free();
  end;
end;

function TGerarModel.PrimaryKey(Tabela: string): string;
var
  oTabela    : TTabela;
begin
  Result     := '';
  oTabela    := TTabela.Create;
  try
    oTabela.Query.SQL.Add('SELECT IDX.RDB$FIELD_NAME AS PRIMARY_KEY');
    oTabela.Query.SQL.Add(' FROM RDB$RELATION_CONSTRAINTS TC ');
    oTabela.Query.SQL.Add(' JOIN RDB$INDEX_SEGMENTS IDX ON (IDX.RDB$INDEX_NAME = TC.RDB$INDEX_NAME) ');
    oTabela.Query.SQL.Add('WHERE TC.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'' AND                         ');
    oTabela.Query.SQL.Add('      TC.RDB$RELATION_NAME = '+ QuotedStr(Tabela));
    oTabela.Query.SQL.Add('ORDER BY IDX.RDB$FIELD_POSITION        ');
    oTabela.Query.Open();
    Result:= oTabela.Query.FieldByName('PRIMARY_KEY').AsString;
  finally
    oTabela.Free;
  end;
end;

function TGerarModel.PrimeiraLetraMaiscula(Str: string): string;
var
  i: integer;
  esp: boolean;
begin
  str := LowerCase(Trim(str));
  for i := 1 to Length(str) do
  begin
    if i = 1 then
      str[i] := UpCase(str[i])
    else
      begin
        if i <> Length(str) then
        begin
          esp := (str[i] = ' ');
          if esp then
            str[i+1] := UpCase(str[i+1]);
        end;
      end;
  end;
  Result := Str;
end;

function TGerarModel.ValidaCampo(value, precisao, subTipo: string): string;
begin
  if value = 'SMALLINT' then
    Result := 'Integer'
  else if value = 'INTEGER' then
    Result := 'Integer'
  else if value = 'SMALLINT' then
    Result := 'Integer'
  else if value = 'FLOAT' then
    Result := 'Currency'
  else if value = 'D_FLOAT' then
    Result := 'Currency'
  else if value = 'DATE' then
    Result := 'TDate'
  else if value = 'TIME' then
    Result := 'TTime'
  else if value = 'CHAR' then
    Result := 'string'
  else if value = 'INT64' then
  begin
    if (StrToIntDef(precisao, 0) > 0) and  (StrToIntDef(subTipo, 0) > 0) then
      Result := 'Currency'
    else
      Result := 'Int64';
  end
  else if value = 'DOUBLE' then
    Result := 'Currency'
  else if value = 'TIMESTAMP' then
    Result := 'Tdatetime'
  else if value = 'CSTRING' then
    Result := 'string'
  else
    Result := 'string';

end;

end.
