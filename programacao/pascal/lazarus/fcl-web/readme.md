# README.TXT do projeto fcl-web

- Este é o LEIA-ME do diretório de componentes fpWeb.
Contém 2 pacotes:

- O pacote LazWeb implementa a funcionalidade IDE para FCL-Web. Deve funcionar com a versão 2.4.x do FPC.

- O pacote LazWebExtra implementa mais projetos e componentes IDE,
que estão disponíveis apenas a partir da versão 2.5.1 do compilador. À medida que esses itens forem disponibilizados em uma versão estável, o pacote será
fundidas em **Lazweb**.

- Ambos os pacotes registram uma série de assistentes de projeto e alguns componentes.

- Os seguintes tipos de projeto são registrados no pacote **lazweb**:

  - **Aplicação CGI**
  - **Aplicativo Apache (um módulo apache)**
  - **Aplicativo CGI personalizado ("bare bones" cgi, sem módulos da web)**
  - **Aplicativo FastCGI**
  - **Aplicativo FastCGI personalizado (fastcgi "bare bones", sem módulos da web)**

- Para cada um desses projetos, um **Módulo Web** é criado por padrão.

- Os seguintes módulos web podem ser criados:

  - **WebDataModule** (TFPWebModule)
    - Este é um módulo de manipulação de solicitação HTTP de uso geral, que pode ser usado para lidar com qualquer solicitação HTTP para qualquer tipo de dados.

  - **HTMLModule** (TFPHTMLModule)
    - Este é um módulo específico de tratamento de requisições HTTP, voltado especialmente em produzir uma resposta HTML.

- Os seguintes componentes são registrados:
  - **THTMLDatasetContentProducer**
    - Cria uma tabela HTML baseada em um descendente TDataset;

  - **THTMLSelectProducer**
    - Cria um elemento < SELECT > baseado em um TStringList.

  - **THTMLDatasetSelectProducer**
    - Cria um elemento < SELECT > com base em um conjunto de dados (uma combinação de pesquisa)

  - **THTMLEntityProducer**
    - Cria um documento HTML ENTITY

  - **THTMLPageProducer**
    - Cria uma página HTML usando um manipulador de eventos.

  - **THTMLDataSetFormShowProducer**
    - Cria um < FORM > que permite mostrar um único registro de um conjunto de dados.

  - **THTMLDataSetFormEditProducer**
    - Cria um < FORM > que permite editar um único registro de um conjunto de dados.

  - **THTMLDataSetFormGridProducer**
    - Cria uma série de formulários.

- O pacote **lazwebextra** registra adicionalmente os seguintes módulos da web e componentes:

  - **Módulo Web Data Provider** (TFPWebProviderDataModule)
    - Usado para converter **TDataset** em uma variedade de formatos e para lidar com atualizações dos dados. (**ExtJS** **JSON** e **XML** atualmente)

  - **Módulo de manipulação de solicitação JSON-RPC** (TJSONRPCModule)
    - Usado para lidar com solicitações JSON-RPC.

  - **Tratamento Ext.Direct de solicitações JSON-RPC** (TExtDirectModule)
    - Lida com a variante Ext.Direct de JSON-RPC.

- Os seguintes componentes são registrados:

  - **TFPWebDataProvider**
    - Lida com operações CRUD (criar/ler/atualizar/excluir) em um TDataset

  - **TSQLDBWebDataProvider**
    - Lida com operações CRUD (criar/ler/atualizar/excluir) em um TSQLConnection.   (As instruções SQL INSERT/SELECT/UPDATE/DELETE podem ser especificadas).

  - **TWebdataInputAdaptor**
    - Transforma a solicitação HTTP para um formato que TFPWebDataProvider entende, usando manipuladores de eventos.

  - **TExtJSJSonWebdataInputAdaptor**
    - Descendente TWebdataInputAdaptor que transforma um ExtJS Datastore Solicitação JSON para entrada utilizável por TFPWebDataProvider.

  - **TEXTJSJSONDataFormatter**
    - Gera JSON conforme esperado pelos armazenamentos de dados ExtJS de todas as operações em um Instância TFPWebDataProvider.

  - **TEXTJSXMLWebdataInputAdaptor**
    - Descendente TWebdataInputAdaptor que transforma um ExtJS Datastore Solicitação XML para entrada utilizável por **TFPWebDataProvider**.

  - **TEXTJSXMLDataFormatter**,
    - Gera XML conforme esperado pelos armazenamentos de dados ExtJS de todas as operações em um Instância **TFPWebDataProvider**.

  - **TJSONRPCHandler**
    - Componente que lida com uma única solicitação JSON-RPC.

  - **TJSONRPCDispatcher**
    - Componente que despacha um lote de solicitações JSON-RPC para Instâncias **JSONRPCHandler**.

  - TSessionJSONRPCDispatcher
    - Componente que despacha um lote de solicitações **JSON-RPC** para instâncias **TJSONRPCHandler** e que reconhecem a sessão. (sessão no fcl-web sentido da palavra)

  - TJSONRPCContentProducer
    - Componente que manipula a entrada de uma solicitação HTTP, passa-a para um    TJSONRPCDispatcher e formata o resultado.

  - **TEXTDirectDispatcher**
    - ??

  - **TEXTDirectContentProducer**
    - Descendentes de **TJSONRPCDispatcher** e **TJSONRPCContentProducer** que entenda a variante Ext.Direct do extJS.

- Projetos de demonstração estão disponíveis no subdiretório demo e demos adicionais
podem ser encontrados no diretório fcl-web/examples do FPC.

- Leia-me adicionais com informações sobre os componentes estão em fcl-web/src/*
diretórios.

- Autor: Michael Van Canneyt & Joost van der Sluis