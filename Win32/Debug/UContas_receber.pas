unit UContas_receber;

interface

uses
  Classes,
  System.Generics.Collections,
  System.SysUtils,            
  Data.SqlExpr,               
  UTabela;                    

type
  TContas_receber = class(TPersistent)
  private
    FTabela: TTabela;
    FId: integer;
    FId_gerado_caixa: integer;
    FId_cliente: integer;
    FDt_conta: TDate;
    FDt_venc: TDate;
    FHistorico: String;
    FTipo_doc: String;
    FNosso_numero: String;
    FNumero_documento: String;
    FVlr_conta: Currency;
    FVlr_desconto: Currency;
    FVlr_acrescimo: Currency;
    FVlr_juros: Currency;
    FVlr_bx_parcial: Currency;
    FVlr_quitacao: Currency;
    FVlr_tarifa: Currency;
    FVlr_iof: Currency;
    FDt_quitacao: TDate;
    FBoleto_impresso: String;
    FSituacao: String;
    FId_operacao: integer;
    FTipo_operacao: String;
    FRetorno: String;
    FRemessa: String;
    FRemessa_status: String;
    FId_operador: integer;
    FOperador: String;
    FParcela: String;
    FSerie_ecf: String;
    FQuantidade_parcela: integer;
    FNumero_parcela: integer;
    FCentro_custo: String;
    FCentro_custo_descricao: String;
    FCoo: integer;
    FOrdem_ecf: integer;
    FBarras_parcela: Currency;
    FVlr_juros_acum: Currency;
    FDt_bx_parc: TDate;
    FVlr_fatura: Currency;
    FId_banco: integer;
    FCheque_conta: String;
    FCheque_agencia: String;
    FCheque_cidade: String;
    FCheque_titular: String;
    FFoto: String;
    FId_cobranca_boleto: integer;
    FId_conta_bancaria: integer;
    FVlr_multa: Currency;
    FHora_emissao: TTime;
    FCheque_situacao: String;
    FCheque_portador: String;
  published
    property Id: integer read FId write FId;
    property Id_gerado_caixa: integer read FId_gerado_caixa write FId_gerado_caixa;
    property Id_cliente: integer read FId_cliente write FId_cliente;
    property Dt_conta: TDate read FDt_conta write FDt_conta;
    property Dt_venc: TDate read FDt_venc write FDt_venc;
    property Historico: String read FHistorico write FHistorico;
    property Tipo_doc: String read FTipo_doc write FTipo_doc;
    property Nosso_numero: String read FNosso_numero write FNosso_numero;
    property Numero_documento: String read FNumero_documento write FNumero_documento;
    property Vlr_conta: Currency read FVlr_conta write FVlr_conta;
    property Vlr_desconto: Currency read FVlr_desconto write FVlr_desconto;
    property Vlr_acrescimo: Currency read FVlr_acrescimo write FVlr_acrescimo;
    property Vlr_juros: Currency read FVlr_juros write FVlr_juros;
    property Vlr_bx_parcial: Currency read FVlr_bx_parcial write FVlr_bx_parcial;
    property Vlr_quitacao: Currency read FVlr_quitacao write FVlr_quitacao;
    property Vlr_tarifa: Currency read FVlr_tarifa write FVlr_tarifa;
    property Vlr_iof: Currency read FVlr_iof write FVlr_iof;
    property Dt_quitacao: TDate read FDt_quitacao write FDt_quitacao;
    property Boleto_impresso: String read FBoleto_impresso write FBoleto_impresso;
    property Situacao: String read FSituacao write FSituacao;
    property Id_operacao: integer read FId_operacao write FId_operacao;
    property Tipo_operacao: String read FTipo_operacao write FTipo_operacao;
    property Retorno: String read FRetorno write FRetorno;
    property Remessa: String read FRemessa write FRemessa;
    property Remessa_status: String read FRemessa_status write FRemessa_status;
    property Id_operador: integer read FId_operador write FId_operador;
    property Operador: String read FOperador write FOperador;
    property Parcela: String read FParcela write FParcela;
    property Serie_ecf: String read FSerie_ecf write FSerie_ecf;
    property Quantidade_parcela: integer read FQuantidade_parcela write FQuantidade_parcela;
    property Numero_parcela: integer read FNumero_parcela write FNumero_parcela;
    property Centro_custo: String read FCentro_custo write FCentro_custo;
    property Centro_custo_descricao: String read FCentro_custo_descricao write FCentro_custo_descricao;
    property Coo: integer read FCoo write FCoo;
    property Ordem_ecf: integer read FOrdem_ecf write FOrdem_ecf;
    property Barras_parcela: Currency read FBarras_parcela write FBarras_parcela;
    property Vlr_juros_acum: Currency read FVlr_juros_acum write FVlr_juros_acum;
    property Dt_bx_parc: TDate read FDt_bx_parc write FDt_bx_parc;
    property Vlr_fatura: Currency read FVlr_fatura write FVlr_fatura;
    property Id_banco: integer read FId_banco write FId_banco;
    property Cheque_conta: String read FCheque_conta write FCheque_conta;
    property Cheque_agencia: String read FCheque_agencia write FCheque_agencia;
    property Cheque_cidade: String read FCheque_cidade write FCheque_cidade;
    property Cheque_titular: String read FCheque_titular write FCheque_titular;
    property Foto: String read FFoto write FFoto;
    property Id_cobranca_boleto: integer read FId_cobranca_boleto write FId_cobranca_boleto;
    property Id_conta_bancaria: integer read FId_conta_bancaria write FId_conta_bancaria;
    property Vlr_multa: Currency read FVlr_multa write FVlr_multa;
    property Hora_emissao: TTime read FHora_emissao write FHora_emissao;
    property Cheque_situacao: String read FCheque_situacao write FCheque_situacao;
    property Cheque_portador: String read FCheque_portador write FCheque_portador;
public
   function NomeTabela():string;
   function PrimaryKey():string;
   function Carregar(): TObjectList<TContas_receber>;
   function Gravar(): boolean;                   
   function Delete(): boolean;                   
   function NomeGenerator(): string;             
   constructor Create(_id:integer = -1); 
   constructor CreateFirst(_Filter:string = ''); 
  end;

implementation

{TContas_receber}

constructor TContas_receber.Create(_id: integer);
var
FTabela: TTabela;  
oqry   : TSQLQuery;
sSQL   : string;   
begin
  if _id > 0 then                                     
  begin                                               
    sSQL    := 'SELECT * FROM CONTAS_RECEBER';            
    sSQL    := sSQL + ' WHERE ID = ' + IntToStr(_id); 
    sSQL    := sSQL + ' ORDER BY ID';                 
    FTabela := TTabela.Create;              
    try                                     
      oqry:= FTabela.Open(sSQL);            
      FTabela.SerializarObjeto(oqry, Self); 
    finally          
      FTabela.Free;  
    end;       
  end          
  else         
    ID := -1;  
end;

constructor TContas_receber.CreateFirst(_Filter: string);
var
  FTabela: TTabela;  
  oqry   : TSQLQuery;
  sSQL   : string;   
begin                
  if _Filter <> '' then                                
  begin                                                  
    _filter:= ' WHERE ' + _filter;                     
    sSQL    := 'SELECT * FROM CONTAS_RECEBER'; 
    sSQL    := sSQL + _Filter;                           
    sSQL    := sSQL + ' ORDER BY ID';     
    FTabela := TTabela.Create;                           
    try                                     
      oqry:= FTabela.Open(sSQL);            
      FTabela.SerializarObjeto(oqry, Self); 
    finally                
     FTabela.Free;         
   end;                    
  end                      
  else                     
    ID:= -1;  
end;                       

function TContas_receber.NomeTabela(): string;
begin
  Result:= 'Contas_receber';
end;

function TContas_receber.Carregar(): TObjectList<TContas_receber>;
var
  FTabela: TTabela;
  oContas_receber:TContas_receber;
  oqry: TSQLQuery; 
  sSQL: string;    
begin
  Result := TObjectList<TContas_receber>.Create; 
  sSQL:= 'SELECT * FROM CONTAS_RECEBER ORDER BY ID';
  FTabela              := TTabela.Create; 
  try                                     
    oqry:= FTabela.Open(sSQL);            
    while not oqry.Eof do                 
    begin                                 
      oContas_receber   := TContas_receber.Create;  
      FTabela.Classe := oContas_receber;        
      FTabela.SerializarObjeto(oqry, oContas_receber);
      Result.Add(oContas_receber);                   
      oqry.Next;                          
    end;                                  
  finally                                 
    FTabela.Free;                         
  end;
end;

function TContas_receber.Delete(): boolean;
var
  sSQL: string;
begin          
  Result:= True;
  FTabela := TTabela.Create();   
  try                            
    sSQL   := 'DELETE FROM CONTAS_RECEBER WHERE ID = '+ IntToStr(ID) ;
    FTabela.ExecutarSQL(sSQL);   
  finally                        
    FTabela.Free;                
  end;                           
end;

function TContas_receber.Gravar(): boolean;
var                                             
  sSQL: string;                                 
begin                                           
  Result  := True;
  FTabela := TTabela.Create();                  
  try                                           
    FTabela.Classe     := Self;                 
    FTabela.NomeTabela := NomeTabela;           
    if  ID <= 0 then                            
    begin                                       
      ID   := FTabela.GetNewID(NomeGenerator);  
      sSQL := FTabela.PrepararInsert();         
    end                                         
    else                                        
      sSQL := FTabela.PrepararUpdate();         
    FTabela.ExecutarSQL(sSQL);                  
  finally         
    FTabela.free; 
  end; 
end;

function TContas_receber.NomeGenerator(): string;
begin
  Result:= 'CONTAS_RECEBER_GEN';
end;

function TContas_receber.PrimaryKey():string;
begin
  Result:= 'ID';
end;

end.