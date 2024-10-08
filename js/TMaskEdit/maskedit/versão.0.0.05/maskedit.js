class TMaskEdit {
    static getFormatValue(aValue, aMask) {
        let result = '';
    
        if (aMask[0] === 'FldDateTime') {
            // Tratamento especial para FldDateTime
            result = aValue; // Placeholder para tratamento de datas
        } else {
            let lenS = aValue.length;
            let posS = 0;
            let len_aMask = aMask.length;
            let s = String(aValue);
            let r = 0;
    
            // Checa se a máscara é número relativo
            if (aMask.includes('fldReal4P') || aMask.includes('fldReal4PPositivo')) {
                r = parseFloat(aValue);
                r = r * 100;
                s = this.strNum(aMask, r, 'fldExtended'); // Você precisaria implementar strNum
                if (s.includes(this.showDecimalSeparator)) {
                    s = s.replace(this.showDecimalSeparator, this.decimalSeparator);
                }
            }
    
            // Gera a máscara
            for (let i = len_aMask - 1; i >= 0; i--) {
                switch (aMask[i]) {
                    case 'fldAnsiChar':
                    case 'fldAnsiChar_Lowcase':
                    case 'fldAnsiCharVAL':
                    case 'fldSTRNUM':
                    case 'fldSTR':
                    case 'fldRealNum':
                    case 'fldReal4':
                    case 'fldReal4Positivo':
                    case 'fldReal4P':
                    case 'fldReal4PPositivo':
                    case 'fldRealNum_Positivo':
                    case 'fldExtended':
                    case 'fldENum':
                    case 'fldENum_db':
                    case 'fldBOOLEAN':
                    case 'fldBYTE':
                    case 'fldSHORTINT':
                    case 'fldSmallWORD':
                    case 'fldSmallInt':
                    case 'fldLONGINT':
                    case 'FldRadioButton':
                        if (lenS >= 1) {
                            result = s[lenS - 1] + result;
                            lenS--;
                        }
                        break;
    
                    case 'fldstr_Lowcase':
                        if (lenS >= 1) {
                            result = s[lenS - 1].toLowerCase() + result;
                            lenS--;
                        }
                        break;
    
                    default:
                        if (lenS >= 1) {
                            result = aMask[i] + result;
                        }
                        break;
                }
            }
        }
    
        return result;
    }
    
    static strNum(mask, value, type) {
        // Implementar a função de formatação de número
        // Esta função deve lidar com o valor, a máscara e o tipo
        // como no Pascal
        return value.toString(); // Placeholder
    }
    
    static get decimalSeparator() {
        return ','; // Define o separador decimal como vírgula
    }
    
    static get showDecimalSeparator() {
        return '.'; // Define o caractere separador a ser exibido
    }

    constructor(inputElement, mask, maskType) {
        this.inputElement = inputElement;
        this._mask = mask;
        this._maskType = maskType;

        this.inputElement.addEventListener('input', this.onInput.bind(this));
        this.inputElement.addEventListener('blur', this.onBlur.bind(this));
        this.inputElement.addEventListener('focus', this.onFocus.bind(this));
    }

    onInput(event) {
        let value = event.target.value;
        value = this.formatValue(value);
        event.target.value = value; // Atualiza o valor do input após aplicar a máscara
    }

    onBlur(event) {
        let value = event.target.value;
        value = this.formatValue(value); // Aplica a formatação ao perder o foco
        event.target.value = value; // Atualiza o valor do input após aplicar a máscara
    }

    onFocus(event) {
        let value = event.target.value;
        event.target.value = value; // Mantém o valor ao receber foco
    }

    formatValue(value) {
        return TMaskEdit.getFormatValue(value, this._mask);      
    }
}

// Inicializando a classe TMaskEdit para todos os inputs com máscara
document.querySelectorAll('input[data-mask]').forEach(input => {
    const mask = input.getAttribute('data-mask');
    const maskType = input.getAttribute('data-mask-type');

    new TMaskEdit(input, mask, maskType);
});
