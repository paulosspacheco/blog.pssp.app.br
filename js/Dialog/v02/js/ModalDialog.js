// ModalDialog.js
import AbstractModalDialog from './AbstractModalDialog.js';

export default class ModalDialog extends AbstractModalDialog {
    setupEventListeners() {
        document.getElementById('openDialogBtn').addEventListener('click', () => this.openDialogAndDisplayData());
        document.getElementById('cancelBtn').addEventListener('click', () => this.cancelDialogProcedure());
        document.getElementById('confirmBtn').addEventListener('click', () => this.confirmDialogProcedure());
    }

    openDialog() {
        this.dialog.showModal();
    }

    collectDialogData() {
        const name = document.getElementById('name').value;
        const age = document.getElementById('age').value;
        return { name, age };
    }

    closeDialog() {
        this.dialog.close();
    }

    confirmDialogProcedure() {
        if (this.form.checkValidity()) {
            const data = this.collectDialogData();
            this.closeDialog();
            this.resolveDialog(data);
        } else {
            this.form.reportValidity();
        }
    }

    cancelDialogProcedure() {
        this.closeDialog();
        this.rejectDialog('Dialog canceled by user');
    }
}
