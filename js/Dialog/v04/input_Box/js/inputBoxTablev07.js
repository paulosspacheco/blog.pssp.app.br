export class InputBox {
    constructor(title, template) {
        this.fields = [];
        this.title = title; // Armazena o título
        this.tableContainer = document.createElement('div');
        this.tableContainer.className = 'table-container';
        this.table = document.createElement('table');
        this.table.className = 'inputBox-table';

        // Adiciona os estilos
        this.addStyles();

        // Processa o template
        this.parseTemplate(template);

        // Adiciona a tabela ao container
        this.tableContainer.appendChild(this.table);
        document.body.appendChild(this.tableContainer);

        // Adiciona eventos para ajuste do tamanho da fonte
        window.addEventListener("resize", this.adjustTableFontSize.bind(this));
        window.addEventListener("load", this.adjustTableFontSize.bind(this));
    }

    // Método para incluir estilos sem bordas
    // addStyles() {
    //     const style = document.createElement('style');
    //     style.textContent = `
    //         .table-container {
    //             width: 100%;
    //             max-width: 1500px;
    //             height: 800px;
    //             overflow: auto;
    //             border: 1px solid #ccc;
    //             margin-top: 20px;
    //         }
    //         .inputBox-table {
    //             border-collapse: collapse;
    //             width: 100%;
    //         }
    //         .inputBox-table th, 
    //         .inputBox-table td {
    //             border: 1px solid #ccc; /* Adiciona bordas às células */
    //             padding: 8px;
    //             text-align: left;
    //             overflow: hidden;
    //         }
    //         .inputBox-table label {
    //             display: block;
    //             margin-bottom: 5px;
    //         }
    //         .inputBox-table input {
    //             box-sizing: border-box;
    //             overflow: auto;
    //             white-space: nowrap;
    //             width: 100%;
    //         }
    //         .align-left {
    //             text-align: left;
    //         }
    //         .align-center {
    //             text-align: center;
    //         }
    //         .align-right {
    //             text-align: right;
    //         }
    //         /* Estilos do overlay */
    //         .inputBox-dialog-overlay {
    //             position: fixed;
    //             top: 0;
    //             left: 0;
    //             width: 100%;
    //             height: 100%;
    //             background-color: rgba(0, 0, 0, 0.5);
    //             display: flex;
    //             justify-content: center;
    //             align-items: center;
    //             z-index: 1000; /* Certifique-se de que o overlay está acima de outros elementos */
    //         }
    //         /* Estilos da caixa de diálogo */
    //         .inputBox-dialog-box {
    //             background-color: white;
    //             padding: 20px;
    //             border-radius: 8px;
    //             box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
    //             max-width: 90%; /* Largura máxima responsiva */
    //             overflow: auto;
    //         }
    //         .button-container {
    //             margin-top: 20px;
    //             text-align: right; /* Alinha os botões à direita */
    //         }
    //         .inputBox-button {
    //             padding: 10px 15px;
    //             margin-left: 10px; /* Espaçamento entre os botões */
    //         }
    //     `;
    //     document.head.appendChild(style);
    // }
        
    addStyles() {
        const style = document.createElement('style');
        style.textContent = `
            .table-container {
                width: 100%;
                max-width: 1500px;
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
            /* Estilos do overlay */
            .inputBox-dialog-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1000; /* Certifique-se de que o overlay está acima de outros elementos */
            }
            /* Estilos da caixa de diálogo */
            .inputBox-dialog-box {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
                max-width: 90%; /* Largura máxima responsiva */
                overflow: auto;
            }
            .button-container {
                margin-top: 20px;
                text-align: right; /* Alinha os botões à direita */
            }
            .inputBox-button {
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
    }

    // Método para calcular a largura de um texto em pixels
    getTextWidth(text, fontSize) {
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        context.font = `${fontSize}px Arial`;
        return context.measureText(text).width;
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
    
                const input = document.createElement('input');
                input.type = 'text'; // Tipo de entrada
                input.maxLength = field.maxLength; // Define o comprimento máximo
                input.name = field.name; // Nome do campo
                input.id = field.id; // ID do campo
                input.style.textAlign = field.align; // Alinhamento do texto no campo
                cell.appendChild(input);
                row.appendChild(cell); // Adiciona a célula à linha
            });
            table.appendChild(row); // Adiciona a linha à tabela
        });
    
        // Adiciona a tabela ao formulário
        form.appendChild(table);
    
        // Cria o container de botões
        const buttonContainer = document.createElement('div');
        buttonContainer.className = 'button-container';
    
        // Cria o botão "OK"
        const okButton = document.createElement('button');
        okButton.innerText = 'OK';
        okButton.className = 'inputBox-button'; // Classe para estilos do botão
        okButton.onclick = () => {
            this.getValues();
            document.body.removeChild(overlay); // Remove o overlay
        };
    
        // Cria o botão "Cancelar"
        const cancelButton = document.createElement('button');
        cancelButton.innerText = 'Cancelar';
        cancelButton.className = 'inputBox-button'; // Classe para estilos do botão
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

    // Método estático para instanciar a classe e exibir a caixa de entrada
    static inputBox(title, template) {
        return new Promise((resolve) => {
            const inputBoxInstance = new InputBox(title, template);
            inputBoxInstance.showInputBox(resolve);
        });
    }
}



