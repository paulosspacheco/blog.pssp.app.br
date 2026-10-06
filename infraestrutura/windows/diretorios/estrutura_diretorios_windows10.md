# Estrutura de Diretórios do Sistema Windows 10

    C:\
    ├── Arquivos de Programas\
    │   ├── WindowsApps\
    │   └── Common Files\
    ├── Arquivos de Programas (x86)\
    ├── Usuários\
    │   ├── Público\
    │   ├── Default\
    │   ├── Usuário1\
    │   └── Usuário2\
    ├── Windows\
    │   ├── System32\
    │   ├── Logs\
    │   ├── Temp\
    │   └── WinSxS\
    ├── PerfLogs\
    ├── ProgramData\
    └── Recuperação\

------------------------------------------------------------------------

## Descrição dos Diretórios

### `C:\`

É o **diretório raiz** da unidade principal do sistema operacional
Windows. É onde o sistema é instalado por padrão e contém todos os
arquivos essenciais e pastas do usuário.

------------------------------------------------------------------------

### `C:\Arquivos de Programas`

Contém os **aplicativos instalados no sistema** (versões de 64 bits).\
- Subpastas comuns incluem: - `WindowsApps`: onde ficam os aplicativos
da Microsoft Store. - `Common Files`: arquivos compartilhados entre
diferentes programas.

------------------------------------------------------------------------

### `C:\Arquivos de Programas (x86)`

Semelhante à pasta anterior, mas destinada a **programas de 32 bits** em
sistemas Windows de 64 bits. Essa separação garante compatibilidade
entre softwares de diferentes arquiteturas.

------------------------------------------------------------------------

### `C:\Usuários`

Contém as **pastas pessoais de cada usuário** do sistema.\
- `Público`: arquivos acessíveis por todos os usuários.\
- `Default`: modelo de configuração usado para criar novos perfis.\
- `Usuário1`, `Usuário2`: diretórios pessoais contendo documentos,
downloads, músicas, vídeos e área de trabalho de cada usuário.

------------------------------------------------------------------------

### `C:\Windows`

É o **núcleo do sistema operacional**, onde estão localizados os
arquivos necessários para o funcionamento do Windows.\
Subpastas importantes incluem:\
- `System32`: contém arquivos de sistema e executáveis essenciais (DLLs,
drivers, ferramentas administrativas).\
- `Logs`: registros de eventos e erros do sistema.\
- `Temp`: arquivos temporários utilizados durante instalações ou
execuções.\
- `WinSxS`: armazena diferentes versões de componentes do sistema para
garantir compatibilidade e restauração.

------------------------------------------------------------------------

### `C:\PerfLogs`

Abreviação de **Performance Logs**. Contém **relatórios e registros de
desempenho** gerados por ferramentas de diagnóstico do Windows (como o
Performance Monitor).

------------------------------------------------------------------------

### `C:\ProgramData`

Armazena **dados de configuração e arquivos compartilhados entre todos
os usuários**.\
Essa pasta é geralmente oculta e usada por softwares para salvar
informações que não devem ser específicas de um único usuário.

------------------------------------------------------------------------

### `C:\Recuperação`

Contém **arquivos de recuperação do sistema**, usados para restaurar o
Windows em caso de falha ou erro grave.\
Inclui pontos de restauração, imagens de backup e informações do
ambiente de recuperação (Windows RE).

------------------------------------------------------------------------

## Outras Pastas Comuns

-   **`C:\Temp`** → Pode ser usada por aplicações para armazenar
    arquivos temporários.\
-   **`C:\$Recycle.Bin`** → Contém as lixeiras individuais de cada
    usuário.\
-   **`C:\System Volume Information`** → Armazena dados do sistema, como
    pontos de restauração e índices de pesquisa (oculta por padrão).\
-   **`C:\Drivers`** → Alguns fabricantes armazenam drivers de hardware
    aqui para reinstalação rápida.

------------------------------------------------------------------------

📘 **Resumo:**\
A estrutura de diretórios do Windows 10 é organizada de forma a
**separar os arquivos do sistema, programas e dados dos usuários**,
garantindo estabilidade, compatibilidade e segurança.
