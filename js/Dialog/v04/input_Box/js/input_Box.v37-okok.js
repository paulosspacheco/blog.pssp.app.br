import { MiMethods } from './MiMethods.js';


class FormFieldsContainer {
    constructor() {
        this.container = document.createElement('div');
        this.container.className = 'inputBox-dialog-form-fields'; // Classe padrão para o contêiner
        this.container.style.overflowX = 'auto'; // Permite rolagem horizontal
        this.container.style.whiteSpace = 'nowrap'; // Impede a quebra de linha
    }

    // Método para adicionar uma linha de campos ao contêiner
    addFieldRow(line) {
        const fieldsetElement = document.createElement('div');
        fieldsetElement.className = 'inputBox-dialog-form-row'; // Uma linha de campos

        line.forEach((field, fieldIndex) => {
            const labelElement = document.createElement('label');
            labelElement.innerText = `${field.label} `;
            labelElement.classList.add(field.align === 'right' ? 'align-right' : 'align-left');

            const inputField = document.createElement('input');
            inputField.type = 'text';
            inputField.maxLength = field.maxLength;

            const inputFieldId = `${field.label.replace(/\s+/g, '_')}_${fieldIndex}`;
            inputField.id = inputFieldId;

            // Adiciona rótulo e input ao fieldset
            fieldsetElement.appendChild(labelElement);
            fieldsetElement.appendChild(inputField);
        });

        // Adiciona a linha de campos ao contêiner
        this.container.appendChild(fieldsetElement);
    }

    // Método para obter o elemento do contêiner
    getElement() {
        return this.container;
    }
}


export class InputBox {
    constructor(title, template) {
        this.fields = [];
        this.title = title; // Armazena o título
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

                        // Conta quantos 's' existem após a barra invertida
                        while (i < line.length && line[i] === 's') {
                            inputLength++;
                            i++;
                        }
                  
                        // Adiciona o campo se um label foi encontrado
                        if (currentLabel) {
                            currentLine.push({
                                label: currentLabel,
                                maxLength: inputLength,
                                align: line.trim().startsWith('~') ? 'right' : 'left' // Alinha baseado na presença de '~' no início
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

        // Inclui o CSS dinamicamente no documento, verificando se já está presente
        if (!document.querySelector('link[href="../css/input_Box.css"]')) {
            MiMethods.includeCSS('../css/input_Box.css');
        }          
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

        // Arrays para armazenar larguras máximas
        const maxLabelWidth = [];
        const maxInputWidth = [];

        // Assume um tamanho de fonte padrão (em pixels)
        const fontSize = 16; // Ajuste este valor conforme necessário

        this.fields.forEach((line, lineIndex) => {
            // Adiciona a linha de campos ao contêiner
            formFieldsContainer.addFieldRow(line);
        });

        // Calcular e aplicar larguras máximas
        const maxLabelWidthValue = Math.max(...maxLabelWidth);
        const maxInputWidthValue = Math.max(...maxInputWidth);

        // Aplicar larguras máximas
        formFieldsContainer.getElement().querySelectorAll('label').forEach(label => {
            label.style.width = `${maxLabelWidthValue}px`;
        });
        
        formFieldsContainer.getElement().querySelectorAll('input').forEach(input => {
            input.style.width = `${maxInputWidthValue}px`;
        });

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



