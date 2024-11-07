class InputBox {
    constructor() {
        this.tableContainer = document.createElement('div');
        this.tableContainer.className = 'table-container';
        this.table = document.createElement('table');
        this.table.className = 'inputBox-table';
        
        // Adiciona a tabela ao container
        this.tableContainer.appendChild(this.table);
        document.body.appendChild(this.tableContainer);
        
        // Adiciona os estilos
        this.addStyles();
        
        // Adiciona eventos para ajuste do tamanho da fonte
        window.addEventListener("resize", this.adjustTableFontSize.bind(this));
        window.addEventListener("load", this.adjustTableFontSize.bind(this));
    }

    addStyles() {
        const style = document.createElement('style');
        style.textContent = `
            .table-container {
                width: 100%;
                max-width: 1500px;
                height: 800px;
                overflow: auto;
                border: 1px solid #ccc;
                margin-top: 20px;
            }

            .inputBox-table {
                border-collapse: collapse;
                width: 100%;
            }

            .inputBox-table th, 
            .inputBox-table td {
                border: none;
                padding: 8px;
                text-align: left;
                overflow: hidden;
            }

            .inputBox-table label {
                display: block;
                margin-bottom: 5px;
            }

            .inputBox-table input {
                box-sizing: border-box;
                overflow: auto;
                white-space: nowrap;
                width: 100%;
            }

            .align-left {
                text-align: left;
            }
            .align-center {
                text-align: center;
            }
            .align-right {
                text-align: right;
            }
        `;
        document.head.appendChild(style);
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

    addRow(labels, inputWidths) {
        const row = document.createElement('tr');
        
        labels.forEach((label, index) => {
            const th = document.createElement('th');
            const labelElement = document.createElement('label');
            labelElement.textContent = label;
            labelElement.className = `align-${['right', 'center', 'left'][index % 3]}`;
            th.appendChild(labelElement);
            
            const td = document.createElement('td');
            const input = document.createElement('input');
            input.type = 'text';
            input.style.width = inputWidths[index] + 'px';
            td.appendChild(input);
            
            row.appendChild(th);
            row.appendChild(td);
        });
        
        this.table.appendChild(row);
    }

    showInputBoxTable() {
        // Exemplo de dados
        this.addRow(['Label 1:', 'Label 2:', 'Label 3:'], [50, 90, 150]);
        this.addRow(['Label 1:', 'Label 2:', 'Label 3:'], [70, 100, 120]);
        this.addRow(['Label 1:', 'Label 2:', 'Label 3:'], [150, 200, 180]);
        
        // Adiciona botão de enviar
        const submitButton = document.createElement('button');
        submitButton.type = 'submit';
        submitButton.textContent = 'Enviar';
        document.body.appendChild(submitButton);
    }
}

// Uso
const inputBox = new InputBox();
inputBox.showInputBoxTable();
