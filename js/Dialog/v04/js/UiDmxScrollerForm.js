// UiDmxScrollerForm.js

import { MiMethods } from './MiMethods.js';
import { UiDmxScroller } from './UiDmxScroller.js';

export class UiDmxScrollerForm extends UiDmxScroller {
    
    // Construtor que chama o construtor da classe base
    constructor(title, template) {
        super(title, template); // Chama o construtor da classe base
        // Você pode inicializar outras propriedades específicas da classe aqui, se necessário

        this.tableContainer = document.createElement('div');
        this.tableContainer.className = 'inputBox-table-container';
        this.tableContainer.appendChild(this.table);
        document.body.appendChild(this.tableContainer);
    }

    // Método para lidar com o envio do formulário
    submit() {
        // Lógica para lidar com o envio
        console.log('Formulário enviado!');
        // Adicione a lógica necessária para processar os dados do formulário aqui
    }

    // Método para lidar com o cancelamento do formulário
    cancel() {
        // Lógica para lidar com o cancelamento
        console.log('Formulário cancelado!');
        // Adicione a lógica necessária para limpar o formulário ou fechar o diálogo aqui
    }


    // Implementação do método getPainel
    getPainel() {
        // Cria o contêiner do painel
        const painel = document.createElement('div');
        painel.className = 'inputBox-panel'; // Adiciona uma classe para estilo, se necessário

        // Cria o botão Enviar
        const enviarButton = document.createElement('button');
        enviarButton.textContent = 'Enviar';
        enviarButton.className = 'inputBox-button enviar'; // Adiciona uma classe para estilo
        enviarButton.addEventListener('click', () => {
            this.submit(); // Chama o método submit ao clicar em Enviar
        });

        // Cria o botão Cancelar
        const cancelarButton = document.createElement('button');
        cancelarButton.textContent = 'Cancelar';
        cancelarButton.className = 'inputBox-button cancelar'; // Adiciona uma classe para estilo
        cancelarButton.addEventListener('click', () => {
            this.cancel(); // Chama o método cancel ao clicar em Cancelar
        });

        // Adiciona os botões ao painel
        painel.appendChild(enviarButton);
        painel.appendChild(cancelarButton);

        return painel; // Retorna o painel com os botões
    }

    /** # Método `addFieldsToTable`

        ## Descrição
        
        O método `addFieldsToTable` cria um contêiner de tabela dinâmico no DOM, contendo campos de entrada 
        conforme especificado. Ele permite a adição de um rodapé opcional através de um painel, caso um método de 
        obtenção de painel seja fornecido.

        ## Parâmetros

        - **targetContainer** (`HTMLElement`): O contêiner de destino onde o novo contêiner será adicionado. Por 
                                               padrão, é o corpo do documento (`document.body`).
        
        - **getPanel** (`function` | `null`): Um método opcional que retorna um painel a ser adicionado ao contêiner. 
                                              Se não for fornecido, o método `getPainel` da instância é chamado.

        ## Retorno
        - Retorna o `HTMLElement` do contêiner criado que contém a tabela e os campos de entrada.

        ## Exceções

            - Não lança exceções específicas, mas pode falhar se o `targetContainer` não for um `HTMLElement` válido.

        ## Exemplo de Uso básico

            ```javascript

              const uiDmxScrolso boas dicas lerForm = new UiDmxScrollerForm();
              const container = UiDmxScrollerForm.addFieldsToTable(document.getElementById('myTargetContainer'), myGetPanelFunction);

            ```   


        ## Detalhes de Implementação

            - Criação do Contêiner: Um div é criado como contêiner principal, que contém a tabela.

            - Título da Tabela: Um título é adicionado ao contêiner, definido pela propriedade title da instância.

            - Tabela: Uma tabela é criada, onde cada linha corresponde a um conjunto de campos definidos em fields.
                - Para cada campo, um rótulo (label) e um campo de entrada (input) são criados.
                - O campo de entrada é estilizado com base na propriedade maxLength.

            - Rodapé: Se um método getPanel é fornecido, o painel correspondente é adicionado ao contêiner principal. 
                      Caso contrário, o método getPainel da instância é chamado para obter um painel.

            - Adição ao DOM: O contêiner é anexado ao targetContainer especificado.

            - Estilos CSS
                - .inputBox-container: Classe para o contêiner externo.
                - .inputBox-table-title: Classe para o título da tabela.
                - .inputBox-table-container: Classe para o contêiner da tabela.

            - Observações
                - Certifique-se de que os campos definidos em fields contenham as propriedades necessárias como label, 
                  align, id, name e maxLength.
                - A largura do campo de entrada é calculada com base no número máximo de caracteres permitidos e 
                  na largura estimada de cada caractere.
    */
    addFieldsToTable(targetContainer = document.body, getPanel = null) {
        // Cria o contêiner externo com a tag <form>
        const form = document.createElement('form');
        form.className = 'inputBox-container'; // Classe CSS para o formulário
        
        // Cria o título do contêiner
        const titleElement = document.createElement('div');
        titleElement.className = 'inputBox-table-title'; // Classe CSS para o título
        titleElement.textContent = this.title; // Define o texto do título
        form.appendChild(titleElement); // Adiciona o título ao formulário
        
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
                    const estimatedCharWidth = MiMethods.textWidthChar(this.font);
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
        form.appendChild(tableContainer); // Adiciona o contêiner da tabela ao formulário
    
        // Executa o método getPanel se não for nulo
        if (getPanel !== null) {
            const auxPanel = getPanel(); // Chama o método passado como parâmetro
            if (auxPanel instanceof Node) {
                form.appendChild(auxPanel); // Adiciona o painel ao formulário
            } else {
                console.error('getPanel não retornou um nó válido:', auxPanel);
            }            
        } else {
            const painel = this.getPainel(); // Assumindo que getPainel é uma função ou um elemento
            if (painel instanceof Node) {
                form.appendChild(painel);
            } else {
                console.error('this.getPainel não retornou um nó válido:', painel);
            }
        }
    
        // Adiciona o formulário ao contêiner de destino
        targetContainer.appendChild(form);
    
        this.adjustTableFontSize(form); // Ajusta o tamanho da fonte se necessário
    
        return form; // Retorna o formulário em vez do div
    }

        
       
    // Método estático createForm
    static createForm(title, template, targetContainer, getPanel = null) {
        const formInstance = new UiDmxScrollerForm(title, template);
        return formInstance.addFieldsToTable(targetContainer, getPanel);
    }
 
    

}


