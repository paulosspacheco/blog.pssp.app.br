# SINTAXE DE RECURSOS DO TEMPLATE MARICARAI

1. **Códigos de Controles**
   1. ^A = Zera todos os campos
   2. '~'  = switch tString-literals on/off
   3. ^B = Indica que os caracteres seguintes contem o nome do campo
   4. ^ = A sequência a seguir é o hint do campo.
   5. ^C = O campo corrente possuem uma lista de opções do mesmo tipo.
   6. ^D = use o próximo char como um delimiter de campo
   7. ^E = Campos do tipo enumerado.
   8. ^F = Usado para criar restrições e relacionamentos
   9. ^G = Usada para concatenar duas listas do tipo PSItem.
   10. ^H = Campo escondido
   11. ^I = link to chain of TSItem Templates
   12. ^J = Retorno do carro
   13. ^k = Os caracteres após ^k é capturado no campo TDmxFieldRec.Default
   14. \K = K maiúsculo tipo FldRadioButton.
   15. \k = k minusculo tipo FldDbRadioButton.
   16. ^P = Usado para controlar o flag do tipo de campo
   17. ^R = campo somente de leitura
   18. ^S = " salte " campo (cursor saltar  em cima disto)
   19. ^U = o limite superior do campo (Somente 1 a 255)
   20. ^V = Em caso de omissão use o tString apos ^V
   21. ^X = campo de BOOLEAN especial
   22. ^Z = zera se este campo está vazio
   23. ^L = Link para uma URL ou actionItens
   24. ^U = Informar um limite superior [para](^U) campos do tipo byte.

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

      5. **Const fldBYTE = 'B'**;
         1. O caractere _B_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _B_ após o caractere **"\\"** representa no buffer do formulário um tipo byte e só pode receber valor na faixa _[0..255]_.
            1. **EXEMPLO**

            ```pascal

                Resourcestring

                  '~idade :~\BBB' //Os três dígitos estarão em um buffer de 1 byte;

            ```

      6. **Const fldSHORTINT =  'J'**;
         1. O caractere _J_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _J_ após o caractere **"\\"** representa no buffer do formulário um tipo byte e só pode receber valor na faixa _[-128 a 127]_, usado quando precisamos de um tipo byte com valores negativos.

            1. **EXEMPLO**

                  ```pascal
      
                      Resourcestring

                        '~Tempo de vida ou de morte:~\JJJ' //Os três dígitos estarão em um buffer de 1 byte;

                  ```

      7. **Const fldSmallWORD = 'W'**
            1. O caractere _W_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _W_ após o caractere **"\\"** representa no buffer do formulário um tipo word curto e só pode receber valor na faixa _[0 a 65535]_.

            1. **EXEMPLO**

                  ```pascal
      
                      Resourcestring

                        '~idade :~\WW,WWW' //Os cinco dígitos estarão em um buffer de 2 bytes;

                  ```

      8. **Const fldSmallInt = 'I'**;
         1. O caractere _I_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _I_ após o caractere **"\\"** representa no buffer do formulário um tipo Inteiro curto (2 bytes) e só pode receber valor na faixa _[-32.768 a 32.767]_.

            1. **EXEMPLO**

                  ```pascal
      
                      Resourcestring

                        '~Tipo small int :~\II,III' //Os cinco dígitos estarão em um buffer de 2 bytes;

                  ```

      9. **Const fldLONGINT = 'L'**;
         1. O caractere _L_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _L_ após o caractere **"\\"** representa no buffer do formulário um tipo Inteiro longo (4 bytes) e só pode receber valor na faixa _[ -2.147.483.648 a 2.147.483.647]_.

            1. **EXEMPLO**

                  ```pascal
      
                      Resourcestring

                        '~Tipo longint :~\LLL,LLL' //Os seis dígitos estarão em um buffer de 4 bytes;

                  ```

      10. **Const fldRealNum = 'R'**;
          1. O caractere _R_ usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _R_ após o caractere **"\\"** representa no buffer do formulário um tipo double (8 bytes) e pode receber valores positivos e negativos.
             1. **EXEMPLO**

                  ```pascal
      
                      Resourcestring

                        '~Patrimônio liquido :~\RRR,RRR,RRR.RR' //Os 11 dígitos estarão em um buffer de 8 bytes;

                  ```
  
      11. **Const fldRealNum_Positivo = 'r'**;
          1. O caractere _r usado na máscara do template, informa ao componente **TUiDmxScroller** que a sequência de caracteres _r_ após o caractere **"\\"** representa no buffer do formulário um tipo double (8 bytes) e só pode receber valores positivos.
             1. **EXEMPLO**

                  ```pascal
      
                      Resourcestring

                        '~Patrimônio liquido :~\RRR,RRR,RRR.RR' //Os 11 dígitos estarão em um buffer de 8 bytes;

                  ```

      12. **Const fldBoolean = 'X'**;
          1. O caractere _X_ usado na máscara do Template, informa ao componente **TUiDmxScroller** que o campo é do tipo  byte e só pode ter dois valores.
             1. **NOTA**
                1. Valores possíveis:
                   1. 0 - False; não
                   2. 1 = True;  sim
             2. A forma de editá-los deve ser com o componente checkbox.

          2. **EXEMPLO**

               ```pascal

                  Resourcestring

                    '~Aceita os termos do contrato~\X ^Bfld_ceita_contrato^Aceita os termos do contrato?';   

               ```

      13. **Const FldRadioButton = 'K'**; //Maiúscula
          1. O caractere _K_ (maiúsculo) usado na máscara do Template, , informa ao componente **TUiDmxScroller** que é um campo tipo TCluster e é representado no template por  um controle TRadioButton
             1. **NOTAS**
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
