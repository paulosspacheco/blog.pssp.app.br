export class InputBox {
    constructor(title, template) {
        this.fields = [];
        this.title = title; // Armazena o título
        this.tableContainer = document.createElement('div');
        this.tableContainer.className = 'inputBox-table-container';
        this.table = document.createElement('table');
        this.table.className = 'inputBox-table';
        this.font = "16px Arial"; // Fonte usada para calcular a largura média de caractere                

        // Adiciona os estilos
        this.addStyles();
        
        // Inclui o CSS dinamicamente no documento, verificando se já está presente
        // if (!document.querySelector('link[href="../css/input_Box.css"]')) {
        //     this.includeCSS('../css/input_Box.css');
        // }


        // Processa o template
        this.parseTemplate(template);

        // Adiciona a tabela ao container
        this.tableContainer.appendChild(this.table);
        document.body.appendChild(this.tableContainer);

        // Adiciona eventos para ajuste do tamanho da fonte
        window.addEventListener("resize", this.adjustTableFontSize.bind(this));
        window.addEventListener("load", this.adjustTableFontSize.bind(this));
    }

    // Método para incluir CSS
    includeCSS(href) {
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = href;
        document.head.appendChild(link);
    }    
           
    addStyles() {
        const style = document.createElement('style');
        style.textContent = `

            /* input_Box.css */

            /* @import url('./color_tons_de_cinza.css'); */
            /* @import url('./color_tons_dark.css'); */
            /* @import url('./color_tons_de_dark_claro.css'); */
            /* @import url('./color_tons_de_azul_ceu.css'); */
            /* @import url('./color_tons_de_verde_claro.css'); */
            /* @import url('./color_tons_amarelo.css'); */
            @import url('../css/color_tons_de_lilas_claro.css');


            /* Estilo para o overlay da caixa de diálogo */
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

            /* Estilo para a caixa de diálogo */
            .inputBox-dialog-box {
                max-width: 600px; /* Define a largura máxima da caixa de diálogo, evitando que ela ultrapasse 600 pixels de largura.*/
                width: 100%; /*Define que a caixa de diálogo ocupará 100% da largura do contêiner pai, até o limite de max-width. */                
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

            /* Estilo para a linha de campos */
            .inputBox-dialog-form-row {
                display: grid; /* Usando grid para alinhar rótulos e entradas */
                /* grid-template-columns: auto 1fr; 2 colunas: auto para o rótulo e 1fr para o input */
                margin-bottom: 15px; /* Espaçamento entre as linhas de campos */
                align-items: center;              /* Alinha os itens verticalmente ao centro */    
                /* display: flex; */
                justify-content: space-between;
                width: 100%; /* Garante que cada linha ocupe toda a largura disponível */    
                display: grid;    
                grid-template-columns: auto minmax(min-content, 1fr);    
                gap: 10px;    
            }


            /* Estilo para os rótulos */
            .inputBox-dialog-form-row label {
                font-weight: bold; /* Rótulos em negrito */
                margin-right: 10px; /* Margem à direita dos rótulos */
                min-width: 50px; /* Largura mínima para os labels */    
            }

            /* Alinhamento do texto dos labels */
            .inputBox-dialog-form-row label.align-right {
                text-align: right;
                margin-right: 5px; /* Margem direita para alinhamento */
            }

            .inputBox-dialog-form-row label.align-left {
                text-align: left;
                margin-right: 5px;
            }

            .inputBox-dialog-form-row label.hidden {
                visibility: hidden; /* Torna o label invisível também */
            }

            /* Estilo para os campos de entrada */
            .inputBox-dialog-form-row input {
                padding: 8px; /* – Adiciona espaçamento interno ao redor do conteúdo do campo, aumentando a área clicável e melhorando a usabilidade. */    
                border-radius: 4px; /* – Adiciona bordas levemente arredondadas, proporcionando um visual mais suave e moderno. */
                /* width: 100%; – Faz com que o campo ocupe toda a largura do contêiner pai, adaptando-se bem ao layout do formulário. */
                box-sizing: border-box; /* – Inclui o padding e a border no cálculo da largura total do campo, evitando que o campo extrapole o contêiner */
                flex-shrink: 0; /* Esta propriedade impede que o campo de entrada (input) reduza seu tamanho quando o contêiner flexível possui pouco espaço disponível. Mantém o tamanho dos campos estável, mesmo em layouts adaptáveis. */        
                /* min-width: 150px;     */
                width: fit-content; /* Expande conforme o conteúdo */    
                max-width: 200px;    /* Limita o crescimento a 200px ou ajuste conforme necessário */    
                min-width: 50px;     /* Define uma largura mínima confortável */    
            }

            /* Estilo para o container de cada campo */
            .inputBox-dialog-form-row div {
                display: flex; /* Configura o contêiner como um elemento flexível, permitindo melhor controle sobre o alinhamento e espaçamento dos itens internos. */
                align-items: center; /*Centraliza verticalmente os elementos dentro do contêiner, mantendo a harmonia visual entre rótulos e campos de entrada.*/
                margin-right: 10px; /* Adiciona um espaçamento à direita entre os contêineres de cada campo, facilitando a organização e espaçamento uniforme dos elementos no layout do formulário. */
            }

            /* Campo invisível */
            .inputBox-dialog-form-row input.hidden {
                visibility: hidden; /* Campo invisível, mas ocupa espaço */
                width: 1px; /* Mantém largura mínima para alinhamento */
            }


            .align-left {
                text-align: left; /* Alinhamento à esquerda */
            }

            .align-right {
                text-align: right; /* Alinhamento à direita */
            }

            .align-right {
                text-align: right; /* Alinhamento à direita */
            }

            /* Div para limitar o tamanho da área visível da tabela */
            .inputBox-table-container {
                width: 100%;
                /*max-width: 1500px; /* Limite máximo */
                /*height: 800px;*/
                /*overflow: auto;*/
                border: 1px solid #ccc;
                margin-top: 20px;

                max-height: calc(100vh - 50px); /* Subtraia a altura do título se necessário */
                /*max-height: calc(87vh - 5px); /* A tabela ocupará até 85% da altura da janela, menos 5px */
                max-width: calc(100vw - 5px);
                overflow-y: auto;             /* Permite rolagem vertical */
                overflow-x: auto;             /* Permite rolagem horizontal */    
                position: relative;           /* Necessário para o efeito sticky */
 
                    
            }

            .inputBox-table-container table {
                width: calc(100% - 5px);      /* Define a largura da tabela 5px menor que o contêiner */
                max-height: calc(100% - 5px); /* Define a altura da tabela 5px menor que o contêiner */
            }
            

            .inputBox-fixed-table-title {    
                font-size: 1.2em;           /* Tamanho da fonte do título */
                font-weight: bold;          /* Deixa o título em negrito */
                padding: 10px;              /* Espaçamento interno para o título */
                text-align: center;         /* Centraliza o texto do título */
                background-color: #f0f0f0;  /* Cor de fundo para destacar o título */
                position: sticky;           /* Fixa o título no topo ao rolar */
                top: 0;                     /* Mantém o título colado no topo */
                z-index: 1;                 /* Coloca o título sobre as outras linhas */
            }


            /* Estilo para o contêiner de botões */
            .inputBox-dialog-button-container {
                display: flex; /* Usado para alinhar os botões em linha */
                justify-content: space-between; /* Espaço entre os botões */
                margin-top: 10px; /* Espaçamento acima dos botões */
            }

            .inputBox-dialog-button {
                padding: 10px 15px;
                margin-left: 10px; /* Espaçamento entre os botões */
            }

            /* Estilo para o título */
            .inputBox-dialog-box h2 {
                margin: 0 0 15px; /* Define uma margem de 15 pixels abaixo do título, eliminando margens superiores e laterais para criar um espaçamento adequado entre o título e os elementos subsequentes. */
                font-size: 20px; /* Define o tamanho da fonte do título para 20 pixels, tornando-o destacável e fácil de ler. */
                text-align: center; /* Centraliza o texto do título dentro do contêiner, criando um visual harmonioso e centralizado. */
            }

            .inputBox-table {
                border-collapse: collapse;
                width: 100%;
                overflow-x: auto;
                overflow-y: auto;
            }

            /* Estilos para th e td dentro da tabela com a classe inputBox-table */
            .inputBox-table th, 
            .inputBox-table td {
                border: none;
                padding: 8px;
                text-align: left;
                overflow: hidden;
            }

            /* Estilo para os labels e inputs dentro da tabela */
            .inputBox-table label {
                display: block;
                margin-bottom: 5px;
            }

            .inputBox-table input {
                box-sizing: border-box;
                overflow: auto;
                white-space: nowrap;
                width: 100%; /* Ajusta a largura do input para preencher a célula */
            }

            /* Classes de alinhamento */
            .align-left {
                text-align: left;
            }
            .align-center {
                text-align: center;
            }
            .align-right {
                text-align: right;
            }


        `;
        document.head.appendChild(style);
    }
    

    // Método `parseTemplate`
    parseTemplate(template) {
        const lines = template.split('\n');
        lines.forEach((line) => {
            const currentLine = [];
            let currentLabel = '';
            let inputLength = 0;
            let inLabel = false;
            let nameField = ''; // Variável para armazenar o nome do campo

            // Ignora linhas vazias
            if (line.trim().length === 0) return;

            for (let i = 0; i < line.length; i++) {
                switch (line[i]) {
                    case '~':
                        // Troca entre label e valor
                        inLabel = !inLabel;
                        if (!inLabel) currentLabel = currentLabel.trim();
                        break;
                    case '\\':
                        i++; // Move para o próximo caractere
                        inputLength = 0;

                        // Verifica se esta posição deve ser um campo vazio
                        if (currentLabel === '' && line[i] !== 's') {
                            currentLine.push({ label: '', maxLength: 0, align: 'right' });
                            i--; // Decrementa para processar o próximo caractere normalmente
                            break;
                        }

                        // Conta quantos 's' existem após a barra invertida
                        while (i < line.length && line[i] === 's') {
                            inputLength++;
                            i++;
                        }

                        // Ignora espaços em branco até encontrar '^B'
                        while (i < line.length && line[i] !== '^') {
                            i++;
                        }

                        // Verifica se encontramos '^B'
                        if (line[i] === '^' && line[i + 1] === 'B') {
                            i += 2; // Pular o '^B'
                            // Ignora espaços em branco antes do nome do campo
                            while (i < line.length && line[i] === ' ') {
                                i++;
                            }
                            // Captura o nome do campo até encontrar um espaço ou o final da linha
                            while (i < line.length && line[i] !== ' ' && line[i] !== '\n') {
                                nameField += line[i];
                                i++;
                            }
                        }

                        // Adiciona o campo se um label foi encontrado
                        if (currentLabel) {
                            // Determina o alinhamento baseado na posição dos caracteres ':'
                            let align = 'left'; // Alinhamento padrão

                            // Verifica se o label começa e termina com ':'
                            if (currentLabel.startsWith(':') && currentLabel.endsWith(':')) {
                                align = 'center';
                                currentLabel = currentLabel.slice(1, -1).trim(); // Remove ':' do início e do fim
                            } else if (currentLabel.startsWith(':')) {
                                align = 'left';
                                currentLabel = currentLabel.slice(1).trim(); // Remove ':' do início
                            } else if (currentLabel.endsWith(':')) {
                                align = 'right';
                                currentLabel = currentLabel.slice(0, -1).trim(); // Remove ':' do fim
                            }

                            // Adiciona o campo à linha atual
                            currentLine.push({
                                label: currentLabel,
                                maxLength: inputLength,
                                align: align,
                                id: nameField,
                                name: nameField
                            });
                            currentLabel = ''; // Reseta o label após adicionar
                            nameField = ''; // Reseta o nome do campo após adicionar
                        }

                        i--; // Decrementa para não pular o próximo caractere na iteração
                        break;
                    default:
                        // Adiciona caracteres ao label
                        if (inLabel) {
                            currentLabel += line[i];
                        }
                        break;
                }
            }

            // Se houver campos coletados nesta linha, adicione-os ao array de fields
            if (currentLine.length > 0) {
                this.fields.push(currentLine);
            }
        });

      // Adiciona as linhas à tabela
      this.addFieldsToTable(this.title);        
    }

    // Método para calcular a largura de um texto em pixels
    getTextWidth(text, fontSize) {
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        context.font = `${fontSize}px Arial`;
        return context.measureText(text).width;
    }

    // Método para calcular a largura média de um caractere
    textWidthChar(aFont) {
        // Função auxiliar para verificar se a fonte é monoespaçada
        function isMonoSpaced(aFont, context) {
            context.font = aFont;
            const widthA = context.measureText("W").width;
            const widthB = context.measureText("b").width;
            return widthA === widthB;
        }

        // Criando um elemento <canvas> para cálculos de largura de texto
        const canvasElement = document.createElement('canvas');
        const context = canvasElement.getContext("2d");
        context.font = aFont;


        if (!isMonoSpaced(aFont, context)) {
            const sampleText = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            const totalWidth = context.measureText(sampleText).width;
            return totalWidth / sampleText.length;
        } else {
            return context.measureText("A").width;
        }
    }

    adjustTableFontSize() {
        const containerWidth = this.tableContainer.clientWidth;
    
        let fontSize; // Variável para armazenar o tamanho da fonte
    
        if (containerWidth < 600) {
            fontSize = "8px";
        } else if (containerWidth < 1200) {
            fontSize = "12px";
        } else {
            fontSize = "16px";
        }
    
        // Ajustar o tamanho da fonte da tabela
        this.table.style.fontSize = fontSize;
    
        // Ajustar o tamanho da fonte dos inputs
        const inputs = this.table.querySelectorAll('input');
        inputs.forEach(input => {
            input.style.fontSize = fontSize; // Aplica o mesmo tamanho de fonte aos inputs
        });
    }

    // Método para criar uma caixa de diálogo com base no array this.fields
    showInputBox() {
        // Criação do overlay da caixa de diálogo
        const overlay = document.createElement('div');
        overlay.className = 'inputBox-dialog-overlay';
    
        // Criação da caixa de diálogo
        const form = document.createElement('div');
        form.className = 'inputBox-dialog-box'; // Caixa de diálogo
    
        // Configura o título
        const titleElement = document.createElement('h2');
        titleElement.innerText = this.title;
        form.appendChild(titleElement);
    
        // Cria uma tabela para os campos de entrada
        const table = document.createElement('table');
        table.className = 'inputBox-table'; // Classe para estilos da tabela
    
        // Adiciona os campos à tabela
        this.fields.forEach(line => {
            const row = document.createElement('tr'); // Cria uma nova linha para cada campo
            line.forEach(field => {
                const cell = document.createElement('td'); // Cria uma nova célula
    
                const label = document.createElement('label');
                label.innerText = field.label;
                cell.appendChild(label);
    
                if (field.maxLength > 0) {                                
                    const input = document.createElement('input');
                    input.type = 'text'; // Tipo de entrada

                    // Calcular a largura do input com base no maxLength
                    const estimatedCharWidth = this.textWidthChar(this.font);                   
                    const padding = 20; // Padding adicional
                    const width = field.maxLength * estimatedCharWidth + padding;    
                    input.style.width = `${width}px`;
                    input.maxLength = field.maxLength; // Define o maxlength do input                  
                    input.style.textAlign = field.align; // Alinhamento do texto no campo
                    
                    input.name = field.name; // Nome do campo
                    input.id = field.id; // ID do campo
                    input.style.textAlign = field.align; // Alinhamento do texto no campo
                    cell.appendChild(input);
                }
                    
                row.appendChild(cell); // Adiciona a célula à linha
            });
            table.appendChild(row); // Adiciona a linha à tabela
        });
    
        // Adiciona a tabela ao formulário
        form.appendChild(table);
    
        // Cria o container de botões
        const buttonContainer = document.createElement('div');
        buttonContainer.className = 'inputBox-dialog-button-container';
    
        // Cria o botão "OK"
        const okButton = document.createElement('button');
        okButton.innerText = 'OK';
        okButton.className = 'inputBox-dialog-button'; // Classe para estilos do botão
        okButton.onclick = () => {
            this.getValues();
            document.body.removeChild(overlay); // Remove o overlay
        };
    
        // Cria o botão "Cancelar"
        const cancelButton = document.createElement('button');
        cancelButton.innerText = 'Cancelar';
        cancelButton.className = 'inputBox-dialog-button'; // Classe para estilos do botão
        cancelButton.onclick = () => {
            document.body.removeChild(overlay); // Remove o overlay
        };
    
        // Adiciona os botões ao container
        buttonContainer.appendChild(okButton);
        buttonContainer.appendChild(cancelButton);
    
        // Adiciona o container de botões ao formulário
        form.appendChild(buttonContainer);
    
        // Adiciona a caixa de diálogo ao overlay
        overlay.appendChild(form);
    
        // Adiciona o overlay ao corpo do documento
        document.body.appendChild(overlay);
    }

    // Método para criar uma caixa de diálogo com base no array this.fields
    showInputBox2() {
        
        // Criação do overlay da caixa de diálogo
        const overlay = document.createElement('div');
        overlay.className = 'inputBox-dialog-overlay';

        // Criação da caixa de diálogo
        const form = document.createElement('div');
        form.className = 'inputBox-dialog-box'; // Caixa de diálogo

        // Configura o título
        const titleElement = document.createElement('h2');
        titleElement.innerText = this.title;
        form.appendChild(titleElement);

        // Cria uma tabela para os campos de entrada
        const table = document.createElement('table');
        table.className = 'inputBox-table'; // Classe para estilos da tabela

        // Adiciona os campos à tabela
        this.fields.forEach(line => {
            const row = document.createElement('tr'); // Cria uma nova linha para cada campo
            line.forEach(field => {
                // Cria uma célula para o label
                const labelCell = document.createElement('td');
                const label = document.createElement('label');
                label.innerText = field.label;
                labelCell.appendChild(label);
                row.appendChild(labelCell); // Adiciona a célula do label à linha

                // Cria uma célula para o input
                const inputCell = document.createElement('td');

                if (field.maxLength > 0) {                
                    const input = document.createElement('input');
                    input.type = 'text'; // Tipo de entrada
                    

                    // Calcular a largura do input com base no maxLength                   
                    const estimatedCharWidth = this.textWidthChar(this.font);                   
                    const padding = 20; // Padding adicional
                    const width = field.maxLength * estimatedCharWidth + padding;    
                    input.style.width = `${width}px`;
                    input.maxLength = field.maxLength; // Define o maxlength do input                  
                    input.style.textAlign = field.align; // Alinhamento do texto no campo

                    input.name = field.name; // Nome do campo
                    input.id = field.id; // ID do campo
                    

                    inputCell.appendChild(input);
                }

                row.appendChild(inputCell); // Adiciona a célula do input à linha
            });
            table.appendChild(row); // Adiciona a linha à tabela
        });

        // Adiciona a tabela ao formulário
        form.appendChild(table);

        // Cria o container de botões
        const buttonContainer = document.createElement('div');
        buttonContainer.className = 'inputBox-dialog-button-container';

        // Cria o botão "OK"
        const okButton = document.createElement('button');
        okButton.innerText = 'OK';
        okButton.className = 'inputBox-dialog-button'; // Classe para estilos do botão
        okButton.onclick = () => {
            this.getValues();
            document.body.removeChild(overlay); // Remove o overlay
        };

        // Cria o botão "Cancelar"
        const cancelButton = document.createElement('button');
        cancelButton.innerText = 'Cancelar';
        cancelButton.className = 'inputBox-dialog-button'; // Classe para estilos do botão
        cancelButton.onclick = () => {
            document.body.removeChild(overlay); // Remove o overlay
        };

        // Adiciona os botões ao container
        buttonContainer.appendChild(okButton);
        buttonContainer.appendChild(cancelButton);

        // Adiciona o container de botões ao formulário
        form.appendChild(buttonContainer);

        // Adiciona a caixa de diálogo ao overlay
        overlay.appendChild(form);

        // Adiciona o overlay ao corpo do documento
        document.body.appendChild(overlay);
    }


    // Método para coletar os valores dos campos de entrada
    getValues() {
        const values = {};
        this.fields.forEach(line => {
            line.forEach(field => {
                const input = document.getElementById(field.id); // Busca pelo ID do campo
                values[field.name] = input.value; // Armazena o valor no objeto
            });
        });
        console.log(values); // Exibe os valores no console (ou faça o que precisar com eles)
    }
        
    addFieldsToTable(title) {
        // Cria o contêiner externo com a classe table-container
        const container = document.createElement('div');
        container.className = 'inputBox-table-container';
    
        // Cria a tabela e adiciona o título como um <caption>
        const table = document.createElement('table');
        table.id = this.title;//'myTable';
        
        
        const caption = document.createElement('caption');
        caption.textContent = title;
        caption.className = 'inputBox-fixed-table-title'; // Classe CSS para fixação do título
        table.appendChild(caption);
    
        // Adiciona as linhas e colunas conforme o código anterior
        this.fields.forEach((line) => {
            const row = document.createElement('tr');
    
            line.forEach((field) => {
                const th = document.createElement('th');
                const labelElement = document.createElement('label');
                labelElement.textContent = field.label;
                labelElement.className = `align-${field.align}`;
                th.appendChild(labelElement);
    
                const td = document.createElement('td');
    
                if (field.maxLength > 0) {
                    const input = document.createElement('input');
                    input.type = 'text';
                    const estimatedCharWidth = this.textWidthChar(this.font);
                    const width = field.maxLength * estimatedCharWidth;
                    input.style.width = `${width}px`;
    
                    input.id = field.id;
                    input.name = field.name;
                    input.maxLength = field.maxLength;
    
                    td.appendChild(input);
                }
    
                row.appendChild(th);
                row.appendChild(td);
            });
    
            table.appendChild(row);
        });
    
        // Adiciona a tabela dentro do contêiner
        container.appendChild(table);
    
        // Adiciona o contêiner ao corpo do documento ou a outro elemento de destino
        document.body.appendChild(container); // Ou use um elemento específico
    }
          

    // Método estático para instanciar a classe e exibir a caixa de entrada
    static inputBox(title, template) {
        return new Promise((resolve) => {
            const inputBoxInstance = new InputBox(title, template);
            //inputBoxInstance.showInputBox(resolve);            
            //inputBoxInstance.showInputBox2(resolve);
        });
    }


}



    