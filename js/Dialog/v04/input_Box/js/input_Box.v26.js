// input_Box.js

import { MiMethods } from './MiMethods.js';

export class InputBox {
    constructor(title,template ) { // Adiciona o título como parâmetro
        this.fields = [];
        this.title = title; // Armazena o título
        const lines = template.split('\n');

        lines.forEach((line, lineIndex) => {
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
                        if (inLabel) {
                            inLabel = false; // Finaliza a leitura do label
                        } else {
                            currentLabel = ''; // Reseta o label
                            inLabel = true; // Inicia a leitura do label
                        }
                        break;
                    case '\\':
                        i++; // Move para o próximo caractere
                        inputLength = 0; // Reinicia o comprimento para o novo campo

                        // Conta quantos 's' existem após a barra invertida
                        while (i < line.length && line[i] === 's') {
                            inputLength++;
                            i++;
                        }

                        // Adiciona o campo se um label foi encontrado
                        if (currentLabel) {
                            currentLine.push({
                                label: currentLabel.trim(),
                                maxLength: inputLength
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

    // Função para ajustar a largura da caixa de diálogo
    adjustDialogWidth(dialog) {
        // Define a largura mínima e máxima da caixa de diálogo
        const minWidth = 250; // largura mínima padrão
        const maxWidth = window.innerWidth * 0.9; // largura máxima com base na largura da janela
        let totalWidth = 0;

        // Calcula a largura total dos rótulos e campos
        Array.from(dialog.querySelectorAll('.inputBox-dialog-form-row')).forEach(row => {
            let rowWidth = 0;

            // Calcula a largura de cada rótulo e campo
            Array.from(row.children).forEach(child => {
                if (child.tagName === 'LABEL' || child.tagName === 'INPUT') {
                    const computedStyle = getComputedStyle(child);
                    const childWidth = child.offsetWidth + 
                                    parseFloat(computedStyle.marginLeft) + 
                                    parseFloat(computedStyle.marginRight);

                    rowWidth += childWidth; // Adiciona a largura do rótulo ou campo
                }
            });

            // Adiciona margens ou paddings se necessário
            rowWidth += 20; // Adiciona uma margem para espaçamento

            // Verifica se a largura da linha atual é maior do que a largura total já calculada
            totalWidth = Math.max(totalWidth, rowWidth);
        });

        // Ajusta a largura da caixa de diálogo
        dialog.style.width = `${Math.min(Math.max(minWidth, totalWidth), maxWidth)}px`;
    }

    // Função para ajustar a altura da caixa de diálogo
// Função para ajustar a altura da caixa de diálogo
    adjustDialogHeight(dialog) {
        // Calcula a altura total baseada em cada linha
        const totalHeight = Array.from(dialog.querySelectorAll('.inputBox-dialog-form-row')).reduce((sum, row) => {
            return sum + row.offsetHeight + parseFloat(getComputedStyle(row).marginBottom);
        }, 0);

        // Altura mínima garantida
        const minHeight = Math.max(150, totalHeight + 50); // +50 para um padding extra
        dialog.style.height = `${minHeight}px`; // Define a altura da caixa de diálogo
    }

    showInputBox() {
        const overlay = document.createElement('div');
        overlay.className = 'inputBox-dialog-overlay';
    
        const form = document.createElement('div');
        form.className = 'inputBox-dialog-box';
    
        // Título
        const titleElement = document.createElement('h2');
        titleElement.innerText = this.title; // Título definido no construtor
        form.appendChild(titleElement); 
    
        // Contêiner para os campos
        const formFieldsContainer = document.createElement('div');
        formFieldsContainer.className = 'inputBox-dialog-form-fields'; // Use a nova classe para os campos
    
        // Adiciona campos
        this.fields.forEach((line, lineIndex) => {
            const fieldsetElement = document.createElement('div');
            fieldsetElement.className = 'inputBox-dialog-form-row';
    
            line.forEach((field, fieldIndex) => {
                const labelElement = document.createElement('label');
                labelElement.innerText = field.label + ' ';
                labelElement.setAttribute('for', field.label);
                fieldsetElement.appendChild(labelElement);
    
                const inputField = document.createElement('input');
                inputField.type = 'text';
                inputField.maxLength = field.maxLength;
    
                const inputFieldId = `${field.label.replace(/\s+/g, '_')}_${lineIndex}_${fieldIndex}`;
                inputField.id = inputFieldId;
    
                inputField.style.width = `${Math.max(50, field.maxLength * 8)}px`;
                inputField.style.boxSizing = 'border-box';
    
                fieldsetElement.appendChild(inputField);
            });
    
            formFieldsContainer.appendChild(fieldsetElement);
        });
    
        // Adiciona o contêiner de campos ao formulário
        form.appendChild(formFieldsContainer);
    
        // Botões
        const buttonContainer = document.createElement('div');
        buttonContainer.className = 'inputBox-dialog-button-container';
    
        // Botão OK
        const okButton = document.createElement('button');
        okButton.innerText = 'OK';
        okButton.onclick = () => {
            // Lógica para botão OK...
        };
    
        // Botão Cancelar
        const cancelButton = document.createElement('button');
        cancelButton.innerText = 'Cancelar';
        cancelButton.onclick = () => {
            document.body.removeChild(overlay);
        };
    
        buttonContainer.appendChild(okButton);
        buttonContainer.appendChild(cancelButton);
    
        // Adiciona os botões ao formulário
        form.appendChild(buttonContainer);
    
        // Adiciona o formulário ao overlay
        overlay.appendChild(form);
        
        // Adiciona o overlay ao body
        document.body.appendChild(overlay);
    }
    
}    
