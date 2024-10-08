class TMaskEdit {
    constructor(inputElement, mask, maskType) {
        this.inputElement = inputElement;
        this._mask = mask;
        this.maskType = maskType;
        this.lastValidValue = '';

        // Vinculando corretamente os métodos ao escopo da instância
        this.onFocus = this.onFocus.bind(this);
        this.onBlur = this.onBlur.bind(this);
        this.onInput = this.onInput.bind(this);
        this.onKeyDown = this.onKeyDown.bind(this);

        // Adicionando os event listeners
        this.inputElement.addEventListener('focus', this.onFocus);
        this.inputElement.addEventListener('blur', this.onBlur);
        this.inputElement.addEventListener('input', this.onInput);
        this.inputElement.addEventListener('keydown', this.onKeyDown);
    }

    cleanValue(value) {
        if (this.isMonetaryMask()) {
            return value.replace(/[^\d-]/g, ''); // Apenas números para máscara monetária
        } else if (this.maskType === 'S') {
            // Aceitar todos os caracteres, mas converter letras para maiúsculas
            return value.toUpperCase();
        } else if (this.maskType === 's') {
            // Aceitar letras minúsculas, maiúsculas, números e espaços
            return value;
        } else {
            return value.replace(/\D/g, ''); // Para outros tipos, apenas números
        }
    }

    applyGenericMask(value) {
        let cleanValue = this.cleanValue(value);
        let maskedValue = '';
        let valueIndex = 0;

        for (let i = 0; i < this._mask.length; i++) {
            const maskChar = this._mask[i];

            if (maskChar === '#' || maskChar === '0' || maskChar === 'S' || maskChar === 's') {
                if (valueIndex < cleanValue.length) {
                    let currentChar = cleanValue[valueIndex];

                    // Aplica as regras de maiúsculas/minúsculas
                    if (maskChar === 'S') {
                        maskedValue += currentChar.toUpperCase(); // Converte para maiúsculas
                    } else if (maskChar === 's') {
                        maskedValue += currentChar; // Mantém o valor
                    } else {
                        maskedValue += currentChar; // Para # e 0, apenas adiciona o valor
                    }

                    valueIndex++;
                } else {
                    break;
                }
            } else {
                maskedValue += maskChar; // Insere caracteres especiais da máscara (ex: '-')
            }
        }

        return maskedValue;
    }

    // Método de evento para input
    onInput(event) {
        const newValue = this.inputElement.value;
        const maskedValue = this.applyGenericMask(newValue);

        this.inputElement.value = maskedValue;
        this.lastValidValue = maskedValue;
    }

    // Exemplo de método onFocus (adapte conforme necessário)
    onFocus(event) {
        // Adicione seu comportamento de foco aqui
    }

    // Exemplo de método onBlur (adapte conforme necessário)
    onBlur(event) {
        // Adicione seu comportamento de blur aqui
    }

    // Exemplo de método onKeyDown (adapte conforme necessário)
    onKeyDown(event) {
        // Adicione seu comportamento de tecla pressionada aqui
    }

    isMonetaryMask() {
        return this.maskType === '$';
    }
}

// Inicializando a classe TMaskEdit para todos os inputs com máscara
document.querySelectorAll('input[data-mask]').forEach(input => {
    const mask = input.getAttribute('data-mask');
    const maskType = input.getAttribute('data-mask-type');

    // Certifique-se de que todos os inputs tenham máscara e tipo de máscara antes de instanciar
    if (mask && maskType) {
        new TMaskEdit(input, mask, maskType);
    }
});
