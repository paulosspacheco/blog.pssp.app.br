import { MiMethods } from './MiMethods.js';

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
        //MiMethods.addStyles('textos css');
        
        
        MiMethods.includeCSS('link[href="../css/input_Box.css"]');


        // Processa o template
        this.parseTemplate(template);

        // Adiciona a tabela ao container
        this.tableContainer.appendChild(this.table);
        document.body.appendChild(this.tableContainer);

        // Adiciona eventos para ajuste do tamanho da fonte
        window.addEventListener("resize", this.adjustTableFontSize.bind(this));
        window.addEventListener("load", this.adjustTableFontSize.bind(this));
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
    //   this.addFieldsToTable();        
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
    

    // Método para fechar o diálogo
    okBotton() {
        const dialog = document.getElementById('inputBox-dialog');
        if (dialog) {
            dialog.remove(); // Remove o diálogo do DOM
        }
        const overlay = document.getElementById('inputBox-dialog-overlay');
        if (overlay) {
            overlay.remove(); // Remove o overlay do DOM
        }
    }

    // Método para fechar o diálogo
    cancelButton() {
        const dialog = document.getElementById('inputBox-dialog');
        if (dialog) {
            dialog.remove(); // Remove o diálogo do DOM
        }
        const overlay = document.getElementById('inputBox-dialog-overlay');
        if (overlay) {
            overlay.remove(); // Remove o overlay do DOM
        }
    }
    
    GetPainelOkCancel() {
        // Cria o painel do rodapé para os botões
        const footerPanel = document.createElement('div');
        footerPanel.className = 'inputBox-footer-panel'; // Classe CSS para o rodapé
        
        // Centraliza os botões
        footerPanel.style.display = 'flex';
        footerPanel.style.justifyContent = 'center';
        footerPanel.style.gap = '10px'; // Espaçamento entre os botões
        
        // Adiciona botão Cancelar
        const buttonCancel = document.createElement('button');
        buttonCancel.textContent = 'Cancelar';
        buttonCancel.addEventListener('click', () => {
            this.cancelButton(); // Fecha o dialog com valor de retorno 'cancel'
        });
        footerPanel.appendChild(buttonCancel);
        
        // Adiciona botão OK
        const buttonOk = document.createElement('button');
        buttonOk.textContent = 'OK';
        buttonOk.addEventListener('click', () => {                
            this.okBotton(); // Fecha o dialog com valor de retorno 'ok'
        });
        footerPanel.appendChild(buttonOk);
    
        return footerPanel;
    }
    

    addFieldsToTable(targetContainer = document.body, getPanel = null) {
        // Cria o contêiner externo com a classe inputBox-container
        const container = document.createElement('div');
        container.className = 'inputBox-container';
        
        // Cria o título do contêiner
        const titleElement = document.createElement('div');
        titleElement.className = 'inputBox-table-title'; // Classe CSS para o título
        titleElement.textContent = this.title; // Define o texto do título
        container.appendChild(titleElement); // Adiciona o título ao contêiner
        
        // Cria o contêiner para a tabela
        const tableContainer = document.createElement('div');
        tableContainer.className = 'inputBox-table-container'; // Classe CSS para a tabela
    
        // Cria a tabela
        const table = document.createElement('table');
        table.id = this.title; // Define o ID da tabela
    
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
    
        // Adiciona a tabela ao contêiner da tabela
        tableContainer.appendChild(table);
        container.appendChild(tableContainer); // Adiciona o contêiner da tabela ao contêiner principal
    
        // Executa o método getPanel se não for nulo
        if (getPanel) {
            const auxPanel = getPanel(); // Chama o método passado como parâmetro
            // Adiciona o rodapé ao contêiner principal se o painel existir
            if (auxPanel) {
                container.appendChild(auxPanel);
            }
        }
    
        // Adiciona o contêiner ao contêiner de destino
        targetContainer.appendChild(container);
    
        return container;
    }
        
    
    // Método que adiciona um contêiner de campos a um diálogo modal
    addFieldsToDialog() {
        // Método para mostrar o diálogo
        function showDialog() {
            const dialog = document.getElementById('inputBox-dialog');
            const overlay = document.getElementById('inputBox-dialog-overlay');

            if (dialog && overlay) {
                dialog.style.display = 'block'; // Exibe o diálogo
                overlay.style.display = 'block'; // Exibe o overlay
            }
        }

        // Verifica se o elemento `dialog` já existe
        let dialog = document.getElementById('inputBox-dialog');
        if (!dialog) {
            // Cria o elemento `dialog` dinamicamente se não existir
            dialog = document.createElement('div');
            dialog.id = 'inputBox-dialog';
            dialog.className = 'inputBox-dialog';

            // Cria um overlay
            const overlay = document.createElement('div');
            overlay.id = 'inputBox-dialog-overlay';
            overlay.className = 'inputBox-dialog-overlay';
            
            document.body.appendChild(overlay); // Adiciona o overlay ao corpo do documento
            document.body.appendChild(dialog); // Adiciona o diálogo ao corpo do documento

            // // Adiciona um evento de clique no overlay para fechar o diálogo
            // overlay.addEventListener('click', () => {
            //     dialog.style.display = 'none';
            //     overlay.style.display = 'none'; // Oculta o overlay quando o diálogo é fechado
            // });
        }

        // Limpa o conteúdo anterior
        dialog.innerHTML = '';

        //Adiciona cabeçalho e botão de fechar ao diálogo
        const header = document.createElement('div');
        header.className = 'inputBox-dialog-header';
        header.textContent = 'Seu Título Aqui'; // Defina o título desejado
        dialog.appendChild(header);

        // Adiciona o contêiner recebido ao diálogo após o cabeçalho
        const container = this.addFieldsToTable(dialog, () => this.GetPainelOkCancel());
        dialog.appendChild(container);

        // Exibir diálogo
        showDialog();
    }


    // Método para mostrar o diálogo
    showDialog() {               
        this.addFieldsToDialog();
    }


    // Método estático para instanciar a classe e exibir a caixa de entrada
    static inputBox(title, template) {
        return new Promise((resolve) => {
            const inputBoxInstance = new InputBox(title, template);
            inputBoxInstance.showDialog();

        });
    }


}



