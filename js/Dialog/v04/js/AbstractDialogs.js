// AbstractDialogs.js

// import { MiMethods } from './MiMethods.js';
import { UiDmxScrollerForm } from './UiDmxScrollerForm.js';

export  default class AbstractDialogs extends UiDmxScrollerForm {

        
    constructor(title, template) {
        
        super(title, template); // Chama o construtor da classe pai     

        if (this.constructor === AbstractDialogs) {
            throw new Error("Cannot instantiate an abstract class.");
        }

        this.resolveDialog = null;
        this.rejectDialog = null;
        this.form = null;
        //this.createForm();

        this.dialog = null;
        this.createDialog();
        


        this.setupEventListeners();
    }

    createForm(){
        throw new Error("Method 'createForm' must be implemented.");
    };

    createDialog(){
        throw new Error("Method 'createDialog' must be implemented.");        
    };

    setupEventListeners() {
        throw new Error("Method 'setupEventListeners' must be implemented.");
    }

    openDialog() {
        throw new Error("Method 'openDialog' must be implemented.");
    }

    
    collectDialogData() {
        throw new Error("Method 'collectDialogData' must be implemented.");
    }

    closeDialog() {
        throw new Error("Method 'closeDialog' must be implemented.");
    }



    handleDialog(resolve, reject) {
        this.resolveDialog = resolve;
        this.rejectDialog = reject;
        this.openDialog();
    }
    
    // Método para lidar com o envio do formulário
    submit() {
        // Lógica para lidar com o envio
        throw new Error("Method 'submit' must be implemented.");

        // Adicione a lógica necessária para processar os dados do formulário aqui
    }

    // Método para lidar com o cancelamento do formulário
    cancel() {
        // Lógica para lidar com o cancelamento
        throw new Error("Method 'cancel' must be implemented.");
        // Adicione a lógica necessária para limpar o formulário ou fechar o diálogo aqui
    }
        
    callDialog() {
        return new Promise((resolve, reject) => this.handleDialog(resolve, reject));
    }
    
    async executeDialog() {
        try {
            const data = await this.callDialog();
            console.log("Dados coletados no diálogo:", data);
            return data; // Retorna o JSON com os dados coletados
        } catch (error) {
            console.error("Erro ao executar diálogo:", error);
            return null; // Retorna null se houver um erro
        }
    }

    async openDialogAndDisplayData() {
        try {
            const data = await this.executeDialog();
            alert(`Captured data:\nName: ${data.name}\nAge: ${data.age}`);
        } catch (error) {
            alert('Error: ' + error);
        }
    }
}
