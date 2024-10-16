// MiFormattedInput.js

import { MiConsts } from './MiConsts.js';
import { MiMethods } from './MiMethods.js';

export class MiFormattedInput extends MiMethods {
    
    constructor(inputElement) {
        super(); // Chama o construtor da classe pai
        this.inputElement = inputElement;
        this.mask = inputElement.dataset.mask;
        this.maskType = inputElement.dataset.maskType;

//        this.originalValue = null; // Atributo para armazenar o valor original
//        this.isMultiplied = false; // Atributo para rastrear se já foi multiplicado


        // Adiciona eventos para formatar e restaurar o valor
        this.inputElement.addEventListener('focusin', this.handleFocusIn.bind(this));

        //Desativeis os dois eventos abaixo porque o número relativo dever ser multiplicado por 100
        //quando o registro é lido do servidor e dividido por 100 antes de enviar para o servidor.
        //this.inputElement.addEventListener('focusout', this.handleFocusOut.bind(this));
        //this.inputElement.addEventListener('input', this.formatInput.bind(this));
    }


    //handleFocusIn(event) {
    //    if ((this.maskType === 'p' || this.maskType === 'P') && !this.isMultiplied) {
    //        // Armazena o valor original
    //        this.originalValue = event.target.value;
    //
    //        // Multiplica por 100 para exibição
    //        if (!isNaN(parseFloat(this.originalValue))) {
    //            event.target.value = parseFloat(this.originalValue) * 100;
    //            this.isMultiplied = true; // Marca como já multiplicado
    //        }
    //    }
    //}
    //
    //handleFocusOut(event) {
    //    if (this.maskType === 'p' || this.maskType === 'P') {
    //        // Ao sair do campo, divide por 100 para restaurar o valor original
    //        let currentValue = event.target.value;
    //        if (!isNaN(parseFloat(currentValue))) {
    //            event.target.value = parseFloat(currentValue) / 100;
    //            this.isMultiplied = false; // Reseta o estado para a próxima vez
    //        }
    //    }
    //}

    formatInput(event) {
        let cursorPosition = event.target.selectionStart; // Posição do cursor antes da formatação
        let inputValue = event.target.value;
        const originalLength = inputValue.length; // Salva o comprimento original antes da formatação

        try {
            try {
                // Aplica a formatação de acordo com o tipo de máscara
                switch (this.maskType) {
                    case '#':
                    case 'r':
                    case 'R':
                    case 'O':
                    case 'o':
                    case 'P':
                    case 'p':
                        event.target.value = MiMethods.formatValue(inputValue, this.mask);
                        break;
                    case 'B':
                        event.target.value = MiMethods.formatValue(
                            MiMethods.rangeValueInteger(inputValue, 0, 254),
                            this.mask
                        );
                        break;
                    case 'J':
                        event.target.value = MiMethods.formatValue(
                            MiMethods.rangeValueInteger(inputValue, -126, 127),
                            this.mask
                        );
                        break;
                    case 'I':
                        event.target.value = MiMethods.formatValue(
                            MiMethods.rangeValueInteger(inputValue, -32768, 32767),
                            this.mask
                        );
                        break;
                    case 'W':
                        event.target.value = MiMethods.formatValue(
                            MiMethods.rangeValueInteger(inputValue, 0, 65535),
                            this.mask
                        );
                        break;
                    case 'L':
                        event.target.value = MiMethods.formatValue(
                            MiMethods.rangeValueInteger(inputValue, -2147483648, 2147483647),
                            this.mask
                        );
                        break;
                    default:
                        event.target.value = inputValue; // Se não houver máscara correspondente, mantém o valor original
                }
            } catch (error) {
                console.error("Erro ao aplicar a formatação:", error); // Trata a exceção de formatação
            }

        } finally {
            const newLength = event.target.value.length; // Salva o comprimento após a formatação

            // Ajusta a posição do cursor com base na diferença de comprimento
            cursorPosition += (newLength - originalLength);

            // Restaura a posição do cursor ajustada
            event.target.setSelectionRange(cursorPosition, cursorPosition);
        }
    }
}

// Função para inicializar todos os campos com máscara
function initializeFormattedInputs() {
    const inputElements = document.querySelectorAll('[data-mask]');
    inputElements.forEach(inputElement => new MiFormattedInput(inputElement));
}

// Inicializa quando a página estiver carregada
document.addEventListener('DOMContentLoaded', initializeFormattedInputs);
