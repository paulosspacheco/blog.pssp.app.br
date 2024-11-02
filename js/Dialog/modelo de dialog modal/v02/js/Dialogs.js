// Dialogs.js

import AbstractDialogs from './AbstractDialogs.js';


/**
 * Classe Dialog - responsável pela manipulação de diálogos modais em uma interface HTML.
 * 
 * Esta classe estende `AbstractDialogs`, fornecendo métodos para abrir, fechar, confirmar 
 * e cancelar diálogos. Também gerencia eventos de botão para a interação do usuário.
 * 
 * @extends AbstractDialogs
 */
export default class Dialog extends AbstractDialogs {
    /**
     * Construtor da classe Dialog.
     *
     * @param {string} dialogId - ID do elemento dialog HTML.
     * @param {string} formId - ID do formulário associado ao diálogo.
     */
    constructor(dialogId, formId) {
        super(dialogId, formId); // Chama o construtor da classe pai                
    }
    
    /**
     * Configura os ouvintes de eventos para os botões de abrir, confirmar e cancelar o diálogo.
     * 
     * - `openDialogBtn`: Abre o diálogo e exibe os dados.
     * - `cancelBtn`: Cancela o diálogo, chamando a função `cancelDialogProcedure`.
     * - `confirmBtn`: Confirma o diálogo, chamando a função `confirmDialogProcedure`.
     */
    setupEventListeners() {
        document.getElementById('openDialogBtn').addEventListener('click', () => this.openDialogAndDisplayData());
        document.getElementById('cancelBtn').addEventListener('click', () => this.cancelDialogProcedure());
        document.getElementById('confirmBtn').addEventListener('click', () => this.confirmDialogProcedure());
    }

    /**
     * Abre o diálogo modal.
     */
    openDialog() {
        this.dialog.showModal();
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
    confirmDialogProcedure() {
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
    cancelDialogProcedure() {
        this.closeDialog();
        this.rejectDialog('Dialog canceled by user');
    }
}
