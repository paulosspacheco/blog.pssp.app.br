Criado por grok.ia

# TUiDmxScroller.CreateStruct Method Documentation

O método `TUiDmxScroller.CreateStruct` é responsável por processar uma string de template (`ATemplate`) e criar uma lista encadeada de registros de campos (`DMXField1`) que define a estrutura de dados para um componente de interface de usuário. Ele suporta uma ampla gama de tipos de campos, atributos e configurações, permitindo a construção de estruturas de dados complexas para formulários ou controles de entrada de dados.

## Assinatura do Método

```pascal
procedure TUiDmxScroller.CreateStruct(var ATemplate: TString);
```

- **Parâmetro**: `ATemplate` - Uma string que define o formato e a estrutura dos campos, incluindo tipos, tamanhos, nomes, aliases e outros atributos.
- **Objetivo**: Traduzir a string de template em uma lista encadeada de registros de campos (`pDmxFieldRec`), configurando propriedades como tipo de dado, tamanho, nome do campo, visibilidade e comportamento.

## Variáveis Locais

As variáveis locais são usadas para gerenciar o estado do processamento do template e a criação dos registros de campos:

- **SameFieldNum**: `Boolean` - Indica se o número do campo atual é o mesmo do anterior.
- **WasSameNum**: `Boolean` - Registra se o número do campo foi o mesmo anteriormente.
- **NoFieldNum**: `Boolean` - Indica se o campo não deve receber um número.
- **NoFieldAdv**: `Boolean` - Controla se o avanço automático do campo está desativado.
- **AllZeroes**: `Boolean` - Define se valores zero devem ser exibidos.
- **C**: `AnsiChar` - Armazena o caractere atual sendo processado na string de template.
- **DoDecimal**: `Integer` - Controla o número de casas decimais para campos numéricos.
- **Rex, X**: `pDmxFieldRec` - Ponteiros para registros de campos, usados para manipular a lista encadeada.
- **WFieldName**: `TString` - Armazena temporariamente o nome do campo.
- **DmxStr_ID**: `TDmxStr_ID` - Estrutura para dados de campos enumerados.
- **_templx**: `TString` - String temporária para construir o template processado.
- **_templx_Org**: `AnsiString` - Armazena a string de template original.

## Funções e Procedimentos Aninhados

### SetFlags

Define valores para as flags booleanas de controle.

```pascal
Procedure SetFlags(aFlag: Boolean);
begin
  SameFieldNum := aFlag;
  WasSameNum   := aFlag;
  NoFieldNum   := aFlag;
  NoFieldAdv   := aFlag;
end;
```

- **Propósito**: Inicializa ou redefine as flags para um estado específico.
- **Uso**: Chamado em `NewRecord` e `TranslateStruct` para garantir que as flags estejam corretas antes de processar novos campos.

### templx (Funções Sobrecarregadas)

Gerencia a construção da string de template processada.

#### templx(Const Ch, ch_Org: TString): AnsiString

Adiciona caracteres às strings `_templx` e `_templx_Org`.

```pascal
function templx(Const Ch, ch_Org: TString): AnsiString;
begin
  if Ch = '' then
  begin
    _templx := '';
    _templx_Org := '';
  end
  else
  begin
    _templx := _templx + Ch;
    _templx_Org := _templx_Org + ch_Org;
  end;
  Result := _templx;
end;
```

- **Propósito**: Concatena caracteres processados à string de template, mantendo uma cópia original.

#### templx(Const Ch: TString): AnsiString

Chama a função principal `templx` com um `ch_Org` vazio.

```pascal
function templx(Const Ch: TString): AnsiString;
begin
  Result := templx(Ch, '');
end;
```

- **Propósito**: Simplifica chamadas quando não é necessário manter uma cópia original do caractere.

#### templx: AnsiString

Retorna o valor atual de `_templx`.

```pascal
function templx: AnsiString;
begin
  Result := _templx;
end;
```

- **Propósito**: Permite acesso ao template processado sem modificações.

### NewRecord

Cria um novo registro de campo e atualiza a lista encadeada.

```pascal
procedure NewRecord;
begin
  if not CreateValid then Exit;
  with TUiMethods, Rex^ do
  begin
    if DoDecimal > 0 then Rex.Decimals := pred(DoDecimal);
    DoDecimal := 0;
    if FieldSize = 0 then
      access := access or accSkip
    else
    begin
      if not NoFieldAdv then
      begin
        if SameFieldNum and (not NoFieldNum) then
        begin
          Fieldnum := succ(TotalFields);
          if WFieldName = '' then
            WFieldName := Format('Field%d', [Fieldnum]);
          FieldName := WFieldName;
          DataFields.AddFields(Rex);
        end
        else if (access and accHidden = 0) or WasSameNum then
        begin
          Inc(TotalFields);
          Fieldnum := TotalFields;
          if (WFieldName = '') and (Fieldnum <> 0) then
            WFieldName := Format('Field%d', [Fieldnum]);
          FieldName := WFieldName;
          if FieldName <> '' then
            DataFields.AddFields(Rex);
        end;
        DataTab := RecordSize;
        RecordSize := RecordSize + FieldSize;
      end;
    end;
    ScreenTab := Limit.X;
    if (TypeCode = FldBoolean) and (TrueLen = 0) then
      ShowZeroes := FALSE;
    if TypeCode in [fldENUM, FLdEnum_db] then
      ColumnWid := TrueLen
    else
    begin
      if ColumnWid = 0 then
        ColumnWid := length(AnsiString_to_USASCII(templx));
      if (length(templx) > 0) or (Template <> nil) then
      begin
        Template := NewStr(templx);
        Template_org := _templx_Org;
      end
      else if (TypeCode <> #0) and (access and accHidden = 0) then
        Inc(Limit.X);
    end;
    if ShownWid = 0 then
      ShownWid := ColumnWid;
    if access and accHidden = 0 then
      Limit.X := Limit.X + ShownWid;
  end;
  templx('');
  New(Rex.Next);
  X := Rex;
  X.RSelf := Rex;
  Rex := Rex.Next;
  FillChar(Rex^, sizeof(Rex^), 0);
  Rex.Prev := X;
  Rex.Next := nil;
  Rex.ShowZeroes := AllZeroes;
  WFieldName := '';
  Rex.Owner_UiDmxScroller := Self;
  Rex.ProviderFlags := [pfInUpdate, pfInWhere];
  Rex.ID_Dynamic := Alias + '_' + CreateGUID;
  Rex.QuitFieldAltomatic := QuitFieldAltomatic_Default;
  SetFlags(false);
end;
```

- **Propósito**: Cria e configura um novo registro de campo, atualiza a lista encadeada, e define propriedades como número do campo, nome, tamanho e visibilidade.
- **Funcionalidades**:
  - Define o número do campo (`Fieldnum`) com base em `TotalFields`.
  - Gera nomes de campo automáticos (e.g., `Field1`, `Field2`) se `WFieldName` estiver vazio.
  - Atualiza tamanhos de registro (`RecordSize`) e posições na tela (`ScreenTab`, `Limit.X`).
  - Configura propriedades como `ShowZeroes`, `ColumnWid`, e `Template`.
  - Aloca o próximo registro e inicializa suas propriedades.

### TranslateStruct

Processa a string de template caractere por caractere, configurando os registros de campo.

```pascal
procedure TranslateStruct(dataformat: ptString);
var
  df: ptString;
  i, j: integer;
  Flag: byte;
  TS: PSItem;
  temp1, temp2: TDmxStr_ID;
  LenDataformat: integer;
```

- **Propósito**: Analisa a string de template, identifica tipos de campos e atributos, e configura os registros de campo correspondentes.
- **Variáveis Locais**:
  - `df`: Ponteiro para string de dados (usado em recursão).
  - `i, j`: Contadores para iteração na string.
  - `Flag`: Armazena flags numéricas para configurações como chaves primárias ou estrangeiras.
  - `TS`: Ponteiro para itens de lista (usado em `fldSItems`).
  - `temp1, temp2`: Armazenam formatos de data/hora temporariamente.
  - `LenDataformat`: Comprimento da string de template.

#### Funções Auxiliares

##### GetFieldName

Extrai o nome do campo a partir do template.

```pascal
function GetFieldName: AnsiString;
begin
  result := '';
  if CharFieldName <> dataformat^[i] then exit;
  Inc(i);
  While (not (dataformat^[i] in Delimiters)) and (i <= length(dataformat^)) do
  begin
    Result := Result + dataformat^[i];
    Inc(i);
  end;
end;
```

- **Propósito**: Captura o nome do campo após o delimitador `CharFieldName` (`~`).

##### GetExecAction

Extrai uma ação de execução e o nome do campo associado.

```pascal
function GetExecAction: AnsiString;
var
  s, aFieldName: AnsiString;
begin
  result := '';
  aFieldName := '';
  Inc(i);
  s := Copy(dataformat^, i, length(dataformat^));
  if Pos('.', s) <> 0 then
  begin
    While (dataformat^[i] in ['_', 'a'..'z', 'A'..'Z', '0'..'9']) and
          (dataformat^[i] <> '.') and (not (dataformat^[i] in Delimiters)) and
          (i <= length(dataformat^)) do
    begin
      aFieldName := aFieldName + dataformat^[i];
      Inc(i);
    end;
    With Rex^ do
      LinkExecAction := FieldByName(aFieldName);
    Inc(i);
  end;
  While (i <= length(dataformat^)) and (dataformat^[i] in [' ', '_', 'a'..'z', 'A'..'Z', '0'..'9']) and
        (not (dataformat^[i] in Delimiters)) do
  begin
    Result := Result + dataformat^[i];
    Inc(i);
  end;
  result := DelSpcED(Result);
end;
```

- **Propósito**: Captura ações de execução e associa campos a elas, usando a notação de ponto (e.g., `campo.acao`).

##### Get_Alias

Extrai um alias para o campo.

```pascal
function Get_Alias: AnsiString;
begin
  result := '';
  Inc(i);
  While (not (dataformat^[i] in Delimiters)) and (i <= length(dataformat^)) do
  begin
    Result := Result + dataformat^[i];
    Inc(i);
  end;
end;
```

- **Propósito**: Obtém um alias definido no template para o campo.

##### GetFormatoDateTime

Extrai o formato de data/hora.

```pascal
function GetFormatoDateTime: AnsiString;
begin
  result := '';
  Inc(i);
  While (i <= length(dataformat^)) and (dataformat^[i] in ['d', 'm', 'y', 'h', 'n', 's', 'z', '/', '-', ' ', ':']) do
  begin
    Result := Result + dataformat^[i];
    Inc(i);
  end;
end;
```

- **Propósito**: Captura o formato de data/hora (e.g., `dd/mm/yyyy`) para campos `FldDateTime`.

##### GetHints

Processa dicas (hints) para o campo, incluindo "Porque" e "Onde".

```pascal
procedure GetHints;
begin
  if (i > 254) then exit;
  if (dataformat^[i] <> CharHint) then exit;
  inc(i);
  if dataformat^[i] in ['0', '1'] then
  begin
    case dataformat^[i] of
      '0': begin
             While (not (dataformat^[i] in Delimiters)) and (i <= LenDataformat) do
             begin
               inc(i);
               Rex^.HelpCtx_Porque := Rex^.HelpCtx_Porque + dataformat^[i];
             end;
           end;
      '1': begin
             While (not (dataformat^[i] in Delimiters)) and (i <= LenDataformat) do
             begin
               inc(i);
               Rex^.HelpCtx_Onde := Rex^.HelpCtx_Onde + dataformat^[i];
             end;
           end;
    end;
  end
  else
  begin
    While (not (dataformat^[i] in Delimiters)) and (i <= LenDataformat) and (i < sizeof(tstring)) do
    begin
      Rex^.HelpCtx_hint := Rex^.HelpCtx_hint + dataformat^[i];
      inc(i);
    end;
  end;
end;
```

- **Propósito**: Extrai dicas contextuais (`HelpCtx_Porque`, `HelpCtx_Onde`, ou `HelpCtx_hint`) para fornecer informações adicionais ao usuário.

##### GetDefault

Captura valores padrão ou expressões para o campo.

```pascal
procedure GetDefault;
var
  chaControl: char;
begin
  if dataformat^[i] <> CharDefaultBase then exit;
  inc(i);
  chaControl := dataformat^[i];
  inc(i);
  While (not (dataformat^[i] in Delimiters)) and (i <= LenDataformat) do
  begin
    case chaControl of
      '0': Rex^.DefaultConst := Rex^.DefaultConst + dataformat^[i];
      '1': Rex^.DefaultExpression := Rex^.DefaultExpression + dataformat^[i];
      else Raise TException.Create(self, {$I %CURRENTROUTINE%}, 'Erro de sintaxe ao capturar o valor default!.');
    end;
    inc(i);
  end;
end;
```

- **Propósito**: Define valores padrão constantes ou expressões para o campo.

## Processamento de Tipos de Campos

O método `TranslateStruct` processa a string de template caractere por caractere, identificando e configurando diferentes tipos de campos:

- **FldBoolean**: Configura campos booleanos com tamanho de 1 byte e define alias.
- **FldRadioButton**: Gerencia botões de rádio, agrupando-os em clusters (`ClusterTemps`) e definindo números de campo compartilhados.
- **fldStr, fldStrNumber**: Campos de string, incrementando o tamanho do campo e definindo valores de preenchimento (`FillValue`).
- **fldAnsiChar, fldAnsiCharAlfa, fldAnsiCharNum, fldAnsiCharNumPositive**: Campos de caractere único, com suporte a decimais.
- **fldByte, fldShortInt, fldLongInt, fldSmallWord, fldSmallInt**: Campos numéricos inteiros com tamanhos específicos.
- **FldDateTime**: Campos de data/hora, capturando formatos específicos.
- **fldHexValue**: Campos hexadecimais, com tamanho calculado com base no comprimento.
- **fldDouble, fldDoublePositive, fldReal4, fldReal4Positivo, fldReal4P, fldReal4PPositivo**: Campos de ponto flutuante, com suporte a decimais.
- **fldENUM, fldENUM_Db**: Campos enumerados, configurando fontes de dados, chaves e listas de opções.
- **fldBLOB**: Campos de dados binários, com ajustes para arquiteturas de 32 e 64 bits.
- **fldAPPEND**: Permite recursão para processar subestruturas.
- **fldSItems**: Processa listas de itens recursivamente.

## Atributos e Configurações

O método suporta uma variedade de atributos e configurações, processados através de caracteres especiais:

- **CharFieldName (`~`)**: Define o nome do campo (e.g., `~Nome_do_Produto`).
- **CharShowPassword**: Define um caractere para exibir senhas.
- **ThousandSeparator, DecimalSeparator**: Configura separadores para números.
- **CharExecAction**: Associa ações de execução a campos.
- **CharDelimiter_0 (`#0`), CharDelimiter_1 (`\`)**: Delimitadores para separar campos.
- **CharAllZeroes (`^A`)**: Controla a exibição de valores zero.
- **CharAccHidden (`^H`), CharAccReadOnly (`^R`), CharAccSkip (`^S`)**: Define flags de acesso (oculto, somente leitura, ignorar).
- **CharProviderFlag (`^P`)**: Configura flags de provedor (e.g., `pfInUpdate`, `pfInKeyPrimary`).
- **CharForeignKey (`^F`)**: Define chaves estrangeiras com ações como `Fk_Cascade` ou `Fk_Set_Null`.
- **CharUpperlimit (`^U`)**: Define limites superiores para campos.
- **CharFillvalue (`^V`)**: Define valores de preenchimento.
- **CharShowzeroes (`^Z`)**: Habilita a exibição de valores zero.
- **CharHint**: Adiciona dicas contextuais.

## Lógica Principal

```pascal
begin
  if (@ATemplate = nil) then Exit;
  try
    wState := SetState(Mb_St_Creating_Template, true);
    AllZeroes := FALSE;
    templx('');
    New(Rex);
    FillChar(Rex^, sizeof(Rex^), 0);
    Rex.Next := nil;
    Rex.Prev := nil;
    Rex.ShowZeroes := AllZeroes;
    X := nil;
    if DMXField1 = nil then
      DMXField1 := Rex
    else
    begin
      X := DMXField1;
      while X.Next <> nil do X := X.Next;
      X.Next := Rex;
      Rex.Prev := X;
    end;
    TranslateStruct(@ATemplate);
    if templx <> '' then NewRecord;
    if (Rex = DMXField1) then DMXField1 := nil;
    Dispose(Rex);
    if (X <> nil) then X.Next := nil;
    if DMXField1 <> nil then DMXField1.Prev := X;
  finally
    SetState(Mb_St_Creating_Template, wState);
  end;
end;
```

- **Inicialização**: Verifica se `ATemplate` é válido, define o estado (`Mb_St_Creating_Template`), e inicializa o primeiro registro de campo (`Rex`).
- **Processamento**: Chama `TranslateStruct` para processar a string de template.
- **Finalização**: Cria um último registro se necessário, limpa a estrutura e restaura o estado.

## Exemplo de Uso

```pascal
var
  Template: TString;
begin
  Template := 's10~Nome~^Hs5~Idade~^Rd10~Data~';
  TUiDmxScroller.CreateStruct(Template);
end;
```

- **Explicação**:
  - `s10~Nome~`: Cria um campo string de 10 caracteres chamado "Nome".
  - `^H`: Define o próximo campo como oculto.
  - `s5~Idade~`: Cria um campo string de 5 caracteres chamado "Idade".
  - `^R`: Definestick
  - `d10~Data~`: Cria um campo de data/hora de 10 caracteres chamado "Data".

## Notas

- **Tratamento de Erros**: O método lança exceções (e.g., `TException`) para erros de sintaxe, como valores padrão inválidos.
- **Arquitetura**: Suporta 32 e 64 bits, com ajustes condicionais para campos BLOB.
- **Dependências**: Requer tipos como `TUiMethods`, `TObjectsMethods`, e estruturas como `pDmxFieldRec`.
- **Template**: A string de template deve seguir uma sintaxe rigorosa, com delimitadores e caracteres especiais bem definidos.

## Conclusão

O método `TUiDmxScroller.CreateStruct` é uma ferramenta poderosa para criar estruturas de dados dinâmicas para interfaces de usuário, com suporte a uma ampla gama de tipos de campos e configurações. Ele é altamente configurável, mas requer uma string de template bem formatada para evitar erros.


CRiado por cloud.ix.


# Documentação do Método CreateStruct

> **Arquivo:** CreateStruct_Documentation.md  
> **Versão:** 1.0  
> **Data:** 13/07/2025  
> **Autor:** Documentação técnica gerada

## Visão Geral

O método `CreateStruct` é responsável por criar uma estrutura de campos DMX (Data Management eXchange) a partir de um template de string. Este método faz parte da classe `TUiDmxScroller` e é fundamental para a criação dinâmica de formulários e estruturas de dados.

## Assinatura

```pascal
procedure TUiDmxScroller.CreateStruct(var ATemplate: TString);
```

### Parâmetros

- **ATemplate**: `TString` - Template de string que define a estrutura dos campos a serem criados

## Funcionamento

### 1. Estrutura Principal

O método utiliza um procedimento interno `TranslateStruct` que interpreta o template e cria uma lista encadeada de registros de campo (`TDmxFieldRec`).

### 2. Variáveis Principais

- **Rex**: Ponteiro para o registro de campo atual
- **X**: Ponteiro auxiliar para navegação na lista
- **templx**: Funções para construção do template
- **DoDecimal**: Contador para campos decimais
- **Flags de controle**: `SameFieldNum`, `WasSameNum`, `NoFieldNum`, `NoFieldAdv`, `AllZeroes`

### 3. Procedimentos Internos

#### SetFlags(aFlag: Boolean)
Define os flags de controle para o processamento dos campos.

#### templx (Sobrecarregado)
Conjunto de funções para construção e manipulação do template:
- `templx(Ch, ch_Org: tString): AnsiString` - Adiciona caracteres ao template
- `templx(Ch: tString): AnsiString` - Versão simplificada
- `templx: AnsiString` - Retorna o template atual

#### NewRecord
Cria um novo registro de campo e o adiciona à lista encadeada.

### 4. Funções de Análise do Template

#### GetFieldName: AnsiString
Extrai o nome do campo do template quando encontra o caractere `CharFieldName`.

#### GetExecAction: AnsiString
Obtém a ação de execução associada ao campo.

#### Get_Alias: AnsiString
Extrai o alias do campo.

#### GetFormatoDateTime: AnsiString
Obtém o formato de data/hora do campo.

#### GetHints
Processa as dicas (hints) do campo, incluindo:
- Porque (índice 0)
- Onde (índice 1)
- Hint geral

#### GetDefault
Processa valores padrão do campo:
- Constante padrão (índice 0)
- Expressão padrão (índice 1)

## Tipos de Campo Suportados

### Campos Básicos
- **FldBoolean**: Campo booleano
- **FldRadioButton**: Botão de rádio
- **fldStr/fldStrNumber**: Campos de string
- **fldAnsiChar** (e variações): Caracteres ANSI
- **fldByte/fldShortInt**: Números inteiros pequenos
- **fldSmallWord/fldSmallInt**: Números inteiros médios
- **fldLongInt**: Números inteiros longos

### Campos Numéricos
- **fldDouble/fldDoublePositive**: Números de ponto flutuante
- **fldExtended**: Números estendidos
- **fldReal4** (e variações): Números reais
- **fldHexValue**: Valores hexadecimais

### Campos Especiais
- **FldDateTime**: Data e hora
- **fldENum/fldENUM_Db**: Campos enumerados
- **fldBLOB**: Campos BLOB
- **fldSItems**: Itens de estrutura

## Caracteres de Controle

### Controle de Acesso
- **CharAccHidden** (^H): Campo oculto
- **CharAccReadOnly** (^R): Campo somente leitura
- **CharAccSkip** (^S): Campo ignorado

### Formatação
- **ThousandSeparator**: Separador de milhares
- **DecimalSeparator**: Separador decimal
- **CharShowzeroes** (^Z): Mostrar zeros
- **CharAllZeroes** (^A): Alternar exibição de zeros

### Metadados
- **CharFieldName**: Nome do campo
- **CharHint**: Dicas do campo
- **CharDefaultBase**: Valores padrão
- **CharExecAction**: Ação de execução
- **CharProviderFlag** (^P): Flags do provedor
- **CharForeignKey** (^F): Chave estrangeira

### Delimitadores
- **CharDelimiter_0** (#0): Delimitador nulo
- **CharDelimiter_1** (\): Delimitador de barra
- **CharDelimiter_3** (~): Delimitador de til

## Flags do Provedor (CharProviderFlag)

- **0**: `pfInUpdate` - Campo participará de atualizações
- **1**: `pfInWhere` - Campo será usado em cláusulas WHERE
- **2**: `pfInKey` - Campo é chave
- **3**: `pfHidden` - Campo oculto
- **4**: `pfRefreshOnInsert` - Atualizar na inserção
- **5**: `pfRefreshOnUpdate` - Atualizar na atualização
- **6**: `pfInKeyPrimary` - Chave primária
- **7**: `pfInKeyPrimary + pfInAutoIncrement` - Chave primária auto-incremental

## Flags de Chave Estrangeira (CharForeignKey)

- **0**: `Fk_No_Action` - Sem ação
- **1**: `Fk_Restrict` - Restringir
- **2**: `Fk_Cascade` - Cascata
- **3**: `Fk_Set_Null` - Definir nulo
- **4**: `Fk_Set_Default` - Definir padrão

## Fluxo de Execução

1. **Inicialização**: Cria o primeiro registro de campo e inicializa variáveis
2. **Análise do Template**: Processa caractere por caractere do template
3. **Identificação de Tipos**: Determina o tipo de campo baseado no caractere
4. **Configuração de Propriedades**: Define tamanho, tipo, acesso e outras propriedades
5. **Criação de Registros**: Adiciona novos registros à lista encadeada
6. **Finalização**: Limpa registros temporários e ajusta ponteiros

## Exemplo de Uso

```pascal
var
  Template: TString;
begin
  Template := '~Nome:~SSSSSSSSSSSS^BNome_Campo^P6' + 
              '~Idade:~BBB^BIdade_Campo^P0' +
              '~Salário:~RRRRR.RR^BSalario_Campo^P0';
  
  UiDmxScroller.CreateStruct(Template);
end;
```

## Tratamento de Erros

O método possui tratamento básico de erros através de:
- Verificação de ponteiros nulos
- Controle de estados (`SetState`)
- Bloco `try-finally` para garantir limpeza de recursos
- Validação de sintaxe em alguns casos específicos

## Considerações Importantes

1. **Memória**: O método aloca dinamicamente registros de campo que devem ser liberados apropriadamente
2. **Estado**: Utiliza controle de estado para evitar processamento recursivo
3. **Compatibilidade**: Suporta diferentes arquiteturas (CPU32/CPU64)
4. **Template**: Salva o template original quando `ShouldSaveTemplate` é verdadeiro

## Observações Técnicas

- O método modifica o estado interno da classe durante execução
- Utiliza lista encadeada para organizar os campos
- Suporta campos compostos e aninhados
- Implementa cache de templates para performance
- Compatível com diferentes tipos de dados Pascal/Delphi