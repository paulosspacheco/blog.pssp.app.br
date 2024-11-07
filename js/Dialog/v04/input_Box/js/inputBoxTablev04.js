export class InputBox {
    constructor(title, template) {
        this.fields = [];
        this.title = title; // Armazena o título
        this.tableContainer = document.createElement('div');
        this.tableContainer.className = 'table-container';
        this.table = document.createElement('table');
        this.table.className = 'inputBox-table';

        // Processa o template
        this.parseTemplate(template);

        // Inclui o CSS dinamicamente no documento, verificando se já está presente
        if (!document.querySelector('link[href="../css/input_Box.css"]')) {
            this.includeCSS('../css/input_Box.css');
        }

        // Adiciona a tabela ao container
        this.tableContainer.appendChild(this.table);
        document.body.appendChild(this.tableContainer);

        // Adiciona eventos para ajuste do tamanho da fonte
        window.addEventListener("resize", this.adjustTableFontSize.bind(this));
        window.addEventListener("load", this.adjustTableFontSize.bind(this));
    }

    // Método para incluir CSS
    includeCSS(href) {
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = href;
        document.head.appendChild(link);
    }

    // Método `parseTemplate`
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

        // Adiciona as linhas à tabela
        this.addFieldsToTable();
    }

    // Adiciona as linhas coletadas à tabela
    addFieldsToTable() {
        this.fields.forEach((line) => {
            const row = document.createElement('tr');

            line.forEach((field) => {
                const th = document.createElement('th');
                const labelElement = document.createElement('label');
                labelElement.textContent = field.label;
                labelElement.className = `align-${field.align}`;
                th.appendChild(labelElement);

                const td = document.createElement('td');

                // Adiciona o input apenas se o tamanho máximo for maior que 0
                if (field.maxLength > 0) {
                    const input = document.createElement('input');
                    input.type = 'text';

                    // Ajustar largura do input baseado no tamanho do campo
                    const width = this.getTextWidth(field.label, 16) + 20; // 20 para padding
                    input.style.width = `${width}px`;

                    input.id = field.id;
                    input.name = field.name;
                    input.maxLength = field.maxLength; // Define o maxlength do input

                    td.appendChild(input);
                }

                row.appendChild(th);
                row.appendChild(td);
            });

            this.table.appendChild(row);
        });
    }

    // // Adiciona as linhas coletadas à tabela
    // addFieldsToTable() {
    //     this.fields.forEach((line) => {
    //         const row = document.createElement('tr');

    //         line.forEach((field) => {
    //             const th = document.createElement('th');
    //             const labelElement = document.createElement('label');
    //             labelElement.textContent = field.label;
    //             labelElement.className = `align-${field.align}`;
    //             th.appendChild(labelElement);

    //             const td = document.createElement('td');

    //             // Adiciona o input apenas se o tamanho máximo for maior que 0
    //             if (field.maxLength > 0) {
    //                 const input = document.createElement('input');
    //                 input.type = 'text';

    //                 // Ajustar largura do input baseado no tamanho do campo
    //                 const width = this.getTextWidth(field.label, 16) + 20; // 20 para padding
    //                 input.style.width = `${width}px`;

    //                 input.id = field.id;
    //                 input.name = field.name;
    //                 td.appendChild(input);
    //             }

    //             row.appendChild(th);
    //             row.appendChild(td);
    //         });

    //         this.table.appendChild(row);
    //     });
    // }

    // Adiciona as linhas coletadas à tabela
    // addFieldsToTable() {
    //     this.fields.forEach((line) => {
    //         const row = document.createElement('tr');

    //         line.forEach((field) => {
    //             const th = document.createElement('th');
    //             const labelElement = document.createElement('label');
    //             labelElement.textContent = field.label;
    //             labelElement.className = `align-${field.align}`;
    //             th.appendChild(labelElement);

    //             const td = document.createElement('td');
    //             const input = document.createElement('input');
    //             input.type = 'text';
                
    //             // Ajustar largura do input baseado no tamanho do campo
    //             const width = this.getTextWidth(field.label, 16) + 20; // 20 para padding
    //             input.style.width = `${width}px`;
                
    //             input.id = field.id;
    //             input.name = field.name;
    //             td.appendChild(input);

    //             row.appendChild(th);
    //             row.appendChild(td);
    //         });

    //         this.table.appendChild(row);
    //     });
    // }

    // Método para calcular a largura de um texto em pixels
    getTextWidth(text, fontSize) {
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        context.font = `${fontSize}px Arial`;
        return context.measureText(text).width;
    }

    adjustTableFontSize() {
        const containerWidth = this.tableContainer.clientWidth;

        if (containerWidth < 600) {
            this.table.style.fontSize = "8px";
        } else if (containerWidth < 1200) {
            this.table.style.fontSize = "12px";
        } else {
            this.table.style.fontSize = "16px";
        }
    }

    // Método estático inputBox
    static inputBox(title, template) {
        return new InputBox(title, template);
    }
}



