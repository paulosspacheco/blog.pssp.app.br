class TMaskEdit {
    constructor(inputElement, mask) {
        this.inputElement = inputElement;
        this.mask = mask;
        this.inputElement.addEventListener('input', this.applyMask.bind(this));
        this.inputElement.addEventListener('focus', this.onFocus.bind(this));
        this.inputElement.addEventListener('blur', this.onBlur.bind(this));
    }

    onFocus() {
        // Limpa a máscara ao receber foco
        this.inputElement.value = this.clearMask(this.inputElement.value);
    }

    onBlur() {
        // Aplica a máscara genérica ao sair do campo
        this.applyGenericMask(this.inputElement.value);
    }

    applyMask() {
        const value = this.inputElement.value;
        let newValue = '';
        let maskIndex = 0;

        for (let i = 0; i < value.length; i++) {
            const char = value[i];

            if (maskIndex < this.mask.length) {
                const maskChar = this.mask[maskIndex];

                switch (maskChar) {
                    case '0': // Apenas números
                        if (/\d/.test(char)) {
                            newValue += char;
                            maskIndex++;
                        }
                        break;
                    case '#': // Apenas números (caractere alfanumérico)
                        if (/\d/.test(char)) {
                            newValue += char;
                            maskIndex++;
                        }
                        break;
                    case 's': // Alfanumérico, qualquer caractere
                        newValue += char;
                        maskIndex++;
                        break;
                    case 'S': // Alfanumérico, somente maiúsculas
                        newValue += char.toUpperCase();
                        maskIndex++;
                        break;
                    default: // Caracteres da máscara (como -)
                        newValue += maskChar;
                        maskIndex++;
                        i--; // Permite que o mesmo caractere seja verificado novamente
                        break;
                }
            }
        }

        this.inputElement.value = newValue;
    }

    applyGenericMask(value) {
        let maskedValue = '';
        let maskIndex = 0;

        for (let i = 0; i < this.mask.length; i++) {
            const maskChar = this.mask[i];

            if (maskChar === '0' || maskChar === '#' || maskChar === 's' || maskChar === 'S') {
                if (maskIndex < value.length) {
                    maskedValue += value[maskIndex++];
                } else {
                    break; // Sai do loop se não houver mais caracteres a adicionar
                }
            } else {
                maskedValue += maskChar; // Adiciona caracteres fixos da máscara
            }
        }

        this.inputElement.value = maskedValue;
    }

    clearMask(value) {
        // Remove os caracteres da máscara e retorna o valor puro
        return value.replace(/[^0-9A-Za-z]/g, '');
    }
}

// Inicializando a classe TMaskEdit para todos os inputs com máscara
document.querySelectorAll('input[data-mask]').forEach(input => {
    const mask = input.getAttribute('data-mask');
    new TMaskEdit(input, mask);
});
