import { MiMethods } from './MiMethods.js';

//================================================================
//Classe  FormFieldsContainer

class FormFieldsContainer {
    constructor() {
        this.container = document.createElement('div');
        this.container.className = 'inputBox-dialog-form-fields';
        this.fontSize = 12; // Tamanho da fonte em pixels
        this.charWidth = this.fontSize * 0.6; // Estimativa para a largura de cada caractere
        this.minWidth = 50; // Largura mínima dos inputs e labels em pixels
    }

    // Método para calcular a largura de um texto em pixels
    getTextWidth(text, fontSize) {
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        context.font = `${fontSize}px Arial`;
        return context.measureText(text).width;
    }

    // Método para adicionar uma linha de campos ao contêiner
    addFieldRow(line) {
        const fieldsetElement = document.createElement('div');
        fieldsetElement.className = 'inputBox-dialog-form-row';

        line.forEach((field) => {
            const fieldContainer = document.createElement('div');

            // Cria o label do campo
            const labelElement = document.createElement('label');
            labelElement.innerText = `${field.label}: `;
            labelElement.className = field.align === 'right' ? 'align-right' : 'align-left';

            // Cria o input do campo
            const inputField = document.createElement('input');
            inputField.type = 'text';
            inputField.maxLength = field.maxLength;

            // Adiciona o `id` e `name` do campo, se especificados
            if (field.id) {
                inputField.id = field.id;
            }
            if (field.name) {
                inputField.name = field.name;
            }

            // Verifica se é um campo vazio e ajusta para invisível se necessário
            if (field.label === '' && field.maxLength === 0) {
                inputField.classList.add('hidden');
                labelElement.classList.add('hidden');
            } else {
                // Calcula a largura do input com base no maxLength, aplicando uma largura mínima
                const inputWidth = field.maxLength > 0 
                    ? Math.max(field.maxLength * this.charWidth, this.minWidth) // Aplica a largura mínima
                    : Math.max(this.getTextWidth(inputField.value, this.fontSize) + 10, this.minWidth);
                
                inputField.style.width = `${inputWidth}px`;
            }

            fieldContainer.appendChild(labelElement);
            fieldContainer.appendChild(inputField);
            fieldsetElement.appendChild(fieldContainer);
        });

        this.container.appendChild(fieldsetElement);
    }

    // Método para ajustar as larguras das colunas
    adjustColumnWidths() {
        const rows = this.container.querySelectorAll('.inputBox-dialog-form-row');
        const columnWidths = [];

        // Itera sobre cada linha e calcula as larguras das colunas
        rows.forEach(row => {
            const labels = row.querySelectorAll('label');
            const inputs = row.querySelectorAll('input');

            labels.forEach((label, index) => {
                const labelWidth = Math.max(this.getTextWidth(label.innerText, this.fontSize), this.minWidth); // Aplica a largura mínima
                if (!columnWidths[index]) columnWidths[index] = 0;
                columnWidths[index] = Math.max(columnWidths[index], labelWidth);
            });

            inputs.forEach((input, index) => {
                const inputWidth = Math.max(input.offsetWidth, this.minWidth); // Aplica a largura mínima
                if (!columnWidths[index]) columnWidths[index] = 0;
                columnWidths[index] = Math.max(columnWidths[index], inputWidth);
            });
        });

        // Ajusta a largura de labels e inputs com base na largura máxima calculada
        rows.forEach(row => {
            const labels = row.querySelectorAll('label');
            const inputs = row.querySelectorAll('input');

            labels.forEach((label, index) => {
                if (index < columnWidths.length) {
                    label.style.width = `${columnWidths[index]}px`;
                }
            });

            inputs.forEach((input, index) => {
                if (index < columnWidths.length) {
                    input.style.width = `${columnWidths[index]}px`;
                }
            });
        });
    }

    getElement() {
        return this.container;
    }
}


export class InputBox {
    constructor(title, template) {
        this.fields = [];
        this.title = title; // Armazena o título
        const lines = template.split('\n');

        this.parseTemplate(template); // Chama o método para processar o template

        // Inclui o CSS dinamicamente no documento, verificando se já está presente
        if (!document.querySelector('link[href="../css/input_Box.css"]')) {
            MiMethods.includeCSS('../css/input_Box.css');
        }          
    }
    
    // # Método `parseTemplate`
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

    // Método para coletar os valores dos campos e fechar a caixa de diálogo    
    onOkButtonClick(overlay, resolve) {
        const inputValues = {};

        // Função para processar cada campo individualmente
        const processField = function(field, lineIndex, fieldIndex) {
            // Garante que field.id está definido, se não cria um valor padrão
            const inputFieldId = field.id || `${field.name || 'field'}_${lineIndex}_${fieldIndex}`;
            
            const inputField = document.getElementById(inputFieldId);
            
            if (inputField && field.name) { // Verifica se o campo existe e tem name definido
                inputValues[field.name] = inputField.value.trim(); // Armazena o valor usando o name
            }
        };

        // Função para processar cada linha do formulário
        const processLine = function(line, lineIndex) {
            line.forEach(function(field, fieldIndex) {
                processField(field, lineIndex, fieldIndex);
            });
        };

        // Itera sobre as linhas e chama a função para cada linha
        this.fields.forEach(function(line, lineIndex) {
            processLine(line, lineIndex);
        });

        // console.log('Valores de entrada:', inputValues); // Exibe os valores no console
        document.body.removeChild(overlay);
        resolve(inputValues);
    }


    // Método para criar uma caixa de diálogo com base no array this.fields
    showInputBox(resolve) {
        const overlay = document.createElement('div');
        overlay.className = 'inputBox-dialog-overlay';
    
        const form = document.createElement('div');
        form.className = 'inputBox-dialog-box'; // Caixa de diálogo
    
        // Configura o título
        const titleElement = document.createElement('h2');
        titleElement.innerText = this.title;
        form.appendChild(titleElement);
    
        // Cria uma instância de FormFieldsContainer
        const formFieldsContainer = new FormFieldsContainer();
    
        // Adiciona as linhas do template ao contêiner
        this.fields.forEach(line => formFieldsContainer.addFieldRow(line));
    
        // Ajusta a largura das colunas
        formFieldsContainer.adjustColumnWidths();
    
        // Adiciona o contêiner de campos ao formulário
        form.appendChild(formFieldsContainer.getElement());
    
        // Configura botões OK e Cancelar
        const buttonContainer = document.createElement('div');
        buttonContainer.className = 'inputBox-dialog-button-container';
    
        const okButton = document.createElement('button');
        okButton.innerText = 'OK';
        okButton.onclick = () => this.onOkButtonClick(overlay, resolve);
    
        const cancelButton = document.createElement('button');
        cancelButton.innerText = 'Cancelar';
        cancelButton.onclick = () => {
            document.body.removeChild(overlay);
            resolve(null); // Resolve a Promise com null se o usuário cancelar
        };
    
        buttonContainer.appendChild(okButton);
        buttonContainer.appendChild(cancelButton);
        form.appendChild(buttonContainer);
    
        overlay.appendChild(form);
        document.body.appendChild(overlay);
    }
    
        
    // Método estático para criar a caixa de entrada e retornar uma promessa com os dados
    static inputBox(title, template) {
        return new Promise((resolve) => {
            const inputBox = new InputBox(title, template);
            inputBox.showInputBox(resolve);
        });
    }
}



