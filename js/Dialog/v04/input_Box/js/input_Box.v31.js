// input_Box.js

import { MiMethods } from './MiMethods.js';

export class InputBox {
    constructor(title, template) {
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

    }

    // Método para coletar os valores dos campos e fechar a caixa de diálogo
    onOkButtonClick(overlay) {
        const inputValues = {};
        this.fields.forEach((line, lineIndex) => {
            line.forEach((field, fieldIndex) => {
                const inputFieldId = `${field.label.replace(/\s+/g, '_')}_${lineIndex}_${fieldIndex}`;
                const inputField = document.getElementById(inputFieldId);
                if (inputField) {
                    inputValues[field.label] = inputField.value; // Armazena o valor da entrada
                }
            });
        });

        console.log('Valores de entrada:', inputValues); // Aqui você pode usar os valores como desejar

        // Remover a caixa de diálogo da tela
        document.body.removeChild(overlay);
    }

    // showInputBox agora recebe o callback resolve
    showInputBox(resolve) { 
        const overlay = document.createElement('div');
        overlay.className = 'inputBox-dialog-overlay';

        const form = document.createElement('div');
        form.className = 'inputBox-dialog-box';

        // Configura o título
        const titleElement = document.createElement('h2');
        titleElement.innerText = this.title;
        form.appendChild(titleElement);

        // Contêiner para os campos
        const formFieldsContainer = document.createElement('div');
        formFieldsContainer.className = 'inputBox-dialog-form-fields';

        this.fields.forEach((line, lineIndex) => {
            const fieldsetElement = document.createElement('div');
            fieldsetElement.className = 'inputBox-dialog-form-row';

            line.forEach((field, fieldIndex) => {
                const labelElement = document.createElement('label');
                labelElement.innerText = `${field.label} `;
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

        form.appendChild(formFieldsContainer);

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

// InputBox.inputBox('Informe seus dados', '~Nome: ~\\ssss\nIdade: ~\\ss')
//     .then((result) => {
//         if (result) {
//             console.log('Dados recebidos:', result);
//         } else {
//             console.log('Caixa de diálogo cancelada.');
//         }
//     });


    // document.addEventListener('DOMContentLoaded', () => {
    //     document.getElementById('showInputBoxBtn').addEventListener('click', () => {
    //         // Título e template para o InputBox
    //         const title = 'Formulário de Exemplo';
    //         const template = `
    //             Nome~\\sss
    //             Idade~\\ss
    //             Endereço~\\ssssssss
    //         `;

    //         // Chamar o método estático inputBox
    //         InputBox.inputBox(title, template).then(result => {
    //             console.log("Resultado final:", result); // Exibe o JSON no console
    //         });
    //     });
    // });
