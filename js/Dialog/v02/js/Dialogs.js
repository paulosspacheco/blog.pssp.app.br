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
    createDialog(){
        

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
          this.form = this.addFieldsToTable(this.dialog, () => this.getPainel());         
         this.dialog.appendChild(this.form);
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
        const values = this.getValues(); // Declara `values` usando `const`
        console.log(values);
        return values;
    }    

    /**
     * Fecha o diálogo modal.
     */
    // closeDialog() {
    //     this.dialog.close();
    // }
    // closeDialog() {
    //     if (this.dialog) {
    //         // Remove o diálogo e o overlay do DOM
    //         const overlay = document.getElementById('inputBox-dialog-overlay');
            
    //         if (overlay) {
    //             overlay.remove();  // Remove o overlay do DOM
    //         }
    
    //         this.dialog.remove();  // Remove o diálogo do DOM
    //         this.dialog = null;    // Remove a referência para evitar reutilização sem recriação
    //     }
    // }
    
    closeDialog() {
        this.dialog.style.display = 'none';
        const overlay = document.getElementById('inputBox-dialog-overlay');
        if (overlay) {
            overlay.style.display = 'none';
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
            // Todos os campos são válidos, você pode enviar os dados
            console.log('Todos os campos estão válidos. Enviar dados.');
            // Aqui você pode chamar uma função para enviar os dados
        } else {
            alert(errorMessage); // Mostra a mensagem de erro
        }
    }

    // validateField(field) {
    //     // Lógica de validação aqui
    //     // Exemplo simples de verificação se o campo não está vazio
    //     const input = document.getElementById(field.id);
    //     if (!input || !input.value) {
    //         alert(`O campo ${field.label} é obrigatório!`);
    //         return false; // Retorna falso se a validação falhar
    //     }
    //     return true; // Retorna verdadeiro se a validação passar
    // }
        // Valida todos os campos
        // this.fields.forEach(field => {
        //     if (!this.validateField(field)) {
        //         isValid = false; // Se algum campo não for válido, define a flag como falsa
        //     }
        // });




    /**
     * Procedimento para confirmação do diálogo.
     * 
     * Verifica a validade do formulário antes de confirmar. Se válido, coleta os dados, fecha o 
     * diálogo e resolve a promessa associada ao diálogo com os dados coletados. Caso contrário, 
     * exibe a validade dos campos do formulário.
     */
    // submit() {
    //     // if (this.validateFields()) {
    //     if (this.form.checkValidity()) {            
    //         const data = this.collectDialogData();
    //         this.closeDialog();
    //         this.resolveDialog(data);
    //     } else {
    //         this.form.reportValidity();
    //     }
    // }
    submit() {
        if (this.form.checkValidity()) {
            const data = this.collectDialogData();
            this.closeDialog();
            console.log(data); // Verifique o que está sendo passado
    
            try {
                // Verifica se resolveDialog é uma função e se retorna uma promessa
                if (typeof this.resolveDialog === 'function') {
                    const result = this.resolveDialog(data);
                    
                    // Verifica se o resultado é uma promessa
                    if (result instanceof Promise) {
                        result.catch(error => {
                            console.error("Erro ao resolver o diálogo:", error);
                        });
                    } else {
                        console.warn("resolveDialog não retornou uma promessa.");
                    }
                } else {
                    console.error("resolveDialog não é uma função válida.");
                }
            } catch (error) {
                console.error("Erro inesperado ao chamar resolveDialog:", error);
            }
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
        // Cria o painel do rodapé para os botões
        const footerPanel = document.createElement('div');
        footerPanel.className = 'inputBox-footer-panel'; // Classe CSS para o rodapé
        
        // Centraliza os botões
        footerPanel.style.display = 'flex';
        footerPanel.style.justifyContent = 'center';
        footerPanel.style.gap = '10px'; // Espaçamento entre os botões
        
        // Adiciona botão Cancelar
        const buttonCancel = document.createElement('button');
        buttonCancel.id = 'cancelBtn';
        buttonCancel.textContent = 'Cancelar';
        buttonCancel.addEventListener('click', () => {
            this.cancel(); // Fecha o dialog com valor de retorno 'cancel'
        });
        footerPanel.appendChild(buttonCancel);
        
        // Adiciona botão OK
        const buttonOk = document.createElement('button');
        buttonOk.id = 'confirmBtn';
        buttonOk.textContent = 'OK';
        buttonOk.addEventListener('click', () => {                
            this.submit(); // Fecha o dialog com valor de retorno 'ok'
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
        const container = this.addFieldsToTable(dialog, () => this.getPainel());
        dialog.appendChild(container);

        // Exibir diálogo
        showDialog();
    }

    async openDialog() {
        try {
            const data = await this.executeDialog();
            alert(`Captured data:\nName: ${data.name}\nAge: ${data.age}`);
        } catch (error) {
            alert('Error: ' + error);
        }
    }

    // async openDialog() {
    //     if (this.isOpen) {
    //         console.warn("Dialog is already open."); // Evita reentrância
    //         return;
    //     }

    //     this.isOpen = true; // Marca o diálogo como aberto
    //     try {
    //         const data = await this.executeDialog();
    //         alert(`Captured data:\nName: ${data.name}\nAge: ${data.age}`);
    //     } catch (error) {
    //         alert('Error: ' + error);
    //     } finally {
    //         this.isOpen = false; // Garante que o estado seja resetado quando o diálogo fechar
    //     }
    // }
   

    /**
     * Abre o diálogo modal.
     */
    // static showModal(title, template) {
    //     const dialogInstance = new Dialog(title, template);
    //     return dialogInstance.openDialog();      
    // }

    static showModal(title, template) {
        if (Dialog.currentInstance) {
            console.warn("Dialog is already open.");
            return;
        }
    
        const dialogInstance = new Dialog(title, template);
        Dialog.currentInstance = dialogInstance; // Armazena a instância atual

    }
    

}
