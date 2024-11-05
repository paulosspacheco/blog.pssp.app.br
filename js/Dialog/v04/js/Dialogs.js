// Dialogs.js

// import UiDmxScrollerForm from './UiDmxScrollerForm.js';
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
    createDialog() {
        this.dialog = document.getElementById('inputBox-dialog');
        if (this.dialog === null)  {
            this.dialog = document.createElement('div');
            this.dialog.id = 'inputBox-dialog';
            this.dialog.className = 'inputBox-dialog';
    
            const overlay = document.createElement('div');
            overlay.id = 'inputBox-dialog-overlay';
            overlay.className = 'inputBox-dialog-overlay';
            
            document.body.appendChild(overlay);
            document.body.appendChild(this.dialog);
        }
    
        this.dialog.innerHTML = '';
    
        const header = document.createElement('div');
        header.className = 'inputBox-dialog-header';
        header.textContent = 'Seu Título Aqui';
        this.dialog.appendChild(header);
    
        if (this.form == null){
            this.form = this.addFieldsToTable(this.dialog, () => this.getPainel());         
            this.dialog.appendChild(this.form);
        }
    
        // Adiciona lógica para exibir o diálogo
        this.dialog.style.display = 'none'; // Inicialmente oculto
        const overlay = document.getElementById('inputBox-dialog-overlay');
        if (overlay) {
            overlay.style.display = 'none'; // Inicialmente oculto
        }
    }
  
    /**
     * Configura os ouvintes de eventos para os botões de abrir, confirmar e cancelar o diálogo.
     * 
     * - `openDialogBtn`: Abre o diálogo e exibe os dados.
     * - `cancelBtn`: Cancela o diálogo, chamando a função `cancel`.
     * - `confirmBtn`: Confirma o diálogo, chamando a função `submit`.
     */
    setupEventListeners() {
        // document.getElementById('openDialogBtn').addEventListener('click', () => this.openDialog());
        // document.getElementById('cancelBtn').addEventListener('click', () => this.cancel());
        // document.getElementById('confirmBtn').addEventListener('click', () => this.submit());
    }
    
    /**
     * Coleta os dados do diálogo.
     * 
     * @returns {Object} - Um objeto contendo os dados inseridos pelo usuário.     * 
     */       
    collectDialogData() {
        const values = this.getValues();
        return values;
    }  
   
    closeDialog() {
        if (this.dialog) {
            const overlay = document.getElementById('inputBox-dialog-overlay');
            if (overlay) overlay.remove();
    
            this.dialog.remove();
            this.dialog = null;    
            Dialog.currentInstance = null;         
        }
    }
    
    // Função para validar os campos
    validateFields() {
        const inputs = this.dialog.querySelectorAll('input[type="text"]');
        let isValid = true;
        let errorMessage = '';

        inputs.forEach(input => {
            if (input.value.trim() === '') {
                isValid = false;
                errorMessage += `O campo ${input.name} não pode estar vazio.\n`;
            } else if (input.value.length > input.maxLength) {
                isValid = false;
                errorMessage += `O campo ${input.name} deve ter no máximo ${input.maxLength} caracteres.\n`;
            }
        });

        if (isValid) {
            console.log('Todos os campos estão válidos. Enviar dados.');
        } else {
            alert(errorMessage);
        }
    }

    validateField(field) {

        /*
            //Exemplo de uso deste método
            this.fields.forEach(field => {
                if (!this.validateField(field)) {
                    isValid = false; // Se algum campo não for válido, define a flag como falsa
                }
            });
        */
        // Lógica de validação aqui
        // Exemplo simples de verificação se o campo não está vazio
        const input = document.getElementById(field.id);
        if (!input || !input.value) {
            alert(`O campo ${field.label} é obrigatório!`);
            return false; // Retorna falso se a validação falhar
        }
        return true; // Retorna verdadeiro se a validação passar
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

    
    // Método para criar um painel de botões    
    getPainel() {
        const footerPanel = document.createElement('div');
        footerPanel.className = 'inputBox-footer-panel';
        footerPanel.style.display = 'flex';
        footerPanel.style.justifyContent = 'center';
        footerPanel.style.gap = '10px';
        
        const buttonCancel = document.createElement('button');
        buttonCancel.id = 'cancelBtn';
        buttonCancel.textContent = 'Cancelar';
        buttonCancel.addEventListener('click', () => this.cancel());
        footerPanel.appendChild(buttonCancel);
        
        const buttonOk = document.createElement('button');
        buttonOk.id = 'confirmBtn';
        buttonOk.textContent = 'OK';
        buttonOk.addEventListener('click', () => this.submit());
        footerPanel.appendChild(buttonOk);
    
        return footerPanel;
    }

    async openDialog() {
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
    static showModal(title, template) {
        return new Promise((resolve, reject) => {
            const dialog = new Dialog(title, template);
            
            // Configura as promessas para resolver ou rejeitar
            dialog.resolveDialog = resolve;
            dialog.rejectDialog = reject;

            // Exibe o diálogo
            dialog.dialog.style.display = 'block'; // Torna o diálogo visível
            const overlay = document.getElementById('inputBox-dialog-overlay');
            if (overlay) {
                overlay.style.display = 'block'; // Torna o overlay visível
            }
            
            
  
        });
    }    

}
