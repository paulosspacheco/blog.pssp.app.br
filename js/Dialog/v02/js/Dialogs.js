// Dialogs.js

import UiDmxScrollerForm from './UiDmxScrollerForm.js';
import AbstractDialogs from './AbstractDialogs.js';


/**
 * Classe Dialog - responsável pela manipulação de diálogos modais em uma interface HTML.
 * 
 * Esta classe estende `AbstractDialogs`, fornecendo métodos para abrir, fechar, confirmar 
 * e cancelar diálogos. Também gerencia eventos de botão para a interação do usuário.
 * 
 * @extends Dialog
 */
export default class Dialog extends AbstractDialogs {
    /**
     * Construtor da classe Dialog.
     *
     * @param {string} title - Titulo do Dialogo.
     * @param {string} template - Template usado para criar form do dialogo.
     */
    constructor(title, template) {
        super(title, template); // Chama o construtor da classe pai                       

       
    }

    // Método que adiciona um contêiner de campos a um diálogo modal
    createDialog(){        
            
        // Método para mostrar o diálogo
        // function showDialog() {
        //     const dialog = document.getElementById('inputBox-dialog');
        //     const overlay = document.getElementById('inputBox-dialog-overlay');

        //     if (dialog && overlay) {
        //         dialog.style.display = 'block'; // Exibe o diálogo
        //         overlay.style.display = 'block'; // Exibe o overlay
        //     }
        // }

        // Verifica se o elemento `dialog` já existe
        this.dialog = document.getElementById('inputBox-dialog');
        if (this.dialog === null)  {
            // Cria o elemento `this.dialog` dinamicamente se não existir
            this.dialog = document.createElement('div');
            this.dialog.id = 'inputBox-dialog';
            this.dialog.className = 'inputBox-dialog';

            // Cria um overlay
            const overlay = document.createElement('div');
            overlay.id = 'inputBox-dialog-overlay';
            overlay.className = 'inputBox-dialog-overlay';
            
            document.body.appendChild(overlay); // Adiciona o overlay ao corpo do documento
            document.body.appendChild(this.dialog); // Adiciona o diálogo ao corpo do documento

            // // Adiciona um evento de clique no overlay para fechar o diálogo
            // overlay.addEventListener('click', () => {
            //     this.dialog.style.display = 'none';
            //     overlay.style.display = 'none'; // Oculta o overlay quando o diálogo é fechado
            // });
        }

        // Limpa o conteúdo anterior
        this.dialog.innerHTML = '';

        //Adiciona cabeçalho e botão de fechar ao diálogo
        const header = document.createElement('div');
        header.className = 'inputBox-dialog-header';
        header.textContent = 'Seu Título Aqui'; // Defina o título desejado
        this.dialog.appendChild(header);


        // Adiciona o contêiner recebido ao diálogo após o cabeçalho
        if (this.form == null){
          this.form = this.addFieldsToTable(this.dialog, () => this.GetPainel());
        }

        
        this.dialog.appendChild(this.form);

        // Exibir diálogo
        // showDialog();
    };

  
    /**
     * Configura os ouvintes de eventos para os botões de abrir, confirmar e cancelar o diálogo.
     * 
     * - `openDialogBtn`: Abre o diálogo e exibe os dados.
     * - `cancelBtn`: Cancela o diálogo, chamando a função `cancel`.
     * - `confirmBtn`: Confirma o diálogo, chamando a função `submit`.
     */
    setupEventListeners() {
        document.getElementById('openDialogBtn').addEventListener('click', () => this.openDialogAndDisplayData());
        document.getElementById('cancelBtn').addEventListener('click', () => this.cancel());
        document.getElementById('confirmBtn').addEventListener('click', () => this.submit());
    }

    /**
     * Coleta os dados do diálogo.
     * 
     * @returns {Object} - Um objeto contendo os dados inseridos pelo usuário.
     * @property {string} name - Nome inserido pelo usuário.
     * @property {string} age - Idade inserida pelo usuário.
     */
    collectDialogData() {
        const name = document.getElementById('name').value;
        const age = document.getElementById('age').value;
        return { name, age };
    }

    /**
     * Fecha o diálogo modal.
     */
    closeDialog() {
        this.dialog.close();
    }

    /**
     * Procedimento para confirmação do diálogo.
     * 
     * Verifica a validade do formulário antes de confirmar. Se válido, coleta os dados, fecha o 
     * diálogo e resolve a promessa associada ao diálogo com os dados coletados. Caso contrário, 
     * exibe a validade dos campos do formulário.
     */
    submit() {
        if (this.form.checkValidity()) {
            const data = this.collectDialogData();
            this.closeDialog();
            this.resolveDialog(data);
        } else {
            this.form.reportValidity();
        }
    }

    /**
     * Procedimento para cancelamento do diálogo.
     * 
     * Fecha o diálogo e rejeita a promessa associada ao diálogo com uma mensagem de cancelamento.
     */
    cancel() {
        this.closeDialog();
        this.rejectDialog('Dialog canceled by user');
    }

    // Método para lidar com o envio do formulário
    submit() {
        // Lógica para lidar com o envio
        console.log('Button Enviar');

        // Adicione a lógica necessária para processar os dados do formulário aqui
    }

    
    // Método para criar um painel de botões    
    GetPainel() {
        // Cria o painel do rodapé para os botões
        const footerPanel = document.createElement('div');
        footerPanel.className = 'inputBox-footer-panel'; // Classe CSS para o rodapé
        
        // Centraliza os botões
        footerPanel.style.display = 'flex';
        footerPanel.style.justifyContent = 'center';
        footerPanel.style.gap = '10px'; // Espaçamento entre os botões
        
        // Adiciona botão Cancelar
        const buttonCancel = document.createElement('button');
        buttonCancel.textContent = 'Cancelar';
        buttonCancel.addEventListener('click', () => {
            this.cancelButton(); // Fecha o dialog com valor de retorno 'cancel'
        });
        footerPanel.appendChild(buttonCancel);
        
        // Adiciona botão OK
        const buttonOk = document.createElement('button');
        buttonOk.textContent = 'OK';
        buttonOk.addEventListener('click', () => {                
            this.okBotton(); // Fecha o dialog com valor de retorno 'ok'
        });
        footerPanel.appendChild(buttonOk);
    
        return footerPanel;
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
        const container = this.addFieldsToTable(dialog, () => this.GetPainel());
        dialog.appendChild(container);

        // Exibir diálogo
        showDialog();
    }

    async openDialogAndDisplayData() {
        try {
            const data = await this.executeDialog();
            alert(`Captured data:\nName: ${data.name}\nAge: ${data.age}`);
        } catch (error) {
            alert('Error: ' + error);
        }
    }

    /**
     * Abre o diálogo modal.
     */
    // openDialog() {
    //     this.dialog.showModal();
    // }
    static openDialog(title, template) {
        const dialogInstance = new Dialog(title, template);
        return dialogInstance.dialog.showModal();
        
        addFieldsToTable(targetContainer, getPanel);
    }



}
