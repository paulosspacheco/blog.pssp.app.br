=============================================================
Constantes usados no gerador de recursor.


unit mi.rtl.Consts;
{:< - A Unit **@name** reúne as constantes globais usados pelo pacote
      **mi.rtl**.

  - **VERSÃO**
    - Alpha - 1.0.0

  - **CÓDIGO FONTE**:
    - @html(<a href="../units/mi.rtl.consts.pas">mi.rtl.consts.pas</a>)          
  
  - **HISTÓRICO**
    - Criado por: Paulo Sérgio da Silva Pacheco e-mail: paulosspacheco@@yahoo.com.br
      - **13/11/2021** : Classe criada

      - **/16/11/2021** :
        - Em **TConsts.Initialization** executar:
          - **System.FileMode** := **TConsts.FileMode**;
          - Motivo: O mapa de Bits **System.FileMode** não permite acesso compartilhado.

      - **15/12/2021**
        - Criado a constante Identification = TIdentification.

      - **31/12/2021**
        - Criado a constante NRec e NRecAux para manter a compatibilidade com o passado.

      - **24/06/2022
        - Criar constante FldLink  
}


{$H+}

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  {$IFDEF Windows}Windows,{$ENDIF}
  {$IFDEF UNIX}BaseUnix,  Unix,
//               clocale, cwstring,
  {$ENDIF}

  Classes
  ,SysUtils
  ,db

  ,process

  ,fpTemplate
  ,mi.rtl.types;

  {: A variável **@name** foi declarada porque os controles dataware não estão
     obdecendo o valor padrão}
  var FormatBr: TFormatSettings;

  { TConsts }
  {: A classe **@name** declara todas as constantes globais do
     pacote Mi.RTL
  }
 type
 TConsts =
  class(TTypes)
    {:A constante **@name** contém o nome das aplicações clientes que pretendo
      gerar automaticamente.
    }
    public const NameClientsApplication : TNameClientsApplication =
      ('indefinido','lcl'+PathDelim+'units','javascript','dynamic_html','vuejs','angularjs','reactjs');

    {:A constante **@name** contém o nome da extenção dos arquivos das aplicações
      clientes que pretendo gerar automaticamente.
    }
    public const NameClientsApplicationExt : TNameClientsApplicationExt =
      ('','pas','js','html'        ,'vue'  ,'js'       ,'js');

    public Const C_MessageError : TMessageError = nil;
    public Const C_DEF_VER_FORMAT4             = '{mjr}.{mnr}.{rev}.{bld}';
    public Const C_DEF_VER_FORMAT3             = '{mjr}.{mnr}.{rev}';
    public Const C_DEF_VER_FORMAT2             = '{mjr}.{mnr}';

    {: Pilha com tStrings de erros.}
    public  Const ListaDeMsgErro : TTypes.PSItem = nil;

    public
      {$REGION 'tvDMX Field access attributes' }
        { Resumo criado por Rand back:

           Modificador de código de campo:
             ' Z'--zero modificador para forçar conduzindo ou arrastando zeroes

             # SINTAXE DE RECURSOS DO TEMPLATE MARICARAI

             1. **Códigos de Controles**
                - _~_ switch tString-literals on/off
                - _^A_ Zera todos os campos
                - _^B_ Indica que os caracteres seguintes contém o nome do campo
                - _^C_ O campo corrente possui uma lista de opções do mesmo tipo.
                - _ _ Use o próximo o estilo da fonte do campo anterior . Ideia não implementado
                - _^D_ fldENum_db = campo do tipo longint associado a um dataSource
                - _^E_ fldENum = Campo do tipo enumerado.
                - _^F_ Usado para criar restrições e relacionamentos
                - _^G_ Usada para concatenar duas listas do tipo PSItem.
                - _^H_ Campo escondido
                - _^I_ Link para cadeia de template pSItem
                - _^J_ Retorno do carro
                - _^k0_ Os caracteres após ^k0 é capturado no campo TDmxFieldRec.DefaultConst
                - _^k1_ Os caracteres após ^k1 é capturado no campo TDmxFieldRec.Expression
                - _^L_ Link para uma URL ou actionItens
                - _^M_ Fim da linha
                - _^N_ A sequência a seguir é o hint do campo.
                - _^O_ Campo fldBLOb
                - _^P_ Usado para controlar o flag do tipo de campo
                   ^Q  Livre
                - _^R_ Campo somente de leitura
                - _^S_ Salte campo para o próximo campo de acesso normal
                - _^T_ O campo é um botão de ação
                - _^U_ Informar um limite superior campos do tipo byte. Faixa: [0..255]
                - _^V_ Se o campo for numérico, preencha com '#0'(AccNormal) se for alfanumérico, preencha com ' ' AccNormal
                - _X_ Campo de BOOLEAN especial
                - _^Z_ Zera se este campo está vazio

             2. **Delimitadores de campos:**
                - #0 = delimiter de campo técnico (não exibe)
                - \ = exibe como um espaço
                - | = exibe como**Tipos de campos:** uma linha vertical sólida (#179)

             3. **Códigos de tipos de dados**
                - _'E'_ fldExtended = Número real com sizeof = 10 bytes. Aceita positivos e negativos
                - _'O'_ fldReal4 = Número Real sizeof = 4 Byte. Aceita positivos e negativos
                - _'o'_ fldReal4Positivo = Número Real sizeof = 4 Byte. Aceita só positivos
                - _'P'_ fldReal4P = Número Real sizeof = 4 Byte. Ao entrar no campo o mesmo é por 100 e ao sair o mesmo é dividido por 100 aceita positivos e negativos
                - _'p'_ fldReal4PPositivo = Número Real sizeof = 4 Ao entrar no campo o mesmo é por 100 e ao sair o mesmo é dividido por 100 aceita positivos e negativos
                - _'R'_ fldDouble = número real sizeof = 8 positivos e negativos;
                - _'r'_ fldDoublePositive = Número real sizeof = 8 positivo;
                - _'B'_ fldByte = Campo do tipo byte só permite valores de 0 a 254
                - _'J'_ fldShortInt = Número shortint sizeof = 1 aceita positivo e negativo
                - _'W'_ fldSmallWord = Número SmallWord sizeof = 2 aceita só positivos
                - _'I'_ fldSmallInt = Número SmallInt sizeof = 2 aceita só positivos e negativos
                - _'L'_ fldLongInt = Número longint = 4 bytes aceita positivos e negativos
                - _'#'_ fldStrNumber = Numero String que só aceita digitos 0 a 9
                - _'0'_ fldAnsiCharNumPositive = AnsiChar que só aceita digitos 0 a 9
                - _'N'_ fldAnsiCharNum = Aceita caractere numérico ['0'..'9']] com formatação dbase.
                - _'S'_ fldStr = Campo ShortString maiusculas;
                - _'s'_ fldStrAlfa = Campo ShortString maiusculas e minusculas;
                - _'C'_ fldAnsiChar = AnsiString maiusculas;
                - _'c'_ fldAnsiChar = AnsiString maiusculas e minusculas;
                - _'X'_ fldBoolean = Campo boolean só aceita 0 ou 1
                - _'D'_ FldDateTime  //:< TDateTime;Guarda a data e hora compactada. O Formato é retonado pela função TDateFreePascal.TDatesFreePascal.Mask_to_MaskEdit
                - _'k'_ k Minusculo tipo FldDbRadioButton.
                - _'K'_ K maiúsculo tipo FldRadioButton.



                      ```pascal

                          const
                            fldAnsiChar          = 'C'; //:< AnsiString maiusculas;
                            fldAnsiCharAlfa      = 'c'; //:< AnsiString maiusculas e minusculas;
                            fldAnsiCharNum       = 'N'; //:< Aceita caractere numérico ['0'..'9']] com formatação dbase.
                            fldAnsiCharNumPositive  = '0'; //:< AnsiChar que só aceita digitos 0 a 9
                            fldStrNumber         = '#'; //:< Numero String que só aceita digitos 0 a 9
                            fldStr               = 'S'; //:< Campo ShortString maiusculas;
                            fldStrAlfa           = 's'; //:< Campo ShortString maiusculas e minusculas;
                            fldExtended          = 'E'; //:< Real 10 bytes
                            fldDouble            = 'R'; //:< Número real sizeof = 8 positivos e negativos;
                            fldDoublePositive    = 'r'; //:< Número real sizeof = 8 positivo;
                            fldReal4             = 'O'; //:< Real 4 Byte positivos e negativos
                            fldReal4Positivo     = 'o'; //:< Real 4 Byte positivos
                            fldReal4P            = 'P'; //:< P = Real de mostrado x por 100 positivos e negativos
                            fldReal4PPositivo    = 'p'; //:< P = Real de mostrado x por 100 positivos
                            fldENum              = ^E;  //:< Tipo TComboBox se o registro não está associado a banco de dados;
                            fldENum_db           = ^D;  //:< campo do tipo longint associado a um dataSource
                            fldBoolean           = 'X'; //:< Campo boolean só aceita 0 ou 1
                            fldByte              = 'B';
                            fldShortInt          = 'J'; //:< Campo shortInt
                            fldSmallWord         = 'W'; //:< Número SmallWord sizeof = 2 aceita só positivos
                            fldSmallInt          = 'I'; //:< Número SmallInt sizeof = 2 aceita só positivos e negativos
                            fldLongInt           = 'L'; //:< Número longint = 4 bytes aceita positivos e negativos;
                            FldRadioButton       = 'K'; //:< tipo byte usado como index de um controle TRadiobutton.
                            FldDateTime          = 'D'; //:< TDateTime;Guarda a data e hora compactada. O Formato é retonado pela função TDateFreePascal.TDatesFreePascal.Mask_to_MaskEdit

                      ```
             Obs:
               também podem ser usados #179 ou #186 como delimiters.
               Obs: No modo console os caracteres #179 ou #186 eram impressos para dividir colunas.

           Funções de extensão do modelo:  (em arquivo DMXGIZMA.PAS)

              func CreateAppendFields ()
              func CreateBlobField ()
              func CreateEnumField ()
              func CreateTSItemFields ()
        }

        {: A constante **@name** (Const AccNormal = 0;) é um mapa de bits usado para identificar o
           bit do campo TDmxFieldRec.access que informa se que o campo pode ser editado.

           - **EXEMPLO**
             - Como usar o mapa de bits accNormal para saber se o campo pode ser editado.

               ```pascal

                  with pDmxFieldRec^ do
                    If (access and accNormal <> 0)
                    then begin
                           ShowMessage(Format('O campo %s pode ser editado'),[CharFieldName]);
                         end;
               ```
        }
        Const accNormal      =    0; //00000000 - Campo editavel

        {: A constante **@name** (Const ReadOnly = 1;) é um mapa de bits usado para identificar o
           bit do campo TDmxFieldRec.access que informa se o campo é somente para leitura.

           - **EXEMPLO**
             - Como usar o mapa de bits ReadOnly para saber se o campo não pode ser editado.

               ```pascal

                  with pDmxFieldRec^ do
                    If (access and ReadOnly <> 0)
                    then begin
                           ShowMessage(Format('O campo %s não pode ser editado'),[CharFieldName]);
                         end;
               ```
        }
        Const accReadOnly  =  $1; //00000001 - Somente para leitura

        {: A constante **@name** (Const accHidden = 2;) é um mapa de bits usado para identificar o
           bit do campo TDmxFieldRec.access que informa se o mesmo é invisível.

           - **EXEMPLO**
             - Como usar o mapa de bits accHidden para saber se o campo é invisível.

               ```pascal

                  with pDmxFieldRec^ do
                    If (access and accHidden <> 0)
                    then begin
                        ShowMessage(Format('O campo %s está invisível'),[CharFieldName]); 
                        end;
               ```
        }
        Const accHidden      =  $2; //00000010 - Campo invis=vel

        {: A constante **@name** (Const accSkip = 4;) é um mapa de bits usado para identificar o
           bit do campo TDmxFieldRec.access que informa se o campo pode receber o focus.

           - **EXEMPLO**
             - Como usar o mapa de bits accSkip para saber se o campo não pode receber o focus.

               ```pascal

                  with pDmxFieldRec^ do
                    If (access and accSkip <> 0)
                    then begin
                           ShowMessage(Format('O campo %s não pode receber o focus'),[CharFieldName]);
                         end;
               ```
        }        
        Const accSkip  =  $4; //00000100 - Passe para o próximo campo

        {: A constante **@name** informa que o campo é delimitador de campos no Template.}
        Const accDelimiter   =  $8; //00001000

        Const accExternal    =  $10;//00010000 - for future use }
        Const accSpecA       =  $20;//00100000
        Const accSpecB       =  $40;//01000000
        Const accSpecC       =  $80;//10000000


        {: A constante **@name** (Const fldStr = 'S') usado na máscara do Template,
           informa ao componente **TUiDmxScroller** que a sequência de caracteres 'S'
           após o caractere **"\"** representa no buffer do formulário um tipo ShortString
           que só aceita caractere maiúsculo.

           - **EXEMPLO**
             - Representação de um string de 10 dígitos em um buffer de 11 bytes
               onde o byte zero contém o tamanho da string;

               ```pascal

                  Const
                    Nome := '\SSSSSSSSSSSSSSSSSSS' //PAULO SÉRGIO

               ```
        }
        Const fldStr              =   'S';
        Const fldS = fldStr;

        {: A constante **@name** (Const fldStrAlfa = 's') usado na máscara do Template,
           informa ao componente **TUiDmxScroller** que a sequência de caracteres 's'
           após o caractere **"\"** representa no buffer do formulário um tipo ShortString
           que aceita caracteres minúsculas e maiusculas.

           - **EXEMPLO**
             - Representação de um string de 10 dígitos em um buffer de 11 bytes
               onde o byte zero contém o tamanho da string;

               ```pascal

                  Const
                    Nome := '\ssssssssssssssssssss' //Paulo Sérgio
               ```
        }
        Const fldStrAlfa    =   's';

        {: A constante **@name** (Const fldStrNumber = '#') usado na máscara do Template,
           informa ao componente **TUiDmxScroller** que a sequência de caracteres '#'
           após o caractere **"\"** representa no buffer do formulário um tipo ShortString
           que só aceita caractere numérico.

           - **EXEMPLO**
             - Representação de um string de 11 dígitos em um buffer de 12 bytes
               onde o byte zero contém o tamanho da string;

               ```pascal

                  Const
                    telefone := '\(##) # ####-####' //85 9 9702 4498

               ```
        }
        Const fldStrNumber           =   '#';
        Const fldSN = fldStrNumber;

        {: A constante **@name** (Const fldAnsiChar = 'C') usado na máscara do Template,
           informa ao componente **TUiDmxScroller** que a sequência de caracteres 'C'
           após o caractere **"\"** representa no buffer do formulário um tipo AnsiString
           que só aceita caractere maiúsculo.

           - **EXEMPLO**
             - Representação de um AnsiString de 10 dígitos em um buffer de 11 bytes
               onde o ultimo byte contém o caractere #0 informando o fim da string;

               ```pascal

                  Const
                    Nome := '\CCCCCCCCCC'; //PAULO SÉRG

               ```
        }
        Const fldAnsiChar             =   'C';
        Const fldAC = fldAnsiChar;

        {: A constante **@name** (Const fldAnsiChar = 'c') usado na máscara do Template,
           informa ao componente **TUiDmxScroller** que a sequência de caracteres 'c'
           após o caractere **"\"** representa no buffer do formulário um tipo AnsiString
           que só aceita caractere maiusculos e minúsculo.

           - **EXEMPLO**
             - Representação de um AnsiString de 10 dígitos em um buffer de 11 bytes
               onde o ultimo byte contém o caractere #0 informando o fim da string;

               ```pascal

                  Const
                    Nome := '\cccccccccc'; //paulo Sérg
                    Nome := '\Cccccccccc'; //Paulo Sérg


               ```
        }
        Const fldAnsiCharAlfa   =   'c';
        Const fldACMi = fldAnsiCharAlfa;

        {: A constante **@name** usado na máscara do Template,
           informa ao componente **TUiDmxScroller** que a sequência de caracteres '0'
           após o caractere **"\"** representa no buffer do formulário um tipo AnsiString
           que só aceita caractere numérico ['0'..'9']] .

           - **EXEMPLO**
             - Representação de um AnsiString de 11 dígitos em um buffer de 12 bytes
               onde o ultimo byte contém o caractere #0 informando o fim da string;

               ```pascal

                  Const

                    telefone := '\(00) 0 0000-0000' //85 9 9702 4498

               ```
        }
        Const fldAnsiCharNumPositive   =   '0';
        Const fldACN = fldAnsiCharNumPositive;

        {: A constante **@name** usado na máscara do Template, informa ao componente
           **TUiDmxScroller** que a sequência de caracteres 'N' após o caractere
           **"\"** representa no buffer do formulário um tipo AnsiString que só aceita
           caractere numérico ['0'..'9']] com formatação dbase.

           - **EXEMPLO**
             - Representação de um AnsiString de 11 dígitos em um buffer de 12 bytes
               onde o ultimo byte contém o caractere #0 informando o fim da string;

               ```pascal

                  Const

                    telefone := '\(NN) N NNNN-NNNN' //85 9 9702 4498

               ```
        }
        Const fldAnsiCharNum    =   'N';

        {: A constante **@name** (Const fldByte = 'B') usado na máscara do Template,
           informa ao componente **TUiDmxScroller** que a sequência de caracteres 'B'
           após o caractere **"\"** representa no buffer do formulário um tipo byte.

           - **EXEMPLO**

               ```pascal

                  Const
                     idade := '\BB' //Os dois dígitos estarão em um buffer de 1 byte;

               ```
        }
        Const fldByte             =   'B';  //:< byte Field
        Const fldShortInt         =   'J';  //:< shortint Field
        Const fldSmallWord        =   'W';  //:< word Field NortSoft
        Const fldSmallInt         =   'I';  //:< integer Field NortSoft
        Const fldLongInt          =   'L';  //:< longint Field
        Const fldDouble           =   'R';  //:< real number Field  (uses TRealNum)
        Const fldDoublePositive      =   'r';  //:< real number Field positive (uses TRealNum)
      
        {: A constante **@name** indica que o campo é do tipo byte e só pode ter dois
           valores 0 ou 1.

           - **NOTA**
             - Valores possíveis:
               - 0 - False; não
               - 1 = True;  sim

             - A forma de editá-los deve ser com o componente checkbox.

           - **EXEMPLO**

               ```pascal

                  Resourcestring
                    tmp_Aceita = '\X Aceita o contrato +ChFN+'Aceita_contrato'+CharHint+'Aceita os termos do contrato?';
                    Template = tmp_Aceita+'~Aceita os termos do contrato~';
               ```
        }
        Const fldBoolean  =   'X';

        {: O tipo do campo **@name** tipo byte usado como index de um controle TRadiobutton.
           Template em um controle TRadioButton

           - **NOTAS**
             - Um template pode conter vários campos do tipo cluster e o mesmo é
               identificado após a sequência \K? onde ? indica que a informação
               que pertence ao campo ?
               - Exemplo:
                 - SEXO
                   - \Ka Masculino
                   - \Ka Feminino
                   - \Ka Indefinido
             - Os campos clusteres possuem o mesmo número do campo e na primeira
               ocorrência contém o nome do campo na lista pDmxFieldRec.

           - **EXEMPLO**

             ```pascal
                 Result :=
                   NewSItem('~  SEXO~',
                   NewSItem('~  ~\Ka Masculino',
                   NewSItem('~  ~\Ka Feminino',
                   NewSItem('~  ~\Ka Indefinido',
                   NewSItem('~  ESTADO CIVIL~',
                   NewSItem('~  ~\Kb Solteiro',
                   NewSItem('~  ~\Kb Casado',
                   NewSItem('~  ~\Kb Divorciado',
                   nil))))))))
             ```
        }
        Const FldRadioButton      =  'K'; //Maiúscula

        Const fldHexValue         =   'H';  //:< hexadecimal numeric entry

        {: A constante **@name** (CharUpperlimit=^U) permite informar um limite superior para campos
           do tipo byte.

           - O gerador de formulário deve usar o conteúdo do campo pDmxFieldRec.Upperlimit
             para criticar se o valor do campo está na faixa entre 1 e pDmxFieldRec.Upperlimit.
           - O valor zero significa que o campo está nulo.


           - **EXEMPLO**
              - Um campo onde o seu conteúdo não ultrapasse um byte, pode ser informado
                 no Template da seguinte forma:

                ```pascal

                  Const
                    idade := '\BBB+CharUpperlimit+#130+CharHint+'Não existe humanos
                              com a idade superior a 130 anos.';
                ```
        }
        Const CharUpperlimit       =   ^U ;  //:< Limite superior do campo (Somente 1 a 255)

        {: A constante **@name** é um campo do tipo longint que contém o índice corrente
           da lista de string.

           - Os controles usados para edita-lo são:
             - TComboBox se o registro não está associado a banco de dados;
             - TdbLookupComboBox se o registro estiver associado a TDataSet.

           - **EXEMPLO USO NO TEMPLATE**

             ```pascal

                Const 
                  tmpMidia : PSitem = nil;

                begin
                  tmpMidia := CreateEnumField(TRUE, accNormal, 0,
                                              NewSItem(' indefinido ', //0
                                              NewSItem(' Pendriver  ', //1
                                              NewSItem(' SSD        ', //2 
                                              nil))))+CharFieldName+'Midia;

                  Template = NewSItem('~  Eu uso ~'+ tmpMidia + '~ em meu computador.~',
                      Next);
                end;

             ```
        }
        Const fldENUM      =  ^E;

        {: A constante **@name** é um campo do tipo longint associado a um dataSource,
           uma chave dataSource.dataSet.KeyField e um campo a ser visualizado na liasta
           dataSource.dataSet.listField.

           - Os controles usados para edita-lo são:
             - TdbLookupComboBox.

             - **EXEMPLO USO NO TEMPLATE**

               ```pascal

                 function T__dm_xtable__.DmxScroller_Form1GetTemplate(aNext: PSItem): PSItem;
                 begin
                    with DmxScroller_Form1 do
                    begin
                      Result :=
                      NewSItem(GetTemplate_CRUD_Buttons(CmNewRecord,CmUpdateRecord,CmLocate,CmDeleteRecord),
                      NewSItem('',
                 //     NewSItem('~ID:            ~\LLLLLL'+chFN+'id',
                      NewSItem('~ID:            ~'+CreateEnumField(TRUE, accNormal, 1,NewSItem('ssssssssssssssssssssssssssssssssssssssssssssssssss',nil),
                                                              Mi_SQLQuery1.DataSource,'id','nome')+
                                                    ChFN+'id'+
                                                    CharHint+'Campo enumero lookup',
                      NewSItem('~Nome:          ~\ssssssssssssssssssssssssssssssssssssssssssssssssss'+chFN+'nome'+CharHint+'Campo alfanumérico aceita maiuscula e minuscula',
                      NewSItem('~endereco       ~\ssssssssssssssssssssssssssssssssssssssssssssssssss'+chFN+'endereco',
                      NewSItem('~cnpj           ~\##.###.###/####-##'+chFN+'cnpj',
                      NewSItem('~cpf            ~\###.###.###-##'+chFN+'cpf',
                      NewSItem('~cep            ~\##.###-###'+chFN+'cep',
                      NewSItem('~valor_SMALLINT ~\IIIII'+chFN+'valor_SMALLINT',
                      NewSItem('~valor_Integer  ~\LLLLLLLLLL'+chFN+'valor_Integer',//Maximo:2.147.483.647

                      NewSItem('~valor_FLOAT8   ~\RRR,RRR.ZZ'+chFN+'valor_FLOAT8',
                      NewSItem('~Data_1         ~\Ddd/mm/yy'+chFN+'Data_1',
                      NewSItem('~hora_1         ~\Dhh:nn:ss'+chFN+'hora_1',
                      NewSItem('~hora_2         ~\Dhh:nn'+chFN+'hora_2',
                      NewSItem('',
                      NewSItem(GetTemplate_DbNavigator_Buttons(CmGoBof,CmNextRecord,CmPrevRecord,CmGoEof,CmRefresh),
                      NewSItem('',
                      aNext)))))))))))))))));
                    end;
                 end;

               ```
        }
        Const fldENUM_Db   =  ^D;   //:< enumerated Field

        {: A constante **@name** indica que o campo é não formatado 
           podendo ser um Record, porém a edição do mesmo será feito por outros meios.

           - **NOTA**
               - Para informar ao buffer do registro que o campo é **@name**,
                 a função **CreateBlobField** é necessário.
               - A **class function TUiMethods.CreateBlobField(Len: integer; AccMode,Default: byte) : TDmxStr_ID;**
                 reserva espaço para o mesmo.

               - Pendência: Preciso criar um exemplo de uso deste tipo de informação.  
        }
        Const fldBLOb =   ^O;


        {: O tipo do campo **@name** é um campo tipo String e é representado no Template
           em controle TDbRadioButton

           - **NOTAS**
             - Um Template pode conter vários campos do tipo DbRaidoButton e o mesmo é identificado
               após a sequencia \k? onde ? indica que a informação pertence ao campo ?
               - Exemplo:
                 - SEXO
                   - \ka Masculino
                   - \ka Feminino
                   - \ka Indefinido
             - Os campos DbRadioButton possuem o mesmo número do campo e na primeira
               ocorrência contém o nome do campo na lista pDmxFieldRec.

             - O motivo pelo qual **@name** foi criado é que o banco de dados do freepascal
               reconhece esse tipo como string com o nome do caption selecionado.

             - O tamanho da string deve ser o tamanho da maior string da lista de opções.
        }
//        Const FldDbRadioButton    =  'k';//minúsculo

        Const fldZEROMOD          =   'Z';  //:< zero modifier

        {: A constante **@name** omite da visão do usuário a parte do campo 
           que não precisa ser mostrado, ou seja: limita a parte visível do texto 
           permitindo scroll lateral do mesmo.  }
        Const fldCONTRACTION      =   '`';  

        {:A constante **@name** é usada para concatenar duas listas do tipo PSItem.

          - A constante **@name** é necessário porque DmxScroller trabalha com string curta
            e a mesma tem um tamanho de 255 caracteres, onde o tamanho está na posição 0.

          - Como usar a constante **@name**:

            - A função **CreateAppendFields** retorna a constante **fldAPPEND** mais
              o endereço da string a ser concatenada.

              - **EXEMPLO**

                  ```pascal

                     procedure Template : ShortString;
                       Var
                         S1,s2,Template : TString;
                     begin
                       S1 := '~Nome do Aluno....:~\ssssssssssssssssssssssssssssssssss';
                       s2 := '~Endereço do aluno:~\sssssssssssssssssssssssss';
                       result := S1+CreateAppendFields(s2);
                     end;

                  ```
              - **NOTA**
                - A contante **@name** foi criada porque o projeto inicial foi
                  para turbo pascal e ambiente console.
                - A versão atual podemos usar AnsiString visto que o limite do mesmo
                  é a memória.
                - Para usar AnsiString é necessário converter para PSitem com a função: **StringToSItem**.

                  - **EXEMPLO:**

                    ```pascal

                      function TMI_UI_InputBox.DmxScroller_Form1GetTemplate(aNext: PSItem): PSItem;
                      begin
                        with DmxScroller_Form1 do
                        begin
                          if _Template  <> ''
                          then Result := StringToSItem(_Template, 80);

                      //    Result := StringToSItem(_Template, 40,TObjectsTypes.TAlinhamento.Alinhamento_Esquerda)
                      //    Result := StringToSItem(_Template, 40,TObjectsTypes.TAlinhamento.Alinhamento_Central)
                      //    Result := StringToSItem(_Template, 40,TObjectsTypes.TAlinhamento.Alinhamento_Direita)
                      //    Result := StringToSItem(_Template, 80,TObjectsTypes.TAlinhamento.Alinhamento_Justificado)

                          else result := nil;
                        end;
                      end;

                    ```
        }
        Const fldAPPEND           =   ^G;

        Const fldSItems           =   ^I;   //:< link to chain of TSItem Templates
//        Const fldXSPACES          =   ' ';  //:< spaces --extended code follows <Esc>
//        Const fldXTABTO           =   ^I;   //:< tab    --extended code follows <Esc>

//        Const fldXFieldNUM        =   ^F;   //:< fnum   --extended code follows <Esc>

        {: A constante **@name** (fldExtended='E') usado na máscara do Template,
           informa ao componente **TUiDmxScroller** que a sequência de caracteres 'E'
           após o caractere **"\"** representa no buffer do formulário um tipo Extended.

           - **EXEMPLO**

               ```pascal

                  Const
                     Valor := '\EEE,EEE,EEE,EEE,EE' //Todos os número editados nesta
                                                      mascara estarão em um buffer de 10 bytes;

               ```
        }
        Const fldExtended       = 'E';  //:< Real 10 bytes
        Const fldReal4          = 'O';  //:< Real 4 Byte positivos e negativos
        Const fldReal4Positivo  = 'o';  //:< Real 4 Byte positivos
        Const fldReal4P         = 'P';  //:< P = Real de mostrado x por 100 positivos e negativos
        Const fldReal4PPositivo = 'p';  //:< P = Real de mostrado x por 100 positivos

        {: A constante **@name** indica que o campo contém um campo com 255 posições
           que contém um endereço para um página html ou não:

           - **LINKS POSSÍVEIS:**
             - ^L+1 = Endereço de uma página na web a ser acessada pelo browser.

           - ATENÇÃO: Não implementado

        }
        //Const FldLink       = ^L; 
        //Const FldlinkUrl    = ^L+'1';//:< Endereço de uma página na web a ser acessada pelo browser.

//        Const FldDateTimeDOS       = #4;
        Const FldSData      = '##/##/##';

        Const fldLHora      = #2 ;  //:< #2 = Longint;Guarda a hora compactada  ##:##:##
        Const FldSHora      = '99:99:99';
        Const fld_LHora     = 'h';  //:< h = Longint;Guarda a hora compactada   hh:hh:hh
        Const FldOperador   = #3; //:< #3 = Byte indica que o campo é um operador matemático

        Const FldDateTime   = 'D' ;  //:< TDateTime;Guarda a data e hora compactada. O Formato é retonado pela função TDateFreePascal.TDatesFreePascal.Mask_to_MaskEdit


        {: Usado para omitir os caracteres que estão sendo digitados em qualquer tipo de campo
        }
        Const CharShowPassword      = ^W;

        {: A contante **@name** é igual CharShowPassword. }
        Const ChSP = CharShowPassword;

        Const CharShowPasswordChar  =   '*';  {:< Caractere a ser mostrado quando CharShowPassword em fldField for igual = ^W}

        {: A contante **@name** é usado para associar ao campo atual uma classe **TAction**.

           - **NOTA**
             - O interpretador de Templates associa a ação do Template ao corrente campo.
        }
        Const CharExecAction       = ^T;  //#20=^T O Ponteiro para um procedimento



=====================================================
Registro base 

      {: O tipo **@name** é usado para fazer pesquisa genérica no banco de dados
         quando a  tecla F7 é pressionada.}
      TEndProc = Procedure(Const AOwner:TUiDmxScroller; Const ADmxFieldRec:PDmxFieldRec);

      { TDmxFieldRec }
      {: O registro **@name** é usado para guardar as informações passadas
         pelos Templates das strings.

        - **REFERÊNCIA**
          - [Estrutura record e object]https://wiki.freepascal.org/Record

        - A aparência padrão dessas visualizações geralmente é orientada por
          coluna/linha, com exceção de exibições do tipo formulário e campos
          únicos.
        - Você declara uma estrutura de registro para o procedimento de
          inicialização do **tvDMX** em um modelo string – que também determina
          o formato de exibição. (Você verá mais tarde como o **tvDMX** pode
          ser usado para trabalhar com formulários ou editores de campo.)

        - **EXEMPLO**

          - O Template '\ sssssssss`sssssssssss \ iiii \ rrr.rr' representa o
            registro:
            - **CÓDIGO PASCAL**

                ```pascal

                   type

                     TRecord = Record
                                 nome : String [20];
                                 Ano  : Integer;
                                 Valor : Real;
                               end;
               ```

            - **NOTA:**
              - A letra ( **s** ) minúsculo aceita qualquer número e letras
                maiúsculas e minúsculas;

              - A letra ( **i** ) representa um número inteiro com 2 bytes
                com edição em 4 posições (0 a 9999);

              - A letra ( **r** ) representa um número real com 8 bytes com
                edição em 5 posições (0 a 999.99)

              - O símbolo ( **`** ) crase é usado para informar que a parte do
                texto depois deste sinal deve ser omitida da visão.

              - A símbolo ( **' \ '** ) barra invertida deve ser usada como
                delimitador de campo e é exibida como um espaço em branco.

              - O símbolo ( **~** ) til deve ser usado para separar rótulos
                dos campos de dados.

        - **ATENÇÃO**
           - O registro **@name** não pode ser **class** e nem conter **métodos virtuais**, porque este
             registro e alocado com as funções **new** e **dispose**.

           - Campos que podem ser publicados para uso em javascript.
             - Alias
             - AliasList
             - FieldName
             - Template_org
             - Mask
             - access
             - ShownWid
             - TypeCode
             - KeyField
             - ListField  : AnsiString;
             - ListOptions  : PSItem;
             - ListOptions_Default : Longint;
             - Default
      }
      TDmxFieldRec = Record //Esta estrutura não pode ser object pq não funciona.
         {: O campo **@name** é usado para associar label ao corrente campo.

            - **NOTA**
              - Esse campo foi necessário para implementar campos do tipo boolean [X]
                por que o mesmo sempre vem associado a um rótulos amigável e o controle
                checkbox precisa dele.

            - **EXEMPLO**
              - Template de um botão checkbox:

                ```pascal

                   Resourcestring
                     tmp_Aceita = '\X Aceita o contrato +ChFN+'Aceita_contrato'+CharHint+'Aceita os termos do contrato?';
                ```

         }
         Public Alias : AnsiString;
         {: O campo **@name** é usado para registrar as opções possívesivel para
            o campo.

            - **NOTAS**
              - Este campo deve ser criado em DataField.AddFileds() e destruido
                em dispose() quando o campo for:
                - FldRadioGroup;

              - Os Campos FldRadioGroup conté um alias do campo onde este alias é
                adicionado ao campo no qual o alias pertence.

              - **EXEMPLO**
                - Template de um botão radioButton:

                  ```pascal

                     Resourcestring

                       ^A~~\Ka Indefinido ^Bsexo^N+'O campo sexo é necessário para....';
                       ^A~~\Ka Masculino   ^Bsexo
                       ^A~~\Ka Feminino   ^Bsexo
                  ```

         }
         Public AliasList : TStringList;

         {: O função **@name** retorna o tipo da mascara contida em template_org;
         }
         public function Mask :TDates.TMask;

         {: O campo **@name** guarda o componente corrente que está editando esse campo.}
         public LinkEdit :  TComponent;

         {$REGION 'Construção Propriedade FieldName'}
           private  _FieldName : AnsiString;
           private procedure SetFieldName(aFieldName : AnsiString);
           {: O campo **@name** guarda o nome do campo e deve ser inicializado
              em CreateStruct}
           public property FieldName : AnsiString  read _FieldName write SetFieldName;
         {$ENDREGION 'Construção Propriedade FieldName'}

         {: O campo **@name** guarda o modelo original do Template e deve ser inicializado em
            CreateStruct}
         public Template_org : AnsiString;

         {: O campo **@name**  aponta para o próximo campo }
         public Next          :  pDmxFieldRec;

         {: O campo **@name** é usado para referenciar-se a si mesmo.}
         public RSelf         :  pDmxFieldRec;

         {: O campo **@name**  aponta para o campo anterior
         }
         public Prev          :  pDmxFieldRec;

         {: O campo **@name** é usado para read-only, hidden, skip, accSpecX
         }
         public access        :  byte;

         {: O campo **@name** Número do campo, varia de 1 a totalFields (Se zero
           (0) é porque trata-se um rótulos)
         }
         public Fieldnum      :  Integer;

         {: O campo **@name** contém o número do controle}
         public ScreenTab     :  integer;

         {: O campo **@name** informa a largura do campo}
         public ColumnWid     :  byte;
         {: O campo **@name** informa o número de caracteres que serpa visualizado}
         public ShownWid      :  byte;

         {: O campo **@name** é usado para o tipo do código 's', 'r', etc.}
         public TypeCode      :  AnsiChar;

         {A o campo **@name** é iniciado quando este registro
          estiver sendo usado por componentes herdado de TUiDmxScroller que
          precisem acessar banco de dados com TDataSet.
         }
         Public FldEnum_Lookup:TFldEnum_Lookup;

         {:  If the Field is numeric, fill in with '#0' if it's alphanumeric, fill in with ' '}
         public FillValue     :  AnsiChar;

         public UpperLimit    :  byte;         //:< maximum value limit
         public ShowZeroes    :  boolean;      //:< display zero values
         public TrueLen       :  byte;         //:< unformatted text length
         public Parenthesis   :  boolean;      //:< '('/')' AnsiCharacters
         public Decimals      :  byte;         //:< decimal point or cluster value
         public FieldSize     :  integer;      //:< sizeof (datatype)
         public
         public DataTab       :  integer;      //:< position in record
         public Template      :  ptString;     //:< Field Template

         {$REGION ' ---> Property DataSource : TDataSource '}
            {: A propriedade **@name** permite que controles da **LCL** (Lazarus Componentes Library)
                possam usar os dados do componente **TDmxScroller**.

                - **NOTA**
                  - Essa integração permite que **TDmxScroller** utilize todos os componentes de banco
                    de dados do Free Pascal.
            }
           public DataSource : TDataSource;
         {$ENDREGION ' <--- Property DataSource : TDataSource '}

         {: O atributo **@name** contém o nome do campo chave da tabela associada
            a ListOptions.
         }
         public KeyField   : AnsiString;

         {: O atributo **@name** contém o nome do campo da tabela associada a ser visualizado a ListOptions.}
         public ListField  : AnsiString;

         {: O atributo **@name** contém uma lista de opções possíveis para o campo.

            - Nota:
              - Após caractere **CharListOptions** contém um ponteiro para uma
                lista de opções do mesmo tipo de campo.
                - Exemplo:
                  ```pascal

                     Const
                        '~Dia de vencimento:~\Ssssss'+ChFN+'Dia'+CreateOptions(accNormal, 1,
                           NewSItem('Dia 10',
                           NewSItem('Dia 15',
                           NewSItem('Dia 20',
                           NewSItem('Dia 25',
                                    nil)))));
                  ```
         }
         Public ListOptions  : PSItem;

         {: O Atributo **@name*** é usado guardar o valor padrão
            para a lista do BomboBox ou LookupBox

            - Exemplo para selecionar "Dia 20" da lista.
              - O número **2** representa  o terceiro item da lista.
              ```pascal

                 Const
                    '~Vencimento:~\Ssssss'+ChFN+'Dia'+CreateOptions(accNormal, 2,
                       NewSItem('Dia 10',
                       NewSItem('Dia 15',
                       NewSItem('Dia 20',
                       NewSItem('Dia 25',
                                nil)))));
              ```
         }
         public ListOptions_Default : Longint;

         {: O Atributo **@name*** é usado guardar o valor padrão de campos e é
            setado usando o caractere charDefaut = chDf+'Digite o seu nome?'

            - Exemplo de como editar um campo onde o que fazer está em seu conteúdo.

              ```pascal

                 Const
                    '\Sssssssssssssssssssssssssss'+ChFN+'nome'+chDf+'Digite o seu nome?'
              ```
         }
         public DefaultConst : String;

         public DefaultExpression : String;


         {$Region ID_Dynamic}
           Private _ID_Dynamic  : AnsiString; // Usado para gerar paginas html dinamicamente
           Public Property ID_Dynamic : AnsiString Read _ID_Dynamic Write _ID_Dynamic;
         {$EndRegion ID_Dynamic}

         {$Region owner}
           private _owner_UiDmxScroller :  TUiDmxScroller;
           private Procedure SetOwner(a_owner:TUiDmxScroller);
           public property owner_UiDmxScroller :  TUiDmxScroller read _owner_UiDmxScroller write SetOwner;
         {$EndRegion owner}

         Public Function GetOwner: TUiDmxScroller;

         {: O campo **@name** é inicializado no interpretador de Template quando
            o caractere **CharExecAction** é encontrado.

            - **EXEMPLO DE USO DE AÇÕES NO TEMPLATE**
               1. Se o atributo **Fieldnum** do campo for diferente de zero,
                  então o **rótulo** do botão associado a ação será o caracteres 🔍
                  e a ação pode atualizar o buffer do campo.
                  - No exemplo a seguir a função command retorna a string
                    **chFN+aFieldName+'~ 🔍~'+ChEA+(aFieldName+'.'+aExecAction)**.
                  - O interpretador de Template atualiza a string LinkExecAction caso o
                    o ponto seja encontrado no ExecAction do Label.

                    ```pascal

                       Result := NewSItem('~Cliente:~'+'\LLLLL'+
                                           command('Cliente',Pesquisa.Name),nil);

                    ```

               2. Se o atributo **Fieldnum** do campo for igual a zero,
                  então a rótulo do botão será o rótulo do campo.
                  - No exemplo a seguir um rótulo de novo cliente (icons  🆕) e
                    um botão ok (icons 🆗)

                    ```pascal

                      NewSItem('~ 🆕 &Novo cliente:~'+CharExecAction+Action_Novo.name+
                               '~   ~~ 🆗 ~'+CharExecAction+Action_Ok.name)

                    ```
         }
         Public ExecAction : AnsiString;

         {: O atributo **@name** é atualizado com o ponteiro do campo passado
            por **execAction**.

            - O Interpretador de Template deve pegar o campo usando a função
              FieldByName(aFieldName passado em execAction), quando execAction
              tiver um ponto antes do nome da ação.
              - Ex: **(aFieldName.aExecAction)**.

            ```pascal

               Result := NewSItem('~Cliente:~'+'\LLLLL'+command('Cliente',Pesquisa.Name),nil);

            ```
         }
         public LinkExecAction : pDmxFieldRec;

         {: O campo **@name** indica que este campo não deve ser visualizado,
            usado nos campos tipo senha}
         public CharShowPassword   :  AnsiChar;
         public var _Mask : TDates.TMask;

         {: O campo **@name** se true os campos Strings passa para o próximo
            campo quando o cursor estiver na ultima posição e um novo caractere
            for digitado.
         }
         public QuitFieldAltomatic : Boolean;

         {: O campo **@name** contém a posição do curso quando este campo estiver
            sendo editado.
         }
         Public CurPos : integer;

         {: O campo **@name** posição do início da seleção quando este campo
            estiver sendo editado.
         }
         public SelStart        : Integer;

         {: O campo **@name** contém a posição do fim da seleção quando este campo
            estiver sendo editado.
         }
         public SelEnd          : Integer;

         {$REGION 'Construção Propriedade FieldAltered'}
           private public _FieldAltered   : Boolean;
           private function GetFieldAltered:Boolean;

           {: A propriedade **@name** indica que o campo foi alterado e deve ser
              atualizado na visão caso a tabela esteja em modo de edição.
           }
           public property FieldAltered : Boolean read GetFieldAltered write _FieldAltered;
         {$ENDREGION 'Construção Propriedade FieldAltered'}

         {: O campo **@name** contém a documentação resumida do registro.
         }
         public HelpCtx_Hint : AnsiString;

         {: O campo **@name** contém o por que preciso deste campo?
         }
         public HelpCtx_Porque    : AnsiString;

         {: O campo **@name** contém o texto indicando onde esse campo será usado?
         }
         public HelpCtx_Onde      : AnsiString;

         //public HelpCtx_Como      : AnsiString; //:< Como esse campo pe usado?
         //public HelpCtx_Quais     : AnsiString; //:< Quais locais onde esse campo será usado?
         //public HelpCtx_Historico : AnsiString; //:< Histórico do projeto.

         {$REGION 'Construção Propriedade OkSpc'}
           {: Salva o valor de _OkSpc antes de setar com aOkSpc}
           public  _OkSpcAnt  : Boolean;
           Private _OkSpc  : Boolean;
           Private procedure SetOkSpc(aOkSpc  : Boolean);
           public Property OkSpc : Boolean read _OkSpc write SetOkSpc;
         {$ENDREGION 'Construção Propriedade OkSpc'}

         {$REGION 'Construção Propriedade OkMask'}
           Private _OkMask  : Boolean;
           function getOkMask: Boolean;
           procedure SetokMask(AValue: Boolean);
           {: O método **@name** é usado para habilitar ou não em GetString
           a mascara em campos numéricos.}
           public Property OkMask : Boolean read getOkMask write SetokMask;
         {$ENDREGION 'Construção Propriedade OkMask'}

         public Function GetAsStringFromBuffer(aWorkingData : pointer):AnsiString;
         function RemoveMaskNumber(S: AnsiString): AnsiString;
         function RemoveMask(S: AnsiString): AnsiString;
         Function AddMask(S: AnsiString;DisplayText: Boolean):Ansistring;

         {$REGION 'Construção do propriedade AsString'}
           public Procedure SetAsString(S:AnsiString);
           public Function GetAsString:AnsiString;
           Public Property AsString : AnsiString read GetAsString write SetAsString;
         {$ENDREGION 'Construção do propriedade AsString'}

         {$REGION 'Construção da propriedade Variante'}
           Private Function GetValue:Variant;
           Private Procedure SetValue(aValue:Variant);
           Public Property Value : Variant Read GetValue write SetValue;
         {$ENDREGION 'Construção da propriedade Variante'}

        //        public function IsButton:Boolean;
         Public Function IsInputText:Boolean;
         public function SItemsLen(S: PSItem) : SmallInt;
         public function MaxItemStrLen(AItems: PSItem) : integer;
         Public Function GetMaxLength():integer;
         public function IsStaticText:Boolean;
         public function IsInputRadio:Boolean;
//           public function IsInputDbRadio:Boolean;
         public function IsInputCheckbox:Boolean;
         public function isInputPassword:Boolean;
         public function IsInputHidden:Boolean;

         {: O objeto filho que implementar um ISelect deve anular e retornar
           a interface ISelect;}
         public function IsSelect:Boolean;

         {: Usado quando trata-se de campos enumerados em memória ou em arquivos.}
         public function IsComboBox:Boolean;

         Public function FirstField : pDmxFieldRec;
         Public function LastField  : pDmxFieldRec;
         Public function NextField  : pDmxFieldRec;
         Public function PrevField  : pDmxFieldRec;

         //Public Function SelectFirstField  : pDmxFieldRec;
         //Public Function SelectLastField  : pDmxFieldRec;

    //         private Var _reintrance_Select:boolean;
         Public Procedure Select;

         //=============================================================================================================
         {$Region '//*** propriedade Cluster e seus métodos usados para as Interfaces IInputRadio e IInputCheckBox ***'}
         //=============================================================================================================

             Public Function GetCount_Cluster:Integer;

             //Construção da propriedade IInputRadio.Value
             Public Function GetValue_Cluster(aItem: Integer):AnsiString;//=string value passed to form processing application
             Public Procedure SetValue_Cluster(aItem:Integer;wValue:AnsiString);

            //Construção da propriedade IInputRadio.Checked
             Public  Function GetChecked_Cluster( aItem: Integer):Boolean;       {property Checked Read GetChecked}
             Public  Procedure SetChecked_Cluster( aItem : Integer;aValue:Boolean); {property Checked Write SetChecked}

        {$EndRegion '//*** Construção da propriedade Cluster e seus métodos usados para IInputRadio e IInputCheckBox ***'}
         //=============================================================================================================

         //=============================================================================================================
         {$Region '//*** interface IInputRadio ***'}
         //=============================================================================================================
            //Construção da propriedade Count do IInputRadio
             Public Function GetCount_InputRadio:Integer;

             //Construção da propriedade IInputRadio.Value
             Public Function GetValue_InputRadio(aItem: Integer):AnsiString;//=string value passed to form processing application
             Public Procedure SetValue_InputRadio(aItem:Integer;aValue:AnsiString);

            //Construção da propriedade IInputRadio.Checked
             Public  Function GetChecked_InputRadio( aItem: Integer):Boolean;       {property Checked Read GetChecked}
             Public  Procedure SetChecked_InputRadio( aItem : Integer;aValue:Boolean); {property Checked Write SetChecked}

             //Nota: Retorna o numero do item Selecionado
             Public Function get_Item_Focused_InputRadio:Longint;

         {$EndRegion '//*** Implementação da interface IInputRadio ***'}
         //=============================================================================================================

         //=============================================================================================================
         {$Region '//***  INTERFACE IInputCheckbox ***' }
         //=============================================================================================================

             {: Construção da propriedade Count
                - Objetivo: Retorna o numero de items da lista onde os itens devem ser acessados com index 0 a count-1
             }
             Public Function GetCount_InputCheckbox:Integer;

             {: Construção da propriedade Value

                - Objetivo: Ler o label associado a opção ou trocar seu valor.

                - Sintaxe: Setando = Value[1] = 'Sim'; Value[2] = 'Nao'; Value[1] = 'Yes'
                           Lendo   = If LowerCase(Value[1]) = 'SIM' Then;
             }
             Public Function GetValue_InputCheckbox(aItem: Integer):AnsiString;
             Public Procedure SetValue_InputCheckbox(aItem: Integer;aValue:AnsiString);

             {: Construção da propriedade Checked - Sintaxe: 1 = If Checked[1] then; 2 = Checked[1] := True.

                - Objetivo: Selecionar um item da lista de opções ou checar se a opção está selecionada
             }
             Public Function GetChecked_InputCheckbox( aItem: Integer):Boolean;
             Public Procedure SetChecked_InputCheckbox( aItem : Integer;aValue:Boolean);

         //=============================================================================================================
         {$EndRegion '//***  IMPLEMENTAÇÃO DATA INTERFACE IInputCheckbox ***' }
         //=============================================================================================================

         {: Construção da propriedade Count de campos enumerados
            - Objetivo: Retorna o numero de items da lista onde os itens devem ser acessados com index 0 a count-1
         }
         Public Function GetCount_Select:Variant;

         {: Número de Linhas a ser mostrada no box. Usado em campos enumerados.}
         Public Function GetSize_Select():Variant;//=n specifies the number of options to display

         {: Construção da propriedade Value
            - Objetivo: Ler o label associado a opção ou trocar seu valor.

            - Sintaxe: Setando = Value[1] = 'Sim'; Value[2] = 'Nao'; Value[1] = 'Yes'
                       Lendo   = If LowerCase(Value[1]) = 'SIM' Then;
         }
         Public Function GetValue_Select(aItem: Integer):AnsiString;

         Public Procedure SetValue_Select(aItem: Integer;aValue:AnsiString);

         {: Construção da propriedade Checked - Sintaxe: 1 = If Checked[1] then; 2 = Checked[1] := True.

            - Objetivo: Selecionar um item da lista de opções ou checar se a opção está selecionada
         }
         Public Function GetChecked_Select( aItem: Integer):Boolean;

         Public Procedure SetChecked_Select( aItem : Integer;aValue:Boolean);

         {: O método **@name** retorna true se o campo é numérico e false se alfanumérico}
         Public Function IsNumber:Boolean;
         Public Function IsNumberReal:Boolean;
         Public Function IsNumberInteger:Boolean;
         Public Function IsNumberString:Boolean;
         public function IsBoolean: Boolean;
         Public function IsData: Boolean;
//           Public function IsHora: Boolean;

         //Número da Linha inicial
         Private _FldOrigin_Y : Integer      ;
         Private Function GetFldOrigin_Y:Integer;
         Public Property FldOrigin_Y:Integer Read GetFldOrigin_Y Write _FldOrigin_Y;

         //Construção da propriedade Origin
         Private Function GetFldOrigin: TPoint;
         Public Property FldOrigin  : TPoint read getFldOrigin;

         //Public Function GetLeft :Integer;
         //Public Function GetTop :Integer;
         //Public Function GetWidth :Integer;
         //Public Function GetHeight :Integer;

         public Function SetAccess(aaccess :  byte):Byte; //Seta access e retorna conteúdo anterior


         {$REGION ' ---> Property reintrance_OnEnter : Boolean '}

           strict Private Var _reintrance_OnEnter : Boolean ;
           strict Private Function  Getreintrance_OnEnter : Boolean;
           strict Private Procedure Setreintrance_OnEnter (areintrance_OnEnter : Boolean );
           Public

           {: A propriedade **@name** usado para evitar reentrância do evento DoOnEnter()
           }
           property  reintrance_OnEnter: Boolean Read Getreintrance_OnEnter   Write  Setreintrance_OnEnter;
         {$ENDREGION}

         {$REGION ' ---> Property reintrance_OnExit : Boolean '}
           strict Private Var _reintrance_OnExit : Boolean ;
           strict Private Function  Getreintrance_OnExit : Boolean;
           strict Private Procedure Setreintrance_OnExit (areintrance_OnExit : Boolean );

           {: A propriedade **@name** é usado para evitar reentrância do evento DoOnExit()
           }
           Public property  reintrance_OnExit: Boolean Read Getreintrance_OnExit   Write  Setreintrance_OnExit;
         {$ENDREGION}


         {:O método **@name** é executado toda vez antes do controle ler do
            buffer do campo.

           - **Descrição**
             - O método `DoOnEnter` é chamado quando o campo associado à instância
               de `TDmxFieldRec` recebe foco. Ele assegura que o campo seja registrado
               como o campo atual e atualizado adequadamente dentro do `owner_UiDmxScroller`.
               Além disso, ele executa os eventos de entrada de campo e cálculo de campo,
               se definidos, e também atualiza os buffers se o campo foi alterado.

           - **Parâmetros Locais**
             - `reintrance_DmxFieldRec_OnEnter`: Variável booleana para evitar
               reentrância no método, garantindo que a lógica seja executada
               apenas uma vez por chamada.

           - **Fluxo de Execução**
             1. Verifica se `reintrance_DmxFieldRec_OnEnter` está desativada e
                se `owner_UiDmxScroller` está atribuído.
              2. Define `reintrance_DmxFieldRec_OnEnter` como `true` para evitar
                 reentrância.
              3. Chama os métodos `SetCurrentField` e `Scroll_it_inview` no
                 `owner_UiDmxScroller` para atualizar o campo atual e garantir
                 que ele esteja visível na interface.
              4. Executa o evento `onEnterField` se ele estiver atribuído e o
                 número do campo (`Fieldnum`) for diferente de zero.
              5. Executa o evento `OnCalcField` se ele estiver atribuído e o
                 número do campo (`Fieldnum`) for diferente de zero.
              6. Se o campo tiver sido alterado (`FieldAltered`), chama os métodos
                 `PutBuffers` e `UpdateBuffers` no `owner_UiDmxScroller` para
                 atualizar o estado dos buffers.
              7. No bloco `finally`, redefine `reintrance_DmxFieldRec_OnEnter`
                 para `false`.

           - **Ver Também**
             - `TDmxScroller.SetCurrentField`
             - `TDmxScroller.Scroll_it_inview`
             - `TDmxScroller.onEnterField`
             - `TDmxScroller.OnCalcField`
             - `TDmxScroller.PutBuffers`
             - `TDmxScroller.UpdateBuffers`
         }
         Public procedure DoOnEnter(Sender: TObject);

         {:O método **@name** é executado toda vez antes do controle gravar no buffer do campo.

           - **Descrição**
             - O método `DoOnExit` é executado quando o campo associado à instância
               de `TDmxFieldRec` perde o foco. Ele garante que os eventos e cálculos
               relacionados à saída do campo sejam processados e que os buffers
               sejam atualizados se o campo foi alterado.

           - **Parâmetros Locais**
             - `reintrance_DmxFieldRec_OnExit`: Variável booleana para evitar
                reentrância no método, assegurando que o processamento de saída
                ocorra apenas uma vez por chamada.

           - **Fluxo de Execução**
             1. Verifica se `reintrance_DmxFieldRec_OnExit` está desativada e se
                `owner_UiDmxScroller` está atribuído.
             2. Define `reintrance_DmxFieldRec_OnExit` como `true` para evitar
                reentrância.
             3. Executa o evento `onExitField` se ele estiver atribuído e o
                número do campo (`Fieldnum`) for diferente de zero.
             4. Executa o evento `OnCalcField` se ele estiver atribuído e o
                número do campo for diferente de zero.
             5. Se o número do campo for diferente de zero e o campo tiver sido
                alterado (`FieldAltered`), executa o evento `OnChangeField`
                (caso atribuído) e chama `DoChangeField`.
             6. Chama o método `DoCalcFields` para recalcular os campos, se necessário.
             7. Se o campo foi alterado, chama os métodos `PutBuffers`, `UpdateCommands`
                e `UpdateBuffers` para atualizar os buffers e comandos do scroller.
             8. No bloco `finally`, redefine `reintrance_DmxFieldRec_OnExit` para `false`.

           - **Ver Também**
             - `TDmxScroller.onExitField`
             - `TDmxScroller.OnCalcField`
             - `TDmxScroller.OnChangeField`
             - `TDmxScroller.DoChangeField`
             - `TDmxScroller.DoCalcFields`
             - `TDmxScroller.PutBuffers`
             - `TDmxScroller.UpdateCommands`
             - `TDmxScroller.UpdateBuffers`
         }
         Public procedure DoOnExit(Sender: TObject);

         {: O atributo **@name** é usado nos métodos **TUiDmxScroller_sql.CreateTables** e
            **TUiDmxScroller_sql.CreateBufDataset_FieldDefs** para integração do componente
            **TDmxScroller**  com o componente TSqlDbConnector.
         }
         public ProviderFlags : TUiTypes.TMiProviderFlags;

         {: O atributo **@name** é usado para criar chave estrangeira e os relacionamentos}
         public ForeignKey : TuiTypes.TForeignKey;

         {: O atributo **@name** contém uma string com o nome da tabela estrangeira e a lista de campos relacionados

            - **EXEMPLO**
              - CIDADES,ESTADO;CIDADE
                - CIDADES = tabela estrangeira
                - ESTADO = Estado da cidade.
                - CIDADE = Cidade do estado.

         }
         public KeyForeign : AnsiString;

         {:O método **@name** copia o conteúdo de TDataField para self

           - **Descrição**:
             - O método `CopyFrom` copia o valor de um campo de dados (`TField`)
               para a instância atual de `TDmxFieldRec`. Dependendo do tipo de
               dado, ele formata o valor adequadamente antes de atribuí-lo ao
               campo local `Value`.

           - **Parâmetros Locais**:
             - **aDataField**: `TField`
               - Campo de dados de onde o valor será copiado.
             - **wDefaultFormatSettings**: `TFormatSettings`
               - Armazena as configurações de formato padrão para datas e
                 números, ajustadas temporariamente durante a execução.
             - **s**: `AnsiString`
               - Variável temporária que armazena o valor do campo em formato
                 string.
             - **v**: `Variant`
               - Variável que pode armazenar diferentes tipos de dados.

           - **Fluxo de Execução**:
             1. **Verificação de Dados:**
                - Se o campo atual (`IsData`) for um campo de data:
                  - Ajusta as configurações de formato de acordo com a máscara (`Mask`).
                  - Copia o valor de `aDataField` para a variável `s`.
                  - Se `s` não for uma string vazia, atribui `s` ao campo `Value`.
                    Caso contrário, se o campo for numérico (`IsNumber`) ou de dados
                    (`IsData`), atribui `0`; caso contrário, atribui uma string
                    vazia (`''`).
                  - As configurações de formato são restauradas após o processamento.

             2. **Outro Tipo de Dado:**
                - Se o campo não for de dados (`IsData` é `False`):
                  - Se o campo for booleano (`IsBoolean`), atribui o valor booleano do campo de dados (`aDataField.AsBoolean`).
                  - Caso contrário, copia o valor diretamente de `aDataField`.

           - **Ver Também**:
             - `TField`
             - `TFormatSettings`
             - `TDates.SetDefaultFormatSettings`
         }
         public Procedure CopyFrom(aDataField:TField);

         {: O atributo **@name** copia o conteúdo de self para TDataField.
         }
         public Procedure CopyTo(aDataField:TField);

      end;

=====================================================




=====================================================
Abaixo o nucleo do gerador de recursor para gerar formulários em qualquer linguagem:
=====================================================



    procedure TUiDmxScroller.CreateStruct(var ATemplate: TString);
        var
          SameFieldNum  : boolean;
          WasSameNum    : boolean;
          NoFieldNum    : boolean;
          NoFieldAdv    : boolean;
          AllZeroes     : boolean;
          C             : AnsiChar;
          DoDecimal     : integer;
          Rex,X         : pDmxFieldRec;
          WFieldName    : tString;
          DmxStr_ID     : TDmxStr_ID;
          _templx       :  tString;
          _templx_Org   :  AnsiString;


      Procedure SetFlags(aFlag:Boolean);
      begin
        SameFieldNum := aFlag;
        WasSameNum   := aFlag;
        NoFieldNum   := aFlag;
        NoFieldAdv   := aFlag;
      end;

      {$REGION 'templx'}
        //Objetivo desta função é salva o Template original.

        function templx(Const Ch,ch_Org:tString) : AnsiString;Overload;
            Begin
              if Ch=''
              then Begin
                     _templx := '';
                     _templx_Org := '';
                   End
              Else Begin
                     _templx := _templx + ch;
                     _templx_Org := _templx_Org + ch_Org;
                   End;

              Result := _templx;
            End;

        function templx(Const Ch:tString) : AnsiString;Overload;
        Begin
          Result := templx(ch,'');
        End;

        function templx : AnsiString;Overload;
            Begin
              Result := _templx;
            End;

      {$ENDREGION}

      procedure NewRecord;
      begin
        If not CreateValid
        then Exit;

        With TUiMethods,Rex^ do
        begin
          If DoDecimal > 0
          then Rex.Decimals := pred(DoDecimal);

          DoDecimal := 0;
          If (FieldSize= 0)
          then access := access or accSkip
          else begin
                 If not NoFieldAdv
                 then begin
                        If SameFieldNum  and (not NoFieldNum)
                        then Begin
                               Fieldnum := succ(TotalFields);
                               {Se não existir nome do campo no Template, então devo criar um.
                                formato:
                                   Para o campo 1 nome do campo = Field1,
                                   Para o campo 2 nome do campo = filed2
                                   .............
                                   Para o campo n nome do campo = filedn
                               }

                               if WFieldName = ''
                               then WFieldName := Format('Field%d',[Fieldnum]);

                               FieldName := WFieldName; //ITMS
                               DataFields.AddFields(Rex);

                             end
                             else If (access and accHidden = 0) or WasSameNum
                                  then begin
                                          Inc(TotalFields);
                                          Fieldnum := TotalFields;

                                          if (WFieldName = '') and (Fieldnum<>0 )
                                          then WFieldName := Format('Field%d',[Fieldnum]);

                                          FieldName := WFieldName; //ITMS
                                          if FieldName<>''
                                          Then DataFields.AddFields(Rex);
                                       end;

                        DataTab    := RecordSize;
                        RecordSize := RecordSize + FieldSize;

                      end;
                 end;
          ScreenTab  := Limit.X;

          If (TypeCode = FldBoolean) and (TrueLen = 0)
          then ShowZeroes := FALSE;

          If TypeCode in [fldENUM,FLdEnum_db]
          then ColumnWid := TrueLen
          else begin
                 If (ColumnWid = 0)
                 then ColumnWid := length(AnsiString_to_USASCII(templx));

                 If (length(templx) > 0) or (Template <> nil)
                 then begin
                        Template     := NewStr(templx);
                        Template_org := _templx_Org; //ITMS
                      end
                 else begin
                        If (TypeCode <> #0) and (access and accHidden = 0)
                        then Inc(Limit.X);
                      end;
               end;

          If (ShownWid = 0)
          then ShownWid := ColumnWid;

          If access and accHidden = 0
          then Limit.X := Limit.X + ShownWid;

        end;

        templx('');

        {$REGION '---> Aloca o próximo registro'}
          New(Rex.Next);
          //Fields.Add(Rex);
          X       := Rex;
          x.RSelf := Rex;
          Rex     := Rex.Next;
          //Zera o novo registro
          FillChar(Rex^, sizeof(Rex^), 0);
          Rex.Prev := X;
          Rex.Next := nil;

          Rex.ShowZeroes := AllZeroes;

          WFieldName := ''; //< NortSoft
          Rex.Owner_UiDmxScroller := Self; // NortSoft

          Rex.ProviderFlags := [pfInUpdate,pfInWhere];
          Rex.ID_Dynamic := Alias+'_'+CreateGUID;
          Rex.QuitFieldAltomatic := QuitFieldAltomatic_Default;

        {$ENDREGION}


        //WasSameNum := FALSE;
        //NoFieldNum := FALSE;
        //NoFieldAdv := FALSE;
        SetFlags(false);
      end; {<procedure NewRecord;}

      {: O método **@name** tranfere as informações da string dataformat para
         a lista encadea cujo o primeiro elemento é: DMXField1
      }
      procedure TranslateStruct(dataformat: ptString);
        var
          df   : ptString;
          i,j  : integer;
          Flag : byte;
          TS   : PSItem;
          temp1,
          temp2: TDmxStr_ID;//String[30];
          LenDataformat : integer;


        function GetFieldName:AnsiString;
          begin
            result := '';
            if CharFieldName <> dataformat^[i]
            then exit;

            Inc(i);
            While (not (dataformat^[i] in Delimiters))
                  and (i <= length(dataformat^))
            do begin
                 Result := Result + dataformat^[i];
                 Inc(i);
               end;
          End;

        function GetExecAction:AnsiString;
          var
            s,aFieldName : Ansistring;

        begin
          result := '';
          aFieldName := '';
          Inc(i);

          s:= Copy(dataformat^,i,length(dataformat^));

          if (Pos('.',s)<> 0)
          then begin //Inicia LinkExecAction
                 While (dataformat^[i] in ['_','a'..'z','A'..'Z','0'..'9']) and
                        (dataformat^[i] <> '.')
                        and (not (dataformat^[i] in Delimiters))
                        and (i <= length(dataformat^))
                 do
                 begin
                   aFieldName := aFieldName + dataformat^[i];
                   Inc(i);
                 end;

                 With Rex^ do
                  LinkExecAction := FieldByName(aFieldName);
                 Inc(i);
               end;

          While (i <= length(dataformat^)) and
                (dataformat^[i] in [' ','_','a'..'z','A'..'Z','0'..'9'])
                and (not (dataformat^[i] in Delimiters))
          do begin
               Result := Result + dataformat^[i];
               Inc(i);
             end;
          result := DelSpcED(Result);
        End;

        function Get_Alias:AnsiString;
        begin
          result := '';
          Inc(i);
          While (not (dataformat^[i] in Delimiters))
                and (i <= length(dataformat^))
          do begin
                Result := Result + dataformat^[i];
                Inc(i);
             end;
        end;

        function GetFormatoDateTime: AnsiString;
        begin
          result := '';
          Inc(i);
          While (i <= length(dataformat^))
                and (dataformat^[i] in ['d','m','y','h','n','s','z','/','-',' ',':']) //Cara
          do begin
                Result := Result + dataformat^[i];
                Inc(i);
             end;
        end;

        Procedure GetHints;
        begin
          if (i > 254) then exit;
          if (dataformat^[i] <> CharHint)
          then exit;
          inc(i);

          if dataformat^[i] in ['0','1']
          then begin
                 case dataformat^[i] of
                   '0' : begin //Porque
                           While (not (dataformat^[i] in Delimiters)) and (i <= LenDataformat) do
                           begin
                             inc(i);
                             Rex^.HelpCtx_Porque := Rex^.HelpCtx_Porque+ dataformat^[i];
                           end;
//                           writeLn(Rex^.HelpCtx_Porque);
                         end;
                   '1' : begin //Onde
                           While (not (dataformat^[i] in Delimiters)) and (i <= LenDataformat) do
                           begin
                             inc(i);
                             Rex^.HelpCtx_Onde := Rex^.HelpCtx_Onde+ dataformat^[i];
                           end;
//                           writeLn(Rex^.HelpCtx_Onde);
                         end;
                 end;
               end
          else begin //hint
                  While (not (dataformat^[i] in Delimiters)) and (i <= LenDataformat) and (i < sizeof(tstring)) do
                  begin
                    Rex^.HelpCtx_hint := Rex^.HelpCtx_hint+ dataformat^[i];
                    inc(i);
                  end;
                 // writeLn(Rex^.HelpCtx_hint);
               end;

        end;

        Procedure GetDefault;
          var
            chaControl : char;
        begin
          if dataformat^[i] <> CharDefaultBase
          then exit;
          inc(i);
          chaControl := dataformat^[i];
          inc(i);
          While (not (dataformat^[i] in Delimiters)) and (i <= LenDataformat) do
          begin
            case chaControl of
              //CharDefaultConst
              '0': Rex^.DefaultConst := Rex^.DefaultConst+ dataformat^[i];

              //CharDefaultExpression
              '1': Rex^.DefaultExpression := Rex^.DefaultExpression+ dataformat^[i];
              else  Raise TException.Create(self,{$I %CURRENTROUTINE%},'Erro de sintaxe ao capturar o valor default!.');
            end;
            inc(i);
          end;
        end;

      begin
        setFlags(false);
        DoDecimal    := 0;
        i            := 1;

        LenDataformat := length(dataformat^);
//        LenDataformat := length(AnsiString_to_USASCII(dataformat^));

        if ShouldSaveTemplate and (TableName<>'')
        Then SaveTemplate(TableName+'.lfm_mi',dataformat^);

        While (i <= LenDataformat) do
        begin
          C := upcase(dataformat^[i]);
          with TUiMethods do
          Case C of
            //ChTest : begin //Usado para saber se o código é válido.
            //           writeLn(ord(chTest));
            //         end;
            CharDefaultBase : begin
                            GetDefault;
                            continue;
                          end;
            FldBoolean :  With Rex^ do
                          begin
                            alias := 'FldBoolean';
                            templx(#0,dataformat^[i]);
                            If upcase(C) <> fldShortInt
                            then C := upcase(C);

                            TypeCode  := dataformat^[i];
                            Inc(TrueLen);
                            FieldSize := sizeof(BYTE);
                            FillValue := #0;
                            Alias := Get_Alias;
                            Rex.ShownWid := + Rex.ShownWid + Length(alias);
                            getHints;
                            continue;
                          end;

            FldRadioButton : //With Rex^ do
                             begin
                                Rex^.TypeCode  := dataformat^[i];
                                Rex^.FieldSize := Sizeof(byte);

                                Inc(i);
                                j := ord(dataformat^[i]);
                                If (ClusterTemps[j].fnum = 0)
                                then begin
                                       ClusterTemps[j].fnum := succ(TotalFields);
                                       ClusterTemps[j].ofs  := RecordSize;
                                     end
                                else begin
                                       Inc(ClusterTemps[j].value);
                                       Rex^.Fieldnum := ClusterTemps[j].fnum;
                                       Rex^.Decimals := ClusterTemps[j].value;
                                       Rex^.DataTab  := ClusterTemps[j].ofs;
                                       //NoFieldNum    := TRUE;
                                       //NoFieldAdv    := TRUE;
                                       //SameFieldNum  := true;
                                       SetFlags(true);
                                     end;
                                Rex^.Fieldnum := ClusterTemps[j].fnum;

                                templx(#0,dataformat^[i]);
                                Inc(Rex^.TrueLen);
                                Rex^.Alias := Get_Alias;
                                Rex^.ShownWid := + Rex^.ShownWid + Length(Rex^.alias);
                                GetHints;
                                continue;
                             end;
            fldStr,
            fldStrNumber       : With Rex^ do
                              begin
                                templx(#0,dataformat^[i]);
                                TypeCode := dataformat^[i];
                                Inc(TrueLen);
                                If FieldSize > 0
                                then Inc(FieldSize)
                                else begin
                                       FieldSize :=  2;
                                       FillValue := ' ';
                                     end;
                              end;

            CharListOptions  : Begin //O campo corrente possue uma lista de opções.
                                  Move(dataformat^[succ(i)], TS, sizeof(TS));
                                  rex^.ListOptions := TS;
                                  Inc(i,sizeof(TS));
                                  //GetHints;
                                  //continue;
                                end;

            fldAnsiChar,
            fldAnsiCharAlfa,
            fldAnsiCharNum,
            fldAnsiCharNumPositive  :
                              With Rex^ do
                              begin
                                If (DoDecimal > 0)
                                then begin
                                       //templx    := templx + #1;
                                       templx(#1,dataformat^[i]);
                                       Inc(DoDecimal);
                                     end
                                else templx(#0,dataformat^[i]);
                                TypeCode  := dataformat^[i];
                                Inc(TrueLen);
                                Inc(FieldSize);
                                FillValue := ' ';
                              end;

            fldByte,
            fldShortInt   :  With Rex^ do
                              Begin
                                templx(#0,dataformat^[i]);

                                If upcase(C) <> fldShortInt
                                then C := upcase(C);

                                TypeCode  := dataformat^[i];
                                Inc(TrueLen);

                                FieldSize := sizeof(BYTE);
                                FillValue := #0;

                              end;

            {< 'Z' }
            fldZEROMOD   :    With Rex^ do
                              begin
                                If (TypeCode = #0) or (TypeCode = fldDouble)
                                then Inc(FieldSize);

                                templx(#1,dataformat^[i]);
                                Inc(TrueLen);

                                If DoDecimal > 0
                                then Inc(DoDecimal);
                              end;


            fldSmallWord :    With Rex^ do
                              begin
                                templx(#0,dataformat^[i]);
                                TypeCode  := dataformat^[i];
                                Inc(TrueLen);
                                FieldSize := sizeof(SmallWord);
                                FillValue := #0;
                              end;

            FldSmallInt  :  With Rex^ do
                              begin
                                templx(#0,dataformat^[i]);
                                TypeCode  := dataformat^[i];
                                Inc(TrueLen);
                                FieldSize := sizeof(SmallInt);
                                FillValue := #0;
                              end;


            fldLongInt  : With Rex^ do
                          begin
                            templx(#0,dataformat^[i]);
                            TypeCode  := dataformat^[i];
                            Inc(TrueLen);
                            FieldSize := sizeof(LONGINT);
                            FillValue := #0;
                          end;

            FldDateTime : With Rex^ do
                          begin
                            templx(#0,dataformat^[i]);
                            TypeCode  := dataformat^[i];
                            FieldSize := sizeof(TDateTime);
                            FillValue := #0;
                            //Identifica o tipo de formato de dados do template.
                            //
                            temp1 := GetFormatoDateTime;
                            temp2 := temp1;
                            Inc(TrueLen,length(temp1));
                            FillChar(temp1[1],length(temp1),#0);
                            templx(temp1,temp2);
                            continue;
                          end;


            fldHexValue :     With Rex^ do
                              begin
                                templx(#0,dataformat^[i]);
                                TypeCode  := dataformat^[i];
                                Inc(TrueLen);
                                FieldSize := succ(TrueLen) shr 1;
                                FillValue := #0;
                              end;

            fldDouble,
            fldDoublePositive: With Rex^ do
                                  begin
                                    templx(#0,dataformat^[i]);
                                    TypeCode  := dataformat^[i];
                                    Inc(TrueLen);
                                    FieldSize := sizeof(TRealNum);
                                    FillValue := #0;
                                    If DoDecimal > 0
                                    then Inc(DoDecimal);
                                  end;

            fldExtended : With Rex^ do
                          begin
                            templx(#0,dataformat^[i]);
                            TypeCode  := dataformat^[i];
                            Inc(TrueLen);
                            FieldSize := sizeof(Extended);
                            FillValue := #0;
                            If DoDecimal > 0
                            then Inc(DoDecimal);
                          end;
            fldReal4,
            fldReal4Positivo,
            fldReal4P,
            fldReal4PPositivo
                        : With Rex^ do
                          begin
                            templx(#0,dataformat^[i]);
                            TypeCode  := dataformat^[i];
                            Inc(TrueLen);
                            FieldSize := sizeof(real);
                            FillValue := #0;
                            If DoDecimal > 0
                            then Inc(DoDecimal);
                          end;

            fldENum :
            begin
              If (templx <> '')
              then NewRecord;
              if dataformat^[i] = fldENUM
              Then begin
                     DmxStr_ID := Copy(dataformat^,i,EnumField_ofs.Default+sizeof(TEnumField.Default));
                     Rex^.DataSource := nil;
                     Rex^.KeyField   := 'id';
                     Rex^.ListField  := 'descricao';
                   end
              else Raise TException.Create(self,{$I %CURRENTROUTINE%},'Chamada ao método CreateStruct inválida.');

              Inc(i, Length(DmxStr_ID));
              Move(DmxStr_ID[EnumField_ofs.Items],Rex^.Template,sizeof(Rex^.Template));

              Rex^.TypeCode  := fldENUM;
              if Assigned(Rex^.Template)
              then Rex^.TrueLen := MaxItemStrLen(PSItem(Rex^.Template));

              Rex.FieldSize := sizeof(Longint);
              Rex^.FillValue  := #0;

              If DmxStr_ID[EnumField_ofs.ShowZ]  = '0' //NortSoft Free Vision
              Then Rex^.ShowZeroes      := false
              else Rex^.ShowZeroes      := True;

              Rex^.access               := byte(DmxStr_ID[EnumField_ofs.AccMode]);
              move(DmxStr_ID[EnumField_ofs.Default],Rex^.ListOptions_Default,Sizeof(TEnumField.Default));

              WFieldName := '';

              //Procura o nome do campo enumerado.

              for j := i to length(dataformat^) do
              begin
                inc(i);
                case dataformat^[j] of
                  CharFieldName : begin //Achou nome do campo.
                                  i := j;
                                  WFieldName := trim(GetFieldName);
                                  break //Sai do laço for j
                                End;
                end;
              end;
              GetHints;
              Rex^.FldEnum_Lookup := TFldEnum_Lookup.create(Rex);

              if Rex^.template_org = ''
              then Rex^.template_org := 'LLLLLL';

              NewRecord;
              continue;
            end;

            fldENUM_Db: begin

                          If (templx <> '')
                          then NewRecord;
                          if dataformat^[i] = fldENUM_db
                          Then begin
                            DmxStr_ID := Copy(dataformat^,i,EnumField_ofs.ListField+sizeof(TEnumField.ListField));
                            move(DmxStr_ID[EnumField_ofs.DataSource],Rex^.DataSource,Sizeof(TEnumField.DataSource));
                            move(DmxStr_ID[EnumField_ofs.KeyField],Rex^.KeyField,Sizeof(TEnumField.KeyField));
                            move(DmxStr_ID[EnumField_ofs.ListField],Rex^.ListField,Sizeof(TEnumField.ListField));
                          end
                          else Raise TException.Create(self,{$I %CURRENTROUTINE%},'Chamada ao método CreateStruct inválida.');


                          Inc(i, Length(DmxStr_ID));
                          Move(DmxStr_ID[EnumField_ofs.Items],Rex^.Template,sizeof(Rex^.Template));

                          Rex^.TypeCode  := fldENUM_db;
                          if Assigned(Rex^.Template)
                          then Rex^.TrueLen := MaxItemStrLen(PSItem(Rex^.Template));

                          Rex.FieldSize := sizeof(Longint);
                          Rex^.FillValue  := #0;

                          If DmxStr_ID[EnumField_ofs.ShowZ]  = '0' //NortSoft Free Vision
                          Then Rex^.ShowZeroes      := false
                          else Rex^.ShowZeroes      := True;

                          Rex^.access               := byte(DmxStr_ID[EnumField_ofs.AccMode]);
                          move(DmxStr_ID[EnumField_ofs.Default],Rex^.ListOptions_Default,Sizeof(TEnumField.Default));

                          WFieldName := '';

                          //Procura o nome do campo enumerado.

                          for j := i to length(dataformat^) do
                          begin
                            inc(i);
                            case dataformat^[j] of
                              CharFieldName : begin //Achou nome do campo.
                                              i := j;
                                              WFieldName := trim(GetFieldName);
                                              break //Sai do laço for j
                                            End;
                            end;
                          end;
                          GetHints;

                          if (DataSource<>nil)
                          then begin
                                 Rex^.FldEnum_Lookup := TFldEnum_Lookup.create(Rex);
                               end;

                          NewRecord;
                          continue;
                        end;

            fldBLOB  :        begin
                                If (templx <> '')
                                then NewRecord;

                                Rex.TypeCode    := fldBLOB;
                                Move(dataformat^[i+1] , Rex.FieldSize, sizeof(Rex.FieldSize));
                                {$IFDEF CPU32}
                                  Rex.access    := byte(dataformat^[i+6]) or accHidden;
                                  Rex.FillValue := dataformat^[i+7];
                                {$ENDIF}
                                {$IFDEF CPU64}
                                  Rex.access    := byte(dataformat^[i+6+4]) or accHidden;
                                  Rex.FillValue := dataformat^[i+7+4];
                                {$ENDIF}

                                Inc(i, sizeof(TDmxStr_ID) - 2);

                                NewRecord;
                              end;


            fldAPPEND  :      begin
                                If (templx <> '')
                                then NewRecord;

                                Move(dataformat^[succ(i)], df, sizeof(df));
                                TranslateStruct(df);
                                Inc(i, sizeof(TDmxStr_ID) - 2);
                              end;

            { NortSoft
                Informa o nome do campo no Template
                Sintaxe: ~Nome do produto: ~ SSSSSSSSSSSSSSSS^BNome_do_Produto+#0
                Nota:
                  O nome do campo é passado após ^B e o mesmo não pode conter espaço em branco.
            }
            CharFieldName : Begin
                              WFieldName := trim(GetFieldName);
                              continue;
                            end;

            CharShowPassword : begin {<NortSoft}
                                 Rex^.CharShowPassword := dataformat^[i];
                               end;

            fldSItems    :    begin
                                If (templx <> '')
                                then NewRecord;

                                Move(dataformat^[succ(i)], TS, sizeof(TS));

                                While (TS <> nil) do
                                begin
                                    If (TS.Value <> nil)
                                    then TranslateStruct(TS.Value);
                                    TS := TS.Next;
                                end;

//                                Inc(i, sizeof(TDmxStr_ID) - 2);
                                Inc(i, 9-1);
                              end;

            ThousandSeparator : begin
                                  With Rex^ do
                                    if TObjectsMethods.IsNumber(TypeCode)
                                    then templx(ShowThousandSeparator,ShowThousandSeparator)
                                    else templx(dataformat^[i],dataformat^[i]);
                                end;

            CloseParenthesis,{')'}
            DecimalSeparator //'.'
                            :
                              With Rex^ do
                              begin
                                if (c = CloseParenthesis) or (Not TObjectsMethods.IsNumber(TypeCode))
                                Then templx(C,dataformat^[i])
                                else templx(ShowDecimalSeparator,ShowDecimalSeparator);

                                If (upcase(Rex.TypeCode) = fldDouble)
                                then begin
                                       If (C = CloseParenthesis {')'})
                                          then Inc(TrueLen);  {<?????}

                                       Inc(FieldSize);
                                     end;

                                If (C = DecimalSeparator)
                                then begin
                                       If (upcase(TypeCode) = fldDouble) or
                                          (upcase(TypeCode) = fldDouble) or
                                          (upcase(TypeCode) = fldExtended) or
                                          (upcase(TypeCode) = fldReal4) or
                                          (upcase(TypeCode) = fldReal4P) or
                                          (upcase(TypeCode) = fldReal4Positivo) or
                                          (upcase(TypeCode) = fldReal4PPositivo)
                                       then DoDecimal := 1;
                                     end
                                else Parenthesis := TRUE;
                              end;

            CharExecAction :  begin
                                with Rex^ do
                                  ExecAction := GetExecAction;
                                GetHints;
                                continue;
                              end;

            {'~'}
            CharDelimiter_3 : begin

                                If (templx <> '')
                                then NewRecord;
                                Rex^.alias := '~';
                                C := ' ';

                                templx(C,dataformat^[i]);

                                Inc(i);
                                While (dataformat^[i] <> CharDelimiter_3{'~'}) and (i < LenDataformat) do
                                begin
                                  C := dataformat^[i];

                                  If C = AnsiChar(accNormal)
                                  then C := ' ';

                                  //If C = #1 then C := #2;
                                  If C = AnsiChar(accReadOnly)
                                  then C := AnsiChar(accHidden);


                                  templx(C,dataformat^[i]);
                                  Inc(i);
                                  //if ord(c) <=127
                                  //then Inc(i)
                                  //else i := i+2;
                                end;
                                C := ' ';

                                templx(C,dataformat^[i]);

                                //==========================================================================================================
                                {$REGION ' ---> Tarefa: Permitir que o label torne-se invisível'}
                                //==========================================================================================================

                                if (length(dataformat^) > i)
                                   and (
                                          (dataformat^[i+1] = CharAccHidden) {^H}
                                          //or  (dataformat^[i+1] = AnsiChar(accHidden))
                                       )
                                then begin
                                       if Rex<>nil
                                       Then begin
                                              Rex.access    := Rex.access or accHidden;
                                            end;
                                     end;

                                {$ENDREGION}
                                //==========================================================================================================


                              end;

            CharDelimiter_0,  {#0}
            CharDelimiter_1{'\'} :
                              begin
                                If (templx <> '')
                                then NewRecord;
                                If C <> CharDelimiter_0{#0}
                                then begin
                                       //If C = '|'
                                       //then C := '|'else
                                       If C = CharDelimiter_1{'\'}
                                       then C := ' ';

                                       Rex.access    := Rex.access or accDelimiter;
                                       Rex.TypeCode  := C;
                                       NewRecord;
                                     end;
                              end;

            {^A}
            CharAllZeroes   : begin
                                AllZeroes       := not AllZeroes;
                                Rex^.ShowZeroes := AllZeroes;
                                Rex.Alias:='CharAllZeroes';
                              end;

            CharAccHidden {^H}  : Begin
                                    Rex^.SetAccess(accHidden);
                                   End;

            {^P}
            CharProviderFlag  : begin
                                  With Rex^ do
                                  begin
                                    FieldName := WFieldName;
                                    inc(i);
                                    //val(dataformat^[i],flag,err);
                                    flag := StrToInt(dataformat^[i]);
                                    case flag  of
                                      0 : begin
                                            Rex^.ProviderFlags := Rex^.ProviderFlags + [pfInUpdate];
                                          End;
                                      1 : Begin
                                            Rex^.ProviderFlags := Rex^.ProviderFlags + [pfInWhere];
                                          End;

                                      2 : Begin
                                            Rex^.ProviderFlags := Rex^.ProviderFlags + [pfInKey];
                                          End;

                                      3 : Begin
                                            Rex^.ProviderFlags := Rex^.ProviderFlags + [pfHidden];
                                          End;

                                      4 : Begin
                                            Rex^.ProviderFlags := Rex^.ProviderFlags + [pfRefreshOnInsert];
                                          End;

                                      5 : Begin
                                            Rex^.ProviderFlags := Rex^.ProviderFlags + [pfRefreshOnUpdate];
                                          End;

                                      6 : Begin //Chave primária
                                            Rex^.ProviderFlags := Rex^.ProviderFlags + [pfInKeyPrimary,pfInKey];

                                            if keysPrimaryKeyComposite = ''
                                            then keysPrimaryKeyComposite := FieldName
                                            else keysPrimaryKeyComposite := keysPrimaryKeyComposite + ';'+FieldName;
                                          End;

                                      7 : Begin //Chave primária auto incremental
                                            Rex^.ProviderFlags := Rex^.ProviderFlags + [pfInKeyPrimary,pfInKey,pfInAutoIncrement];
                                            keysPrimaryKeyComposite := FieldName;
                                            flagPrimaryKey_AutoIncrement := true;
                                          End;

                                    End;


                                  End;
                                 end;

            {^F}
            CharForeignKey  : begin
                                With Rex^ do
                                begin
                                  FieldName := WFieldName;
                                  inc(i);
                                  //val(dataformat^[i],flag,err);
                                  flag := StrToInt(dataformat^[i]);

                                  KeyForeign := '';
                                  //Seleciona os parâmetros de CharForeignKey
                                  While (not (dataformat^[i] in Delimiters)) and (i < LenDataformat) do
                                  begin
                                    inc(i);
                                    KeyForeign := KeyForeign+ dataformat^[i];
                                  end;

                                  case flag  of
                                    0 : begin
                                          Rex^.ForeignKey := Fk_No_Action;
                                        End;

                                    1 : Begin
                                          Rex^.ForeignKey := Fk_Restrict;
                                        End;

                                    2 : Begin
                                          Rex^.ForeignKey := Fk_Cascade;
                                        End;

                                    3 : Begin
                                          Rex^.ForeignKey := Fk_Set_Null;
                                        End;

                                    4 : Begin
                                          Rex^.ForeignKey := Fk_Set_Default;
                                        End;

                                  End;


                                End;

                             end;

            //^P      :       With Rex^ do
            //                  begin
            //                    Inc(i);
            //                    RecordSize := RecordSize + shortint(dataformat^[i]);
            //                  end;

            {^R}
            CharAccReadOnly : Begin
                                Rex^.SetAccess(accReadOnly);
//                                With Rex^ do access := access or accReadOnly;
                              end;
            {^S}
            CharAccSkip:     Begin
                               Rex^.SetAccess(accSkip);
                              end;

            {^U}
            CharUpperlimit    : With Rex^ do
                                begin
                                  Inc(i);
                                  UpperLimit := byte(dataformat^[i]);
                                end;


            {^V}
            CharFillvalue   : With Rex^ do
                              begin
                                Inc(i);
                                FillValue := dataformat^[i];
                              end;

            CharShowzeroes{^Z}  : Rex^.ShowZeroes := TRUE;

            fldCONTRACTION:   With Rex^
                                do ShownWid := length(AnsiString_to_USASCII(templx));

            CharHint   : begin
                           GetHints;
                           Continue;
                         end;
            else begin
                   templx(dataformat^[i],dataformat^[i]);
                 end;
          end;  {< case of C }

          Inc(i);
        end; {<While (i <= length(dataformat^)) do}

//        writeln(' ');
      end; {<procedure TranslateStruct(dataformat: ptString);}

      var wState : Boolean;
    begin
      If (@ATemplate = nil)
      then Exit;

      try
        wState := SetState(Mb_St_Creating_Template,true);
        AllZeroes      := FALSE;
        templx('');
        New(Rex);
        FillChar(Rex^, sizeof(Rex^), 0);
        Rex.Next       := nil;
        Rex.Prev       := nil;
        Rex.ShowZeroes := AllZeroes;
        X              := nil;
        If DMXField1 = nil
        then DMXField1 := Rex
        else begin
               X := DMXField1;
               While X.Next <> nil do X := X.Next;
               X.Next := Rex;
               Rex.Prev := X;
             end;
        TranslateStruct(@ATemplate);
//      SameFieldNum := FALSE;
        If templx <> ''
        then NewRecord;
        If (Rex = DMXField1)
        then DMXField1 := nil;
        Dispose(Rex);
        If (X <> nil)
        then X.Next := nil;
        If DMXField1 <> nil
        then DMXField1.Prev := X;
      Finally
        SetState(Mb_St_Creating_Template,wState);
      End;
    end;

    procedure TUiDmxScroller.CreateStruct(var ATemplate: PSItem);
      Var s :TString;
    begin
      Move(ATemplate, s[1],sizeof(ATemplate));
      s[0] := chr(sizeof(ATemplate));
      CreateStruct(s);
    end;

    procedure TUiDmxScroller.CreateStruct;
      Var L : Longint;
          Template : PSItem;
      var wState : Boolean;
    begin
      if not GetState(Mb_St_Creating)
      then raise TException.Create(self,{$I %CURRENTROUTINE%},'Chamada ao método CreateStruct inválida.');

      try
        wState := SetState(Mb_St_Creating_Template,true);
        Template := GetTemplate(nil);
        if Template<> nil
        then begin
               Fields := TFields.Create;
               FillChar(ClusterTemps, sizeof(ClusterTemps), 0);
               CreateValid   := TRUE;
               Limit.X       := 0;
               CreateStruct(Template);
               If (RecordSize > 0)
               then begin
                      CreateData;
                      L := RecordSize;
                      L := DataBlockSize div L;
                      SetLimit(Limit.X, L);
                    end;
               LeftField := DMXField1;
               DisposeSItems(Template);

               if (DataSource<>nil) and  (DataSource.DataSet=nil)
               then DataSource.DataSet := BufDataset;

             end;

      finally
        SetState(Mb_St_Creating_Template,wState);
      end;
    end;

    procedure TUiDmxScroller.DestroyStruct;
       var  P : pDmxFieldRec;
    begin
      Try
        While (DMXField1 <> nil) do
        begin
          If DMXField1.Template <> nil
          then begin
                 If upcase(DMXField1.TypeCode) in [fldENum,fldENum_db,fldSItems] //<NortSoft
                 then Begin
                         DisposeSItems(PSItem(DMXField1.Template ));
                         PSItem(DMXField1.Template ) := nil;
                      End
                 else DisposeStr(DMXField1.Template);
               end;
          P := DMXField1.Next;
          Dispose(DMXField1);
          DMXField1 := P;
        end;

      Finally
        LeftField     := nil;
        DMXField1     := nil;//<  Caso ocorra um excessao a destruir estrutura
      End;
    end;
           

=========================================
Exeplo de template para gerar recursos com turdo que for necessário para se criar um formulário em qualquer linguagem
=========================================
function TMi_rtl_WebModule_Custom.DmxScroller_Form1GetTemplate(aNext: PSItem): PSItem;
begin
  with DmxScroller_Form1 do
  begin
    Result :=
    NewSItem('',
    NewSItem(GetTemplate_CRUD_Buttons(CmNewRecord,CmUpdateRecord,'CmLocate',CmDeleteRecord,CmCancel),
    NewSItem(GetTemplate_DbNavigator_Buttons(CmGoBof,CmNextRecord,CmPrevRecord,CmGoEof,CmRefresh),
    NewSItem('',
    //NewSItem('~Status:        ~\ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss'+CharAccSkip+chFN+'status',//+CharAccReadOnly,

     NewSItem('~ID:            ~\LLLLLL'+chFN+'id'+CharAccReadOnly+CharPfInKeyPrimary+CharPfInKeyPrimaryAutoIncrement,//+CharAccSkip,

//     NewSItem('~ID:           ~\LLLLLL'+chFN+'id'+CharPfInKeyPrimary+CharPfInKeyPrimaryAutoIncrement+CharAccSkip,

    //NewSItem('~ID_operadores:  ~'+CreateEnumField(TRUE, accNormal, 1,NewSItem('ssssssssssssssssssssss',nil),
    //                                             Mi_SQLQuery1.DataSource,'id_operadores','nome')+
    //                                             ChFN+'id_Operadores'+
    //                                             CharHint+'Campo enumero lookup',

//     NewSItem('~ID_operadores: ~\LLLLLL'+chFN+'id_operadores',
    NewSItem('~Nome:          ~\ssssssssssssssssssssssssssssssssssssssssssssssssss'+chFN+'nome'+CharHint+'Campo alfanumérico aceita maiuscula e minuscula',
    NewSItem('~endereco       ~\ssssssssssssssssssssssssssssssssssssssssssssssssss'+chFN+'endereco',
    NewSItem('~cnpj           ~\##.###.###/####-##'+chFN+'cnpj',
    NewSItem('~cpf            ~\###.###.###-##'+chFN+'cpf',
    NewSItem('~cep            ~\##.###-###'+chFN+'cep',
    NewSItem('~valor_SMALLINT ~\IIIII'+chFN+'valor_SMALLINT',
    NewSItem('~valor_Integer  ~\LLL.LLL'+chFN+'valor_Integer',//Maximo:2.147.483.647
    NewSItem('~valor_FLOAT8   ~\RRR,RRR,RRR.RR'+chFN+'valor_FLOAT8',
    NewSItem('~TESTE DE DATAS E HORAS~',
    NewSItem('~ ~',
    NewSItem('~ Data: dia/mes/ano ~',
    NewSItem('~  dd/mm/yy         ~\Ddd/mm/yy'+chFN+'dd_mm_yy',
    NewSItem('~  dd/mm/yyyy       ~\Ddd/mm/yyyy'+chFN+'dd_mm_yyyy',
    NewSItem('~ ~',
    NewSItem('~ Horas: Hora:Minutos:Segundos ~',
    NewSItem('~  hh:nn:ss         ~\Dhh:nn:ss'+chFN+'hh_nn_ss',
    NewSItem('~  hh:nn            ~\Dhh:nn'+chFN+'hh_nn'+ChH+'Campo hora e minutos',
    NewSItem('~ ~',
    NewSItem('~ Data e Horas: dia/mes/ano hora:minutos:segundos~',
    NewSItem('~    dd/mm/yy hh:nn:ss:   ~\Ddd/mm/yy hh:nn:ss'+chFN  +'dd_mm_yy_hh_nn_ss',
    NewSItem('~    dd/mm/yyyy hh:nn:ss: ~\Ddd/mm/yyyy hh:nn:ss'+chFN+'dd_mm_yyyy_hh_nn_ss',
    NewSItem('',
    NewSItem('~ Data e Horas: dia/mes/ano hora:minutos~',
    NewSItem('~    dd/mm/yy hh:nn:      ~\Ddd/mm/yy hh:nn'+chFN+'dd_mm_yy_hh_nn',
    NewSItem('~    dd/mm/yyyy hh:nn:    ~\Ddd/mm/yyyy hh:nn'+chFN+'dd_mm_yyyy_hh_nn',
    NewSItem('',
    NewSItem(GetTemplate_CRUD_Buttons(CmNewRecord,CmUpdateRecord,'',CmDeleteRecord,CmCancel),
    NewSItem(GetTemplate_DbNavigator_Buttons(CmGoBof,CmNextRecord,CmPrevRecord,CmGoEof,CmRefresh),
    NewSItem('',
    aNext))))))))))))))))))))))))))))))))));
  end;
end;
