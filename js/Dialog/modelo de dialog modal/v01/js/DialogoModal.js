// DialogoModal.js
import DialogoModalAbstrato from './DialogoModalAbstrato.js';

export default class DialogoModal extends DialogoModalAbstrato {
    setupEventListeners() {
        document.getElementById('abrirDialogoBtn').addEventListener('click', () => this.abrirDialogoEExibirDados());
        document.getElementById('cancelarBtn').addEventListener('click', () => this.procedimentoCancelarDialogo());
        document.getElementById('confirmarBtn').addEventListener('click', () => this.procedimentoConfirmarDialogo());
    }

    abrirDialogo() {
        this.dialogo.showModal();
    }

    coletarDadosDialogo() {
        const nome = document.getElementById('nome').value;
        const idade = document.getElementById('idade').value;
        return { nome, idade };
    }

    fecharDialogo() {
        this.dialogo.close();
    }

    procedimentoConfirmarDialogo() {
        if (this.formulario.checkValidity()) {
            const dados = this.coletarDadosDialogo();
            this.fecharDialogo();
            this.resolverDialogo(dados);
        } else {
            this.formulario.reportValidity();
        }
    }

    procedimentoCancelarDialogo() {
        this.fecharDialogo();
        this.rejeitarDialogo('Diálogo cancelado pelo usuário');
    }
}
