//UiDmxScroller.js

import { MiMethods } from './MiMethods.js';

// Classe UiDmxScroller que herda de MiMethods
export class UiDmxScroller extends MiMethods {
    constructor(title, template) {
        super(); // Chama o construtor da classe pai        
        this.fields = [];
        this.title = title;

        this.table = document.createElement('table');
        this.table.className = 'inputBox-table';
        this.font = "16px Arial";
        this.parseTemplate(template);

        // Adiciona eventos para ajuste do tamanho da fonte
        window.addEventListener("resize", this.adjustTableFontSize.bind(this));
        window.addEventListener("load", this.adjustTableFontSize.bind(this));

        // this.includeCSS();         
    }

    /**# includeCSS() 
           
       - Este método é virtual e pode ser redefinido nas classe filha desde que que se altere os atributos da 
         classe sem alterar o nome das mesmas exceto no nome das classes CSS abaixo.      
           
       - Este documento fornece um resumo das classes CSS utilizadas no arquivo `UiDmxScroller.css`, que 
       estiliza a caixa de diálogo de entrada.
      
       - Classes CSS
           1. **`.inputBox-dialog-overlay`**: 
                - Define o overlay que cobre a tela quando a caixa de diálogo está ativa, 
                 com fundo semi-transparente e oculto por padrão.

            2. **`.inputBox-dialog`**: 
                - Estiliza a caixa de diálogo centralizada na tela, com fundo branco, bordas arredondadas e 
                 sombra. Controla a largura e altura máximas da caixa.

            3. **`.inputBox-dialog-header`**: 
                - Estiliza o cabeçalho da caixa de diálogo, definindo o tamanho da fonte e espaçamento inferior.

            4. **`.inputBox-container`**: 
                - Um contêiner flexível que ocupa toda a largura e altura disponíveis, permitindo rolagem vertical quando o conteúdo excede o tamanho da caixa.

            5. **`.inputBox-table-title`**: 
                - Estiliza a linha de título da tabela, com altura fixa, cor de fundo e centralização do texto.

            6. **`.inputBox-table-container`**: 
                - Contêiner que permite que a tabela ocupe o espaço restante, com rolagem vertical e horizontal.

            7. **`.inputBox-footer-panel`**: 
                - Estiliza o painel do rodapé, definindo altura, cor de fundo e alinhamento dos botões.

        - Essas classes são usadas para compor a interface da caixa de diálogo, garantindo uma apresentação 
          visual organizada e responsiva.

    */
    includeCSS(){
        MiMethods.includeCSS('../css/UiDmxScroller.css');
    }
        

    // Método para ajustar o tamanho da fonte com base na largura do container
    adjustTableFontSize(container) {        
        
        if (container !== null){
            const containerWidth = container.clientWidth;            
            let fontSize;

            if (containerWidth < 600) {
                fontSize = "8px";
            } else if (containerWidth < 1200) {
                fontSize = "12px";
            } else {
                fontSize = "16px";
            }

            this.table.style.fontSize = fontSize;

            const inputs = this.table.querySelectorAll('input');
            inputs.forEach(input => {
                input.style.fontSize = fontSize;
            });
        } 
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
   
    }

    // Método para coletar os valores dos campos de entrada
    getValues() {
        // Verificação final para garantir que `values` é um JSON válido
        try {

            const values = {};
            this.fields.forEach(line => {
                line.forEach(field => {
                    const input = document.getElementById(field.id);
                    
                    // Verificação extra para garantir que o input existe e é válido
                    if (input) {
                        values[field.name] = input.value; 
                    } else {
                        // console.warn(`Campo com id ${field.id} não encontrado no DOM.`);
                        // values[field.name] = '';  // Pode ser ajustado para omitir valores inexistentes
                    }
                });
            });
    
            JSON.stringify(values); // Validação extra do JSON            
            // console.log(values);            
            return values;
        } catch (error) {
            console.error("Erro ao converter values para JSON:", error);
            return null;
        }
    }   
}

