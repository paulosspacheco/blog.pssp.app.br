# Documentação CSS para FormFieldsContainer e InputBox

## Classes CSS Utilizadas

### `.inputBox-dialog-overlay`

Classe responsável por estilizar a sobreposição da caixa de diálogo. Utilizada para criar um fundo semi-transparente atrás da caixa de entrada.

**Exemplo de uso:**

```css

    .inputBox-dialog-overlay {
        right: 0;
        bottom: 0;
        top: 0; /* Fica no topo da tela */
        left: 0; /* Fica à esquerda */
        width: 100%; /* Largura total */
        height: 100%; /* Altura total */    
        background-color: var(--overlay-bg-color);/* Fundo semitransparente */
        position: fixed; /* Fica fixo na tela */
        /* background: rgba(0, 0, 0, 0.5); Fundo semi-transparente */
        display: flex; /* Para centralizar o conteúdo */
        align-items: center; /* Alinhamento vertical */
        justify-content: center; /* Alinhamento horizontal */    
        z-index: 1000; /* Coloca o overlay acima de outros elementos */    
    }

```

### .inputBox-dialog-box

Classe utilizada para estilizar a caixa de diálogo que contém os campos de entrada.

**Exemplo de uso**:

```css

    .inputBox-dialog-box {
        max-width: 600px; /* Define a largura máxima da caixa de diálogo, evitando que ela ultrapasse 600 pixels de largura.*/
        width: 100%; /*Define que a caixa de diálogo ocupará 100% da largura do contêiner pai, até o limite de `max-width`. */                
        overflow: hidden; /* Garante que o conteúdo que exceder o contêiner principal seja ocultado. */
        overflow-y: auto; /* Permite a rolagem vertical, útil se o conteúdo ultrapassar a altura máxima definida. */
        overflow-x: auto; /* Permite a rolagem horizontal, evitando o corte de conteúdo em dispositivos menores.*/    
        max-height: 80vh; /* Limita a altura máxima da caixa de diálogo a 80% da altura da tela do usuário. */
        padding: 20px;    /* Adiciona espaçamento interno, garantindo que o conteúdo tenha espaço nas bordas. */    
        border-radius: 5px; /* Arredonda levemente os cantos da caixa para um visual mais suave. */
        background-color: var(--dialog-box-bg-color);/* Define a cor de fundo como branco, garantindo um fundo limpo e claro. */
        color: var(--dialog-box-text-color);    
        box-shadow: var(--dialog-box-shadow);/*Adiciona uma sombra suave ao redor da caixa, proporcionando um efeito de elevação.*/        
    }


```

### .inputBox-dialog-form-fields

Classe que estiliza o contêiner dos campos de entrada dentro da caixa de diálogo.

Exemplo de uso:

```css

    /* Estilo para o contêiner de campos */
    .inputBox-dialog-form-fields {
        align-items: center;              /* Alinha os itens verticalmente ao centro */   
        gap: 10px;                        /* Espaçamento entre as linhas */    
        max-height: 60vh;                /* Limita a altura máxima do contêiner de campos */
        overflow-y: auto;                 /* Permite rolagem vertical */    
        overflow-x: auto; /* Permite rolagem horizontal */
        white-space: nowrap; /* Impede a quebra de linha */
        display: flex;
        flex-direction: column; /* Organiza as linhas verticalmente */
        font-size: 12px; /* Tamanho da fonte em pixels */    
    }

```

### .inputBox-dialog-form-row

Classe utilizada para cada linha de campos dentro do contêiner de campos.

Exemplo de uso:

```css

    .inputBox-dialog-form-row {
        display: grid; /* Usando grid para alinhar rótulos e entradas */
        grid-template-columns: auto 1fr; /* 2 colunas: auto para o rótulo e 1fr para o input */
        /* align-items: center; Alinha verticalmente no centro */
        margin-bottom: 15px; /* Espaçamento entre as linhas de campos */
        /* display: contents; Permite que o grid funcione corretamente dentro de cada linha     */
        /* display: flex;                    Coloca os campos em linha */
        /* justify-content: space-between;   Distribui espaço entre rótulos e inputs */
        align-items: center;              /* Alinha os itens verticalmente ao centro */    
        display: flex;
        justify-content: space-between;
        width: 100%; /* Garante que cada linha ocupe toda a largura disponível */    
    }


```

### .inputBox-dialog-form-row label

**Descrição:** Classe base para rótulos dentro do diálogo `inputBox-dialog`.

Exemplo de uso:

```css

    /* Estilo para os rótulos */
    .inputBox-dialog-form-row label {
        font-weight: bold; /* Rótulos em negrito */
        margin-right: 10px; /* Margem à direita dos rótulos */
        min-width: 50px; /* Largura mínima para os labels */    
    }

```

### .inputBox-dialog-form-row label.align-right

**Descrição:** Classe auxiliar para alinhar o texto dos rótulos à direita.

Exemplo de uso:

```css
    /* Alinhamento do texto dos labels */
    .inputBox-dialog-form-row label.align-right {
        text-align: right;
        margin-right: 5px; /* Margem direita para alinhamento */
    }

```

### .inputBox-dialog-form-row label.align-left

**Descrição:** Classe auxiliar para alinhar o texto dos rótulos à esquerda.

Exemplo de uso:

```css

    .inputBox-dialog-form-row label.align-left {
        text-align: left;
        margin-right: 5px;
    }

```

### .inputBox-dialog-form-row label.hidden

**Descrição:** Classe auxiliar para ocultar rótulos visualmente, mantendo o espaço em layout.

Exemplo de uso:

```css

    .inputBox-dialog-form-row label.hidden {
        visibility: hidden; /* Torna o label invisível também */
    }


```

### .inputBox-dialog-form-row input

**Descrição:** Classe para estilizar campos de entrada em uma linha de formulário no diálogo `inputBox-dialog`.

Obs: Classe aplicada aos campos de entrada de dados dentro de cada linha do formulário. O objetivo desta classe é garantir que os campos de entrada tenham um tamanho fixo e não sejam encolhidos em layouts flexíveis.

Exemplo de uso:

```css

    /* Estilo para os campos de entrada */
    .inputBox-dialog-form-row input {
        padding: 8px; /* – Adiciona espaçamento interno ao redor do conteúdo do campo, aumentando a área clicável e melhorando a usabilidade. */        
        border-radius: 4px; /* – Adiciona bordas levemente arredondadas, proporcionando um visual mais suave e moderno. */
        width: 100%; /* – Faz com que o campo ocupe toda a largura do contêiner pai, adaptando-se bem ao layout do formulário. */
        box-sizing: border-box; /* – Inclui o `padding` e a `border` no cálculo da largura total do campo, evitando que o campo extrapole o contêiner */
        flex-shrink: 0; /* Esta propriedade impede que o campo de entrada (input) reduza seu tamanho quando o contêiner flexível possui pouco espaço disponível. Mantém o tamanho dos campos estável, mesmo em layouts adaptáveis. */    
    }

```

### .inputBox-dialog-form-row div

**Descrição:** Classe aplicada ao contêiner de cada campo em uma linha de formulário para organizar a disposição dos elementos.

Exemplo de uso:

```css

    /* Estilo para o container de cada campo */
    .inputBox-dialog-form-row div {
        display: flex; /* Configura o contêiner como um elemento flexível, permitindo melhor controle sobre o alinhamento e espaçamento dos itens internos. */
        align-items: center; /*Centraliza verticalmente os elementos dentro do contêiner, mantendo a harmonia visual entre rótulos e campos de entrada.*/
        margin-right: 10px; /* Adiciona um espaçamento à direita entre os contêineres de cada campo, facilitando a organização e espaçamento uniforme dos elementos no layout do formulário. */
    }

```

### .align-left

Classe que alinha o texto do rótulo à esquerda.

Exemplo de uso:

```css

    .align-left {
        text-align: left; /* Alinhamento à esquerda */
    }

```

### .align-right

Classe que alinha o texto do rótulo à direita.

Exemplo de uso:

```css

    .align-right {
        text-align: right; /* Alinhamento à direita */
    }

```

### .hidden

Classe que oculta um elemento na interface.

Exemplo de uso:

```css

    .hidden {
        display: none; /* Não exibe o elemento */
    }

```

### .inputBox-dialog-button-container

Classe para o contêiner dos botões OK e Cancelar.

Exemplo de uso:

```css

.inputBox-dialog-button-container {
    display: flex; /* Usado para alinhar os botões em linha */
    justify-content: space-between; /* Espaço entre os botões */
    margin-top: 10px; /* Espaçamento acima dos botões */
}

```

### .inputBox-dialog-box h2

**Descrição:** Classe aplicada ao elemento de título (`h2`) que representa o cabeçalho do diálogo. Este estilo centraliza o título e adiciona espaçamento para uma apresentação mais organizada.

Exemplo de uso:

```css

    /* Estilo para o título */
    .inputBox-dialog-box h2 {
        margin: 0 0 15px; /* Define uma margem de 15 pixels abaixo do título, eliminando margens superiores e laterais para criar um espaçamento adequado entre o título e os elementos subsequentes. */
        font-size: 20px; /* Define o tamanho da fonte do título para 20 pixels, tornando-o destacável e fácil de ler. */
        text-align: center; /* Centraliza o texto do título dentro do contêiner, criando um visual harmonioso e centralizado. */
    }


```

