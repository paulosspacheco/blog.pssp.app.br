# SINTAXE DE RECURSOS DO TEMPLATE MARICARAI

1. **Códigos de Controles**
   1. _~_ switch tString-literals on/off
   2. _^A_ Zera todos os campos
   3. _^B_ Indica que os caracteres seguintes contém o nome do campo
   4. _^C_ O campo corrente possui uma lista de opções do mesmo tipo.
   5. _^D_ Use o próximo caractere como um delimiter de campo
   6. _^E_ Campo do tipo enumerado.
   7. _^F_ Usado para criar restrições e relacionamentos
   8. _^G_ Usada para concatenar duas listas do tipo PSItem.
   9. _^H_ Campo escondido
   10. _^I_ Link para cadeia de template pSItem
   11. _^J_ Retorno do carro
   12. _^k_ Os caracteres após ^k é capturado no campo TDmxFieldRec.Default
   13. _\\k_ k minusculo tipo FldDbRadioButton.
   14. _\\K_ K maiúsculo tipo FldRadioButton.
   15. _^L_ Link para uma URL ou actionItens
   16. _^M_ Fim da linha
   17. _^N_ A sequência a seguir é o hint do campo.
   18. _^O_ Campo fldBLOb
   19. _^P_ Usado para controlar o flag do tipo de campo
   20. _^R_ Campo somente de leitura
   21. _^S_ Salte campo para o próximo campo de acesso normal
   22. _^T_ O campo é um botão de ação
   23. _^U_ Informar um limite superior campos do tipo byte. Faixa: [0..255]
   24. _^V_ Se o campo for numérico, preencha com '#0'(AccNormal) se for alfanumérico, preencha com ' ' AccNormal
   25. _^X_ Campo de BOOLEAN especial
   26. _^Z_ Zera se este campo está vazio

2. **Delimitadores de campos:**
   1. #0 = delimiter de campo técnico (não exibe)
   2. \ = exibe como um espaço
   3. | = exibe como**Tipos de campos:** uma linha vertical sólida (#179)

3. **Tipos de campos:**
   1. **Campo string com tamanho da string no byte 0:**
      1. **Const fldStr = 'S';**
         1. O caractere _S_ informa ao componente **TUiDmxScroller** que a sequência de caracteres _S_ após o caractere **"\\"** representa no buffer do formulário um tipo _ShortString_ que só aceita caracteres maiúsculas.
            1. **EXEMPLO**

                ```pascal

                    Resourcestring

                     ~Nome:    ~'\SSSSSSSSSSSSSSSSSSSS' //Campo com 20 caracteres maiúsculas
                     ~Endereço:~'\SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS' //Campo com 40 caracteres maiúsculas

                ```

      2. **Const fldstr_Lowcase = 's';**
         1. O caractere _s_ informa ao componente **TUiDmxScroller** que a sequência de caracteres _s_ após o caractere **"\\"** representa no buffer do formulário um tipo ShortString que só aceita caractere minúscula.
            1. **EXEMPLO**

                ```pascal

                    Resourcestring

                     ~Nome:    ~'\ssssssssssssssssssss' //Campo com 20 caracteres minúsculas 
                     ~Endereço:~'\ssssssssssssssssssssssssssssssssssssssss' //Campo com 40 caractere minúsculas

                ```

      3. **Const fldSTRNUM = '#'**
         1. O caractere _#_ usado na máscara do template e informa ao componente **TUiDmxScroller** que a sequência de caracteres _#_ após o caractere **"\\"** representa no buffer do formulário um tipo ShortString que só aceita caracteres numéricos.
            1. **EXEMPLO**

                  ```pascal
                     
                     Resourcestring

                      ~Telefone: ~\(##) # ####-#### //85 9 9702 4498
                      ~Cep:      ~\## #### ###

                  ```

   2. **Campo string com tamanho da string limitado pelo caractere _0 (zero)_ no fim da string.**
      1. **Const fldAnsiChar = 'C'**
         1. O caractere **c** usado na máscara do Template, informa ao componente **TUiDmxScroller** que a sequência de caracteres 'C' após o caractere **"\\"** representa no buffer do formulário um tipo AnsiString que só aceita caracteres maiúsculos.
            1. **EXEMPLO**

               ```pascal

                     Resourcestring

                  ~Nome:    ~'\CCCCCCCCCCCCCCCCCCCC' //Campo com 20 caracteres maiúsculas
                  ~Endereço:~'\CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC' //Campo com 40 caractere maiúsculas

               ```

      2. **Const fldAnsiChar_LowCase =  'c'**
         1. O caractere **c** usado na máscara do Template, informa ao componente **TUiDmxScroller** que a sequência de caracteres **c** após o caractere **"\\"** representa no buffer do formulário um tipo AnsiString que só aceita caractere minúsculo.
            1. **EXEMPLO**

               ```pascal

                  Resourcestring

                  ~Nome:    ~'\cccccccccccccccccccc' //Campo com 20 caracteres minúsculas
                  ~Endereço:~'\cccccccccccccccccccccccccccccccccccccccc' //Campo com 40 caractere minúsculas

               ```

      3. **Const fldAnsiCharNUM = '0'**
         1. Usado na máscara do Template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _0_ após o caractere **"\\"** representa no buffer do formulário um tipo AnsiString que só aceita caractere numérico [_'0'..'9']_.
            1. **EXEMPLO**

               ```pascal

                  Resourcestring

                     ~telefone :~\(00) 0 0000-0000' //85 9 9702 4498

               ```

      4. **Const fldAnsiCharVAL = 'N'**;  
         1. O caractere _N_ usado na máscara do template informa ao componente **TUiDmxScroller** que a sequência de caracteres _0_ após o caractere **"\\"** representa no buffer do formulário um tipo AnsiString  que só aceita caractere numérico _['0'..'9']_ com formatação dbase.
            1. **EXEMPLO**

               ```pascal

                  Resourcestring

                     '~telefone :~\(NN) N NNNN-NNNN' //85 9 9702 4498

               ```

   3. **Campos do tipo inteiro**
      1. **Const fldBYTE = 'B'**;
         1. O caractere _B_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _B_ após o caractere **"\\"** representa no buffer do formulário um tipo byte e só pode receber valor na faixa _[0..255]_.
            1. **EXEMPLO**

            ```pascal

                  Resourcestring

                  '~idade :~\BBB' //Os três dígitos estarão em um buffer de 1 byte;

            ```

      2. **Const fldSHORTINT =  'J'**;
         1. O caractere _J_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _J_ após o caractere **"\\"** representa no buffer do formulário um tipo byte e só pode receber valor na faixa _[-128 a 127]_, usado quando precisamos de um tipo byte com valores negativos.

            1. **EXEMPLO**

               ```pascal

                     Resourcestring

                     '~Tempo de vida ou de morte:~\JJJ' //Os três dígitos estarão em um buffer de 1 byte;

               ```

      3. **Const fldSmallWORD = 'W'**
            1. O caractere _W_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _W_ após o caractere **"\\"** representa no buffer do formulário um tipo word curto e só pode receber valor na faixa _[0 a 65535]_.
               1. **EXEMPLO**

                  ```pascal

                        Resourcestring

                        '~idade :~\WW,WWW' //Os cinco dígitos estarão em um buffer de 2 bytes;

                  ```

      4. **Const fldSmallInt = 'I'**;
         1. O caractere _I_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _I_ após o caractere **"\\"** representa no buffer do formulário um tipo Inteiro curto (2 bytes) e só pode receber valor na faixa _[-32.768 a 32.767]_.

            1. **EXEMPLO**

               ```pascal

                     Resourcestring

                     '~Tipo small int :~\II,III' //Os cinco dígitos estarão em um buffer de 2 bytes;

               ```

      5. **Const fldLONGINT = 'L'**;
         1. O caractere _L_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _L_ após o caractere **"\\"** representa no buffer do formulário um tipo Inteiro longo (4 bytes) e só pode receber valor na faixa _[ -2.147.483.648 a 2.147.483.647]_.
            1. **EXEMPLO**

                  ```pascal

                        Resourcestring

                        '~Tipo longint :~\LLL,LLL' //Os seis dígitos estarão em um buffer de 4 bytes;

                  ```

      6. **Const fldBoolean = 'X'**;
         1. O caractere _X_ usado na máscara do template, informa ao componente **TUiDmxScroller** que o campo é do tipo  byte e só pode ter dois valores.
               1. **NOTAS**
                  1. Valores possíveis:
                     1. 0 = False
                     2. 1 = True
                     3. A forma de editá-los deve ser com o componente checkbox.

               2. **EXEMPLO**

                     ```pascal

                        Resourcestring

                          '~Aceita os termos do contrato~\X ^Bfld_ceita_contrato^Aceita os termos do contrato?';   

                     ```

      7. **Const FldRadioButton = 'K'**; //Maiúscula
         1. O caractere _K_ (maiúsculo) usado na máscara do Template, , informa ao componente **TUiDmxScroller** que é um campo tipo TCluster e é representado no template por  um controle TRadioButton.
            1. Um Template pode conter vários campos do tipo cluster e o mesmo é identificado após a sequencia **\\Kx**, onde _x_ indica que a informação pertence ao campo _x_,
               1. **EXEMPLO**

                  ```pascal

                  Resourcestring  
                     ~ SEXO ~
                     ~  ~\Ka Masculino
                     ~  ~\Ka Feminino
                     ~  ~\Ka Indefinido
                     ~  ESTADO CIVIL
                     ~  ~\Kb Solteiro
                     ~  ~\Kb Casado
                     ~  ~\Kb Divorciado
                  
                  ```

            2. **NOTA**
               1. Os campos _cluster_ possuem o mesmo número do campo e na primeira ocorrência contém o nome do campo na lista _pDmxFieldRec_.

   4. **Campos do tipo Real**
      1. **fldExtended       = 'E'**;
         1. O caractere _E_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _E_ após o caractere **"\\"** representa no buffer do formulário um tipo Extended (10 bytes) e pode receber valores positivos e negativos.
            1. **EXEMPLO**

               ```pascal

                     Resourcestring

                     '~Patrimônio liquido do grupo :~\EEE,EEE,EEE,EEE.EE' //Os 14 dígitos estarão em um buffer de 10 bytes;

               ```

      2. **Const fldRealNum = 'R'**;
         1. O caractere _R_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _R_ após o caractere **"\\"** representa no buffer do formulário um tipo double (8 bytes) e pode receber valores positivos e negativos.
            1. **EXEMPLO**

               ```pascal

                     Resourcestring

                     '~         Patrimônio liquido :~\RRR,RRR,RRR.RR' //Os 11 dígitos estarão em um buffer de 8 bytes;

               ```
  
      3. **Const fldRealNum_Positivo = 'r'**;
         1. O caractere _r_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _r_ após o caractere **"\\"** representa no buffer do formulário um tipo double (8 bytes) e só pode receber valores positivos.
            1. **EXEMPLO**

               ```pascal

                     Resourcestring

                     '~Patrimônio liquido :~\RRR,RRR,RRR.RR' //Os 11 dígitos estarão em um buffer de 8 bytes;

               ```

      4. **Const fldReal4 = 'O'**;
         1. O caractere _O_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _O_ após o caractere **"\\"** representa no buffer do formulário um tipo single (4 bytes) e só pode receber valores positivos.
            1. **EXEMPLO**

               ```pascal

                     Resourcestring

                     '~Salário :~\OO,OOO.OO' //Os 7 dígitos estarão em um buffer de 4 bytes;

               ```

      5. **fldReal4Positivo  = 'o'**;
         1. O caractere _o_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _o_ após o caractere **"\\"** representa no buffer do formulário um tipo single (4 bytes) e pode receber valores positivos e negativos.
            1. **EXEMPLO**

               ```pascal

                     Resourcestring

                     '~Patrimônio liquido :~\oo,ooo.oo' //Os 7 dígitos estarão em um buffer de 4 bytes;

               ```
  
      6. **fldReal4P = 'P'**;
         1. O caractere _P_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _P_ após o caractere **"\\"** representa no buffer do formulário um tipo single (4 bytes) com a seguinte característica: Ao ler compo do arquivo o resultado é multiplicado por 100 e ao gravar é dividido 100 usado para campos relativos e pode conter valores positivos e negativos.
            1. **EXEMPLO**

               ```pascal

                     Resourcestring

                     '~Valor percentual :~\PPP.PP' //Os 5 dígitos estarão em um buffer de 4 bytes;

               ```

      7. **fldReal4PPositivo = 'p'**;
         1. O caractere _p_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _p_ após o caractere **"\\"** representa no buffer do formulário um tipo single (4 bytes) com a seguinte característica: Ao ler compo do arquivo o resultado é multiplicado por 100 e ao gravar é dividido 100 usado para campos relativos e só pode conter valores positivos.
            1. **EXEMPLO**

               ```pascal

                     Resourcestring

                     '~Valor percentual :~\ppp.pp' //Os 5 dígitos estarão em um buffer de 4 bytes;

               ```
