<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

<script type="application/x-javascript" src="/js/mermaid.min.js"></script>

# Projeto para criar aplicações clientes dentro de um formulário LCL do servidor.

- [Projeto para criar aplicações clientes dentro de um formulário LCL do servidor.](#projeto-para-criar-aplicações-clientes-dentro-de-um-formulário-lcl-do-servidor)
  - [Introdução](#introdução)
  - [**Objetivo**.](#objetivo)
  - [Diagrama do projeto.](#diagrama-do-projeto)
  - [Unit DataModules](#unit-datamodules)

## Introdução

- O projeto /\ar/\carai visa desenvolver um gerador de aplicações clientes que interagem com serviços de backend, utilizando um framework flexível e modular. Com a crescente demanda por soluções que integrem diferentes tecnologias e plataformas, este projeto se propõe a facilitar a criação de aplicações clientes em diversas estruturas de framework, como Free Pascal - LCL, HTML dinâmico, Vue.js, AngularJS e ReactJS.

- A principal motivação por trás deste projeto é a necessidade de simplificar o processo de desenvolvimento de aplicações que se conectam a serviços de backend, permitindo que desenvolvedores criem rapidamente interfaces de usuário que se comunicam de forma eficiente com APIs. O gerador de aplicações clientes oferece uma interface intuitiva para configuração e personalização, permitindo que os usuários definam parâmetros essenciais, como o protocolo de comunicação, endereço do servidor, porta, e o nome do recurso (WebModule) que será utilizado.

- Atualmente, o projeto já implementou suporte para Free Pascal - LCL e HTML dinâmico, enquanto as implementações para Vue.js, AngularJS e ReactJS estão previstas para futuras versões, dependendo da demanda dos usuários. A arquitetura do sistema foi projetada para ser extensível, permitindo que novos frameworks sejam adicionados conforme necessário.

- Além disso, o projeto inclui um módulo de gerenciamento de dados que facilita a criação e edição de formulários, bem como o mapeamento de campos de banco de dados. Com um foco na usabilidade e na eficiência, o sistema é capaz de gerar automaticamente a estrutura de diretórios e arquivos necessários para cada tipo de aplicação cliente, garantindo que os desenvolvedores possam se concentrar na lógica de negócios e na experiência do usuário.

- Em resumo, o projeto /\ar/\carai representa uma solução inovadora para o desenvolvimento de aplicações clientes, promovendo a integração entre diferentes tecnologias e simplificando o processo de criação de interfaces de usuário dinâmicas e responsivas.

## **Objetivo**.

- Desenvolver aplicativos clientes _http_ ou _https_ para as seguintes estruturas de framework:  
  - _FreePascal - LCL_  
    - Implementado.  
  - _JavaScript_.  
    - Implementado parcialmente.  
  - _HTML dinâmico_.  
    - Implementado.  
  - _VueJs_.  
    - Não implementado.  
  - _Angularjs_.  
    - Não implementado.  
  - _Reactjs_.  
    - Não implementado.

- Notas:
  - Os frameworks para web browser não implementados na versão de lançamentos serão implementados caso exista demanda por parte dos usuários, visto que as aplicações cliente LCL e _HTML dinâmico_ atendam as necessidades até o momento.  
  - Internamente, o projeto já calcula as pastas nas quais as futuras implementações clientes serão criadas.

## Diagrama do projeto.

Esse diagrama representa a arquitetura do sistema, destacando a interação entre o usuário, a aplicação cliente, o servidor, o banco de dados e o módulo de gerenciamento de dados, além de incluir os componentes específicos da aplicação cliente (Free Pascal - LCL e HTML Dinâmico).

<pre><code class="language-mermaid"><div class="mermaid">

graph TD;

    A[Form LCL no Servidor] --> B[App Criar Clientes]

    subgraph Aplicações Clientes
        B1[FreePascal - LCL]
        B3[HTML Dinâmico]
    end

    B --> B1
    B --> B3
    B1 --> F[API RESTful]
    B3 --> F[API RESTful]
    F --> G[WebModule]
    G --> D[Fonte de dados-TDataSource]

</pre>

- **Descrição do Diagrama.**
  - _Servidor-Form LCL_: Formulário do servidor que aciona a aplicação para criar clientes.
  - _App Criar Clientes_: A aplicação que permite a criação de clientes.
    - _Aplicações Cliente_: Um subgrupo que inclui:
      - _FreePascal - LCL_: Módulo http RestFul usando formulários LCL na aplicação cliente.
      - _HTML Dinâmico_: Módulo http/https RestFul escrito em HTML e JavaScript para criar formulários web na aplicação cliente.
  - _API RESTful_: A interface que conecta as aplicações cliente ao servidor.
  - _WebModule_: O módulo que gerencia as requisições da API.
  - _Fonte de dados (TDataSource)_: Onde os dados dos clientes são armazenados.
    - Notas.
      - Cada webModule do servidor que não seja informada uma fonte de dados em particular, o sistema cria uma fonte de dados no formato json e usa o nome da tabela com extensão json.

## Unit DataModules

- **Objetivo**.
  - Unit usada para criar as regras na aplicação e definir o layout do formulário de entrada, bem como mapear o banco de dados usado pelo formulário.
    - Nota:
      - A tabela usada neste projeto é um arquivo json com o nome da aplicação cliente, no qual armazena todos os parâmetros usados para criar os formulários gerados.

- **Classe TCreateClientes**  
  - **Objetivo**.  
    - Contêm os parâmetros necessários para criar as aplicações clientes, bem como a definição da tela e do banco de dados usados para salvar os parâmetros para cada aplicação configurada.

  - **Evento DmxScroller_Form1AddTemplate (Definição do formulário)**:
    - **Objetivo.**
      - Formulário usado para edição dos recursos usados para criar os formulários, bem como mapeamento dos campos do banco de dados.
        - Nota:06:28
          - Os dados deste template serão armazenados no arquivo com nome do DataModule com a extensão (.json).  

    - **Descrição do formulário.**

      - **Painel dos botões.**
        - **Botões de ações.**
          - Novo.
            - _CmNewRecord_ : Botão de ação coloca o registro no modo de edição para adicionar registro.
            - Tags:
              - _ChEA_ : A sequência a seguir é o nome da ação.
                - Exemplo de uso:
                  - _ChEA_+_CmNewRecord_+➕.
            - Eventos:
              - _DmxScroller_Form1.DoOnNewRecord_;

          - Gravar.
            - _CmUpdateRecord_ : Botão de ação para adicionar o registro se o estado atual estiver no modo insert ou gravar as alterações se estiver no modo update.
            - Tags:
              - _ChEA_ : A sequência a seguir é o nome da ação.
                - Exemplo de uso:
                  - _ChEA_+_CmUpdateRecord_+✔️.
            - Eventos:
              - _CmUpdateRecordExecute_.
                - _DmxScroller_Form1.UpdateRec_;

              - _DmxScroller_Form1BeforeInsert_
                - Neste momento, o sistema deve executar o módulo para criar a aplicação cliente.
                - Nota:
                  - Caso ocorra exceção, este evento deve retornar false.

              - _DmxScroller_Form1BeforeUpdate_
                - Caso o registro seja alterado, a aplicação atual deve ser excluída e criada outra com os novos parâmetros.
                  - Nota:
                    - Caso ocorra exceção, este evento deve retornar false.

          - Localizar.
            - _CmLocate_ : Botão de ação localiza o registro para edição.
            - Tags:
              - _ChEA_ : A sequência a seguir é o nome da ação.
                - Exemplo de uso:
                  - _ChEA_+_CmLocate_+🔍.
            - Eventos:
              - _CmLocateExecute_.
                - _if Locate()= mrNo Then TMi_rtl.ShowMessage('Registro não localizado');_;
              - Notas:
                - Pesquisa na lista de todos os _WebModules_ gerados por tipo de cliente.

          - Excluir.
            - _CmDeleteRecord_ : Botão de ação coloca o registro no modo de edição para adicionar registro.
            - Tags:
              - _ChEA_ : A sequência a seguir é o nome da ação.
                - Exemplo de uso:
                  - _ChEA_+_CmDeleteRecord_+➖.
            - Eventos:
              - _CmDeleteRecordExecute_
                - DmxScroller_Form1.DeleteRec;

              - _DmxScroller_Form1BeforeInsert_
                - Neste momento, o sistema deve deletar o módulo cliente gerado antes de excluir o registro.
                - Notas:
                  - Caso ocorra exceção, este evento deve retornar false.

          - Cancelar.
            - _Cancelar_ : Botão de ação coloca o registro no modo de edição para adicionar registro.
            - Tags:
              - _ChEA_ : A sequência a seguir é o nome da ação.
                - Exemplo de uso:
                  - _ChEA_+_Cancelar_+❌.
            - Eventos:
              - _CmCancelExecute_
                - _DmxScroller_Form1.Cancel;_

        - **Botões de navegação.**
          - Primeiro registro.
            - _CmGoBofExecute_ : Botão de ação para posicionar o dataset no primeiro registro.
            - Tags:
              - _ChEA_ : A sequência a seguir é o nome da ação.
                - Exemplo de uso:
                  - _ChEA_+_CmGoBofExecute_+⬅️ .
            - Eventos:
              - _DmxScroller_Form1.FirstRec;_;

          - Próximo registro.
            - _CmNextRecord_ : Botão de ação coloca o registro no modo de edição para adicionar registro.
            - Tags:
              - _ChEA_ : A sequência a seguir é o nome da ação.
                - Exemplo de uso:
                  - _ChEA_+_CmNextRecord_+➡️.
            - Eventos:
              - _CmNextRecordExecute_.
                - _DmxScroller_Form1.NextRec;_;

          - Registro anterior.
            - _CmPrevRecord_ : Botão de ação para posicionar no registro anterior.
            - Tags:
              - _ChEA_ : A sequência a seguir é o nome da ação.
                - Exemplo de uso:
                  - _ChEA_+_CmPrevRecord_+⬅️.
            - Eventos:
              - _CmPrevRecordExecute_.
                - _DmxScroller_Form1.PrevRec;_;

          - Último Registro.
            - _CmGoEof_ : Botão de ação coloca o registro no modo de edição para adicionar registro.
            - Tags:
              - _ChEA_ : A sequência a seguir é o nome da ação.
                - Exemplo de uso:
                  - _ChEA_+_CmGoEof~_+🔄.
            - Eventos:
              - _CmGoEofExecute_
                - _DmxScroller_Form1.LastRec;_

          - Atualizar.
            - _CmRefresh_ : Botão de ação para cancelar e ler o registro atual do arquivo.
            - Tags:
              - _ChEA_ : A sequência a seguir é o nome da ação.
                - Exemplo de uso:
                  - _ChEA_+_CmRefresh_+🔄.
            - Eventos:
              - _CmRefreshExecute_
                - _DmxScroller_Form1.Refresh;_

        - **Dados de acesso ao serviço**:
          - Protocolo do serviço no servidor:
            - _protocol_: Nome do campo.
              - Valores Possíveis
                - http.
                - https.
            - Eventos.
              - _OnCalcFields_.
                - Calcula a URL do serviço.

          - Endereço IP ou Nome do Host:
            - _Host_ : Nome do campo.

          - Número da porta do serviço no servidor.
            - _Port_ : Nome do campo.

          - Nome do recurso (_TMi_rtl_web_module_) do servidor:
            - _TMi_rtl_web_module_ : Nome do campo.
            - Eventos.
              - _OnCalcFields_.
                - Calcula a URL do serviço.
            - Notas:
              - O nome do _webModule_ deve ser passado como parâmetro ao executar o formulário _TCreateclientesForm_.

          - Nome da URL do serviço
            - _URL_ : Nome do campo.
            - Tag
              - CharDefaultExpression+'protocol'+``://``+'Host'+``/``+'TMi_rtl_web_module'.

      - **Parâmetros para criar aplicações clientes.**
        - _Número sequencial_:  
          - _id_ : Nome do campo;
          - Tags:
            - _ChFN_:
              - Indica que a próxima sequência é o nome do campo.
            - _CharAccSkip_:
              - Ao pressionar a tecla tab, o campo não é selecionado.
            - _CharAccReadOnly_:
              - Indica que o campo é somente para leitura.
            - _CharPfInKeyPrimary_:
              - Indica que o campo é um campo de chave primária. É usado na cláusula WHERE de uma instrução de atualização.
            - _CharPfInKeyPrimaryAutoIncrement_:
              - Indica que o campo é um campo autoincremental. É usado em uma instrução de atualização.
            - _ChH_:
              - É usado para documentar o campo. Indica que todo o texto até o próximo caractere de controle será o conteúdo do campo HelpCtx_Hint.

        - _Nome da pasta root onde se criarão as aplicações clientes_:
          - _PathRoot_: Nome do Campo.
          - _CmLocatePathRoot_ : Botão de ação para selecionar pasta.
          - Tags:
            - _ChEA_ : A sequência a seguir é o nome da ação. A mesma deve ser implementada no formulário LCL.
              - Exemplo de uso:
                - _ChEA_+_CmLocatePathRoot_+🔍.
          - Eventos.
            - _OnEnterField_.
              - Seleciona a pasta root onde a aplicação será criada.
          - Obs.: O padrão da pasta root é a pasta do executável da aplicação servidora.

        - _Tipo de aplicação_.  
          - _typApp_ : Nome do campo.
            - Valores possíveis.
              1. App LCL : sim.
              2. App Javascript: não.
              3. App Dynamic_html:sim.  
              4. App VueJS: não.
              5. App AngularJS: não.
              6. App ReactJS: não.

            - Eventos:
              - _OnCalcFields_
                - Calcular o nome da pasta destino da aplicação.

        - _Nome da subpasta da aplicação cliente usada para gerar a aplicação_.  
          - _PathClient_: Nome do Campo
          - Tags :
            - _CharAccReadOnly_:
              - Indica que o campo é somente para leitura.

          - **Exemplo de árvore gerada**:  

            ```txt  
              .                  
              ├── lcl  
              │   └── templates  
              │        ├── mi.rtl.web.module.dfm
              │        ├── mi.rtl.web.module.pas                        
              │        ├── mi.rtl.web.module.form.dfm                        
              │        └── mi.rtl.web.module.form.pas
              ├── dynamic_html
              │   ├── css  
              │   │   ├── color_tons_amarelo.css  
              │   │   ├── color_tons_dark.css  
              │   │   ├── color_tons_de_azul_ceu.css  
              │   │   ├── color_tons_de_cinza.css  
              │   │   ├── color_tons_de_dark_claro.css  
              │   │   ├── color_tons_de_lilas_claro.css  
              │   │   ├── color_tons_de_verde_claro.css                  
              │   │   ├── MiEditForm.css                                                  
              │   │   └── MiUiDmxScroller.css  
              │   ├── js  
              │   │   ├── MiMessageBox.js  
              │   │   ├── MiThemeDialog.js  
              │   │   ├── MiConsts.js  
              │   │   │   └── MiMethods.js                  
              │   │   │       ├── MiUiDmxScroller.js                 
              │   │   │       │   ├── MiUiDmxScrollerForm.js  
              │   │   │       │   ├── MiUiDmxScrollerForm.MiAbstractDialogs.js                  
              │   │   │       │   └── MiUiDmxScrollerForm.MiDialogs.js                  
              │   │   │       ├── MiDates.js  
              │   │   │       ├── MiMaskEdit.js  
              │   │   │       └── MiEditForm.js 
              │   ├── templates  
              │   │   └──  MiEditForm.html  
              │   └── Tmi_rtl_web_module.form.html  
              
            ```  

        - _Nome do arquivo destino do código gerado_.
          - _fileNameResult_ : Nome do campo.
          - Tags :
            - _CharAccReadOnly_:
              - Indica que o campo é somente para leitura.

          - Notas:
            - O nome do arquivo destino será o mesmo nome do WebModule server com a extensão compatível com a aplicação destino.
              - Exemplo:  
                    - Módulo servidor:  
                      - Classe **Tmi_rtl_web_module** representa um serviço do servidor.
                        - O arquivo cliente a ser gerado para o módulo servidor **Tmi_rtl_web_module** é:  
                          - **Tmi_rtl_web_module.pas** se app FreePascal - LCL.
                          - **Tmi_rtl_web_module.js** se app javascript.
                          - **Tmi_rtl_web_module.html** se app HTML dinâmico.  
                          - **Tmi_rtl_web_module.vue** se App VueJS.  
                          - **Tmi_rtl_web_module** App AngularJS.
                            - Tmi_rtl_web_module.module.ts: Configuração do módulo principal da aplicação.
                            - Tmi_rtl_web_module.component.ts: Componente raiz da aplicação.
                            - Tmi_rtl_web_module.component.html: Template do componente raiz.
                            - Tmi_rtl_web_module.component.js: O transpilador Ângula gera o javascript a partir do Typescript
                            - Tmi_rtl_web_module.service.ts: Serviço para fazer chamadas HTTP para a API RESTful.
                          - **Tmi_rtl_web_module.jsx** App ReactJS.  
            - A versão de lançamento do projeto maricarai vai gerar aplicações clientes somente para LCL e HTML dinâmico, visto que as mesmas atendem todas as necessidades, porém preparei o projeto para que no futuro alguém interessado queira implementar destinos para os frameworks acima.

    - **Desenho do formulário**

      - **Evento: DmxScroller_Form1AddTemplate**.  

        ```text

          ~➕ &Novo     ~^TCmNewRecord~✔️ &Gravar   ~^TCmUpdateRecord~🔍 &Pesquisar~^TCmLocate~➖ &Excluir  ~^TCmDeleteRecord~❌ &Cancelar ~^TcmCancel
          ~⬅️ P&rimeiro ~^TCmGoBof~➡️ Pró&ximo  ~^TCmNextRecord~⬅️ &Anterior ~^TCmPrevRecord~➡️ Ú&ltimo   ~^TCmGoEof~🔄 A&tualizar~^TCmRefresh

          '~~'
          '~  DADOS DE ACESSO AO SERVIÇO~'
          '~ Protocolo:~\sssssssssss'+ChFN+'protocol'+ChDfC+'http'+CreateOptions(NewSitem('http',
                                                                                 NewSItem('https',
                                                                                 nil)))+chH+'Procolo do servidor'
          '~      Host:~\ssssssssssssssssssssssssssssss'+ChFN+'host'+ChDfC+'localhost'+chH+'Endereço IP ou Nome do Host'+
              '~ Porta:~\####'+ChFN+'port'+chH+'Número da porta do serviço no servidor~ TMi_rtl_web_module: ~\ssssssssssssssssssssssssssssss'+chFN+'TMi_rtl_web_module'+ChDfC+'TMi_rtl_web_module'//+chH+'Nome do recurso no servidor.', comentei o help pq a linha não pode ser mais de 255 char

          '~      URL: ~\sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss`sssssssssssssssssssssssssssssssssssssssssssss'+
              ChFN+'url'+ChDfE+'protocol + ''://'' + host + '':'' + Port + ''/'' + TMi_rtl_web_module'//+ChH+'Endereço usado pelo cliente para comunicar-se com o servidor.'

          '~    PARÂMETROS PARA CRIAR APLICAÇÕES CLIENTES~'
          '~               ID:                    ~\LLLLLL'+ChFN+'id'+ChAS+ChARO+CharPfInKeyPrimary+CharPfInKeyPrimaryAutoIncrement+ChH+'Número sequêncial'
          '~      Selecione a aplicação destino:  ~\'+CreateEnumField(TRUE, accNormal, 0,
                                                          NewSItem('app LCL : sim',
                                                          NewSItem('app javascript : não',
                                                          NewSItem('app dynamic_html : sim',
                                                          NewSItem('app vuejs : não',
                                                          NewSItem('app angularjs : não',
                                                          NewSItem('app reactjs : não',
                                                          nil)))))))+
                                                          ChFN+
                                                          'typAppClient'+
                                                          ChH+
                                                          'Tipo de aplicação cliente a ser gerada.'


          '~      Nome da pasta raiz dos clientes:~\sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss`sssssssssssssssssssssssssssssssssssssssssssss'+
              ChFN+'pathRoot'+ChDfC+'./clientes'+ChH+'Usado como raiz da pasta cliente.'+commandIcon('pathRoot','cmSelectDirectoryDialog')

          '~       Nome do arquivo destino:       ~\sssssssssssssssssssssssssssss'+
              ChFN+'fileNameResult'+ChARO+ChDfE+'TMi_rtl_web_module'+ChH+'Nome do arquivo de cliente a ser gerado na pasta da aplicação cliente. '
          '~~'
          command('    ~Gerar formulário~    ','cmBuildCustomerFormFromTemplate')
          '~~'




        ```

    - **TCreateClientes.BuildCustomerFormFromTemplate(aEnClientsApplication:TEnClientsApplication);**
      - _Objetivo:_
        - Método usado para criar aplicações clientes do formulário passado pelo método TCreateClientes.SetFormServer.

      - _Parâmetros passados para o gerador de aplicação cliente:_
        - Formulário com as coordenadas dos controles.
          - _FormServer: TForm;
            - _Mi_lcl_ui_ds_Form: TMi_lcl_ui_ds_Form;
            - _Mi_rtl_web_module: TMi_rtl_WebModule_base;
            - Obs.:
              - Necessários para criar HTML dinâmico, visto que o mesmo usa valor absoluto dos controles da visão no caso de aplicação do tipo _en_app_dynamic_html_.

        - _PathRoot_: Nome do Campo.
          - Usado para identificar a pasta html que o servidor está servindo.

        - _typApp_ : Nome do campo.
          - Usado para selecionar o tipo de aplicação.

        - _PathClient_: Nome do Campo
          - Pasta da aplicação cliente.

        - _fileNameResult_ : Nome do campo.
          - Nome do arquivo a ser gerado, onde a extensão é obtida pelo parâmetro _typApp_.

      - _Procedimentos que executam a classe que gera os formulários clientes_.
        - _Procedure Create_app_cliente_lcl()_;
          - ....
        - _Procedure Create_app_dynamic_html()_;
          - Classe usada para criar a aplicação:
            - TMi_web_js_Form.


<!-- markdownlint-disable-next-line -->
</main>

[🔝🔝](#topo "Retorna ao topo")
