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
        //this.addStyles();
        
        // Inclui o CSS dinamicamente no documento, verificando se já está presente
        if (!document.querySelector('link[href="../css/input_Box.css"]')) {
            this.includeCSS('../css/input_Box.css');
        }


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

            @import url('../css/color_tons_de_lilas_claro.css');            


            /* Div para limitar o tamanho da área visível da tabela */
            .inputBox-table-container {
                width: 100%;
                max-width: 1500px; /* Limite máximo */
                height: 800px;
                overflow: auto;
                border: 1px solid #ccc;
                margin-top: 20px;
            }

            .inputBox-table {
                border-collapse: collapse;
                width: 100%;
            }
            .inputBox-table th, 
            .inputBox-table td {
                border: 1px solid #ccc; /* Adiciona bordas às células */
                padding: 8px;
                text-align: left;
                overflow: hidden;
            }
            .inputBox-table label {
                display: block;
                margin-bottom: 5px;
            }
            .inputBox-table input {
                box-sizing: border-box;
                overflow: auto;
                white-space: nowrap;
                width: 100%;
            }
            .align-left {
                text-align: left;
            }
            .align-center {
                text-align: center;
            }
            .align-right {
                text-align: right;
            }

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
      this.addFieldsToTable();        
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

    addFieldsToTable() {        
        
        this.fields.forEach((line) => {
            const row = document.createElement('tr');

            line.forEach((field) => {
                const th = document.createElement('th');
                const labelElement = document.createElement('label');
                labelElement.textContent = field.label;
                labelElement.className = `align-${field.align}`;
                th.appendChild(labelElement);

                const td = document.createElement('td');

                // Adiciona o input apenas se o tamanho máximo for maior que 0
                if (field.maxLength > 0) {
                    const input = document.createElement('input');
                    input.type = 'text';

                    // Calcula a largura média do caractere com o método textWidthChar
                    const estimatedCharWidth = this.textWidthChar(this.font);                   
                    // const padding = 20; // Padding adicional
                    const width = field.maxLength * estimatedCharWidth;// + padding;    
                    input.style.width = `${width}px`;

                    input.id = field.id;
                    input.name = field.name;
                    input.maxLength = field.maxLength;

                    td.appendChild(input);
                }

                row.appendChild(th);
                row.appendChild(td);
            });

            this.table.appendChild(row);
        });
    }

        
    // Método estático para instanciar a classe e exibir a caixa de entrada
    static inputBox(title, template) {
        return new Promise((resolve) => {
            const inputBoxInstance = new InputBox(title, template);
            inputBoxInstance.showInputBox2(resolve);
        });
    }


}



    