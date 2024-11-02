export default class DialogoModal {
    constructor(dialogoId, formularioId) {
        this.dialogo = document.getElementById(dialogoId);
        this.formulario = document.getElementById(formularioId);
        this.resolverDialogo = null;
        this.rejeitarDialogo = null;

        this.setupEventListeners();
    }

    setupEventListeners() {
        document.getElementById('abrirDialogoBtn').addEventListener('click', () => this.abrirDialogoEExibirDados());
        document.getElementById('cancelarBtn').addEventListener('click', () => this.procedimentoCancelarDialogo());
        document.getElementById('confirmarBtn').addEventListener('click', () => this.procedimentoConfirmarDialogo());
    }

    abrirDialogo() {
        this.dialogo.showModal();
    }

    handleDialog(resolve, reject) {
        this.resolverDialogo = resolve;
        this.rejeitarDialogo = reject;
        this.abrirDialogo();
    }

    chamarDialogo() {
        return new Promise((resolve, reject) => this.handleDialog(resolve, reject));
    }

    async executarDialogo() {
        const dados = await this.chamarDialogo();
        return dados;
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

    async abrirDialogoEExibirDados() {
        try {
            const dados = await this.executarDialogo();
            alert(`Dados capturados:\nNome: ${dados.nome}\nIdade: ${dados.idade}`);
        } catch (erro) {
            alert('Erro: ' + erro);
        }
    }
}
