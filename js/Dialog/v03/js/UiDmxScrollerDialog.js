// UiDmxScrollerDialog.js

import { UiDmxScrollerForm } from './UiDmxScrollerForm.js';

export class UiDmxScrollerDialog extends UiDmxScrollerForm {
    
    // Construtor que chama o construtor da classe base
    constructor(title, template) {
        super(title, template); // Chama o construtor da classe base
        // Você pode inicializar outras propriedades específicas da classe aqui, se necessário
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
        if (dialog === null)  {
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
        const container = this.addFieldsToTable(dialog, () => this.getPainel());
        dialog.appendChild(container);

        // Exibir diálogo
        showDialog();
    }

}