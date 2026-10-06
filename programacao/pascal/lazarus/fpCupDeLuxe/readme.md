<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Configurações Avançadas do FPCupDeluxe

Este documento descreve cada opção disponível na janela de configurações avançadas do FPCupDeluxe, com base na tradução fornecida. Para cada opção (campos de texto, caixas de seleção, botões de rádio, etc.), explico o que ela faz e quando é recomendado marcá-la ou usá-la. As explicações são baseadas no funcionamento típico da ferramenta, que é um instalador para o Free Pascal Compiler (FPC) e o Lazarus IDE, permitindo instalações personalizadas, incluindo cross-compilers. Algumas opções são autoexplicativas, mas forneço contextos práticos de uso.

## Configurações de Proxy

Essas são campos de texto para configurar um proxy HTTP, útil em redes corporativas ou restritas.

- **URL do proxy HTTP**: Endereço URL do servidor proxy.  
  Quando usar: Se sua conexão à internet requer um proxy para downloads (ex.: repositórios Git/SVN). Deixe vazio se não precisar.

- **Porta do proxy HTTP**: Número da porta do proxy (ex.: 8080).  
  Quando usar: Sempre que definir uma URL de proxy; use a porta padrão ou especificada pela sua rede.

- **Nome de usuário do proxy HTTP**: Nome de usuário para autenticação no proxy.  
  Quando usar: Se o proxy exigir autenticação básica.

- **Senha do proxy HTTP**: Senha para autenticação no proxy.  
  Quando usar: Junto com o nome de usuário, para proxies autenticados.

## Substituição de Opções

- **Campo de texto**: Permite sobrescrever opções padrão do compilador ou make (ex.: -O3 para otimização).  
  Quando usar: Quando você precisa adicionar flags personalizadas ao processo de build, como opções de depuração ou otimização específicas. Útil para experimentos avançados.

## Branch e Revisão

Esses campos permitem especificar versões exatas do FPC e Lazarus a partir de repositórios (Git/SVN).

- **Branch do FPC**: Nome do branch do FPC (ex.: "trunk" para desenvolvimento, "fixes" para estável).  
  Quando usar: Para instalar uma versão não padrão; marque/use se quiser a última versão de desenvolvimento ou uma branch específica em vez da default.

- **Hashtag/Tag do FPC**: Hash ou tag específico de commit/versão do FPC.  
  Quando usar: Para fixar uma revisão exata, útil em testes reproduzíveis ou para evitar bugs recentes.

- **Branch do Laz.**: Nome do branch do Lazarus (similar ao FPC).  
  Quando usar: Mesmo que acima, para alinhar com o FPC ou testar branches específicas do Lazarus.

- **Hashtag/Tag do Laz.**: Hash ou tag do Lazarus.  
  Quando usar: Para fixar uma versão exata do Lazarus.

## Opções do Laz.

- **Campo de texto**: Opções personalizadas para o Lazarus.  
  Quando usar: Para adicionar flags específicas ao build do Lazarus, como opções de depuração.

- **Depurar (caixa de seleção)**: Ativa modo de depuração para o Lazarus.  
  Quando marcar: Se você quiser compilar o Lazarus com símbolos de depuração para troubleshooting.

## Configurações Diversas (Miscellaneous Settings)

Essas são principalmente caixas de seleção para personalizar o processo de instalação e build.

- **Get FPC/Laz repositories**: Baixa os repositórios Git/SVN do FPC e Lazarus.  
  Quando marcar: Sempre que quiser construir a partir das fontes mais recentes; desmarque se preferir usar fontes locais ou pré-compiladas.

- **Include LCL with cross-compiler**: Inclui a Lazarus Component Library (LCL) no cross-compiler.  
  Quando marcar: Se você planeja desenvolver aplicativos GUI cross-platform; essencial para cross-compilation de apps Lazarus.

- **FPC/Laz rebuild only**: Apenas reconstrói o FPC/Lazarus, sem baixar fontes novas.  
  Quando marcar: Se as fontes já estiverem baixadas e você quiser apenas recompilar (ex.: após edições locais).

- **Include Help**: Inclui arquivos de ajuda e documentação.  
  Quando marcar: Se você quiser acesso à ajuda integrada no IDE Lazarus.

- **Split FPC source and bins**: Separa fontes e binários do FPC em diretórios diferentes.  
  Quando marcar: Para melhor organização de arquivos, especialmente em instalações múltiplas.

- **Split Lazarus source and bins**: Separa fontes e binários do Lazarus.  
  Quando marcar: Mesmo que acima, para manter o Lazarus organizado.

- **Docked Lazarus IDE**: Instala o Lazarus com interface docked (usando pacotes como AnchorDocking).  
  Quando marcar: Se você prefere um IDE com janelas dockáveis, similar a outros IDEs modernos.

- **Force linking against lowest @GLIBC-version**: Força linkagem contra a versão mais baixa do GLIBC (para Linux).  
  Quando marcar: Para garantir compatibilidade de binários com sistemas Linux mais antigos.

- **Use jobs for GNU make**: Ativa compilação paralela (-j) usando múltiplos núcleos.  
  Quando marcar: Em máquinas com múltiplos cores para acelerar o build; desmarque se houver problemas de estabilidade.

- **Be extra verbose**: Aumenta o nível de logs e saídas detalhadas.  
  Quando marcar: Para depuração durante a instalação, quando precisar ver todos os passos.

- **Send location and install info**: Envia dados anônimos de localização e instalação ao desenvolvedor.  
  Quando marcar: Se você quiser contribuir com estatísticas para melhorar a ferramenta.

- **Use local repo-client**: Usa cliente Git/SVN local em vez do embutido.  
  Quando marcar: Se você tem Git/SVN instalado no sistema e o embutido falhar.

- **Check for fpcupdeluxe updates**: Verifica atualizações do FPCupDeluxe automaticamente.  
  Quando marcar: Para manter a ferramenta atualizada; desmarque se preferir atualizações manuais.

- **Enable software emulation of 80 bit floats**: Ativa emulação de software para floats de 80 bits.  
  Quando marcar: Em plataformas sem suporte hardware para tipos extended float.

- **Enable Delphi RTTI**: Ativa Runtime Type Information (RTTI) compatível com Delphi.  
  Quando marcar: Para código que usa RTTI avançado, como em migrações de Delphi.

- **Allow patching of sources by online patches**: Permite aplicar patches online às fontes.  
  Quando marcar: Para correções automáticas de bugs conhecidos via repositório.

- **Re-apply local changes when updating**: Reaplica modificações locais ao atualizar fontes.  
  Quando marcar: Se você editou fontes localmente e quer preservá-las em atualizações.

- **Always ask for confirmation**: Sempre pede confirmação antes de ações.  
  Quando marcar: Para controle manual, evitando operações automáticas acidentais.

- **Save settings in fpcup-script**: Salva configurações em um script fpcup.  
  Quando marcar: Para automatizar instalações futuras via script.

- **Get package repositories**: Baixa repositórios de pacotes adicionais.  
  Quando marcar: Se você precisar instalar pacotes extras via Online Package Manager (OPM).

- **Build FPC Unicode**: Constrói o FPC com suporte Unicode completo.  
  Quando marcar: Para aplicativos que requerem manipulação avançada de Unicode.

- **Build dotted RTL**: Constrói a Runtime Library (RTL) com nomes "pontilhados" (possivelmente para namespaces ou compatibilidade).  
  Quando marcar: Em cenários específicos de compatibilidade ou módulos personalizados.

- **Use system FPC for Lazarus**: Usa o FPC instalado no sistema para o Lazarus.  
  Quando marcar: Se você já tem um FPC no sistema e quer integrá-lo ao Lazarus instalado.

- **Use wget/libcurl as downloader**: Usa wget ou libcurl para downloads em vez do padrão.  
  Quando marcar: Se o downloader embutido falhar (ex.: problemas de SSL ou rede).

- **Add context for FPC and Lazarus files**: Adiciona opções de contexto (menu direito) para arquivos FPC/Lazarus no explorador de arquivos.  
  Quando marcar: Para integração com o sistema operacional, facilitando abertura de arquivos.

## CPU/OS (Subarch)

- **Select CPU**: Seleciona a CPU alvo para cross-compilation (dropdown).  
  Quando usar: Ao configurar um cross-compiler para outra arquitetura (ex.: ARM, x86).

- **Select OS**: Seleciona o SO alvo (dropdown).  
  Quando usar: Para builds cross-platform (ex.: Windows para Linux).

- **List All**: Lista todas as opções disponíveis.  
  Quando usar: Para ver todas as combinações possíveis de CPU/OS.

## Opções de Pesquisa

- **fpcup (botão de rádio)**: Modo de busca padrão via fpcup.  
  Quando selecionar: Para buscas automáticas de dependências.

- **full auto**: Modo totalmente automático.  
  Quando selecionar: Para instalações sem intervenção, deixando o tool resolver tudo.

- **custom**: Modo personalizado.  
  Quando selecionar: Quando precisar definir caminhos manuais para bibliotecas ou ferramentas.

- **Bibliotecas**: Campo para paths de bibliotecas.  
  Quando usar: No modo custom, para especificar locais de libs externas.

- **Ferramentas**: Campo para paths de ferramentas.  
  Quando usar: Similar, para ferramentas como make ou binutils.

## Substituição de Opções de Construção Cruzada (i.e. -CfSoft)

- **Campo de texto**: Sobrescreve opções para builds cross (ex.: -CfSoft para soft float).  
  Quando usar: Para flags específicas de cross-compilation, como emulações ou otimizações por alvo.

## Substituição de Compilador

- **Campo de texto**: Especifica um compilador alternativo.  
  Quando usar: Se quiser usar um compilador diferente do padrão (ex.: bootstrap com outro FPC).

- **Compilar (botão)**: Compila com as substituições.  
  Quando usar: Após definir o override, para testar.

## Alvo ARM

- **none (botão de rádio)**: Sem alvo ARM específico.  
  Quando selecionar: Para builds não-ARM.

- **armel**: ARM little-endian softfloat.  
  Quando selecionar: Para dispositivos ARM antigos ou que não suportam hardfloat.

- **armeb**: ARM big-endian.  
  Quando selecionar: Para sistemas ARM big-endian (raro).

- **armhf**: ARM hardfloat (floating point hardware).  
  Quando selecionar: Para dispositivos modernos como Raspberry Pi, para melhor performance.

## Patching de Fonte

- **Add FPC patch**: Adiciona um patch às fontes do FPC.  
  Quando usar: Para aplicar correções personalizadas ou experimentais ao FPC.

- **Add Laz patch**: Adiciona um patch às fontes do Lazarus.  
  Quando usar: Similar, para o Lazarus.

- **Rem. FPC patch**: Remove um patch do FPC.  
  Quando usar: Para reverter um patch aplicado.

- **Rem. Laz patch**: Remove um patch do Lazarus.  
  Quando usar: Para reverter.

## Scripts de Pré e Pós-Instalação

- **FPC pré**: Script a executar antes da instalação do FPC.  
  Quando usar: Para preparações personalizadas, como definir variáveis de ambiente.

- **FPC pós**: Script após a instalação do FPC.  
  Quando usar: Para configurações pós-instalação, como copiar arquivos.

- **Lazarus pré**: Script antes do Lazarus.  
  Quando usar: Similar, para o Lazarus.

- **Lazarus pós**: Script após o Lazarus.  
  Quando usar: Para finalizações, como registrar componentes.

Essas opções permitem uma instalação altamente personalizada. Consulte o fórum do Lazarus (forum.lazarus.freepascal.org) para exemplos específicos ou problemas.

</main>

[🔝🔝](#topo "Retorna ao topo")