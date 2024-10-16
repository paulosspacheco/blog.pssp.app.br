// MiFormattedInput.js

import { MiConsts } from './MiConsts.js';
import { MiMethods } from './MiMethods.js';

export class MiFormattedInput extends MiMethods{

    constructor(inputElement) {
        super(); // Chama o construtor da classe pai
        this.inputElement = inputElement;
        this.mask = inputElement.dataset.mask;
        this.maskType = inputElement.dataset.maskType;

        // Adiciona o evento para formatar enquanto o usuário digita
        this.inputElement.addEventListener('input', this.formatInput.bind(this));
    }

    formatInput(event) {

        let cursorPosition = event.target.selectionStart; // Mova para fora do bloco try
        try {
            let inputValue = event.target.value;
            const originalLength = inputValue.length; // Salva o comprimento original antes da formatação

            //try {
                // Aplica a formatação de acordo com o tipo de máscara
                switch (this.maskType) {
                    case '#':
                        event.target.value = MiMethods.formatValue(inputValue, this.mask);
                        break;
                    case 'r':  // Monetário (positivo)
                        event.target.value = MiMethods.formatValue(inputValue, this.mask);
                        break;
                    case 'R':  // Monetário (positivo e negativo)
                        event.target.value = MiMethods.formatValue(inputValue, this.mask);
                        break;
                    case 'O':  // LongInt (-99.999,99 a +99.999,99)
                        event.target.value = MiMethods.formatValue(inputValue, this.mask);
                        break;
                    case 'o':  // LongInt (0 a +99.999,99)
                        event.target.value = MiMethods.formatValue(inputValue, this.mask);
                        break;
                    case 'B':  // Byte (0 a 254)
                        event.target.value = MiMethods.formatValue(MiMethods.rangeValueInteger(inputValue, 0, 254), this.mask);
                        break;
                    case 'J':  // ShortInt (-126 a +127)
                        event.target.value = MiMethods.formatValue(MiMethods.rangeValueInteger(inputValue, -126, 127), this.mask);
                        break;
                    case 'I':  // SmallInt (-32,768 a 32,767)
                        event.target.value = MiMethods.formatValue(MiMethods.rangeValueInteger(inputValue, -32768, 32767), this.mask);
                        break;
                    case 'W':  // SmallWord (0 a +65,535)
                        event.target.value = MiMethods.formatValue(MiMethods.rangeValueInteger(inputValue, 0, 65535), this.mask);
                        break;
                    case 'L':  // LongInt (-2.147.483.648 a +2.147.483.647)
                        event.target.value = MiMethods.formatValue(MiMethods.rangeValueInteger(inputValue, -2147483648, 2147483647), this.mask);
                        break;
                    default:
                        event.target.value = inputValue;
                }
            //} catch (error) {
            //    console.error("Erro ao aplicar a formatação:", error); // Trata a exceção de formatação
            //}

            const newLength = event.target.value.length; // Salva o comprimento após a formatação

            // Ajusta a posição do cursor com base na diferença de comprimento
            cursorPosition += (newLength - originalLength);

        } finally {

            // Restaura a posição do cursor ajustada
            event.target.setSelectionRange(cursorPosition, cursorPosition);
        }
    }


//
//    formatInput(event) {
//        let cursorPosition = event.target.selectionStart; // Posição do cursor antes da formatação
//        let inputValue = event.target.value;            
//        const originalLength = inputValue.length; // Salva o comprimento original antes da formatação
//        
//        try {
//            
//            try {
//                // Aplica a formatação de acordo com o tipo de máscara
//                switch (this.maskType) {
//                    case '#':
//                    case 'r':
//                    case 'R':
//                    case 'O':
//                    case 'o':
//                        event.target.value = MiMethods.formatValue(inputValue, this.mask);
//                        break;
//                    case 'B':
//                        event.target.value = MiMethods.formatValue(
//                            MiMethods.rangeValueInteger(inputValue, 0, 254), 
//                            this.mask
//                        );
//                        break;
//                    case 'J':
//                        event.target.value = MiMethods.formatValue(
//                            MiMethods.rangeValueInteger(inputValue, -126, 127), 
//                            this.mask
//                        );
//                        break;
//                    case 'I':
//                        event.target.value = MiMethods.formatValue(
//                            MiMethods.rangeValueInteger(inputValue, -32768, 32767), 
//                            this.mask
//                        );
//                        break;
//                    case 'W':
//                        event.target.value = MiMethods.formatValue(
//                            MiMethods.rangeValueInteger(inputValue, 0, 65535), 
//                            this.mask
//                        );
//                        break;
//                    case 'L':
//                        event.target.value = MiMethods.formatValue(
//                            MiMethods.rangeValueInteger(inputValue, -2147483648, 2147483647), 
//                            this.mask
//                        );
//                        break;
//                    default:
//                        event.target.value = inputValue; // Se não houver máscara correspondente, mantém o valor original
//                }
//            } catch (error) {
//                console.error("Erro ao aplicar a formatação:", error); // Trata a exceção de formatação
//            }   
//        
//        } finally {
//            const newLength = event.target.value.length; // Salva o comprimento após a formatação
//   
//            // Ajusta a posição do cursor com base na diferença de comprimento
//            cursorPosition += (newLength - originalLength);
//
//            // Restaura a posição do cursor ajustada
//            event.target.setSelectionRange(cursorPosition, cursorPosition);
//        }
//    }
//        
}

// Função para inicializar todos os campos com máscara
function initializeFormattedInputs() {
    const inputElements = document.querySelectorAll('[data-mask]');
    inputElements.forEach(inputElement => new MiFormattedInput(inputElement));
}

// Inicializa quando a página estiver carregada
document.addEventListener('DOMContentLoaded', initializeFormattedInputs);
