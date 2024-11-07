import { MiMethods } from './MiMethods.js';

//================================================================
//Classe  FormFieldsContainer

class FormFieldsContainer {
    constructor() {
        this.container = document.createElement('div');
        this.container.className = 'inputBox-dialog-form-fields';
        this.container.style.overflowX = 'auto'; // Permite rolagem horizontal
        this.container.style.whiteSpace = 'nowrap'; // Impede a quebra de linha
        this.container.style.display = 'flex';
        this.container.style.flexDirection = 'column'; // Organiza as linhas verticalmente
        this.fontSize = 16; // Tamanho da fonte em pixels
        this.charWidth = this.fontSize * 0.6; // Estimativa para a largura de cada caractere
    }

    // Método para calcular a largura de um texto em pixels
    getTextWidth(text, fontSize) {
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        context.font = `${fontSize}px 'Courier New'`; // Use uma fonte monoespaçada
        return context.measureText(text).width;
    }

    // Método para adicionar uma linha de campos ao contêiner

    addFieldRow(line) {
        const fieldsetElement = document.createElement('div');
        fieldsetElement.className = 'inputBox-dialog-form-row';
        fieldsetElement.style.display = 'flex';
        fieldsetElement.style.justifyContent = 'space-between';
        fieldsetElement.style.width = '100%'; // Garante que cada linha ocupe toda a largura disponível
    
        line.forEach((field, fieldIndex) => {
            const fieldContainer = document.createElement('div');
            fieldContainer.style.display = 'flex';
            fieldContainer.style.alignItems = 'center';
            fieldContainer.style.marginRight = '10px'; // Espaçamento entre campos
    
            // Cria o label do campo
            const labelElement = document.createElement('label');
            labelElement.innerText = `${field.label}: `;
            labelElement.style.minWidth = '50px'; // Largura mínima para os labels
    
            // Determine o alinhamento do rótulo
            if (field.align === 'right') {
                labelElement.style.textAlign = 'right';
                labelElement.style.marginRight = '5px';
                fieldContainer.style.justifyContent = 'flex-end'; // Alinha o container à direita
            } else {
                labelElement.style.textAlign = 'left';
                labelElement.style.marginRight = '5px';
            }
    
            // Cria o input do campo
            const inputField = document.createElement('input');
            inputField.type = 'text';
            inputField.maxLength = field.maxLength;
    
            // Verifica se é um campo vazio e ajusta para invisível se necessário
            if (field.label === '' && field.maxLength === 0) {
                inputField.style.visibility = 'hidden'; // Campo invisível, mas ocupa espaço
                inputField.style.width = '1px'; // Mantém largura mínima para alinhamento
                labelElement.style.visibility = 'hidden'; // Torna o label invisível também
            } else {
                // Calcula a largura do input com base no maxLength
                const inputWidth = field.maxLength * this.charWidth;
                inputField.style.width = `${inputWidth}px`;
            }
    
            inputField.style.flexShrink = '0'; // Evita que o input encolha
            inputField.id = `${field.label.replace(/\s+/g, '_')}_${fieldIndex}`;
    
            fieldContainer.appendChild(labelElement);
            fieldContainer.appendChild(inputField);
            fieldsetElement.appendChild(fieldContainer);
        });
    
        this.container.appendChild(fieldsetElement);
    }
    
    
    adjustColumnWidths() {
        const rows = this.container.querySelectorAll('.inputBox-dialog-form-row'); // Seleciona todas as linhas
        const columnWidths = []; // Array para armazenar a largura máxima de cada coluna
    
        // Itera sobre cada linha para calcular as larguras
        rows.forEach(row => {
            const labels = row.querySelectorAll('label');
            const inputs = row.querySelectorAll('input');
    
            labels.forEach((label, index) => {
                // Calcula a largura do label
                const labelWidth = this.getTextWidth(label.innerText, this.fontSize);
    
                // Inicializa a largura da coluna se não existir
                if (!columnWidths[index]) {
                    columnWidths[index] = 0;
                }
                // Atualiza a largura máxima da coluna se necessário
                columnWidths[index] = Math.max(columnWidths[index], labelWidth);
            });
    
            inputs.forEach((input, index) => {
                // Calcula a largura do input
                const inputWidth = input.offsetWidth; // Obtenha a largura do input
    
                // Inicializa a largura da coluna se não existir
                if (!columnWidths[index]) {
                    columnWidths[index] = 0;
                }
                // Atualiza a largura máxima da coluna se necessário
                columnWidths[index] = Math.max(columnWidths[index], inputWidth);
            });
        });
    
        // Aplica a largura máxima calculada para todos os labels e inputs
        rows.forEach(row => {
            const labels = row.querySelectorAll('label');
            const inputs = row.querySelectorAll('input');
    
            labels.forEach((label, index) => {
                if (index < columnWidths.length) {
                    label.style.width = `${columnWidths[index]}px`; // Ajusta a largura do label
                }
            });
    
            inputs.forEach((input, index) => {
                if (index < columnWidths.length) {
                    input.style.width = `${columnWidths[index]}px`; // Ajusta a largura do input
                }
            });
        });
    }
    

    
    getElement() {
        return this.container;
    }
}

// Exemplo de uso
// const container = new FormFieldsContainer();
// const inputBoxTemplate = [
//     [
//         { label: 'Nome do Aluno', maxLength: 30 },
//         { label: 'Idade', maxLength: 3 },
//         { label: 'Nome do pai', maxLength: 30 }
//     ],
//     [
//         { label: 'Endereço', maxLength: 50 },
//         { label: 'Número', maxLength: 5 },
//         { label: 'Nome da mãe', maxLength: 30 }
//     ]
// ];

// inputBoxTemplate.forEach(line => container.addFieldRow(line));
// container.adjustColumnWidths();
// document.body.appendChild(container.getElement());




//================================================================
//Classe  InputBox

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
                                align: align
                            });
                            currentLabel = ''; // Reseta o label após adicionar
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
        this.fields.forEach((line, lineIndex) => {
            line.forEach((field, fieldIndex) => {
                const inputFieldId = `${field.label.replace(/\s+/g, '_')}_${lineIndex}_${fieldIndex}`;
                const inputField = document.getElementById(inputFieldId);
                if (inputField) {
                    inputValues[field.label] = inputField.value;
                }
            });
        });

        console.log('Valores de entrada:', inputValues); // Exibe os valores no console
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


