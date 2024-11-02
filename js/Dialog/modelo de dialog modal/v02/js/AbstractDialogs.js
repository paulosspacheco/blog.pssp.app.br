// AbstractDialogs.js
export default class AbstractDialogs {
    constructor(dialogId, formId) {
        if (this.constructor === AbstractDialogs) {
            throw new Error("Cannot instantiate an abstract class.");
        }

        this.dialog = document.getElementById(dialogId);
        this.form = document.getElementById(formId);
        this.resolveDialog = null;
        this.rejectDialog = null;

        this.setupEventListeners();
    }

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

    confirmDialogProcedure() {
        throw new Error("Method 'confirmDialogProcedure' must be implemented.");
    }

    cancelDialogProcedure() {
        throw new Error("Method 'cancelDialogProcedure' must be implemented.");
    }

    handleDialog(resolve, reject) {
        this.resolveDialog = resolve;
        this.rejectDialog = reject;
        this.openDialog();
    }

    callDialog() {
        return new Promise((resolve, reject) => this.handleDialog(resolve, reject));
    }

    async executeDialog() {
        const data = await this.callDialog();
        return data;
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
