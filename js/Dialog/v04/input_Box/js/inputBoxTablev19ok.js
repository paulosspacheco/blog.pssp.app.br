export class InputBox {
    constructor(title, template) {
        this.fields = [];
        this.title = title; // Armazena o título
        this.tableContainer = document.createElement('div');
        this.tableContainer.className = 'inputBox-table-container';
        this.table = document.createElement('table');
        this.table.className = 'inputBox-table';
        this.font = "16px Arial"; // Fonte usada para calcular a largura média de caractere                

        // Adiciona os estilos
        this.addStyles();
        
        // Inclui o CSS dinamicamente no documento, verificando se já está presente
        // if (!document.querySelector('link[href="../css/input_Box.css"]')) {
        //     this.includeCSS('../css/input_Box.css');
        // }


        // Processa o template
        this.parseTemplate(template);

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
           
    addStyles() {
        const style = document.createElement('style');
        style.textContent = `

            /* input_Box.css */

            /* @import url('./color_tons_de_cinza.css'); */
            /* @import url('./color_tons_dark.css'); */
            /* @import url('./color_tons_de_dark_claro.css'); */
            /* @import url('./color_tons_de_azul_ceu.css'); */
            /* @import url('./color_tons_de_verde_claro.css'); */
            /* @import url('./color_tons_amarelo.css'); */
            @import url('../css/color_tons_de_lilas_claro.css');

            html, body {
                height: 100%; /* Garante que o body ocupe toda a altura da janela */
                margin: 0; /* Remove margens do body */
            }            

            .inputBox-dialog-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: rgba(0, 0, 0, 0.5); /* Cor do fundo com transparência */
                z-index: 1000; /* Coloca o overlay acima de outros elementos */
                display: none; /* Inicialmente oculto */
            }

            .inputBox-dialog {
                position: fixed; /* Posiciona o diálogo fixamente em relação à viewport, garantindo que permaneça visível ao rolar a página */
                top: 50%; /* Centraliza o diálogo verticalmente na tela */
                left: 50%; /* Centraliza o diálogo horizontalmente na tela */
                transform: translate(-50%, -50%); /* Ajusta o diálogo para que o ponto central fique exatamente no centro da tela */
                background-color: white; /* Define a cor de fundo do diálogo como branco */
                border-radius: 5px; /* Arredonda levemente os cantos do diálogo */
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Adiciona uma sombra ao redor do diálogo para dar profundidade */
                z-index: 1001; /* Coloca o diálogo acima de outros elementos na página, especialmente overlays */
                display: none; /* Mantém o diálogo inicialmente oculto */
                padding: 20px; /* (Comentado) Espaçamento interno do conteúdo do diálogo */
                width: 90%; /* Define a largura do diálogo como 90% da largura da viewport */
                max-width: 800px; /* Estabelece a largura máxima do diálogo para 800px */
                max-height: 90vh; /* Limita a altura do diálogo a 90% da altura da viewport */
                overflow-y: auto; /* Adiciona rolagem vertical caso o conteúdo exceda a altura definida */
            }

            .inputBox-dialog-header {
                font-size: 1.2em; /* Tamanho da fonte do cabeçalho */
                margin-bottom: 15px; /* Espaçamento inferior */
            }      


.inputBox-dialog {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: white;
    border-radius: 5px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    z-index: 1001;
    display: none;

    /* Define largura e altura máximas da caixa de diálogo */
    width: 90%;
    max-width: 800px;
    max-height: 90vh;

    /* Permite que o conteúdo se expanda verticalmente se necessário */
    overflow: hidden;
}
.inputBox-container {
    /* Usa 100% da largura e altura do pai sem ultrapassar */
    width: 100%;
    height: 100%;

    /* Flexível para rolagem interna quando o conteúdo é maior */
    display: flex;
    flex-direction: column;

    /* Reduz as margens e adição de borda para visualização */
    margin: 0;
    border: 1px solid #ccc;

    /* Rolagem apenas vertical */
    overflow-y: auto;
    overflow-x: hidden; /* Opcional: oculta rolagem horizontal */

    /* Estilo de posicionamento relativo para possíveis conteúdos internos */
    position: relative;
}

            .inputBox-table-title {
                height: 50px; /* Altura fixa do título */
                background-color: #f1f1f1; /* Cor de fundo do título */
                display: flex;
                align-items: center; /* Centraliza verticalmente o texto */
                padding-left: 10px; /* Espaço à esquerda */
                font-weight: bold; /* Deixa o título em negrito */
                border-bottom: 1px solid #ccc; /* Linha inferior para separação */
            }

            .inputBox-table-container {
                flex: 1; /* Faz a tabela ocupar o espaço restante */
                overflow-y: auto; /* Permite rolagem vertical na tabela */
                overflow-x: auto; /* Permite rolagem horizontal se necessário */
                padding: 5px; /* Espaço interno para evitar que o conteúdo fique colado nas bordas */
            }

            .inputBox-table-container table {
                width: 100%; /* A tabela ocupa toda a largura disponível do contêiner */
            }

            .inputBox-footer-panel {                
                height: 50px; /* A altura do painel para os botões */
                background-color: #f1f1f1; /* Cor de fundo do painel */
                display: flex; /* Para alinhar os botões horizontalmente */
                justify-content: flex-end; /* Alinha os botões à direita */
                /* padding: 10px; /* Espaçamento interno */
                border-top: 1px solid #ccc; /* Linha superior para separação */
            }

                `;
        document.head.appendChild(style);
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
    //   this.addFieldsToTable();        
    }

    // Método para calcular a largura de um texto em pixels
    getTextWidth(text, fontSize) {
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        context.font = `${fontSize}px Arial`;
        return context.measureText(text).width;
    }

    // Método para calcular a largura média de um caractere
    textWidthChar(aFont) {
        // Função auxiliar para verificar se a fonte é monoespaçada
        function isMonoSpaced(aFont, context) {
            context.font = aFont;
            const widthA = context.measureText("W").width;
            const widthB = context.measureText("b").width;
            return widthA === widthB;
        }

        // Criando um elemento <canvas> para cálculos de largura de texto
        const canvasElement = document.createElement('canvas');
        const context = canvasElement.getContext("2d");
        context.font = aFont;


        if (!isMonoSpaced(aFont, context)) {
            const sampleText = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            const totalWidth = context.measureText(sampleText).width;
            return totalWidth / sampleText.length;
        } else {
            return context.measureText("A").width;
        }
    }

    adjustTableFontSize() {
        const containerWidth = this.tableContainer.clientWidth;
    
        let fontSize; // Variável para armazenar o tamanho da fonte
    
        if (containerWidth < 600) {
            fontSize = "8px";
        } else if (containerWidth < 1200) {
            fontSize = "12px";
        } else {
            fontSize = "16px";
        }
    
        // Ajustar o tamanho da fonte da tabela
        this.table.style.fontSize = fontSize;
    
        // Ajustar o tamanho da fonte dos inputs
        const inputs = this.table.querySelectorAll('input');
        inputs.forEach(input => {
            input.style.fontSize = fontSize; // Aplica o mesmo tamanho de fonte aos inputs
        });
    }

    // Método para criar uma caixa de diálogo com base no array this.fields
    showInputBox() {
        // Criação do inputBox-overlay da caixa de diálogo
        const overlay = document.createElement('div');
        overlay.className = 'inputBox-dialog-overlay';
    
        // Criação da caixa de diálogo
        const form = document.createElement('div');
        form.className = 'inputBox-dialog-box'; // Caixa de diálogo
    
        // Configura o título
        const titleElement = document.createElement('h2');
        titleElement.innerText = this.title;
        form.appendChild(titleElement);
    
        // Cria uma tabela para os campos de entrada
        const table = document.createElement('table');
        table.className = 'inputBox-table'; // Classe para estilos da tabela
    
        // Adiciona os campos à tabela
        this.fields.forEach(line => {
            const row = document.createElement('tr'); // Cria uma nova linha para cada campo
            line.forEach(field => {
                const cell = document.createElement('td'); // Cria uma nova célula
    
                const label = document.createElement('label');
                label.innerText = field.label;
                cell.appendChild(label);
    
                if (field.maxLength > 0) {                                
                    const input = document.createElement('input');
                    input.type = 'text'; // Tipo de entrada

                    // Calcular a largura do input com base no maxLength
                    const estimatedCharWidth = this.textWidthChar(this.font);                   
                    const padding = 20; // Padding adicional
                    const width = field.maxLength * estimatedCharWidth + padding;    
                    input.style.width = `${width}px`;
                    input.maxLength = field.maxLength; // Define o maxlength do input                  
                    input.style.textAlign = field.align; // Alinhamento do texto no campo
                    
                    input.name = field.name; // Nome do campo
                    input.id = field.id; // ID do campo
                    input.style.textAlign = field.align; // Alinhamento do texto no campo
                    cell.appendChild(input);
                }
                    
                row.appendChild(cell); // Adiciona a célula à linha
            });
            table.appendChild(row); // Adiciona a linha à tabela
        });
    
        // Adiciona a tabela ao formulário
        form.appendChild(table);
    
        // Cria o container de botões
        const buttonContainer = document.createElement('div');
        buttonContainer.className = 'inputBox-dialog-button-container';
    
        // Cria o botão "OK"
        const okButton = document.createElement('button');
        okButton.innerText = 'OK';
        okButton.className = 'inputBox-dialog-button'; // Classe para estilos do botão
        okButton.onclick = () => {
            this.getValues();
            document.body.removeChild(overlay); // Remove o overlay
        };
    
        // Cria o botão "Cancelar"
        const cancelButton = document.createElement('button');
        cancelButton.innerText = 'Cancelar';
        cancelButton.className = 'inputBox-dialog-button'; // Classe para estilos do botão
        cancelButton.onclick = () => {
            document.body.removeChild(overlay); // Remove o overlay
        };
    
        // Adiciona os botões ao container
        buttonContainer.appendChild(okButton);
        buttonContainer.appendChild(cancelButton);
    
        // Adiciona o container de botões ao formulário
        form.appendChild(buttonContainer);
    
        // Adiciona a caixa de diálogo ao overlay
        overlay.appendChild(form);
    
        // Adiciona o overlay ao corpo do documento
        document.body.appendChild(overlay);
    }

    // Método para criar uma caixa de diálogo com base no array this.fields
    showInputBox2() {
        
        // Criação do overlay da caixa de diálogo
        const overlay = document.createElement('div');
        overlay.className = 'inputBox-dialog-overlay';

        // Criação da caixa de diálogo
        const form = document.createElement('div');
        form.className = 'inputBox-dialog-box'; // Caixa de diálogo

        // Configura o título
        const titleElement = document.createElement('h2');
        titleElement.innerText = this.title;
        form.appendChild(titleElement);

        // Cria uma tabela para os campos de entrada
        const table = document.createElement('table');
        table.className = 'inputBox-table'; // Classe para estilos da tabela

        // Adiciona os campos à tabela
        this.fields.forEach(line => {
            const row = document.createElement('tr'); // Cria uma nova linha para cada campo
            line.forEach(field => {
                // Cria uma célula para o label
                const labelCell = document.createElement('td');
                const label = document.createElement('label');
                label.innerText = field.label;
                labelCell.appendChild(label);
                row.appendChild(labelCell); // Adiciona a célula do label à linha

                // Cria uma célula para o input
                const inputCell = document.createElement('td');

                if (field.maxLength > 0) {                
                    const input = document.createElement('input');
                    input.type = 'text'; // Tipo de entrada
                    

                    // Calcular a largura do input com base no maxLength                   
                    const estimatedCharWidth = this.textWidthChar(this.font);                   
                    const padding = 20; // Padding adicional
                    const width = field.maxLength * estimatedCharWidth + padding;    
                    input.style.width = `${width}px`;
                    input.maxLength = field.maxLength; // Define o maxlength do input                  
                    input.style.textAlign = field.align; // Alinhamento do texto no campo

                    input.name = field.name; // Nome do campo
                    input.id = field.id; // ID do campo
                    

                    inputCell.appendChild(input);
                }

                row.appendChild(inputCell); // Adiciona a célula do input à linha
            });
            table.appendChild(row); // Adiciona a linha à tabela
        });

        // Adiciona a tabela ao formulário
        form.appendChild(table);

        // Cria o container de botões
        const buttonContainer = document.createElement('div');
        buttonContainer.className = 'inputBox-dialog-button-container';

        // Cria o botão "OK"
        const okButton = document.createElement('button');
        okButton.innerText = 'OK';
        okButton.className = 'inputBox-dialog-button'; // Classe para estilos do botão
        okButton.onclick = () => {
            this.getValues();
            document.body.removeChild(overlay); // Remove o overlay
        };

        // Cria o botão "Cancelar"
        const cancelButton = document.createElement('button');
        cancelButton.innerText = 'Cancelar';
        cancelButton.className = 'inputBox-dialog-button'; // Classe para estilos do botão
        cancelButton.onclick = () => {
            document.body.removeChild(overlay); // Remove o overlay
        };

        // Adiciona os botões ao container
        buttonContainer.appendChild(okButton);
        buttonContainer.appendChild(cancelButton);

        // Adiciona o container de botões ao formulário
        form.appendChild(buttonContainer);

        // Adiciona a caixa de diálogo ao overlay
        overlay.appendChild(form);

        // Adiciona o overlay ao corpo do documento
        document.body.appendChild(overlay);
    }


    // Método para coletar os valores dos campos de entrada
    getValues() {
        const values = {};
        this.fields.forEach(line => {
            line.forEach(field => {
                const input = document.getElementById(field.id); // Busca pelo ID do campo
                values[field.name] = input.value; // Armazena o valor no objeto
            });
        });
        console.log(values); // Exibe os valores no console (ou faça o que precisar com eles)
    }
    

    // Método para fechar o diálogo
    okBotton() {
        const dialog = document.getElementById('inputBox-dialog');
        if (dialog) {
            dialog.remove(); // Remove o diálogo do DOM
        }
        const overlay = document.getElementById('inputBox-dialog-overlay');
        if (overlay) {
            overlay.remove(); // Remove o overlay do DOM
        }
    }

    // Método para fechar o diálogo
    cancelButton() {
        const dialog = document.getElementById('inputBox-dialog');
        if (dialog) {
            dialog.remove(); // Remove o diálogo do DOM
        }
        const overlay = document.getElementById('inputBox-dialog-overlay');
        if (overlay) {
            overlay.remove(); // Remove o overlay do DOM
        }
    }
    
    GetPainelOkCancel() {
        // Cria o painel do rodapé para os botões
        const footerPanel = document.createElement('div');
        footerPanel.className = 'inputBox-footer-panel'; // Classe CSS para o rodapé
    
        // Adiciona botão Cancelar
        const buttonCancel = document.createElement('button');
        buttonCancel.textContent = 'Cancelar';                
        buttonCancel.addEventListener('click', () => {
            this.cancelButton(); // Fecha o dialog com valor de retorno 'cancel'
        });        
        footerPanel.appendChild(buttonCancel);        
    
        
        const buttonOk = document.createElement('button');
        buttonOk.textContent = 'OK';
        buttonOk.addEventListener('click', () => {                
            this.okBotton() ;// Fecha o dialog com valor de retorno 'ok'
        });      
        footerPanel.appendChild(buttonOk);

            
        // }
    
        return footerPanel;
    }
    

    addFieldsToTable(targetContainer = document.body, getPanel = null) {
        // Cria o contêiner externo com a classe inputBox-container
        const container = document.createElement('div');
        container.className = 'inputBox-container';
        
        // Cria o título do contêiner
        const titleElement = document.createElement('div');
        titleElement.className = 'inputBox-table-title'; // Classe CSS para o título
        titleElement.textContent = this.title; // Define o texto do título
        container.appendChild(titleElement); // Adiciona o título ao contêiner
        
        // Cria o contêiner para a tabela
        const tableContainer = document.createElement('div');
        tableContainer.className = 'inputBox-table-container'; // Classe CSS para a tabela
    
        // Cria a tabela
        const table = document.createElement('table');
        table.id = this.title; // Define o ID da tabela
    
        // Adiciona as linhas e colunas conforme o código anterior
        this.fields.forEach((line) => {
            const row = document.createElement('tr');
    
            line.forEach((field) => {
                const th = document.createElement('th');
                const labelElement = document.createElement('label');
                labelElement.textContent = field.label;
                labelElement.className = `align-${field.align}`;
                th.appendChild(labelElement);
    
                const td = document.createElement('td');
    
                if (field.maxLength > 0) {
                    const input = document.createElement('input');
                    input.type = 'text';
                    const estimatedCharWidth = this.textWidthChar(this.font);
                    const width = field.maxLength * estimatedCharWidth;
                    input.style.width = `${width}px`;
    
                    input.id = field.id;
                    input.name = field.name;
                    input.maxLength = field.maxLength;
    
                    td.appendChild(input);
                }
    
                row.appendChild(th);
                row.appendChild(td);
            });
    
            table.appendChild(row);
        });
    
        // Adiciona a tabela ao contêiner da tabela
        tableContainer.appendChild(table);
        container.appendChild(tableContainer); // Adiciona o contêiner da tabela ao contêiner principal
    
        // Executa o método getPanel se não for nulo
        if (getPanel) {
            const auxPanel = getPanel(); // Chama o método passado como parâmetro
            // Adiciona o rodapé ao contêiner principal se o painel existir
            if (auxPanel) {
                container.appendChild(auxPanel);
            }
        }
    
        // Adiciona o contêiner ao contêiner de destino
        targetContainer.appendChild(container);
    
        return container;
    }
        
    
    // Método que adiciona um contêiner de campos a um diálogo modal
    addFieldsToDialog() {
        // Método para mostrar o diálogo
        function showDialog() {
            const dialog = document.getElementById('inputBox-dialog');
            const overlay = document.getElementById('inputBox-dialog-overlay');

            if (dialog && overlay) {
                dialog.style.display = 'block'; // Exibe o diálogo
                overlay.style.display = 'block'; // Exibe o overlay
            }
        }

        // Verifica se o elemento `dialog` já existe
        let dialog = document.getElementById('inputBox-dialog');
        if (!dialog) {
            // Cria o elemento `dialog` dinamicamente se não existir
            dialog = document.createElement('div');
            dialog.id = 'inputBox-dialog';
            dialog.className = 'inputBox-dialog';

            // Cria um overlay
            const overlay = document.createElement('div');
            overlay.id = 'inputBox-dialog-overlay';
            overlay.className = 'inputBox-dialog-overlay';
            
            document.body.appendChild(overlay); // Adiciona o overlay ao corpo do documento
            document.body.appendChild(dialog); // Adiciona o diálogo ao corpo do documento

            // // Adiciona um evento de clique no overlay para fechar o diálogo
            // overlay.addEventListener('click', () => {
            //     dialog.style.display = 'none';
            //     overlay.style.display = 'none'; // Oculta o overlay quando o diálogo é fechado
            // });
        }

        // Limpa o conteúdo anterior
        dialog.innerHTML = '';

        //Adiciona cabeçalho e botão de fechar ao diálogo
        const header = document.createElement('div');
        header.className = 'inputBox-dialog-header';
        header.textContent = 'Seu Título Aqui'; // Defina o título desejado
        dialog.appendChild(header);

        // Adiciona o contêiner recebido ao diálogo após o cabeçalho
        const container = this.addFieldsToTable(dialog, () => this.GetPainelOkCancel());
        dialog.appendChild(container);

        // Exibir diálogo
        showDialog();
    }


    // Método para mostrar o diálogo
    showDialog() {               
        this.addFieldsToDialog();
    }


    // Método estático para instanciar a classe e exibir a caixa de entrada
    static inputBox(title, template) {
        return new Promise((resolve) => {
            const inputBoxInstance = new InputBox(title, template);
            inputBoxInstance.showDialog();
            //   inputBoxInstance.addFieldsToTable(document.body,() =>inputBoxInstance.GetPainelOkCancel());
            
            
            //inputBoxInstance.showInputBox(resolve);            
            //inputBoxInstance.showInputBox2(resolve);
        });
    }


}



